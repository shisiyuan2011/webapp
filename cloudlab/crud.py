from sqlalchemy.orm import Session
from sqlalchemy import text as sqltext
from . import models, schemas
from datetime import datetime
from .database import engine

#######################################################################
#
# Experiment
#
#######################################################################
def exp_get_all_v_brief(db: Session):
    return db.query(models.VExperimentBrief).order_by(
        models.VExperimentBrief.eid).all()

def exp_get_one_v_detail(db: Session, eid: int):
    return db.query(models.VExperimentDetail) \
            .filter(models.VExperimentDetail.eid == eid).first()

def exp_get_one_v_detail_by_name(db: Session, ename: str):
    return db.query(models.VExperimentDetail) \
            .filter(models.VExperimentDetail.ename == ename).first()

def exp_get_v_by_material(db: Session, mid: int):
    return db.query(models.VExperimentBrief) \
        .filter(models.VExperimentBrief.mid == mid) \
        .order_by(models.VExperimentBrief.eid).all()

def exp_new(db: Session, exp: schemas.Experiment):
    theexp = models.Experiment()
    # theexp.eid = exp.eid
    theexp.ename    = exp.ename   
    # theexp.etime    = datetime.utcnow
    theexp.sid      = exp.sid     
    theexp.uid      = exp.uid     
    theexp.frequncy = exp.frequncy
    theexp.sampling = exp.sampling
    theexp.H        = exp.H       
    theexp.cycles   = exp.cycles  
    theexp.datatype = exp.datatype
    theexp.datapath = exp.datapath
    theexp.rawpath  = exp.rawpath 
    theexp.memo     = exp.memo    

    db.add(theexp)
    db.commit()
    db.refresh(theexp)

def exp_get_one(db: Session, eid: int):
    return db.query(models.Experiment) \
            .filter(models.Experiment.eid == eid).first()

def exp_update(db: Session, exp: schemas.Experiment):
    theexp = db.query(models.Experiment) \
                .filter(models.Experiment.eid == exp.eid).first()
    theexp.ename    = exp.ename   
    # theexp.etime    = datetime.now()
    theexp.sid      = exp.sid     
    theexp.uid      = exp.uid     
    theexp.frequncy = exp.frequncy
    theexp.sampling = exp.sampling
    theexp.H        = exp.H       
    theexp.cycles   = exp.cycles  
    theexp.datatype = exp.datatype
    theexp.datapath = exp.datapath
    theexp.rawpath  = exp.rawpath 
    theexp.memo     = exp.memo    

    db.commit()

def exp_delete(db: Session, eid: int):
    theexp = db.query(models.Experiment) \
            .filter(models.Experiment.eid == eid).first()

    db.delete(theexp)
    db.commit()

#######################################################################
#
# Specimen
#
#######################################################################
def spc_get_all_v(db: Session):
    return db.query(models.VSpecimenDetail).order_by(
        models.VSpecimenDetail.sid).all()


def spc_get_one(db: Session, sid: int):
    return db.query(models.Specimen) \
            .filter(models.Specimen.sid == sid).first()

def spc_get_one_bye_name(db: Session, sname: str):
    return db.query(models.Specimen) \
            .filter(models.Specimen.sname == sname).first()

def spc_get_v_by_material(db: Session, mid: int):
    return db.query(models.VSpecimenDetail) \
        .filter(models.VSpecimenDetail.mid == mid) \
        .order_by(models.VSpecimenDetail.sid).all()

def spc_new(db: Session, spc: schemas.Specimen):
    thespc = models.Specimen()
    # theexp.sid      = exp.sid
    thespc.sname = spc.sname
    thespc.mid = spc.mid
    thespc.radius = spc.radius
    thespc.length = spc.length
    thespc.memo   = spc.memo

    db.add(thespc)
    db.commit()
    db.refresh(thespc)

def spc_update(db: Session, spc: schemas.Specimen):
    thespc = db.query(models.Specimen) \
                .filter(models.Specimen.sid == spc.sid).first()
    thespc.sname = spc.sname
    thespc.mid = spc.mid
    thespc.radius = spc.radius
    thespc.length = spc.length
    thespc.memo     = spc.memo

    db.commit()

def spc_delete(db: Session, sid: int):
    thespc = db.query(models.Specimen) \
                .filter(models.Specimen.sid == sid).first()

    db.delete(thespc)
    db.commit()


#######################################################################
#
# Material
#
#######################################################################
def mtr_get_all(db: Session):
    return db.query(models.Material).all()

def mtr_get_one(db: Session, mid: int):
    return db.query(models.Material) \
            .filter(models.Material.mid == mid).first()

def mtr_get_one_by_name(db: Session, mname: int):
    return db.query(models.Material) \
            .filter(models.Material.mname == mname).first()

