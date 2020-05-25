/*
 Navicat Premium Data Transfer

 Source Server         : cloudlab
 Source Server Type    : MySQL
 Source Server Version : 80020
 Source Host           : localhost:33360
 Source Schema         : cloudlab

 Target Server Type    : MySQL
 Target Server Version : 80020
 File Encoding         : 65001

 Date: 25/05/2020 17:58:54
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`eid`) USING BTREE,
  UNIQUE INDEX `unique_ename`(`ename`) USING BTREE,
  UNIQUE INDEX `unique_datapath`(`datapath`) USING BTREE,
  UNIQUE INDEX `unique_rawpath`(`rawpath`) USING BTREE,
  INDEX `fk_experiment_specimen`(`sid`) USING BTREE,
  INDEX `fk_experiment_user`(`uid`) USING BTREE,
  CONSTRAINT `fk_experiment_specimen` FOREIGN KEY (`sid`) REFERENCES `specimen` (`sid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_experiment_user` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of experiment
-- ----------------------------
INSERT INTO `experiment` VALUES (1, 'GCr15测试1', '2019-12-06 10:52:09', 1, 1, 0.1, 16, 20, 3087, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087', 'E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087', NULL);
INSERT INTO `experiment` VALUES (2, 'GCr15 测试2', '2019-12-06 21:36:09', 2, 1, 0.1, 16, 15, 7141, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141', 'E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141', NULL);
INSERT INTO `experiment` VALUES (3, 'GCr15 测试3', '2019-12-07 20:58:53', 3, 1, 0.1, 16, 10, 39534, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534', 'E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534', NULL);
INSERT INTO `experiment` VALUES (4, 'GCr15 测试4', '2019-12-12 13:44:49', 4, 1, 0.1, 16, 25, 1640, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640', 'E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640', NULL);
INSERT INTO `experiment` VALUES (5, 'GCr15 测试5', '2019-12-12 00:00:00', 5, 1, 0.1, 16, 30, 1279, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279', 'E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279', NULL);
INSERT INTO `experiment` VALUES (6, 'GCr15 测试6', '2019-12-13 10:03:47', 6, 1, 0.1, 16, 35, 1250, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250', 'E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250', NULL);
INSERT INTO `experiment` VALUES (7, 'GCr15 测试7', '2019-12-13 16:18:07', 7, 1, 0.1, 16, 40, 791, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S7-H40-N791', 'E:\\试验数据\\韩福宁\\GCr15\\S7-H40-N791', NULL);
INSERT INTO `experiment` VALUES (8, 'QT800 测试1', '2019-12-10 10:19:31', 8, 1, 0.1, 16, 36, 743, 2, 'E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210', NULL);
INSERT INTO `experiment` VALUES (9, 'QT800 测试2', '2019-12-10 14:09:10', 9, 1, 0.1, 16, 34, 954, 2, 'E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210', NULL);
INSERT INTO `experiment` VALUES (10, 'QT800 测试3', '2019-12-12 09:52:39', 10, 1, 0.1, 16, 38, 366, 2, 'E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212', NULL);
INSERT INTO `experiment` VALUES (11, 'QT800 测试4', '2019-12-12 11:55:25', 11, 1, 0.1, 16, 32, 1298, 2, 'E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212', NULL);
INSERT INTO `experiment` VALUES (12, 'QT800 测试5', '2019-12-12 17:50:30', 12, 1, 0.1, 16, 30, 1029, 2, 'E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212', NULL);
INSERT INTO `experiment` VALUES (13, 'QT800 测试6', '2019-12-12 23:24:52', 13, 1, 0.1, 16, 25, 2951, 2, 'E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212', NULL);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rdp_result
-- ----------------------------
INSERT INTO `rdp_result` VALUES (1, 1, 984116, 6150, 6150, 1, 100, 0.07037133535474013, 8.07116752862931, 305.866225937246, -305.866225937246, 8.805229543815195e-16, 0.010528235500595534, -0.010943566328623616, -0.00020766541401403928, 6.870976585350128, 31.265693699642082, 55.7688575038129, 0.2958259077676896, 822.7710534392444, 0.007539892333276753, 0.0030158079699342654, 0.006241379337282653, 190.3061049932076, 290.0118102433621, 0.02147180182921915, 40143.46306867293, 305.866225937246, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (2, 2, 2285961, 14287, 14287, 1, 120, 0.03561708312920607, 9.828691005706775, 278.36393660186536, -278.36393660186536, -4.600672200602637e-16, 0.007365064473433493, -0.00784990431836248, -0.00024241992246445607, 4.868790013374712, 57.07327289862349, 34.16950065400659, 0.03519048720770579, 488.90848281340755, 0.00341795938202921, 0.0030463265384930755, 0.004609132898600138, 250.00971467945416, 263.13521331647655, 0.015214968791795973, 44702.60131206554, 278.36393660186536, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (3, 10, 58478, 365, 365, 1, 100, 0.18114597773523944, 57.42245, 1364.8839082812367, -1364.883908281237, 0.000000000000004372570681600617, 0.02702308087549505, -0.027290834411119447, -0.00013387676781220022, 17.38045289171664, 53.38666441036041, 53.73634622337783, 0.32988719626088725, 10749.622511019941, 0.0020104738734842286, 0.02516142278680169, 0.027073329190779538, 1353.9358165847711, 1302.4179509686767, 0.0543139152866145, 53408.40626207592, 1364.8839082812367, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (4, 8, 115202, 720, 720, 1, 100, 0.17135555329617727, 54.58565, 1296.3176009462395, -1296.3176009462395, -3.16235988099071e-16, 0.025541809852720497, -0.02577991476194704, -0.00011905245461327207, 16.422951876693613, 53.702675803135286, 53.68855500382694, 0.34584913834341297, 11459.430136499595, 0.0017992339992143613, 0.02390409899521223, 0.02582716410485559, 1287.048299168017, 1241.4050193402704, 0.05132172461466754, 53628.96335971633, 1296.3176009462395, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (5, 12, 164668, 1029, 1029, 1, 100, 0.14247122684029712, 47.6678, 1139.16742067455, -1139.16742067455, 7.741321634740391e-16, 0.02100293823861552, -0.021687906598414984, -0.0003424841798997368, 13.661070347849762, 53.71038605139655, 54.81332117190044, 0.33182521687464717, 12971.033766751665, 0.0008441376115642822, 0.020526546414480287, 0.02119396943928014, 1123.9357031579034, 1065.2098870080026, 0.042690844837030506, 54536.0954700335, 1139.16742067455, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (6, 9, 148805, 930, 930, 1, 100, 0.16127889485978802, 52.99325, 1259.5071257287168, -1259.5071257287168, -0.000000000000002202758965542614, 0.024361896130537648, -0.024097628629713, 0.00013213375041232233, 15.507047923280206, 54.009966407766925, 55.10309247224753, 0.4216724377608476, 20568.513579703147, 0.0015880928498309588, 0.022603741379137243, 0.024182016751925738, 1249.5018797043824, 1115.1244139381342, 0.048459524760250644, 54402.055656537545, 1259.5071257287168, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (7, 11, 206443, 1290, 1290, 1, 100, 0.15323990832510215, 49.8517, 1189.2879648365724, -1189.2879648365724, 0.000000000000001322965528180171, 0.02242766812910422, -0.023220470490214497, -0.000396401180555131, 14.60740435818199, 53.847262773359596, 53.59953011796946, 0.38980724786044935, 16958.308644116023, 0.0010570527889829304, 0.02192893345978239, 0.02277981923087349, 1175.4288113384055, 1104.174553853412, 0.04564813861931872, 53962.39729794893, 1189.2879648365724, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (8, 7, 234054, 1462, 1462, 1, 105, 0.1211364454748036, 12.27047872543335, 392.04706956260145, -392.04706956260145, -0.0000000000000027149930337992876, 0.022727104360584432, -0.023442799391240745, -0.0003578475153281506, 14.774369200584056, 8.240169279543545, 55.38157457600233, 0.08623748361214834, 420.55608234880964, 0.013406946197722177, 0.004857002571187154, 0.016682031081402263, 288.361142545752, 323.1316287151986, 0.04616990375182518, 28208.984170279913, 392.04706956260145, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (9, 5, 409446, 2559, 2559, 1, 100, 0.07252849583770432, 13.680786609649676, 352.8170249936818, -352.8170249936818, 0.0000000000000018555220777472513, 0.014794353520671693, -0.015405381738346978, -0.0003055141088376391, 9.663915282885975, 55.80965091231875, 20.820904141369304, 0.004475773661769621, 333.43072293599454, 0.012620426856308781, -0.0017411524806531346, 0.009469924533358676, 322.57256508313446, 321.49427777838747, 0.030199735259018673, 36257.172061326964, 352.8170249936818, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (10, 13, 470498, 2940, 2940, 1, 100, 0.11791182627085892, 40.1402, 961.1414170339734, -961.1414170339733, 8.316662167454048e-16, 0.016271117073593768, -0.01938890850422839, -0.0015588957153172718, 11.411208184903092, 54.59919731174542, 54.45796589188529, 0.23256515130358035, 5481.961579639798, 0.0003625693941683658, 0.01732420454646047, 0.01776164856553939, 946.4461106218216, 918.1424671125608, 0.03566002557782216, 54788.54798627874, 961.1414170339734, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (11, 6, 400187, 2501, 2501, 11, 105, 0.09481912087215387, 12.127638339996324, 362.94736903239, -362.94736903239004, -0.0000000000000019269918993813917, 0.017538215278642324, -0.018193971069919313, -0.00032787789563848625, 11.434299631539723, 7.9618429046376304, 56.70371311958725, 0.0346730393989838, 323.9334819726778, 0.009307386135444668, 0.004635051132593082, 0.011806848389903209, 280.2941522774773, 323.21149273988175, 0.03573218634856164, 33549.65042958489, 362.94736903239, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (12, 4, 499589, 3122, 3122, 1, 100, 0.0682620784818837, 12.614303827285786, 321.3944530177392, -321.3944530177392, 0.0000000000000015982089090150283, 0.012796663099455383, -0.013403757784424215, -0.0003035473424843966, 8.38413468284147, 62.6005331160943, 24.24332554025265, 0.048596175225156316, 361.43971340939, 0.0070913248677288146, 0.003147986904553742, 0.007816101496419469, 297.42649004082165, 286.71046852389395, 0.026200420883879597, 36663.54482832461, 321.3944530177392, 'rdp_data_1');
INSERT INTO `rdp_result` VALUES (13, 3, 12656426, 79102, 79102, 1, 115, 0.021331887042021033, 8.3438563346863, 240.49174769383123, -240.49174769383123, 5.063338979021434e-16, 0.0048095389605776525, -0.005262968473443558, -0.00022671475643313505, 3.223202378886787, 44.414455922836815, 58.76930690993379, 0.036724669580488034, 483.4018486270704, 0.00020034573998315585, 0.002920346425371696, 0.002984072001433786, 190.25282811229283, 204.19032099975453, 0.01007250743402121, 51208.187658257935, 240.49174769383123, 'rdp_data_1');

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
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'the description',
  PRIMARY KEY (`sid`) USING BTREE,
  UNIQUE INDEX `unique_sname`(`sname`) USING BTREE,
  INDEX `fk_specimen_material`(`mid`) USING BTREE,
  CONSTRAINT `fk_specimen_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of specimen
-- ----------------------------
INSERT INTO `specimen` VALUES (1, 'S1-GCr15', 1, 3, 20, NULL);
INSERT INTO `specimen` VALUES (2, 'S2-GCr15', 1, 3, 20, NULL);
INSERT INTO `specimen` VALUES (3, 'S3-GCr15', 1, 3, 20, NULL);
INSERT INTO `specimen` VALUES (4, 'S4-GCr15', 1, 3, 20, NULL);
INSERT INTO `specimen` VALUES (5, 'S5-GCr15', 1, 3, 20, NULL);
INSERT INTO `specimen` VALUES (6, 'S6-GCr15', 1, 3, 20, NULL);
INSERT INTO `specimen` VALUES (7, 'S7-GCr15', 1, 3, 20, NULL);
INSERT INTO `specimen` VALUES (8, 'S2-QT800', 2, 3, 20, NULL);
INSERT INTO `specimen` VALUES (9, 'S3-QT800', 2, 3, 20, NULL);
INSERT INTO `specimen` VALUES (10, 'S5-QT800', 2, 3, 20, NULL);
INSERT INTO `specimen` VALUES (11, 'S6-QT800', 2, 3, 20, NULL);
INSERT INTO `specimen` VALUES (12, 'S7-QT800', 2, 3, 20, NULL);
INSERT INTO `specimen` VALUES (13, 'S8-QT800', 2, 3, 20, NULL);

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
-- View structure for v_experiment
-- ----------------------------
DROP VIEW IF EXISTS `v_experiment`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_experiment` AS select `e`.`eid` AS `eid`,`e`.`ename` AS `ename`,`e`.`etime` AS `etime`,`e`.`sid` AS `sid`,`e`.`uid` AS `uid`,`e`.`frequncy` AS `frequncy`,`e`.`sampling` AS `sampling`,`e`.`H` AS `H`,`e`.`cycles` AS `cycles`,`e`.`datatype` AS `datatype`,`e`.`datapath` AS `datapath`,`e`.`rawpath` AS `rawpath`,`u`.`username` AS `username`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname` from (((`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`m`.`mid` = `s`.`mid`)));

-- ----------------------------
-- View structure for v_rdp_exp
-- ----------------------------
DROP VIEW IF EXISTS `v_rdp_exp`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_rdp_exp` AS select `r`.`expid` AS `expid`,`r`.`eid` AS `eid`,`r`.`rawlen` AS `rawlen`,`r`.`period` AS `period`,`r`.`bpoint` AS `bpoint`,`r`.`theta_8` AS `theta_8`,`r`.`torque_8` AS `torque_8`,`r`.`TauMax` AS `TauMax`,`r`.`TauMin` AS `TauMin`,`r`.`TauMean` AS `TauMean`,`r`.`Strain_TotMax` AS `Strain_TotMax`,`r`.`Strain_TotMin` AS `Strain_TotMin`,`r`.`Strain_TotMean` AS `Strain_TotMean`,`r`.`StrainRate` AS `StrainRate`,`r`.`pic_path` AS `pic_path`,`r`.`dtable_name` AS `dtable_name`,`e`.`ename` AS `ename` from (`rdp_result` `r` join `experiment` `e` on((`r`.`eid` = `e`.`eid`)));

-- ----------------------------
-- View structure for v_rdpd_exp
-- ----------------------------
DROP VIEW IF EXISTS `v_rdpd_exp`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_rdpd_exp` AS select `r`.`rdpd_id` AS `rdpd_id`,`r`.`eid` AS `eid`,`r`.`max_angle` AS `max_angle`,`r`.`min_angle` AS `min_angle`,`r`.`max_torque` AS `max_torque`,`r`.`min_torque` AS `min_torque`,`r`.`max_shearforce` AS `max_shearforce`,`r`.`min_shearforce` AS `min_shearforce`,`r`.`max_shearstrain` AS `max_shearstrain`,`r`.`min_shearstrain` AS `min_shearstrain`,`r`.`max_force_improved` AS `max_force_improved`,`r`.`min_force_improved` AS `min_force_improved`,`r`.`G_right` AS `G_right`,`r`.`G_left` AS `G_left`,`r`.`G_mean_per` AS `G_mean_per`,`r`.`G_mean` AS `G_mean`,`r`.`Tao_max` AS `Tao_max`,`e`.`ename` AS `ename` from (`rdp_data` `r` join `experiment` `e` on((`r`.`eid` = `e`.`eid`)));

-- ----------------------------
-- View structure for v_specimen
-- ----------------------------
DROP VIEW IF EXISTS `v_specimen`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_specimen` AS select `s`.`sid` AS `sid`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname`,`m`.`en_name` AS `en_name`,`m`.`standard` AS `standard`,`m`.`properties` AS `properties` from (`specimen` `s` join `material` `m` on((`s`.`mid` = `m`.`mid`)));

-- ----------------------------
-- View structure for v_specimen_params
-- ----------------------------
DROP VIEW IF EXISTS `v_specimen_params`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_specimen_params` AS select `r`.`expid` AS `expid`,`r`.`eid` AS `eid`,`r`.`period` AS `N`,`r`.`Tau_amplitudeMPa` AS `Strain`,`r`.`Tau_MaxMPa` AS `Tau`,`r`.`Strain_Plastic` AS `pStrain`,`r`.`Strain_Elastic` AS `eStrain`,`e`.`ename` AS `ename`,`s`.`sname` AS `sname`,`m`.`mname` AS `mname`,`e`.`sid` AS `sid`,`s`.`mid` AS `mid` from (((`rdp_result` `r` join `experiment` `e` on((`r`.`eid` = `e`.`eid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`s`.`mid` = `m`.`mid`)));

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
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean_log.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max_log.png');
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
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean_log.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max_log.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_100.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_n1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_last.png');

	SELECT * FROM tt_pic_path;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
