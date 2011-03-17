package de.tub.citydb.db.importer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.concurrent.locks.ReentrantLock;

import org.citygml4j.model.citygml.CityGMLClass;
import org.citygml4j.model.citygml.core.ImplicitGeometry;
import org.citygml4j.model.gml.AbstractGeometry;
import org.citygml4j.model.gml.GeometryProperty;

import de.tub.citydb.config.internal.Internal;
import de.tub.citydb.db.DBTableEnum;
import de.tub.citydb.db.xlink.DBXlinkBasic;
import de.tub.citydb.db.xlink.DBXlinkLibraryObject;
import de.tub.citydb.log.Logger;
import de.tub.citydb.util.Util;

public class DBImplicitGeometry implements DBImporter {
	private final static ReentrantLock mainLock = new ReentrantLock();
	private final Logger LOG = Logger.getInstance();

	private final Connection batchConn;
	private final Connection commitConn;
	private final DBImporterManager dbImporterManager;

	private PreparedStatement psImplicitGeometry;
	private PreparedStatement psUpdateImplicitGeometry;
	private PreparedStatement psSelectLibraryObject;
	private DBSurfaceGeometry surfaceGeometryImporter;
	private ResultSet rs;

	private int batchCounter;

	public DBImplicitGeometry(Connection batchConn, Connection commitConn,DBImporterManager dbImporterManager) throws SQLException {
		this.batchConn = batchConn;
		this.commitConn = commitConn;
		this.dbImporterManager = dbImporterManager;

		init();
	}

	private void init() throws SQLException {
		psImplicitGeometry = commitConn.prepareStatement("insert into IMPLICIT_GEOMETRY (ID, REFERENCE_TO_LIBRARY) values (?, ?)");
		psUpdateImplicitGeometry = batchConn.prepareStatement("update IMPLICIT_GEOMETRY set MIME_TYPE=?, RELATIVE_GEOMETRY_ID=? where ID=?");
		psSelectLibraryObject = batchConn.prepareStatement("select ID from IMPLICIT_GEOMETRY where REFERENCE_TO_LIBRARY=?");

		surfaceGeometryImporter = (DBSurfaceGeometry)dbImporterManager.getDBImporter(DBImporterEnum.SURFACE_GEOMETRY);
	}

	public long insert(ImplicitGeometry implicitGeometry, long parentId) throws SQLException {
		// writing implicit geometries differs from other importers. we want to avoid duplicate
		// entries for library objects. thus we have to make sure on this prior to inserting entries.
		long implicitGeometryId = 0;
		boolean updateTable = false;
		boolean isXLink = false;

		String libraryURI = implicitGeometry.getLibraryObject();
		if (libraryURI != null)
			libraryURI = libraryURI.trim();

		AbstractGeometry relativeGeometry = null;
		String gmlId = null;

		if (implicitGeometry.isSetRelativeGMLGeometry()) {
			GeometryProperty property = implicitGeometry.getRelativeGMLGeometry();

			if (property.isSetHref()) {
				gmlId = property.getHref();
				if (Util.isRemoteXlink(gmlId)) {
					LOG.error("XLink reference '" + gmlId + "' to remote relative GML geometry is not supported.");					
					return 0;
				}				

				gmlId = gmlId.replaceAll("^#", "");
				isXLink = true;

			} else if (property.isSetGeometry()) {
				relativeGeometry = property.getGeometry();
				gmlId = relativeGeometry.getId();
				updateTable = true;
			}
		}

		// we need to synchronize this check.
		final ReentrantLock lock = mainLock;
		lock.lock();

		try {
			if (libraryURI != null) {
				// check if we have the same library object in database
				psSelectLibraryObject.setString(1, libraryURI);
				rs = psSelectLibraryObject.executeQuery();
				if (rs.next())
					implicitGeometryId = rs.getLong(1);
				
				updateTable = true;
			} 

			// check relative geometry reference
			else if (gmlId != null)
				implicitGeometryId = dbImporterManager.getDBId(gmlId, CityGMLClass.CITYOBJECT);				

			if (implicitGeometryId == 0) {
				implicitGeometryId = dbImporterManager.getDBId(DBSequencerEnum.IMPLICIT_GEOMETRY_SEQ);
				psImplicitGeometry.setLong(1, implicitGeometryId);
				psImplicitGeometry.setString(2, libraryURI);
				psImplicitGeometry.execute();

				if (gmlId != null)
					dbImporterManager.putGmlId(gmlId, implicitGeometryId, CityGMLClass.CITYOBJECT);

				dbImporterManager.updateFeatureCounter(CityGMLClass.IMPLICITGEOMETRY);
			}

		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					//
				}

				rs = null;
			}

			lock.unlock();
		}

		// ok, the rest can be handled concurrently and as batch update...
		if (updateTable) {
			psUpdateImplicitGeometry.setLong(3, implicitGeometryId);

			if (libraryURI != null) {
				// mimeType
				if (implicitGeometry.isSetMimeType())
					psUpdateImplicitGeometry.setString(1, implicitGeometry.getMimeType());
				else
					psUpdateImplicitGeometry.setNull(1, Types.VARCHAR);

				// propagate the link to the library object
				dbImporterManager.propagateXlink(new DBXlinkLibraryObject(
						implicitGeometryId,
						libraryURI
				));
			} else
				psUpdateImplicitGeometry.setNull(1, Types.VARCHAR);

			if (relativeGeometry != null) {
				long surfaceGeometryId = surfaceGeometryImporter.insert(relativeGeometry, parentId);
				if (surfaceGeometryId != 0)
					psUpdateImplicitGeometry.setLong(2, surfaceGeometryId);
				else
					psUpdateImplicitGeometry.setNull(2, 0);
			} else
				psUpdateImplicitGeometry.setNull(2, 0);

			psUpdateImplicitGeometry.addBatch();
			if (++batchCounter == Internal.ORACLE_MAX_BATCH_SIZE)
				dbImporterManager.executeBatch(DBImporterEnum.IMPLICIT_GEOMETRY);
		}

		if (isXLink && gmlId != null) {
			dbImporterManager.propagateXlink(new DBXlinkBasic(
					implicitGeometryId, 
					DBTableEnum.IMPLICIT_GEOMETRY, 
					gmlId, 
					DBTableEnum.SURFACE_GEOMETRY)
			);
		}
		
		return implicitGeometryId;
	}

	@Override
	public void executeBatch() throws SQLException {
		psUpdateImplicitGeometry.executeBatch();
		batchCounter = 0;
	}

	@Override
	public void close() throws SQLException {
		psImplicitGeometry.close();
		psUpdateImplicitGeometry.close();
		psSelectLibraryObject.close();
	}

	@Override
	public DBImporterEnum getDBImporterType() {
		return DBImporterEnum.IMPLICIT_GEOMETRY;
	}
}