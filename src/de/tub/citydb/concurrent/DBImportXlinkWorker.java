package de.tub.citydb.concurrent;

import java.sql.SQLException;
import java.util.concurrent.locks.ReentrantLock;

import de.tub.citydb.concurrent.WorkerPool.WorkQueue;
import de.tub.citydb.config.Config;
import de.tub.citydb.config.internal.Internal;
import de.tub.citydb.config.project.database.Database;
import de.tub.citydb.db.cache.CacheManager;
import de.tub.citydb.db.xlink.DBXlink;
import de.tub.citydb.db.xlink.DBXlinkBasic;
import de.tub.citydb.db.xlink.DBXlinkDeprecatedMaterial;
import de.tub.citydb.db.xlink.DBXlinkGroupToCityObject;
import de.tub.citydb.db.xlink.DBXlinkLibraryObject;
import de.tub.citydb.db.xlink.DBXlinkLinearRing;
import de.tub.citydb.db.xlink.DBXlinkSurfaceGeometry;
import de.tub.citydb.db.xlink.DBXlinkTextureAssociation;
import de.tub.citydb.db.xlink.DBXlinkTextureFile;
import de.tub.citydb.db.xlink.DBXlinkTextureParam;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterBasic;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterDeprecatedMaterial;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterEnum;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterGroupToCityObject;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterLibraryObject;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterLinearRing;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterManager;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterSurfaceGeometry;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterTextureAssociation;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterTextureFile;
import de.tub.citydb.db.xlink.importer.DBXlinkImporterTextureParam;
import de.tub.citydb.event.EventDispatcher;
import de.tub.citydb.log.Logger;

public class DBImportXlinkWorker implements Worker<DBXlink> {
	private final Logger LOG = Logger.getInstance();
	
	// instance members needed for WorkPool
	private volatile boolean shouldRun = true;
	private ReentrantLock runLock = new ReentrantLock();
	private WorkQueue<DBXlink> workQueue = null;
	private DBXlink firstWork;
	private Thread workerThread = null;

	// instance members needed to do work
	private final Config config;
	private DBXlinkImporterManager dbXlinkManager;
	private int updateCounter = 0;
	private int commitAfter = 10000;

	public DBImportXlinkWorker(CacheManager cacheManager, Config config, EventDispatcher eventDispatcher) {
		this.config = config;
		dbXlinkManager = new DBXlinkImporterManager(cacheManager, eventDispatcher);
		
		init();		
	}

	private void init() {
		Database database = config.getProject().getDatabase();
		
		Integer commitAfterProp = database.getUpdateBatching().getTempBatchValue();
		if (commitAfterProp != null && commitAfterProp > 0 && commitAfterProp <= Internal.ORACLE_MAX_BATCH_SIZE)
			commitAfter = commitAfterProp;		
	}
	
	@Override
	public Thread getThread() {
		return workerThread;
	}

	@Override
	public void interrupt() {
		shouldRun = false;
		workerThread.interrupt();
	}

	@Override
	public void interruptIfIdle() {
		final ReentrantLock runLock = this.runLock;
		shouldRun = false;

		if (runLock.tryLock()) {
			try {
				workerThread.interrupt();
			} finally {
				runLock.unlock();
			}
		}
	}

	@Override
	public void setFirstWork(DBXlink firstWork) {
		this.firstWork = firstWork;
	}

	@Override
	public void setThread(Thread workerThread) {
		this.workerThread = workerThread;
	}

	@Override
	public void setWorkQueue(WorkQueue<DBXlink> workQueue) {
		this.workQueue = workQueue;
	}

	@Override
	public void run() {
		if (firstWork != null && shouldRun) {
			doWork(firstWork);
			firstWork = null;
		}

		while (shouldRun) {
			try {
				DBXlink work = workQueue.take();
				doWork(work);
			} catch (InterruptedException ie) {
				// re-check state
			}
		}

		try {
			dbXlinkManager.executeBatch();
		} catch (SQLException sqlEx) {
			LOG.error("SQL error: " + sqlEx.getMessage());
		}
		
		try {
			dbXlinkManager.close();
		} catch (SQLException sqlEx) {
			LOG.error("SQL error: " + sqlEx.getMessage());
		}
	}

