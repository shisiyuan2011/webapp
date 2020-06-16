/*
 Navicat Premium Data Transfer

 Source Server         : cloudlab
 Source Server Type    : MySQL
 Source Server Version : 80020
 Source Host           : localhost:33996
 Source Schema         : cloudlab

 Target Server Type    : MySQL
 Target Server Version : 80020
 File Encoding         : 65001

 Date: 10/06/2020 03:31:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for config
-- ----------------------------
DROP TABLE IF EXISTS `config`;
CREATE TABLE `config`  (
  `cid` int(0) UNSIGNED NOT NULL,
  `item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'key',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'value',
  `vtype` tinyint(0) NOT NULL COMMENT '1, string, 2, int, 3, float/double',
  PRIMARY KEY (`cid`) USING BTREE,
  UNIQUE INDEX `unique`(`item`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of config
-- ----------------------------
INSERT INTO `config` VALUES (1, 'webroot', 'E:\\gtt\\webapp', 1);
INSERT INTO `config` VALUES (2, 'rdp_pic_path', 'E:\\gtt\\webapp\\images\\rdp', 1);
INSERT INTO `config` VALUES (3, 'rdp_pic_web_root', '/images/rdp', 1);

-- ----------------------------
-- Table structure for experiment
-- ----------------------------
DROP TABLE IF EXISTS `experiment`;
CREATE TABLE `experiment`  (
  `eid` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'the experiment id',
  `ename` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the name of experiment',
  `etime` datetime(0) NOT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT 'the date and time of experiment',
  `sid` int(0) UNSIGNED NOT NULL COMMENT 'the id of specimen',
  `uid` int(0) UNSIGNED NOT NULL COMMENT 'operator',
  `frequncy` double NOT NULL COMMENT 'the frequncy',
  `sampling` double NOT NULL COMMENT 'the sampling',
  `H` double NULL DEFAULT NULL COMMENT 'the H value',
  `cycles` double NULL DEFAULT NULL COMMENT 'the cycles',
  `datatype` int(0) NOT NULL DEFAULT 0 COMMENT 'the type of datafile, 0 for 3 columns, 1 for 9 columns',
  `datapath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the filepath of raw data file',
  `rawpath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'the path of the raw files',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  PRIMARY KEY (`eid`) USING BTREE,
  UNIQUE INDEX `unique_ename`(`ename`) USING BTREE,
  UNIQUE INDEX `unique_datapath`(`datapath`) USING BTREE,
  UNIQUE INDEX `unique_rawpath`(`rawpath`) USING BTREE,
  INDEX `fk_experiment_specimen`(`sid`) USING BTREE,
  INDEX `fk_experiment_user`(`uid`) USING BTREE,
  CONSTRAINT `fk_experiment_specimen` FOREIGN KEY (`sid`) REFERENCES `specimen` (`sid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_experiment_user` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of experiment
-- ----------------------------
INSERT INTO `experiment` VALUES (1, 'GCr15测试1', '2020-06-08 18:10:35', 1, 1, 0.1, 32, 20, 3087, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087', 'E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087', '');
INSERT INTO `experiment` VALUES (2, 'GCr15 测试2', '2020-06-08 18:10:35', 2, 1, 0.1, 32, 15, 7141, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141', 'E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141', '');
INSERT INTO `experiment` VALUES (3, 'GCr15 测试3', '2020-06-08 18:10:35', 3, 1, 0.1, 32, 10, 39534, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534', 'E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534', '');
INSERT INTO `experiment` VALUES (4, 'GCr15 测试4', '2020-06-08 18:10:35', 4, 1, 0.1, 32, 25, 1640, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640', 'E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640', '');
INSERT INTO `experiment` VALUES (5, 'GCr15 测试5', '2020-06-08 18:10:35', 5, 1, 0.1, 32, 30, 1279, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279', 'E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279', '');
INSERT INTO `experiment` VALUES (6, 'GCr15 测试6', '2020-06-08 18:10:35', 6, 1, 0.1, 32, 35, 1250, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250', 'E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250', '');
INSERT INTO `experiment` VALUES (8, 'QT800 测试1', '2020-06-08 18:10:35', 8, 1, 0.1, 16, 36, 743, 2, 'E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210', '');
INSERT INTO `experiment` VALUES (9, 'QT800 测试2', '2020-06-08 18:10:35', 9, 1, 0.1, 16, 34, 954, 2, 'E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210', '');
INSERT INTO `experiment` VALUES (10, 'QT800 测试3', '2020-06-08 18:10:35', 10, 1, 0.1, 16, 38, 366, 2, 'E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212', '');
INSERT INTO `experiment` VALUES (11, 'QT800 测试4', '2020-06-08 18:10:35', 11, 1, 0.1, 16, 32, 1298, 2, 'E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212', '');
INSERT INTO `experiment` VALUES (12, 'QT800 测试5', '2020-06-08 18:10:35', 12, 1, 0.1, 16, 30, 1029, 2, 'E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212', '');
INSERT INTO `experiment` VALUES (13, 'QT800 测试6', '2020-06-08 18:10:35', 13, 1, 0.1, 16, 25, 2951, 2, 'E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212', '');

-- ----------------------------
-- Table structure for material
-- ----------------------------
DROP TABLE IF EXISTS `material`;
CREATE TABLE `material`  (
  `mid` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'the id of the material',
  `mname` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'name of material',
  `en_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'the english name of material',
  `standard` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'the standard name',
  `properties` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'the description of the material',
  PRIMARY KEY (`mid`) USING BTREE,
  UNIQUE INDEX `unique_mname`(`mname`) USING BTREE,
  UNIQUE INDEX `unique_en_name`(`en_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of material
-- ----------------------------
INSERT INTO `material` VALUES (1, 'GCr15', 'High-carbon chromium bearing steel', 'GB/T 18254-2016', '高碳铬轴承钢');
INSERT INTO `material` VALUES (2, 'QT800', '', '', '');

-- ----------------------------
-- Table structure for rdp_data_1
-- ----------------------------
DROP TABLE IF EXISTS `rdp_data_1`;
CREATE TABLE `rdp_data_1`  (
  `rdpd_id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'the data id',
  `eid` int(0) UNSIGNED NOT NULL COMMENT 'experiment id',
  `max_angle` double NULL DEFAULT NULL COMMENT 'max_angle',
  `min_angle` double NULL DEFAULT NULL COMMENT 'min_angle',
  `max_torque` double NULL DEFAULT NULL COMMENT 'max_torque',
  `min_torque` double NULL DEFAULT NULL COMMENT 'max_torque',
  `max_shearforce` double NULL DEFAULT NULL COMMENT 'max_shearforce',
  `min_shearforce` double NULL DEFAULT NULL COMMENT 'min_shearforce',
  `max_shearstrain` double NULL DEFAULT NULL COMMENT 'max_shearstrain',
  `min_shearstrain` double NULL DEFAULT NULL COMMENT 'min_shearstrain',
  `max_force_improved` double NULL DEFAULT NULL COMMENT 'max_force_improved',
  `min_force_improved` double NULL DEFAULT NULL COMMENT 'min_force_improved',
  `G_right` double NULL DEFAULT NULL COMMENT 'G_right',
  `G_left` double NULL DEFAULT NULL COMMENT 'G_left',
  `G_mean` double NULL DEFAULT NULL COMMENT 'G_mean',
  `Tao_max` double NULL DEFAULT NULL COMMENT 'Tao_max',
  PRIMARY KEY (`rdpd_id`) USING BTREE,
  INDEX `fk_rdpd_exp`(`eid`) USING BTREE,
  CONSTRAINT `fk_rdpd_exp` FOREIGN KEY (`eid`) REFERENCES `experiment` (`eid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rdp_data_1
-- ----------------------------

-- ----------------------------
-- Table structure for rdp_result
-- ----------------------------
DROP TABLE IF EXISTS `rdp_result`;
CREATE TABLE `rdp_result`  (
  `expid` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'result id',
  `eid` int(0) UNSIGNED NOT NULL COMMENT 'the experiment id',
  `rawlen` int(0) UNSIGNED NULL DEFAULT NULL COMMENT 'the length of raw data',
  `period` int(0) UNSIGNED NULL DEFAULT NULL COMMENT 'the amount of period',
  `bpoint` int(0) UNSIGNED NULL DEFAULT NULL COMMENT 'break point',
  `first_loop` int(0) NULL DEFAULT 100 COMMENT 'the effect first loop no for G__',
  `G_loop_no` int(0) NULL DEFAULT 100 COMMENT 'The Effect Loop No for G___',
  `theta_8` double NULL DEFAULT NULL COMMENT 'theta_8',
  `torque_8` double NULL DEFAULT NULL COMMENT 'torque_8',
  `TauMax` double NULL DEFAULT NULL COMMENT 'Max Tau in MPa',
  `TauMin` double NULL DEFAULT NULL COMMENT 'Min Tau in MPa',
  `TauMean` double NULL DEFAULT NULL COMMENT 'Mean Tau in Mpa',
  `Strain_TotMax` double NULL DEFAULT NULL COMMENT 'Strain_TotMax',
  `Strain_TotMin` double NULL DEFAULT NULL COMMENT 'Strain_TotMin',
  `Strain_TotMean` double NULL DEFAULT NULL COMMENT 'Strain_TotMean',
  `StrainRate` double NULL DEFAULT NULL COMMENT 'StrainRate',
  `G_left_value` double NULL DEFAULT NULL COMMENT 'G_left_value',
  `G_right_value` double NULL DEFAULT NULL COMMENT 'G_right_value',
  `nHardening` double NULL DEFAULT NULL COMMENT 'nHardening',
  `KMpa` double NULL DEFAULT NULL COMMENT 'KMpa',
  `Strain_Plastic` double NULL DEFAULT NULL COMMENT 'Strain_Plastic',
  `Strain_Elastic` double NULL DEFAULT NULL COMMENT 'Strain_Elastic',
  `Strain_amplitude` double NULL DEFAULT NULL COMMENT 'Strain_amplitude',
  `Tau_MaxMPa` double NULL DEFAULT NULL COMMENT 'Tau_MaxMPa',
  `Tau_amplitudeMPa` double NULL DEFAULT NULL COMMENT 'Tau_amplitudeMPa',
  `strain_total` double NULL DEFAULT NULL COMMENT 'strain_total',
  `g_mean_mean` double NULL DEFAULT NULL COMMENT 'g_mean_mean',
  `tau_max_mean` double NULL DEFAULT NULL COMMENT 'tau_max_mean',
  `dtname` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'rdp_data_1' COMMENT 'The table name to save result data',
  PRIMARY KEY (`expid`) USING BTREE,
  UNIQUE INDEX `unique_eid`(`eid`) USING BTREE,
  CONSTRAINT `fk_rdp_exp` FOREIGN KEY (`eid`) REFERENCES `experiment` (`eid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rdp_result
-- ----------------------------
INSERT INTO `rdp_result` VALUES (1, 10, 58478, 365, 365, 1, 100, 0.18114597773523944, 57.42245, 1279.8764297092398, -1279.8764297092398, 0.0000000000000012493059090287477, 0.05151359199881366, -0.05235831628348083, -0.0002486862383905371, 33.23901065033424, 26.94998824022008, 27.12651023972543, 0.3305576231897463, 8222.838608039012, 0.0037346075286237256, 0.046739248994877095, 0.050290759981660174, 1269.610205287086, 1221.3009670354609, 0.10387190828229449, 26960.96368988574, 1279.8764297092398, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (2, 9, 148805, 930, 930, 1, 100, 0.16127889485978802, 52.99325, 1181.0627068649258, -1181.062706864926, -8.566284865999055e-16, 0.04803694610872408, -0.04644573260300675, 0.0002454484515234728, 30.234457187753865, 27.26463575914149, 27.816453987686106, 0.42149390718650703, 14841.911246559599, 0.0029500027786253853, 0.04198816201639737, 0.04491992808766811, 1171.680605953418, 1045.6724157514695, 0.09448267871173083, 27462.565349989563, 1181.0627068649258, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (3, 8, 115202, 720, 720, 1, 100, 0.17135555329617727, 54.58565, 1215.5805580253455, -1215.5805580253455, 6.32471976198142e-16, 0.05113475479803315, -0.05131566293499124, -0.00022114895356952172, 32.784133674567805, 27.109513159282177, 27.10238487397899, 0.3446325919855313, 8601.662649231323, 0.003342213459146682, 0.04440367480019726, 0.04797591392811053, 1206.888565399578, 1164.0880329354509, 0.1024504177330244, 27072.30256548991, 1215.5805580253455, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (4, 12, 164668, 1029, 1029, 1, 100, 0.14247122684029712, 47.6678, 1068.2179798353989, -1068.2179798353989, 0.0000000000000021012158722866776, 0.04362852605086115, -0.04580914993828061, -0.0006361903099349099, 28.620056316525364, 27.113405350380177, 27.67017526390818, 0.33600438770783836, 9900.4246037242, 0.0015680495632997072, 0.038129615006292174, 0.03936940383720826, 1053.9349216827868, 998.8666573053825, 0.08943767598914176, 27530.229652251848, 1068.2179798353989, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (5, 11, 206443, 1290, 1290, 1, 100, 0.15323990832510215, 49.8517, 1115.2169243814988, -1115.2169243814988, 0.0000000000000031751172676324106, 0.049978790707846714, -0.046243913041615355, -0.0007363452232736795, 30.791265199827862, 27.18250174529464, 27.05744444450198, 0.3879455201093761, 12390.825865691872, 0.001963555635292534, 0.040734655184383656, 0.04231523996522864, 1102.2209444374146, 1035.4045330795298, 0.09622270374946207, 27240.622516052565, 1115.2169243814988, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (6, 6, 400187, 1250, 1250, 6, 100, 0.1504258911434948, 16.02941864728927, 380.1995175893413, -380.19951758934144, -0.0000000000000028216909282386686, 0.0261303840099313, -0.02479295449734758, -0.000401462154190714, 32.590936644658484, 50.74200534249602, 55.01465417463951, 0.12964540086402682, 611.6954211119142, 0.016333821706151132, 0.006230061965373086, 0.022571074206467433, 377.94980927488734, 383.5008923354456, 0.05092333850727888, 51572.69160810174, 380.1995175893413, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (7, 5, 409446, 1279, 1279, 1, 100, 0.12861460181574583, 15.87528854608536, 393.8042774951746, -393.8042774951746, 0.000000000000001167558485990775, 0.018968611206490207, -0.01967329361777925, -0.000358301477197573, 24.730819087532453, 54.92012618281202, 56.19546036466608, 0.13955437216530117, 674.9537503532681, 0.012989966615484936, 0.006302223656876937, 0.019292190272361873, 374.3156511288345, 363.26686026584383, 0.038641904824269456, 54404.54919278483, 393.8042774951746, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (8, 13, 470498, 2940, 2940, 1, 100, 0.11791182627085892, 40.1402, 901.2797629273892, -901.279762927389, 9.670537404016335e-17, 0.03333767366868384, -0.04053023104935594, -0.0028957668893622177, 23.63772950977273, 27.562083934793257, 27.490789255749036, 0.23210524307391758, 4425.436526060796, 0.0006735001170461006, 0.03218102238478868, 0.03299360778992621, 887.4997072097183, 860.9588666425425, 0.07386790471803978, 27657.669574171734, 901.2797629273892, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (9, 4, 499589, 1561, 1561, 1, 100, 0.10656362798988973, 14.13075160980223, 349.00320265660037, -349.00320265660037, 0.0000000000000019927079929169477, 0.015660965132611795, -0.01633688540412798, -0.0003327766835603283, 20.478624343513452, 56.77597429971943, 53.62387833351888, 0.13323384603394878, 593.0271031249505, 0.010351551103400358, 0.005632993095083104, 0.01589825777916489, 333.18206937833804, 331.19859930803165, 0.03199785053673977, 53009.80346171555, 349.00320265660037, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (10, 1, 984116, 3075, 3075, 1, 100, 0.08480034214078944, 13.219526946544631, 331.40164626871524, -331.40164626871524, 0.000000000000002963291435408095, 0.014366668842833285, -0.012971725037557953, -0.00021858234360035443, 17.496572083450392, 57.39634137520024, 61.081558318271654, 0.17597646568840203, 719.7106656335054, 0.007837846489571235, 0.0048822048315471794, 0.012734432391004845, 311.6967494635685, 341.71498184407994, 0.027338393880391238, 56339.89772541294, 331.40164626871524, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (11, 2, 2285961, 7143, 7143, 6, 100, 0.0630369897126619, 12.102234244346604, 297.20682918956936, -297.20682918956936, -0.0000000000000018852961135051666, 0.010584467436410923, -0.009750355396144005, -0.0002545483982790289, 13.014286612835155, 61.47515234213851, 58.16352444140703, 0.2031071304587932, 842.5002389201799, 0.004711246943915251, 0.004744301512984034, 0.009462738991842499, 285.35265221389193, 315.1445235524376, 0.02033482283255493, 59151.99841835223, 297.20682918956936, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (12, 3, 12656426, 39551, 39551, 6, 100, 0.04136951108377722, 11.55459475517274, 268.95243062241707, -268.95243062241707, 4.4150664301654774e-17, 0.010512562086978785, -0.00829786733761479, -0.0002405450522342558, 12.038674831739888, 60.90105966639339, 61.00081229337973, 0.20523823520630896, 978.8746776028466, 0.0019621028688539847, 0.0042433237937125985, 0.0062198077324530105, 272.44012899398956, 307.6233328575044, 0.018810429424593576, 62359.94330080859, 268.95243062241707, 'rdp_data_1');

-- ----------------------------
-- Table structure for specimen
-- ----------------------------
DROP TABLE IF EXISTS `specimen`;
CREATE TABLE `specimen`  (
  `sid` int(0) UNSIGNED NOT NULL COMMENT 'the specimen id',
  `sname` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the name of specimen',
  `mid` int(0) UNSIGNED NOT NULL COMMENT 'the material id',
  `radius` double NOT NULL COMMENT 'the radius of specimen',
  `length` double NOT NULL COMMENT 'the length of specimen',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'the description',
  PRIMARY KEY (`sid`) USING BTREE,
  UNIQUE INDEX `unique_sname`(`sname`) USING BTREE,
  INDEX `fk_specimen_material`(`mid`) USING BTREE,
  CONSTRAINT `fk_specimen_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of specimen
-- ----------------------------
INSERT INTO `specimen` VALUES (1, 'S1-GCr15', 1, 3, 20, '');
INSERT INTO `specimen` VALUES (2, 'S2-GCr15', 1, 3, 20, '');
INSERT INTO `specimen` VALUES (3, 'S3-GCr15', 1, 3, 20, '');
INSERT INTO `specimen` VALUES (4, 'S4-GCr15', 1, 3, 20, '');
INSERT INTO `specimen` VALUES (5, 'S5-GCr15', 1, 3, 20, '');
INSERT INTO `specimen` VALUES (6, 'S6-GCr15', 1, 3, 20, '');
INSERT INTO `specimen` VALUES (7, 'S7-GCr15', 1, 3, 20, '');
INSERT INTO `specimen` VALUES (8, 'S2-QT800', 2, 3, 20, '');
INSERT INTO `specimen` VALUES (9, 'S3-QT800', 2, 3, 20, '');
INSERT INTO `specimen` VALUES (10, 'S5-QT800', 2, 3, 20, '');
INSERT INTO `specimen` VALUES (11, 'S6-QT800', 2, 3, 20, '');
INSERT INTO `specimen` VALUES (12, 'S7-QT800', 2, 3, 20, '');
INSERT INTO `specimen` VALUES (13, 'S8-QT800', 2, 3, 20, '');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `uid` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'user id',
  `username` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'username',
  `password` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'password of the user',
  `type` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'user type, 0 administrators, 1 teacher, 2 student 3 normal user',
  `userno` int(0) NULL DEFAULT NULL COMMENT 'the digital number for user by type',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'something about the user',
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '韩福宁', '7c4a8d09ca3762af61e59520943dc26494f8941b', 0, 1, '');
INSERT INTO `user` VALUES (2, '高天天', '7c4a8d09ca3762af61e59520943dc26494f8941b', 0, 2, '');

-- ----------------------------
-- View structure for v_exp_brief
-- ----------------------------
DROP VIEW IF EXISTS `v_exp_brief`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_exp_brief` AS select `e`.`eid` AS `eid`,`e`.`ename` AS `ename`,`e`.`etime` AS `etime`,`e`.`sid` AS `sid`,`e`.`uid` AS `uid`,`e`.`H` AS `H`,`e`.`cycles` AS `cycles`,`u`.`username` AS `username`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`m`.`mname` AS `mname` from (((`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`m`.`mid` = `s`.`mid`)));

-- ----------------------------
-- View structure for v_experiment
-- ----------------------------
DROP VIEW IF EXISTS `v_experiment`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_experiment` AS select `e`.`eid` AS `eid`,`e`.`ename` AS `ename`,`e`.`etime` AS `etime`,`e`.`sid` AS `sid`,`e`.`uid` AS `uid`,`e`.`frequncy` AS `frequncy`,`e`.`sampling` AS `sampling`,`e`.`H` AS `H`,`e`.`cycles` AS `cycles`,`e`.`datatype` AS `datatype`,`e`.`datapath` AS `datapath`,`e`.`rawpath` AS `rawpath`,`u`.`username` AS `username`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname`,`e`.`memo` AS `memo` from (((`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`m`.`mid` = `s`.`mid`)));

-- ----------------------------
-- View structure for v_rdp_exp
-- ----------------------------
DROP VIEW IF EXISTS `v_rdp_exp`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_rdp_exp` AS select `r`.`expid` AS `expid`,`r`.`eid` AS `eid`,`r`.`rawlen` AS `rawlen`,`r`.`period` AS `period`,`r`.`bpoint` AS `bpoint`,`r`.`theta_8` AS `theta_8`,`r`.`torque_8` AS `torque_8`,`r`.`TauMax` AS `TauMax`,`r`.`TauMin` AS `TauMin`,`r`.`TauMean` AS `TauMean`,`r`.`Strain_TotMax` AS `Strain_TotMax`,`r`.`Strain_TotMin` AS `Strain_TotMin`,`r`.`Strain_TotMean` AS `Strain_TotMean`,`r`.`StrainRate` AS `StrainRate`,`e`.`ename` AS `ename`,`r`.`first_loop` AS `first_loop`,`r`.`G_loop_no` AS `G_loop_no`,`r`.`G_left_value` AS `G_left_value`,`r`.`G_right_value` AS `G_right_value`,`r`.`nHardening` AS `nHardening`,`r`.`KMpa` AS `KMpa`,`r`.`Strain_Plastic` AS `Strain_Plastic`,`r`.`Strain_Elastic` AS `Strain_Elastic`,`r`.`Strain_amplitude` AS `Strain_amplitude`,`r`.`Tau_MaxMPa` AS `Tau_MaxMPa`,`r`.`Tau_amplitudeMPa` AS `Tau_amplitudeMPa`,`r`.`strain_total` AS `strain_total`,`r`.`g_mean_mean` AS `g_mean_mean`,`r`.`tau_max_mean` AS `tau_max_mean`,`r`.`dtname` AS `dtname` from (`rdp_result` `r` join `experiment` `e` on((`r`.`eid` = `e`.`eid`)));

-- ----------------------------
-- View structure for v_specimen
-- ----------------------------
DROP VIEW IF EXISTS `v_specimen`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_specimen` AS select `s`.`sid` AS `sid`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname`,`m`.`en_name` AS `en_name`,`m`.`standard` AS `standard`,`m`.`properties` AS `properties`,`s`.`memo` AS `memo` from (`specimen` `s` join `material` `m` on((`s`.`mid` = `m`.`mid`)));

-- ----------------------------
-- View structure for v_specimen_params
-- ----------------------------
DROP VIEW IF EXISTS `v_specimen_params`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_specimen_params` AS select `r`.`expid` AS `expid`,`r`.`eid` AS `eid`,`r`.`period` AS `N`,`r`.`Tau_amplitudeMPa` AS `Strain`,`r`.`Tau_MaxMPa` AS `Tau`,`r`.`Strain_Plastic` AS `pStrain`,`r`.`Strain_Elastic` AS `eStrain`,`r`.`g_mean_mean` AS `E`,`e`.`ename` AS `ename`,`s`.`sname` AS `sname`,`m`.`mname` AS `mname`,`e`.`sid` AS `sid`,`s`.`mid` AS `mid` from (((`rdp_result` `r` join `experiment` `e` on((`r`.`eid` = `e`.`eid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`s`.`mid` = `m`.`mid`)));

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

SET FOREIGN_KEY_CHECKS = 1;
