-- OBJECTCLASS_INSTANCES.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--              Philipp Willkomm <pwillkomm@moss.de>
--              Gerhard K�nig <gerhard.koenig@tu-berlin.de>
--              Alexandra Lorenz <di.alex.lorenz@googlemail.com>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universit�t M�nchen, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universit�t Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    FKun
--                                                                    CNag
--                                                                    PWil
-- 2.0.0     2012-05-21   PostGIS version                             FKun
--                                                                    TKol	
--                                                                    GKoe
--                                                                    CNag
--                                                                    ASta
--
DELETE FROM OBJECTCLASS;

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (0,'Undefined',NULL);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (1,'Object',NULL);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (2,'_AbstractFeature',1);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (3,'_CityObject',2);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (4,'LandUse',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (5,'GenericCityObject',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (6,'_VegetationObject',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (7,'SolitaryVegetationObject',6);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (8,'PlantCover',6);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (9,'WaterBody',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (10,'_WaterBoundarySurface',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (11,'WaterSurface',10);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (12,'WaterGroundSurface',10);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (13,'WaterClosureSurface',10);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (14,'ReliefFeature',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (15,'_ReliefComponent',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (16,'TINRelief',15);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (17,'MassPointRelief',15);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (18,'BreaklineRelief',15);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (19,'RasterRelief',15);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (21,'CityFurniture',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (22,'_TransportationObject',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (23,'CityObjectGroup',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (24,'_AbstractBuilding',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (25,'BuildingPart',24);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (26,'Building',24);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (27,'BuildingInstallation',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (28,'IntBuildingInstallation',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (29,'_BoundarySurface',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (30,'CeilingSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (31,'InteriorWallSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (32,'FloorSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (33,'RoofSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (34,'WallSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (35,'GroundSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (36,'ClosureSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (37,'_Opening',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (38,'Window',37);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (39,'Door',37);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (40,'BuildingFurniture',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (41,'Room',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (42,'TransportationComplex',22);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (43,'Track',42);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (44,'Railway',42);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (45,'Road',42);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (46,'Square',42);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (47,'TrafficArea',22);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (48,'AuxiliaryTrafficArea',22);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (49,'FeatureCollection',2);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (50,'Appearance',2);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (51,'_SurfaceData',2);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (52,'_AbstractTexture',51);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (53,'X3DMaterial',51);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (54,'ParameterizedTexture',52);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (55,'GeoreferencedTexture',52);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (56,'TextureParametrization',1);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (57,'CityModel',49);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (58,'Address',2);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (59,'ImplicitGeometry',1);

--// extending the BoudarySurface (OuterCeilingSurface and OuterFloorSurface) of Building for CityGML 2.0

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (60,'OuterCeilingSurface',29);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (61,'OuterFloorSurface',29);

--// BRIDGE

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (62,'_AbstractBridge',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (63,'BridgePart',62);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (64,'Bridge',62);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (65,'BridgeInstallation',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (66,'IntBridgeInstallation',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (67,'_BridgeBoundarySurface',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (68,'BridgeCeilingSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (69,'BridgeInteriorWallSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (70,'BridgeFloorSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (71,'BridgeRoofSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (72,'BridgeWallSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (73,'BridgeGroundSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (74,'BridgeClosureSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (75,'BridgeOuterCeilingSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (76,'BridgeOuterFloorSurface',67);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (77,'_BridgeOpening',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (78,'BridgeWindow',77);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (79,'BridgeDoor',77);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (80,'BridgeFurniture',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (81,'BridgeRoom',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (82,'BridgeConstructionElement',3);

--// TUNNEL

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (83,'_AbstractTunnel',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (84,'TunnelPart',83);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (85,'Tunnel',83);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (86,'TunnelInstallation',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (87,'IntTunnelInstallation',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (88,'_TunnelBoundarySurface',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (89,'TunnelCeilingSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (90,'TunnelInteriorWallSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (91,'TunnelFloorSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (92,'TunnelRoofSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (93,'TunnelWallSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (94,'TunnelGroundSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (95,'TunnelClosureSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (96,'TunnelOuterCeilingSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (97,'TunnelOuterFloorSurface',88);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (98,'_TunnelOpening',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (99,'TunnelWindow',98);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (100,'TunnelDoor',98);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (101,'TunnelFurniture',3);

INSERT INTO OBJECTCLASS ( ID , CLASSNAME , SUPERCLASS_ID )
VALUES (102,'TunnelHollowSpace',3);