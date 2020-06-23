-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: cloudlab
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config` (
  `cid` int unsigned NOT NULL,
  `item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'key',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'value',
  `vtype` tinyint NOT NULL COMMENT '1, string, 2, int, 3, float/double',
  PRIMARY KEY (`cid`) USING BTREE,
  UNIQUE KEY `unique` (`item`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES (1,'webroot','E:\\gtt\\webapp',1),(2,'rdp_pic_path','E:\\gtt\\webapp\\images\\rdp',1),(3,'rdp_pic_web_root','/images/rdp',1);
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `experiment`
--

DROP TABLE IF EXISTS `experiment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `experiment` (
  `eid` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'the experiment id',
  `ename` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the name of experiment',
  `etime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'the date and time of experiment',
  `sid` int unsigned NOT NULL COMMENT 'the id of specimen',
  `uid` int unsigned NOT NULL COMMENT 'operator',
  `frequncy` double NOT NULL COMMENT 'the frequncy',
  `sampling` double NOT NULL COMMENT 'the sampling',
  `H` double DEFAULT NULL COMMENT 'the H value',
  `cycles` double DEFAULT NULL COMMENT 'the cycles',
  `datatype` int NOT NULL DEFAULT '0' COMMENT 'the type of datafile, 0 for 3 columns, 1 for 9 columns',
  `datapath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the filepath of raw data file',
  `rawpath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'the path of the raw files',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  PRIMARY KEY (`eid`) USING BTREE,
  UNIQUE KEY `unique_ename` (`ename`) USING BTREE,
  UNIQUE KEY `unique_datapath` (`datapath`) USING BTREE,
  UNIQUE KEY `unique_rawpath` (`rawpath`) USING BTREE,
  KEY `fk_experiment_specimen` (`sid`) USING BTREE,
  KEY `fk_experiment_user` (`uid`) USING BTREE,
  CONSTRAINT `fk_experiment_specimen` FOREIGN KEY (`sid`) REFERENCES `specimen` (`sid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_experiment_user` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `experiment`
--

LOCK TABLES `experiment` WRITE;
/*!40000 ALTER TABLE `experiment` DISABLE KEYS */;
INSERT INTO `experiment` VALUES (1,'GCr15测试1','2020-06-08 18:10:35',1,1,0.1,32,20,3087,1,'E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087','E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087',''),(2,'GCr15 测试2','2020-06-08 18:10:35',2,1,0.1,32,15,7141,1,'E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141','E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141',''),(3,'GCr15 测试3','2020-06-08 18:10:35',3,1,0.1,32,10,39534,1,'E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534','E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534',''),(4,'GCr15 测试4','2020-06-08 18:10:35',4,1,0.1,32,25,1640,1,'E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640','E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640',''),(5,'GCr15 测试5','2020-06-08 18:10:35',5,1,0.1,32,30,1279,1,'E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279','E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279',''),(6,'GCr15 测试6','2020-06-08 18:10:35',6,1,0.1,32,35,1250,1,'E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250','E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250',''),(8,'QT800 测试1','2020-06-08 18:10:35',8,1,0.1,16,36,743,2,'E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210\\Data','E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210',''),(9,'QT800 测试2','2020-06-08 18:10:35',9,1,0.1,16,34,954,2,'E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210\\Data','E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210',''),(10,'QT800 测试3','2020-06-08 18:10:35',10,1,0.1,16,38,366,2,'E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212\\Data','E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212',''),(11,'QT800 测试4','2020-06-08 18:10:35',11,1,0.1,16,32,1298,2,'E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212\\Data','E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212',''),(12,'QT800 测试5','2020-06-08 18:10:35',12,1,0.1,16,30,1029,2,'E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212\\Data','E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212',''),(13,'QT800 测试6','2020-06-08 18:10:35',13,1,0.1,16,25,2951,2,'E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212\\Data','E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212',''),(14,'GCr15','2020-06-15 15:03:04',13,1,0.1,16,20,12532,1,'E:\\LCF&HCF\\DH\\S2H36N743_20191210\\Data','E:\\LCF&HCF\\DH\\S2H36N743_20191210\\Data','12'),(47,'20200620测试66','2020-06-20 17:53:22',7,1,0.999,1612,777,333,1,'D:\\','D:\\','24234');
/*!40000 ALTER TABLE `experiment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `material` (
  `mid` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'the id of the material',
  `mname` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'name of material',
  `en_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'the english name of material',
  `standard` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'the standard name',
  `properties` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'the description of the material',
  PRIMARY KEY (`mid`) USING BTREE,
  UNIQUE KEY `unique_mname` (`mname`) USING BTREE,
  UNIQUE KEY `unique_en_name` (`en_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material`
--

LOCK TABLES `material` WRITE;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` VALUES (1,'GCr15','High-carbon chromium bearing steel','GB/T 18254-2016','高碳铬轴承钢'),(2,'QT800','Nodular Cast Iron','','球墨铸铁'),(8,'NewMaterial','NewMaterial','NewMaterial','NewMaterial');
/*!40000 ALTER TABLE `material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pp`
--

DROP TABLE IF EXISTS `pp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pp` (
  `pp_id` int unsigned NOT NULL AUTO_INCREMENT,
  `sname` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mid` int unsigned NOT NULL DEFAULT '0',
  `diameter` double NOT NULL DEFAULT '0',
  `meanload` double NOT NULL DEFAULT '0',
  `maxload` double NOT NULL DEFAULT '0',
  `FatigueLifeNf` double NOT NULL DEFAULT '0',
  `FracturedLocs` double NOT NULL DEFAULT '0',
  `ktfactor` int NOT NULL DEFAULT '0',
  `ampload` int NOT NULL DEFAULT '0',
  `ratioofload` double NOT NULL DEFAULT '0',
  `runoutcycles` int NOT NULL DEFAULT '0',
  `runouttime` int NOT NULL DEFAULT '0',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `pic1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `pic2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `pic3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  PRIMARY KEY (`pp_id`),
  KEY `torison_fk` (`mid`) USING BTREE,
  CONSTRAINT `fk_pp_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='PULL AND PUSH TEST';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pp`
--

LOCK TABLES `pp` WRITE;
/*!40000 ALTER TABLE `pp` DISABLE KEYS */;
/*!40000 ALTER TABLE `pp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rotating`
--

DROP TABLE IF EXISTS `rotating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rotating` (
  `rtid` int unsigned NOT NULL AUTO_INCREMENT,
  `sname` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mid` int unsigned NOT NULL DEFAULT '0',
  `diameter` double NOT NULL DEFAULT '0',
  `moment` double NOT NULL DEFAULT '0',
  `FatigueLifeNf` double NOT NULL DEFAULT '0',
  `FracturedLocs` double NOT NULL DEFAULT '0',
  `speed` double NOT NULL DEFAULT '0',
  `lp` double NOT NULL DEFAULT '0',
  `stress` double NOT NULL DEFAULT '0',
  `runoutcycles` int NOT NULL DEFAULT '0',
  `runouttime` int NOT NULL DEFAULT '0',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `pic1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `pic2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `pic3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  PRIMARY KEY (`rtid`),
  CONSTRAINT `fk_rotating_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ROTATING AND BENDING TEST';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rotating`
--

LOCK TABLES `rotating` WRITE;
/*!40000 ALTER TABLE `rotating` DISABLE KEYS */;
/*!40000 ALTER TABLE `rotating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rdp_data_1`
--

DROP TABLE IF EXISTS `rdp_data_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rdp_data_1` (
  `rdpd_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'the data id',
  `eid` int unsigned NOT NULL COMMENT 'experiment id',
  `max_angle` double DEFAULT NULL COMMENT 'max_angle',
  `min_angle` double DEFAULT NULL COMMENT 'min_angle',
  `max_torque` double DEFAULT NULL COMMENT 'max_torque',
  `min_torque` double DEFAULT NULL COMMENT 'max_torque',
  `max_shearforce` double DEFAULT NULL COMMENT 'max_shearforce',
  `min_shearforce` double DEFAULT NULL COMMENT 'min_shearforce',
  `max_shearstrain` double DEFAULT NULL COMMENT 'max_shearstrain',
  `min_shearstrain` double DEFAULT NULL COMMENT 'min_shearstrain',
  `max_force_improved` double DEFAULT NULL COMMENT 'max_force_improved',
  `min_force_improved` double DEFAULT NULL COMMENT 'min_force_improved',
  `G_right` double DEFAULT NULL COMMENT 'G_right',
  `G_left` double DEFAULT NULL COMMENT 'G_left',
  `G_mean` double DEFAULT NULL COMMENT 'G_mean',
  `Tao_max` double DEFAULT NULL COMMENT 'Tao_max',
  PRIMARY KEY (`rdpd_id`) USING BTREE,
  KEY `fk_rdpd_exp` (`eid`) USING BTREE,
  CONSTRAINT `fk_rdpd_exp` FOREIGN KEY (`eid`) REFERENCES `experiment` (`eid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rdp_data_1`
--

LOCK TABLES `rdp_data_1` WRITE;
/*!40000 ALTER TABLE `rdp_data_1` DISABLE KEYS */;
/*!40000 ALTER TABLE `rdp_data_1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rdp_result`
--

DROP TABLE IF EXISTS `rdp_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rdp_result` (
  `expid` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'result id',
  `eid` int unsigned NOT NULL COMMENT 'the experiment id',
  `rawlen` int unsigned DEFAULT NULL COMMENT 'the length of raw data',
  `period` int unsigned DEFAULT NULL COMMENT 'the amount of period',
  `bpoint` int unsigned DEFAULT NULL COMMENT 'break point',
  `first_loop` int DEFAULT '100' COMMENT 'the effect first loop no for G__',
  `G_loop_no` int DEFAULT '100' COMMENT 'The Effect Loop No for G___',
  `theta_8` double DEFAULT NULL COMMENT 'theta_8',
  `torque_8` double DEFAULT NULL COMMENT 'torque_8',
  `TauMax` double DEFAULT NULL COMMENT 'Max Tau in MPa',
  `TauMin` double DEFAULT NULL COMMENT 'Min Tau in MPa',
  `TauMean` double DEFAULT NULL COMMENT 'Mean Tau in Mpa',
  `Strain_TotMax` double DEFAULT NULL COMMENT 'Strain_TotMax',
  `Strain_TotMin` double DEFAULT NULL COMMENT 'Strain_TotMin',
  `Strain_TotMean` double DEFAULT NULL COMMENT 'Strain_TotMean',
  `StrainRate` double DEFAULT NULL COMMENT 'StrainRate',
  `G_left_value` double DEFAULT NULL COMMENT 'G_left_value',
  `G_right_value` double DEFAULT NULL COMMENT 'G_right_value',
  `nHardening` double DEFAULT NULL COMMENT 'nHardening',
  `KMpa` double DEFAULT NULL COMMENT 'KMpa',
  `Strain_Plastic` double DEFAULT NULL COMMENT 'Strain_Plastic',
  `Strain_Elastic` double DEFAULT NULL COMMENT 'Strain_Elastic',
  `Strain_amplitude` double DEFAULT NULL COMMENT 'Strain_amplitude',
  `Tau_MaxMPa` double DEFAULT NULL COMMENT 'Tau_MaxMPa',
  `Tau_amplitudeMPa` double DEFAULT NULL COMMENT 'Tau_amplitudeMPa',
  `strain_total` double DEFAULT NULL COMMENT 'strain_total',
  `g_mean_mean` double DEFAULT NULL COMMENT 'g_mean_mean',
  `tau_max_mean` double DEFAULT NULL COMMENT 'tau_max_mean',
  `dtname` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'rdp_data_1' COMMENT 'The table name to save result data',
  PRIMARY KEY (`expid`) USING BTREE,
  UNIQUE KEY `unique_eid` (`eid`) USING BTREE,
  CONSTRAINT `fk_rdp_exp` FOREIGN KEY (`eid`) REFERENCES `experiment` (`eid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rdp_result`
--

LOCK TABLES `rdp_result` WRITE;
/*!40000 ALTER TABLE `rdp_result` DISABLE KEYS */;
INSERT INTO `rdp_result` VALUES (1,10,58478,365,365,1,100,0.18114597773523944,57.42245,1279.8764297092398,-1279.8764297092398,0.0000000000000012493059090287477,0.05151359199881366,-0.05235831628348083,-0.0002486862383905371,33.23901065033424,26.94998824022008,27.12651023972543,0.3305576231897463,8222.838608039012,0.0037346075286237256,0.046739248994877095,0.050290759981660174,1269.610205287086,1221.3009670354609,0.10387190828229449,26960.96368988574,1279.8764297092398,'rdp_data_1'),(2,9,148805,930,930,1,100,0.16127889485978802,52.99325,1181.0627068649258,-1181.062706864926,-8.566284865999055e-16,0.04803694610872408,-0.04644573260300675,0.0002454484515234728,30.234457187753865,27.26463575914149,27.816453987686106,0.42149390718650703,14841.911246559599,0.0029500027786253853,0.04198816201639737,0.04491992808766811,1171.680605953418,1045.6724157514695,0.09448267871173083,27462.565349989563,1181.0627068649258,'rdp_data_1'),(3,8,115202,720,720,1,100,0.17135555329617727,54.58565,1215.5805580253455,-1215.5805580253455,6.32471976198142e-16,0.05113475479803315,-0.05131566293499124,-0.00022114895356952172,32.784133674567805,27.109513159282177,27.10238487397899,0.3446325919855313,8601.662649231323,0.003342213459146682,0.04440367480019726,0.04797591392811053,1206.888565399578,1164.0880329354509,0.1024504177330244,27072.30256548991,1215.5805580253455,'rdp_data_1'),(4,12,164668,1029,1029,1,100,0.14247122684029712,47.6678,1068.2179798353989,-1068.2179798353989,0.0000000000000021012158722866776,0.04362852605086115,-0.04580914993828061,-0.0006361903099349099,28.620056316525364,27.113405350380177,27.67017526390818,0.33600438770783836,9900.4246037242,0.0015680495632997072,0.038129615006292174,0.03936940383720826,1053.9349216827868,998.8666573053825,0.08943767598914176,27530.229652251848,1068.2179798353989,'rdp_data_1'),(5,11,206443,1290,1290,1,100,0.15323990832510215,49.8517,1115.2169243814988,-1115.2169243814988,0.0000000000000031751172676324106,0.049978790707846714,-0.046243913041615355,-0.0007363452232736795,30.791265199827862,27.18250174529464,27.05744444450198,0.3879455201093761,12390.825865691872,0.001963555635292534,0.040734655184383656,0.04231523996522864,1102.2209444374146,1035.4045330795298,0.09622270374946207,27240.622516052565,1115.2169243814988,'rdp_data_1'),(6,6,400187,1250,1250,6,100,0.1504258911434948,16.02941864728927,380.1995175893413,-380.19951758934144,-0.0000000000000028216909282386686,0.0261303840099313,-0.02479295449734758,-0.000401462154190714,32.590936644658484,50.74200534249602,55.01465417463951,0.12964540086402682,611.6954211119142,0.016333821706151132,0.006230061965373086,0.022571074206467433,377.94980927488734,383.5008923354456,0.05092333850727888,51572.69160810174,380.1995175893413,'rdp_data_1'),(7,5,409446,1279,1279,1,100,0.12861460181574583,15.87528854608536,393.8042774951746,-393.8042774951746,0.000000000000001167558485990775,0.018968611206490207,-0.01967329361777925,-0.000358301477197573,24.730819087532453,54.92012618281202,56.19546036466608,0.13955437216530117,674.9537503532681,0.012989966615484936,0.006302223656876937,0.019292190272361873,374.3156511288345,363.26686026584383,0.038641904824269456,54404.54919278483,393.8042774951746,'rdp_data_1'),(8,13,470498,2940,2940,1,100,0.11791182627085892,40.1402,901.2797629273892,-901.279762927389,9.670537404016335e-17,0.03333767366868384,-0.04053023104935594,-0.0028957668893622177,23.63772950977273,27.562083934793257,27.490789255749036,0.23210524307391758,4425.436526060796,0.0006735001170461006,0.03218102238478868,0.03299360778992621,887.4997072097183,860.9588666425425,0.07386790471803978,27657.669574171734,901.2797629273892,'rdp_data_1'),(9,4,499589,1561,1561,1,100,0.10656362798988973,14.13075160980223,349.00320265660037,-349.00320265660037,0.0000000000000019927079929169477,0.015660965132611795,-0.01633688540412798,-0.0003327766835603283,20.478624343513452,56.77597429971943,53.62387833351888,0.13323384603394878,593.0271031249505,0.010351551103400358,0.005632993095083104,0.01589825777916489,333.18206937833804,331.19859930803165,0.03199785053673977,53009.80346171555,349.00320265660037,'rdp_data_1'),(10,1,984116,3075,3075,1,100,0.08480034214078944,13.219526946544631,331.40164626871524,-331.40164626871524,0.000000000000002963291435408095,0.014366668842833285,-0.012971725037557953,-0.00021858234360035443,17.496572083450392,57.39634137520024,61.081558318271654,0.17597646568840203,719.7106656335054,0.007837846489571235,0.0048822048315471794,0.012734432391004845,311.6967494635685,341.71498184407994,0.027338393880391238,56339.89772541294,331.40164626871524,'rdp_data_1'),(11,2,2285961,7143,7143,6,100,0.0630369897126619,12.102234244346604,297.20682918956936,-297.20682918956936,-0.0000000000000018852961135051666,0.010584467436410923,-0.009750355396144005,-0.0002545483982790289,13.014286612835155,61.47515234213851,58.16352444140703,0.2031071304587932,842.5002389201799,0.004711246943915251,0.004744301512984034,0.009462738991842499,285.35265221389193,315.1445235524376,0.02033482283255493,59151.99841835223,297.20682918956936,'rdp_data_1'),(12,3,12656426,39551,39551,6,100,0.04136951108377722,11.55459475517274,268.95243062241707,-268.95243062241707,4.4150664301654774e-17,0.010512562086978785,-0.00829786733761479,-0.0002405450522342558,12.038674831739888,60.90105966639339,61.00081229337973,0.20523823520630896,978.8746776028466,0.0019621028688539847,0.0042433237937125985,0.0062198077324530105,272.44012899398956,307.6233328575044,0.018810429424593576,62359.94330080859,268.95243062241707,'rdp_data_1');
/*!40000 ALTER TABLE `rdp_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specimen`
--

DROP TABLE IF EXISTS `specimen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specimen` (
  `sid` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'the specimen id',
  `sname` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the name of specimen',
  `mid` int unsigned NOT NULL COMMENT 'the material id',
  `radius` double NOT NULL COMMENT 'the radius of specimen',
  `length` double NOT NULL COMMENT 'the length of specimen',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT 'the description',
  PRIMARY KEY (`sid`) USING BTREE,
  UNIQUE KEY `unique_sname` (`sname`) USING BTREE,
  KEY `fk_specimen_material` (`mid`) USING BTREE,
  CONSTRAINT `fk_specimen_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specimen`
--

LOCK TABLES `specimen` WRITE;
/*!40000 ALTER TABLE `specimen` DISABLE KEYS */;
INSERT INTO `specimen` VALUES (1,'S1-GCr15',1,3,20,''),(2,'S2-GCr15',1,3,20,''),(3,'S3-GCr15',1,3,20,''),(4,'S4-GCr15',1,3,20,''),(5,'S5-GCr15',1,3,20,''),(6,'S6-GCr15',1,3,20,''),(7,'S7-GCr15',1,3,20,''),(8,'S2-QT800',2,3,20,''),(9,'S3-QT800',2,3,20,''),(10,'S5-QT800',2,3,20,''),(11,'S6-QT800',2,3,20,''),(12,'S7-QT800',2,3,20,''),(13,'S8-QT800',2,3,20,'What is this? 中文');
/*!40000 ALTER TABLE `specimen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb`
--

DROP TABLE IF EXISTS `tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb` (
  `tb_id` int unsigned NOT NULL AUTO_INCREMENT,
  `glabel` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mid` int unsigned NOT NULL DEFAULT '0',
  `meanload` double NOT NULL DEFAULT '0',
  `frequency` double NOT NULL DEFAULT '0',
  `FatigueLifeNf` double NOT NULL DEFAULT '0',
  `fracturemode` int NOT NULL DEFAULT '0',
  `nooftheeth` int NOT NULL DEFAULT '0',
  `toothwidth` int NOT NULL DEFAULT '0',
  `ampload` int NOT NULL DEFAULT '0',
  `ratioofload` double NOT NULL DEFAULT '0',
  `runoutcycles` int NOT NULL DEFAULT '0',
  `runouttime` int NOT NULL DEFAULT '0',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `pic1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `pic2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `pic3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  PRIMARY KEY (`tb_id`),
  KEY `torison_fk` (`mid`) USING BTREE,
  CONSTRAINT `fk_tb_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='GEAR TOOTH TEST';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb`
--

LOCK TABLES `tb` WRITE;
/*!40000 ALTER TABLE `tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `torison`
--

DROP TABLE IF EXISTS `torison`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `torison` (
  `torison_id` int unsigned NOT NULL AUTO_INCREMENT,
  `sname` varchar(64) NOT NULL DEFAULT '',
  `mid` int unsigned NOT NULL DEFAULT '0',
  `diameter` double NOT NULL DEFAULT '0',
  `moment` double NOT NULL DEFAULT '0',
  `FatigueLifeNf` double NOT NULL DEFAULT '0',
  `FracturedLocs` double NOT NULL DEFAULT '0',
  `speed` double NOT NULL DEFAULT '0',
  `lp` double NOT NULL DEFAULT '0',
  `stress` double NOT NULL DEFAULT '0',
  `runoutcycles` int NOT NULL DEFAULT '0',
  `runouttime` int NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `pic1` varchar(512) DEFAULT '',
  `pic2` varchar(512) DEFAULT '',
  `pic3` varchar(512) DEFAULT '',
  PRIMARY KEY (`torison_id`),
  KEY `fk_torison_material` (`mid`),
  CONSTRAINT `fk_torison_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Torison Test';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `torison`
--

LOCK TABLES `torison` WRITE;
/*!40000 ALTER TABLE `torison` DISABLE KEYS */;
/*!40000 ALTER TABLE `torison` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `uid` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'user id',
  `username` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'username',
  `password` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'password of the user',
  `type` int unsigned NOT NULL DEFAULT '0' COMMENT 'user type, 0 administrators, 1 teacher, 2 student 3 normal user',
  `userno` int DEFAULT NULL COMMENT 'the digital number for user by type',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'something about the user',
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'韩福宁','7c4a8d09ca3762af61e59520943dc26494f8941b',0,1,''),(2,'高天天','7c4a8d09ca3762af61e59520943dc26494f8941b',0,2,'');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_exp_brief`
--

DROP TABLE IF EXISTS `v_exp_brief`;
/*!50001 DROP VIEW IF EXISTS `v_exp_brief`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_exp_brief` AS SELECT 
 1 AS `eid`,
 1 AS `ename`,
 1 AS `etime`,
 1 AS `sid`,
 1 AS `uid`,
 1 AS `H`,
 1 AS `cycles`,
 1 AS `username`,
 1 AS `sname`,
 1 AS `mid`,
 1 AS `mname`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_experiment`
--

DROP TABLE IF EXISTS `v_experiment`;
/*!50001 DROP VIEW IF EXISTS `v_experiment`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_experiment` AS SELECT 
 1 AS `eid`,
 1 AS `ename`,
 1 AS `etime`,
 1 AS `sid`,
 1 AS `uid`,
 1 AS `frequncy`,
 1 AS `sampling`,
 1 AS `H`,
 1 AS `cycles`,
 1 AS `datatype`,
 1 AS `datapath`,
 1 AS `rawpath`,
 1 AS `username`,
 1 AS `sname`,
 1 AS `mid`,
 1 AS `radius`,
 1 AS `length`,
 1 AS `mname`,
 1 AS `memo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_rdp_exp`
--

DROP TABLE IF EXISTS `v_rdp_exp`;
/*!50001 DROP VIEW IF EXISTS `v_rdp_exp`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_rdp_exp` AS SELECT 
 1 AS `expid`,
 1 AS `eid`,
 1 AS `rawlen`,
 1 AS `period`,
 1 AS `bpoint`,
 1 AS `theta_8`,
 1 AS `torque_8`,
 1 AS `TauMax`,
 1 AS `TauMin`,
 1 AS `TauMean`,
 1 AS `Strain_TotMax`,
 1 AS `Strain_TotMin`,
 1 AS `Strain_TotMean`,
 1 AS `StrainRate`,
 1 AS `ename`,
 1 AS `first_loop`,
 1 AS `G_loop_no`,
 1 AS `G_left_value`,
 1 AS `G_right_value`,
 1 AS `nHardening`,
 1 AS `KMpa`,
 1 AS `Strain_Plastic`,
 1 AS `Strain_Elastic`,
 1 AS `Strain_amplitude`,
 1 AS `Tau_MaxMPa`,
 1 AS `Tau_amplitudeMPa`,
 1 AS `strain_total`,
 1 AS `g_mean_mean`,
 1 AS `tau_max_mean`,
 1 AS `dtname`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_specimen`
--

DROP TABLE IF EXISTS `v_specimen`;
/*!50001 DROP VIEW IF EXISTS `v_specimen`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_specimen` AS SELECT 
 1 AS `sid`,
 1 AS `sname`,
 1 AS `mid`,
 1 AS `radius`,
 1 AS `length`,
 1 AS `mname`,
 1 AS `en_name`,
 1 AS `standard`,
 1 AS `properties`,
 1 AS `memo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_specimen_params`
--

DROP TABLE IF EXISTS `v_specimen_params`;
/*!50001 DROP VIEW IF EXISTS `v_specimen_params`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_specimen_params` AS SELECT 
 1 AS `expid`,
 1 AS `eid`,
 1 AS `N`,
 1 AS `Strain`,
 1 AS `Tau`,
 1 AS `pStrain`,
 1 AS `eStrain`,
 1 AS `E`,
 1 AS `ename`,
 1 AS `sname`,
 1 AS `mname`,
 1 AS `sid`,
 1 AS `mid`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'cloudlab'
--

--
-- Dumping routines for database 'cloudlab'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_rdp_pic_save_path` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cloudlab`@`localhost` PROCEDURE `get_rdp_pic_save_path`(IN `eid` int)
BEGIN
	DECLARE pic_path VARCHAR(512);
	DECLARE root_path VARCHAR(512);
	
	SELECT CONCAT(`content`, '\\', CONVERT(eid, char), '\\') INTO `pic_path` FROM `config` WHERE `item` = 'rdp_pic_path';
	SELECT CONCAT(`content`, '\\', CONVERT(eid, char)) INTO `root_path` FROM `config` WHERE `item` = 'rdp_pic_path';
	CREATE TEMPORARY TABLE IF NOT EXISTS tt_pic_path (`path` VARCHAR(255));
  DELETE FROM tt_pic_path;
	INSERT INTO tt_pic_path(`path`) SELECT root_path;
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_origin.png');
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_origin.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'max_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'min_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'strain.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_all.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_100.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_n1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_last.png');
	SELECT * FROM tt_pic_path;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_rdp_pic_web_path` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cloudlab`@`localhost` PROCEDURE `get_rdp_pic_web_path`(IN `eid` int)
BEGIN
	DECLARE pic_path VARCHAR(512);
	
	SELECT CONCAT(`content`, '/', CONVERT(eid, char), '/') INTO `pic_path` FROM `config` WHERE `item` = 'rdp_pic_web_root';
	CREATE TEMPORARY TABLE IF NOT EXISTS tt_pic_path (`path` VARCHAR(255));
  DELETE FROM tt_pic_path;
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_origin.png');
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_origin.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'max_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'min_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'strain.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_all.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_100.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_n1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_last.png');

	SELECT * FROM tt_pic_path;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_exp_brief`
--

/*!50001 DROP VIEW IF EXISTS `v_exp_brief`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cloudlab`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_exp_brief` AS select `e`.`eid` AS `eid`,`e`.`ename` AS `ename`,`e`.`etime` AS `etime`,`e`.`sid` AS `sid`,`e`.`uid` AS `uid`,`e`.`H` AS `H`,`e`.`cycles` AS `cycles`,`u`.`username` AS `username`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`m`.`mname` AS `mname` from (((`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`m`.`mid` = `s`.`mid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_experiment`
--

/*!50001 DROP VIEW IF EXISTS `v_experiment`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cloudlab`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_experiment` AS select `e`.`eid` AS `eid`,`e`.`ename` AS `ename`,`e`.`etime` AS `etime`,`e`.`sid` AS `sid`,`e`.`uid` AS `uid`,`e`.`frequncy` AS `frequncy`,`e`.`sampling` AS `sampling`,`e`.`H` AS `H`,`e`.`cycles` AS `cycles`,`e`.`datatype` AS `datatype`,`e`.`datapath` AS `datapath`,`e`.`rawpath` AS `rawpath`,`u`.`username` AS `username`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname`,`e`.`memo` AS `memo` from (((`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`m`.`mid` = `s`.`mid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_rdp_exp`
--

/*!50001 DROP VIEW IF EXISTS `v_rdp_exp`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cloudlab`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_rdp_exp` AS select `r`.`expid` AS `expid`,`r`.`eid` AS `eid`,`r`.`rawlen` AS `rawlen`,`r`.`period` AS `period`,`r`.`bpoint` AS `bpoint`,`r`.`theta_8` AS `theta_8`,`r`.`torque_8` AS `torque_8`,`r`.`TauMax` AS `TauMax`,`r`.`TauMin` AS `TauMin`,`r`.`TauMean` AS `TauMean`,`r`.`Strain_TotMax` AS `Strain_TotMax`,`r`.`Strain_TotMin` AS `Strain_TotMin`,`r`.`Strain_TotMean` AS `Strain_TotMean`,`r`.`StrainRate` AS `StrainRate`,`e`.`ename` AS `ename`,`r`.`first_loop` AS `first_loop`,`r`.`G_loop_no` AS `G_loop_no`,`r`.`G_left_value` AS `G_left_value`,`r`.`G_right_value` AS `G_right_value`,`r`.`nHardening` AS `nHardening`,`r`.`KMpa` AS `KMpa`,`r`.`Strain_Plastic` AS `Strain_Plastic`,`r`.`Strain_Elastic` AS `Strain_Elastic`,`r`.`Strain_amplitude` AS `Strain_amplitude`,`r`.`Tau_MaxMPa` AS `Tau_MaxMPa`,`r`.`Tau_amplitudeMPa` AS `Tau_amplitudeMPa`,`r`.`strain_total` AS `strain_total`,`r`.`g_mean_mean` AS `g_mean_mean`,`r`.`tau_max_mean` AS `tau_max_mean`,`r`.`dtname` AS `dtname` from (`rdp_result` `r` join `experiment` `e` on((`r`.`eid` = `e`.`eid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_specimen`
--

/*!50001 DROP VIEW IF EXISTS `v_specimen`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cloudlab`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_specimen` AS select `s`.`sid` AS `sid`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname`,`m`.`en_name` AS `en_name`,`m`.`standard` AS `standard`,`m`.`properties` AS `properties`,`s`.`memo` AS `memo` from (`specimen` `s` join `material` `m` on((`s`.`mid` = `m`.`mid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_specimen_params`
--

/*!50001 DROP VIEW IF EXISTS `v_specimen_params`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cloudlab`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_specimen_params` AS select `r`.`expid` AS `expid`,`r`.`eid` AS `eid`,`r`.`period` AS `N`,`r`.`Tau_amplitudeMPa` AS `Strain`,`r`.`Tau_MaxMPa` AS `Tau`,`r`.`Strain_Plastic` AS `pStrain`,`r`.`Strain_Elastic` AS `eStrain`,`r`.`g_mean_mean` AS `E`,`e`.`ename` AS `ename`,`s`.`sname` AS `sname`,`m`.`mname` AS `mname`,`e`.`sid` AS `sid`,`s`.`mid` AS `mid` from (((`rdp_result` `r` join `experiment` `e` on((`r`.`eid` = `e`.`eid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`s`.`mid` = `m`.`mid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-06-22 21:57:15

-- ----------------------------
-- Procedure structure for get_rdp_pic_save_path
-- ----------------------------
DROP PROCEDURE IF EXISTS `get_rdp_pic_save_path`;
delimiter ;;
CREATE PROCEDURE `get_rdp_pic_save_path`(IN `eid` int)
BEGIN
	DECLARE pic_path VARCHAR(512);
	DECLARE root_path VARCHAR(512);
	
	SELECT CONCAT(`content`, '\\', CONVERT(eid, char), '\\') INTO `pic_path` FROM `config` WHERE `item` = 'rdp_pic_path';
	SELECT CONCAT(`content`, '\\', CONVERT(eid, char)) INTO `root_path` FROM `config` WHERE `item` = 'rdp_pic_path';
	CREATE TEMPORARY TABLE IF NOT EXISTS tt_pic_path (`path` VARCHAR(255));
  DELETE FROM tt_pic_path;
	INSERT INTO tt_pic_path(`path`) SELECT root_path;
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_origin.png');
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_origin.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'max_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'min_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'strain.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_all.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_100.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_n1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_last.png');
	SELECT * FROM tt_pic_path;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for get_rdp_pic_web_path
-- ----------------------------
DROP PROCEDURE IF EXISTS `get_rdp_pic_web_path`;
delimiter ;;
CREATE PROCEDURE `get_rdp_pic_web_path`(IN `eid` int)
BEGIN
	DECLARE pic_path VARCHAR(512);
	
	SELECT CONCAT(`content`, '/', CONVERT(eid, char), '/') INTO `pic_path` FROM `config` WHERE `item` = 'rdp_pic_web_root';
	CREATE TEMPORARY TABLE IF NOT EXISTS tt_pic_path (`path` VARCHAR(255));
  DELETE FROM tt_pic_path;
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_origin.png');
  INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'angle_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_origin.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'torque_smooth.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'max_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'min_force.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'strain.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_all.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_100.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_n1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_last.png');

	SELECT * FROM tt_pic_path;
END
;;
delimiter ;
