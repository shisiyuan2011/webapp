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

 Date: 19/05/2020 22:26:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
  `table_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the table name in the mysql',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`eid`) USING BTREE,
  UNIQUE INDEX `unique_ename`(`ename`) USING BTREE,
  UNIQUE INDEX `unique_datapath`(`datapath`) USING BTREE,
  UNIQUE INDEX `unique_rawpath`(`rawpath`) USING BTREE,
  INDEX `fk_experiment_specimen`(`sid`) USING BTREE,
  INDEX `fk_experiment_user`(`uid`) USING BTREE,
  CONSTRAINT `fk_experiment_specimen` FOREIGN KEY (`sid`) REFERENCES `specimen` (`sid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_experiment_user` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of experiment
-- ----------------------------
INSERT INTO `experiment` VALUES (1, 'GCr15测试1', '2019-12-06 10:52:09', 1, 1, 0.1, 16, 20, 3087, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087', 'E:\\试验数据\\韩福宁\\GCr15\\S1-H20-N3087', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (2, 'GCr15 测试2', '2019-12-06 21:36:09', 2, 1, 0.1, 16, 15, 7141, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141', 'E:\\试验数据\\韩福宁\\GCr15\\S2-H15-N7141', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (3, 'GCr15 测试3', '2019-12-07 20:58:53', 3, 1, 0.1, 16, 10, 39534, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534', 'E:\\试验数据\\韩福宁\\GCr15\\S3-H10-N39534', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (4, 'GCr15 测试4', '2019-12-12 13:44:49', 4, 1, 0.1, 16, 25, 1640, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640', 'E:\\试验数据\\韩福宁\\GCr15\\S4-H25-N1640', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (5, 'GCr15 测试5', '2019-12-12 00:00:00', 5, 1, 0.1, 16, 30, 1279, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279', 'E:\\试验数据\\韩福宁\\GCr15\\S5-H30-N1279', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (6, 'GCr15 测试6', '2019-12-13 10:03:47', 6, 1, 0.1, 16, 35, 1250, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250', 'E:\\试验数据\\韩福宁\\GCr15\\S6-H35-N1250', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (7, 'GCr15 测试7', '2019-12-13 16:18:07', 7, 1, 0.1, 16, 40, 791, 1, 'E:\\试验数据\\韩福宁\\GCr15\\S7-H40-N791', 'E:\\试验数据\\韩福宁\\GCr15\\S7-H40-N791', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (8, 'QT800 测试1', '2019-12-10 10:19:31', 8, 1, 0.1, 16, 36, 743, 2, 'E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S2H36N743_20191210', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (9, 'QT800 测试2', '2019-12-10 14:09:10', 9, 1, 0.1, 16, 34, 954, 2, 'E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S3H34N954_20191210', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (10, 'QT800 测试3', '2019-12-12 09:52:39', 10, 1, 0.1, 16, 38, 366, 2, 'E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S5H38N366_20191212', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (11, 'QT800 测试4', '2019-12-12 11:55:25', 11, 1, 0.1, 16, 32, 1298, 2, 'E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S6H32N1298_20191212', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (12, 'QT800 测试5', '2019-12-12 17:50:30', 12, 1, 0.1, 16, 30, 1029, 2, 'E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S7H30N1029_20191212', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (13, 'QT800 测试6', '2019-12-12 23:24:52', 13, 1, 0.1, 16, 25, 2951, 2, 'E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212\\Data', 'E:\\试验数据\\韩福宁\\QT800\\S8H25N2951_20191212', 'rawdata1', NULL);

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
-- Table structure for rawdata1
-- ----------------------------
DROP TABLE IF EXISTS `rawdata1`;
CREATE TABLE `rawdata1`  (
  `did` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'the data row id',
  `eid` int(0) UNSIGNED NOT NULL COMMENT 'the experiment id',
  `dtime` datetime(0) NULL DEFAULT NULL COMMENT 'the timestamp',
  `torque` double NOT NULL COMMENT 'the torque',
  `angle` double NOT NULL COMMENT 'the angle, theta',
  PRIMARY KEY (`did`) USING BTREE,
  INDEX `fk_rawdata1_experiment`(`eid`) USING BTREE,
  CONSTRAINT `fk_rawdata1_experiment` FOREIGN KEY (`eid`) REFERENCES `experiment` (`eid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rawdata1
-- ----------------------------

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
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_experiment` AS select `e`.`eid` AS `eid`,`e`.`ename` AS `ename`,`e`.`etime` AS `etime`,`e`.`sid` AS `sid`,`e`.`uid` AS `uid`,`e`.`frequncy` AS `frequncy`,`e`.`sampling` AS `sampling`,`e`.`H` AS `H`,`e`.`cycles` AS `cycles`,`e`.`datatype` AS `datatype`,`e`.`datapath` AS `datapath`,`e`.`rawpath` AS `rawpath`,`e`.`table_name` AS `table_name`,`u`.`username` AS `username`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname` from (((`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`m`.`mid` = `s`.`mid`)));

-- ----------------------------
-- View structure for v_specimen
-- ----------------------------
DROP VIEW IF EXISTS `v_specimen`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_specimen` AS select `s`.`sid` AS `sid`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname`,`m`.`en_name` AS `en_name`,`m`.`standard` AS `standard`,`m`.`properties` AS `properties` from (`specimen` `s` join `material` `m` on((`s`.`mid` = `m`.`mid`)));

SET FOREIGN_KEY_CHECKS = 1;
