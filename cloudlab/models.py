from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, DateTime, Float
from sqlalchemy.orm import relationship
from sqlalchemy.types import TIMESTAMP
from .database import Base


'''
-- ----------------------------
-- View structure for v_exp_brief
-- ----------------------------
DROP VIEW IF EXISTS `v_exp_brief`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_exp_brief`
AS
  select 
    `e`.`eid` AS `eid`,
    `e`.`ename` AS `ename`,
    `e`.`etime` AS `etime`,
    `e`.`sid` AS `sid`,
    `e`.`uid` AS `uid`,
    `e`.`H` AS `H`,
    `e`.`cycles` AS `cycles`,
    `u`.`username` AS `username`,
    `s`.`sname` AS `sname`,
    `s`.`mid` AS `mid`,
    `m`.`mname` AS `mname`
from (
  (
    (`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`)))
     join `specimen` `s` on((`e`.`sid` = `s`.`sid`))
  ) join `material` `m` on((`m`.`mid` = `s`.`mid`))
);
'''
class VExperimentBrief(Base):
    __tablename__ = "v_exp_brief"

    eid = Column(Integer, primary_key=True, index=True)
    ename = Column(String)
    etime = Column(DateTime)
    sid = Column(Integer)
    uid = Column(Integer)
    H = Column(Float)
    cycles = Column(Float)
    username = Column(String)
    sname = Column(String)
    mid = Column(Integer)
    mname = Column(String)


'''
-- ----------------------------
-- View structure for v_experiment
-- ----------------------------
DROP VIEW IF EXISTS `v_experiment`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_experiment`
AS
  select 
    `e`.`eid` AS `eid`,
    `e`.`ename` AS `ename`,
    `e`.`etime` AS `etime`,
    `e`.`sid` AS `sid`,
    `e`.`uid` AS `uid`,
    `e`.`frequncy` AS `frequncy`,
    `e`.`sampling` AS `sampling`,
    `e`.`H` AS `H`,
    `e`.`cycles` AS `cycles`,
    `e`.`datatype` AS `datatype`,
    `e`.`datapath` AS `datapath`,
    `e`.`rawpath` AS `rawpath`,
    `u`.`username` AS `username`,
    `s`.`sname` AS `sname`,
    `s`.`mid` AS `mid`,
    `s`.`radius` AS `radius`,
    `s`.`length` AS `length`,
    `m`.`mname` AS `mname`
from (
  (
    (`experiment` `e` join `user` `u` on((`e`.`uid` = `u`.`uid`)))
     join `specimen` `s` on((`e`.`sid` = `s`.`sid`))
  ) join `material` `m` on((`m`.`mid` = `s`.`mid`))
);
'''

class VExperimentDetail(Base):
    __tablename__ = "v_experiment"

    eid = Column(Integer, primary_key=True, index=True)
    ename = Column(String)
    etime = Column(DateTime)
    sid = Column(Integer)
    uid = Column(Integer)
    frequncy = Column(Float)
    sampling = Column(Float)
    H = Column(Float)
    cycles = Column(Float)
    datatype = Column(Integer)
    datapath = Column(String)
    rawpath = Column(String)
    username = Column(String)
    sname = Column(String)
    mid = Column(Integer)
    radius = Column(Float)
    length = Column(Float)
    mname = Column(String)
    memo = Column(String)

'''
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;
'''
class Material(Base):
  __tablename__ = 'material'

  mid = Column(Integer, primary_key=True, index=True)
  mname = Column(String)
  en_name = Column(String)
  standard = Column(String)
  properties = Column(String)


class VSpecimenDetail(Base):
  __tablename__ = 'v_specimen'

  sid = Column(Integer, primary_key=True, index=True)
  sname = Column(String)
  mid = Column(Integer)
  radius = Column(Float)
  length = Column(Float)
  mname = Column(String)
  memo = Column(String)

class Specimen(Base):
  __tablename__ = 'specimen'

  sid = Column(Integer, primary_key=True, index=True)
  sname = Column(String)
  mid = Column(Integer)
  radius = Column(Float)
  length = Column(Float)
  memo = Column(String)


class Experiment(Base):
  __tablename__ = 'experiment'

  eid = Column(Integer, primary_key=True, index=True)
  ename = Column(String)
  etime = Column(TIMESTAMP, nullable=False, server_default='now()')
  sid = Column(Integer)
  uid = Column(Integer)
  frequncy = Column(Float)
  sampling = Column(Float)
  H = Column(Float)
  cycles = Column(Float)
  datatype = Column(Integer)
  datapath = Column(String)
  rawpath = Column(String)
  memo = Column(String)

""" class Hloops(Base):
  __tablename__ = "tt_pic_path"

  id = Column(Integer, primary_key=True, index=True)
  path = Column(String)
 """

class Rotating(Base):
  __tablename__ = 'rotating'

  rtid = Column(Integer, primary_key=True, index=True)
  sname = Column(String)
  mid = Column(Integer)
  diameter = Column(Float)
  moment = Column(Float)
  FatigueLifeNf = Column(Float)
  FracturedLocs = Column(Float)
  speed = Column(Float)
  lp = Column(Float)
  stress = Column(Float)
  runoutcycles = Column(Integer)
  runouttime = Column(Integer)
  description = Column(String)
  pic1 = Column(String)
  pic2 = Column(String)
  pic3 = Column(String)

class VRotating(Base):
  __tablename__ = 'v_rotating'

  rtid = Column(Integer, primary_key=True, index=True)
  sname = Column(String)
  mid = Column(Integer)
  diameter = Column(Float)
  moment = Column(Float)
  FatigueLifeNf = Column(Float)
  FracturedLocs = Column(Float)
  speed = Column(Float)
  lp = Column(Float)
  stress = Column(Float)
  runoutcycles = Column(Integer)
  runouttime = Column(Integer)
  description = Column(String)
  pic1 = Column(String)
  pic2 = Column(String)
  pic3 = Column(String)
  mname = Column(String)