def mtr_new(db: Session, mtr: schemas.Material):
    themtr = models.Material()
    # theexp.sid      = exp.sid
    themtr.mname = mtr.mname
    themtr.en_name = mtr.en_name
    themtr.standard = mtr.standard
    themtr.properties = mtr.properties

    db.add(themtr)
    db.commit()
    db.refresh(themtr)

def mtr_update(db: Session, mtr: schemas.Material):
    themtr = db.query(models.Material) \
                .filter(models.Material.mid == mtr.mid).first()
    themtr.mname = mtr.mname
    themtr.en_name = mtr.en_name
    themtr.standard = mtr.standard
    themtr.properties = mtr.properties

    db.commit()

def mtr_delete(db: Session, mid: int):
    themtr = db.query(models.Material) \
                .filter(models.Material.mid == mid).first()

    db.delete(themtr)
    db.commit()

def loop_get_all(db: Session, eid: int):
    conn = engine.raw_connection()
    conn.commit()
    cursor = conn.cursor()
    results = cursor.callproc('get_rdp_pic_save_path', [eid])
    conn.close()   # commit
    print(results)
    return []

def get_all_mname(db: Session):
    mtrs = mtr_get_all(db)
    strname = ''
    for mtr in mtrs:
        strname += mtr.mname
        strname += ','
    strname = strname[:-1]        
    return strname

def get_all_ename(db: Session):
    exps = exp_get_all_v_brief(db)
    strname = ''
    for exp in exps:
        strname += exp.ename
        strname += ','
    strname = strname[:-1]        
    return strname

def get_all_sname(db: Session):
    spcs = spc_get_all_v(db)
    strname = ''
    for spc in spcs:
        strname += spc.sname
        strname += ','
    strname = strname[:-1]        
    return strname


#######################################################################
#
# Rotating
#
#######################################################################
def rotating_get_all(db: Session):
    return db.query(models.VRotating).all()

def vrotating_get_one(db: Session, rtid: int):
    return db.query(models.VRotating) \
            .filter(models.VRotating.rtid == rtid).first()

def rotating_get_one(db: Session, rtid: int):
    rt = db.query(models.Rotating) \
            .filter(models.Rotating.rtid == rtid).first()
    l = len("/images/rotating/")
    rt.pic1 = rt.pic1[l:]
    rt.pic2 = rt.pic2[l:]
    rt.pic3 = rt.pic3[l:]
    return rt

def rotating_get_one_by_name(db: Session, sname: int):
    return db.query(models.VRotating) \
            .filter(models.VRotating.sname == sname).first()

def rotating_new(db: Session, rt: schemas.Rotating):
    rotating = models.Rotating()
    # rotating.rtid
    rotating.sname = rt.sname
    rotating.mid = rt.mid
    rotating.diameter = rt.diameter
    rotating.moment = rt.moment
    rotating.FatigueLifeNf = rt.FatigueLifeNf
    rotating.FracturedLocs = rt.FracturedLocs
    rotating.speed = rt.speed
    rotating.lp = rt.lp
    rotating.stress = rt.stress
    rotating.runoutcycles = rt.runoutcycles
    rotating.runouttime = rt.runouttime
    rotating.description = rt.description
    rotating.pic1 = "/images/rotating/" + rt.pic1
    rotating.pic2 = "/images/rotating/" + rt.pic2
    rotating.pic3 = "/images/rotating/" + rt.pic3

    db.add(rotating)
    db.commit()
    db.refresh(rotating)

def rotating_update(db: Session, rt: schemas.Rotating):
    rotating = db.query(models.Rotating) \
                .filter(models.Rotating.rtid == rt.rtid).first()
    rotating.sname = rt.sname
    rotating.mid = rt.mid
    rotating.diameter = rt.diameter
    rotating.moment = rt.moment
    rotating.FatigueLifeNf = rt.FatigueLifeNf
    rotating.FracturedLocs = rt.FracturedLocs
    rotating.speed = rt.speed
    rotating.lp = rt.lp
    rotating.stress = rt.stress
    rotating.runoutcycles = rt.runoutcycles
    rotating.runouttime = rt.runouttime
    rotating.description = rt.description
    rotating.pic1 = "/images/rotating/" + rt.pic1
    rotating.pic2 = "/images/rotating/" + rt.pic2
    rotating.pic3 = "/images/rotating/" + rt.pic3

    db.commit()

 
def rotating_delete(db: Session, rtid: int):
    rotating = db.query(models.Rotating) \
                .filter(models.Rotating.rtid == rtid).first()

    db.delete(rotating)
    db.commit()

''' Rotating
rtid
sname
mid
diameter
moment
FatigueLifeNf
FracturedLocs
speed
lp
stress
runoutcycles
runouttime
description
pic1
pic2
pic3
'''