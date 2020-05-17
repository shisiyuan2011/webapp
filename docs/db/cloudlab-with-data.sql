/*
 Navicat Premium Data Transfer

 Source Server         : bit-2020
 Source Server Type    : MySQL
 Source Server Version : 80020
 Source Host           : localhost:33996
 Source Schema         : cloudlab

 Target Server Type    : MySQL
 Target Server Version : 80020
 File Encoding         : 65001

 Date: 17/05/2020 19:23:31
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
  `datatype` int(0) NOT NULL DEFAULT 0 COMMENT 'the type of datafile, 0 for 3 columns, 1 for 9 columns',
  `datapath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the filepath of raw data file',
  `rawpath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'the path of the raw files',
  `table_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the table name in the mysql',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`eid`) USING BTREE,
  INDEX `fk_experiment_specimen`(`sid`) USING BTREE,
  INDEX `fk_experiment_user`(`uid`) USING BTREE,
  CONSTRAINT `fk_experiment_specimen` FOREIGN KEY (`sid`) REFERENCES `specimen` (`sid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_experiment_user` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of experiment
-- ----------------------------
INSERT INTO `experiment` VALUES (1, 'GCr15测试1', '2019-09-07 09:05:02', 1, 1, 20, 10, 0, 'e:\\data\\s1\\data', 'e:\\data\\s1', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (2, 'GCr15 测试2', '2019-09-07 09:00:00', 2, 1, 20, 10, 0, 'e:\\data\\s2\\data', 'e:\\data\\s2', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (3, 'GCr15 测试3', '2020-05-17 19:14:10', 3, 1, 20, 10, 0, 'e:\\data\\GCr15\\s3\\data', 'e:\\data\\GCr15\\s2', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (4, 'GCr15 测试4', '2020-05-17 19:14:12', 4, 1, 20, 10, 0, 'e:\\data\\GCr15\\s4\\data', 'e:\\data\\GCr15\\s2', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (5, 'GCr15 测试5', '2020-05-17 19:14:13', 5, 1, 20, 10, 0, 'e:\\data\\GCr15\\s5\\data', 'e:\\data\\GCr15\\s2', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (6, 'GCr15 测试6', '2020-05-17 19:14:15', 6, 1, 20, 10, 0, 'e:\\data\\GCr15\\s6\\data', 'e:\\data\\GCr15\\s2', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (7, 'GCr15 测试7', '2020-05-17 19:14:16', 7, 1, 20, 10, 0, 'e:\\data\\GCr15\\s7\\data', 'e:\\data\\GCr15\\s2', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (8, 'QT800 测试1', '2020-05-17 19:14:18', 8, 1, 20, 10, 0, 'e:\\data\\QT800\\s1\\data', 'e:\\data\\QT800\\s1', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (9, 'QT800 测试2', '2020-05-17 19:14:20', 9, 1, 20, 10, 0, 'e:\\data\\QT800\\s2\\data', 'e:\\data\\QT800\\s2', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (10, 'QT800 测试3', '2020-05-17 19:14:21', 10, 1, 20, 10, 0, 'e:\\data\\QT800\\s3\\data', 'e:\\data\\QT800\\s3', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (11, 'QT800 测试4', '2020-05-17 19:14:23', 11, 1, 20, 10, 0, 'e:\\data\\QT800\\s4\\data', 'e:\\data\\QT800\\s4', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (12, 'QT800 测试5', '2020-05-17 19:14:24', 12, 1, 20, 10, 0, 'e:\\data\\QT800\\s5\\data', 'e:\\data\\QT800\\s5', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (13, 'QT800 测试6', '2020-05-17 19:14:28', 13, 1, 20, 10, 0, 'e:\\data\\QT800\\s6\\data', 'e:\\data\\QT800\\s6', 'rawdata1', NULL);
INSERT INTO `experiment` VALUES (14, 'QT800 测试7', '2020-05-17 19:14:32', 14, 1, 20, 10, 0, 'e:\\data\\QT800\\s7\\data', 'e:\\data\\QT800\\s7', 'rawdata1', NULL);

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
  PRIMARY KEY (`mid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
  INDEX `fk_specimen_material`(`mid`) USING BTREE,
  CONSTRAINT `fk_specimen_material` FOREIGN KEY (`mid`) REFERENCES `material` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of specimen
-- ----------------------------
INSERT INTO `specimen` VALUES (1, 'S1', 1, 2, 10, NULL);
INSERT INTO `specimen` VALUES (2, 'S2', 1, 2, 10, NULL);
INSERT INTO `specimen` VALUES (3, 'S3', 1, 2, 10, NULL);
INSERT INTO `specimen` VALUES (4, 'S4', 1, 2, 10, NULL);
INSERT INTO `specimen` VALUES (5, 'S5', 1, 2, 10, NULL);
INSERT INTO `specimen` VALUES (6, 'S6', 1, 2, 10, NULL);
INSERT INTO `specimen` VALUES (7, 'S7', 1, 2, 10, NULL);
INSERT INTO `specimen` VALUES (8, 'S1', 2, 2, 10, NULL);
INSERT INTO `specimen` VALUES (9, 'S2', 2, 2, 10, NULL);
INSERT INTO `specimen` VALUES (10, 'S3', 2, 2, 10, NULL);
INSERT INTO `specimen` VALUES (11, 'S4', 2, 2, 10, NULL);
INSERT INTO `specimen` VALUES (12, 'S5', 2, 2, 10, NULL);
INSERT INTO `specimen` VALUES (13, 'S6', 2, 2, 10, NULL);
INSERT INTO `specimen` VALUES (14, 'S7', 2, 2, 10, NULL);

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
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '韩福宁', '7c4a8d09ca3762af61e59520943dc26494f8941b', 0, 1, '');
INSERT INTO `user` VALUES (2, '高天天', '7c4a8d09ca3762af61e59520943dc26494f8941b', 0, 2, '');

-- ----------------------------
-- View structure for v_experiment
-- ----------------------------
DROP VIEW IF EXISTS `v_experiment`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_experiment` AS select `e`.`eid` AS `eid`,`e`.`ename` AS `ename`,`e`.`etime` AS `etime`,`e`.`sid` AS `sid`,`e`.`uid` AS `uid`,`e`.`frequncy` AS `frequncy`,`e`.`sampling` AS `sampling`,`e`.`datatype` AS `datatype`,`e`.`datapath` AS `datapath`,`e`.`rawpath` AS `rawpath`,`e`.`table_name` AS `table_name`,`u`.`username` AS `username`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname` from (((`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`))) join `specimen` `s` on((`e`.`sid` = `s`.`sid`))) join `material` `m` on((`m`.`mid` = `s`.`mid`)));

-- ----------------------------
-- View structure for v_specimen
-- ----------------------------
DROP VIEW IF EXISTS `v_specimen`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_specimen` AS select `s`.`sid` AS `sid`,`s`.`sname` AS `sname`,`s`.`mid` AS `mid`,`s`.`radius` AS `radius`,`s`.`length` AS `length`,`m`.`mname` AS `mname`,`m`.`en_name` AS `en_name`,`m`.`standard` AS `standard`,`m`.`properties` AS `properties` from (`specimen` `s` join `material` `m` on((`s`.`mid` = `m`.`mid`)));

SET FOREIGN_KEY_CHECKS = 1;
