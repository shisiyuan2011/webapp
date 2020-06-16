from . import schemas, crud, database
from fastapi import Depends

def get_analysis_pic_web_path(exp):
  ard = schemas.AnalysisRawData(eid = exp.eid, ename = exp.ename, path = [])

  prefix = "/images/rdp/" + str(exp.eid) + "/"
  ard.path.append(schemas.AnalysPicPath(id = 1,  path = prefix + "angle_origin.png"))
  ard.path.append(schemas.AnalysPicPath(id = 2,  path = prefix + "angle_smooth.png"))
  ard.path.append(schemas.AnalysPicPath(id = 3,  path = prefix + "torque_origin.png"))
  ard.path.append(schemas.AnalysPicPath(id = 4,  path = prefix + "torque_smooth.png"))
  ard.path.append(schemas.AnalysPicPath(id = 5,  path = prefix + "max_force.png"))
  ard.path.append(schemas.AnalysPicPath(id = 6,  path = prefix + "min_force.png"))
  ard.path.append(schemas.AnalysPicPath(id = 7,  path = prefix + "strain.png"))
  ard.path.append(schemas.AnalysPicPath(id = 8,  path = prefix + "loop_all.png"))
  ard.path.append(schemas.AnalysPicPath(id = 9,  path = prefix + "g_mean.png"))
  ard.path.append(schemas.AnalysPicPath(id = 10, path = prefix + "tao_max.png"))
  ard.path.append(schemas.AnalysPicPath(id = 11, path = prefix + "loop_1.png"))
  ard.path.append(schemas.AnalysPicPath(id = 12, path = prefix + "loop_100.png"))
  ard.path.append(schemas.AnalysPicPath(id = 13, path = prefix + "loop_n1.png"))
  ard.path.append(schemas.AnalysPicPath(id = 14, path = prefix + "loop_last.png"))

  return ard

def get_hloop_pic_save_path(eid):
  path = []

  prefix = "E:\\gtt\\webapp\\images\\rdp\\" + str(eid) + "\\"
  path.append(schemas.AnalysPicPath(id = 1,  path = prefix + "angle_origin.png"))
  path.append(schemas.AnalysPicPath(id = 2,  path = prefix + "angle_smooth.png"))
  path.append(schemas.AnalysPicPath(id = 3,  path = prefix + "torque_origin.png"))
  path.append(schemas.AnalysPicPath(id = 4,  path = prefix + "torque_smooth.png"))
  path.append(schemas.AnalysPicPath(id = 5,  path = prefix + "max_force.png"))
  path.append(schemas.AnalysPicPath(id = 6,  path = prefix + "min_force.png"))
  path.append(schemas.AnalysPicPath(id = 7,  path = prefix + "strain.png"))
  path.append(schemas.AnalysPicPath(id = 8,  path = prefix + "loop_all.png"))
  path.append(schemas.AnalysPicPath(id = 9,  path = prefix + "g_mean.png"))
  path.append(schemas.AnalysPicPath(id = 10, path = prefix + "tao_max.png"))
  path.append(schemas.AnalysPicPath(id = 11, path = prefix + "loop_1.png"))
  path.append(schemas.AnalysPicPath(id = 12, path = prefix + "loop_100.png"))
  path.append(schemas.AnalysPicPath(id = 13, path = prefix + "loop_n1.png"))
  path.append(schemas.AnalysPicPath(id = 14, path = prefix + "loop_last.png"))

  return path