	private void doWork(DBXlink work) {
		final ReentrantLock runLock = this.runLock;
		runLock.lock();

		try {
			try {
				boolean success = false;

				switch (work.getXlinkType()) {
				case SURFACE_GEOMETRY:
					DBXlinkSurfaceGeometry xlinkSurfaceGeometry = (DBXlinkSurfaceGeometry)work;

					DBXlinkImporterSurfaceGeometry dbSurfaceGeometry = (DBXlinkImporterSurfaceGeometry)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.SURFACE_GEOMETRY);
					if (dbSurfaceGeometry != null)
						success = dbSurfaceGeometry.insert(xlinkSurfaceGeometry);

					break;
				case LINEAR_RING:
					DBXlinkLinearRing xlinkLinearRing = (DBXlinkLinearRing)work;

					DBXlinkImporterLinearRing dbLinearRing = (DBXlinkImporterLinearRing)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.LINEAR_RING);
					if (dbLinearRing != null)
						success = dbLinearRing.insert(xlinkLinearRing);

					break;
				case BASIC:
					DBXlinkBasic xlinkBasic = (DBXlinkBasic)work;

					DBXlinkImporterBasic dbBasic = (DBXlinkImporterBasic)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.XLINK_BASIC);
					if (dbBasic != null)
						success = dbBasic.insert(xlinkBasic);

					break;
				case TEXTUREPARAM:
					DBXlinkTextureParam xlinkAppearance = (DBXlinkTextureParam)work;

					DBXlinkImporterTextureParam dbAppearance = (DBXlinkImporterTextureParam)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.XLINK_TEXTUREPARAM);
					if (dbAppearance != null)
						success = dbAppearance.insert(xlinkAppearance);

					break;
				case TEXTUREASSOCIATION:
					DBXlinkTextureAssociation xlinkTextureAssociation = (DBXlinkTextureAssociation)work;

					DBXlinkImporterTextureAssociation dbTexAss = (DBXlinkImporterTextureAssociation)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.XLINK_TEXTUREASSOCIATION);
					if (dbTexAss != null)
						success = dbTexAss.insert(xlinkTextureAssociation);

					break;
				case TEXTURE_FILE:
					DBXlinkTextureFile xlinkFile = (DBXlinkTextureFile)work;

					DBXlinkImporterTextureFile dbFile = (DBXlinkImporterTextureFile)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.TEXTURE_FILE);
					if (dbFile != null)
						success = dbFile.insert(xlinkFile);

					break;
				case LIBRARY_OBJECT:
					DBXlinkLibraryObject xlinkLibraryObject = (DBXlinkLibraryObject)work;

					DBXlinkImporterLibraryObject dbLibraryObject = (DBXlinkImporterLibraryObject)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.LIBRARY_OBJECT);
					if (dbLibraryObject != null)
						success = dbLibraryObject.insert(xlinkLibraryObject);

					break;
				case DEPRECATED_MATERIAL:
					DBXlinkDeprecatedMaterial xlinkDeprecatedMaterial = (DBXlinkDeprecatedMaterial)work;

					DBXlinkImporterDeprecatedMaterial dbDeprectatedMaterial = (DBXlinkImporterDeprecatedMaterial)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.XLINK_DEPRECATED_MATERIAL);
					if (dbDeprectatedMaterial != null)
						success = dbDeprectatedMaterial.insert(xlinkDeprecatedMaterial);

					break;
				case GROUP_TO_CITYOBJECT:
					DBXlinkGroupToCityObject xlinkGroupToCityObject = (DBXlinkGroupToCityObject)work;
					
					DBXlinkImporterGroupToCityObject dbGroup = (DBXlinkImporterGroupToCityObject)dbXlinkManager.getDBImporterXlink(DBXlinkImporterEnum.GROUP_TO_CITYOBJECT);
					if (dbGroup != null)
						success = dbGroup.insert(xlinkGroupToCityObject);
					
					break;
				}

				if (success)
					updateCounter++;

			} catch (SQLException sqlEx) {
				LOG.error("SQL error: " + sqlEx.getMessage());
				return;
			}

			try {
				if (updateCounter == commitAfter) {
					dbXlinkManager.executeBatch();

					updateCounter = 0;
				}
			} catch (SQLException sqlEx) {
				LOG.error("SQL error: " + sqlEx.getMessage());
				return;
			}

		} finally {
			runLock.unlock();
		}
	}

}