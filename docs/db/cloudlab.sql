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

 Date: 24/05/2020 18:05:08
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
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

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
-- Table structure for rdp_result
-- ----------------------------
DROP TABLE IF EXISTS `rdp_result`;
CREATE TABLE `rdp_result`  (
  `expid` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'result id',
  `eid` int(0) UNSIGNED NOT NULL COMMENT 'the experiment id',
  `rawlen` int(0) UNSIGNED NULL DEFAULT NULL COMMENT 'the length of raw data',
  `period` int(0) UNSIGNED NULL DEFAULT NULL COMMENT 'the amount of period',
  `bpoint` int(0) UNSIGNED NULL DEFAULT NULL COMMENT 'break point',
  `G_row` int(0) UNSIGNED NULL DEFAULT 100 COMMENT 'The Effect Loop No for G___',
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_100.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_n1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_last.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean_log.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max_log.png');
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
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_100.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_n1.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'loop_last.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'g_mean_log.png');
	INSERT INTO tt_pic_path(`path`) SELECT CONCAT(pic_path, 'tao_max_log.png');
	SELECT * FROM tt_pic_path;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
