from typing import List
from datetime import date, datetime, time, timedelta
from pydantic import BaseModel

class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str = None


class User(BaseModel):
    username: str
    email: str = None
    full_name: str = None
    disabled: bool = None


class UserInDB(User):
    hashed_password: str


class UserVerify(BaseModel):
    username: str
    password: str

class RefreshToken(BaseModel):
    refresh_token: str
    token_type: str 

class Resullt(BaseModel):
    message: str

class VExperimentBrief(BaseModel):
    eid : int
    ename : str
    etime : datetime
    sid : int
    uid : int
    H : float
    cycles : float
    username : str
    sname : str
    mid : str
    mname : str
    class Config:
        orm_mode = True

class VExperimentDetail(BaseModel):
    eid : int
    ename : str
    etime : datetime
    sid : int
    uid : int
    frequncy : float
    sampling : float
    H : float
    cycles : float
    datatype : int
    datapath : str
    rawpath : str
    username : str
    sname : str
    mid : int
    radius : float
    length : float
    mname : str
    memo : str
    class Config:
        orm_mode = True

class Material(BaseModel):
    mid : int
    mname : str
    en_name : str
    standard : str
    properties : str
    class Config:
        orm_mode = True

class SpecimenDetail(BaseModel):
    sid : int
    sname : str
    mid : int
    radius : float
    length : float
    mname : str
    memo : str
    class Config:
        orm_mode = True

class Specimen(BaseModel):
    sid : int
    sname : str
    mid : int
    radius : float
    length : float
    memo : str
    class Config:
        orm_mode = True

class Experiment(BaseModel):
    eid : int
    ename : str
    etime : datetime
    sid : int
    uid : int
    frequncy : float
    sampling : float
    H : float
    cycles : float
    datatype : int
    datapath : str
    rawpath : str
    memo : str

    class Config:
        orm_mode = True

class AnalysPicPath(BaseModel):
    id : int
    path : str

class AnalysisRawData(BaseModel):
    eid: int
    ename: str
    path: List[AnalysPicPath]

class Avatar(BaseModel):
    id : int
    name : str
    race : str
    avatar: str

class Mname(BaseModel):
    mname: str

class Ename(BaseModel):
    ename: str

class Sname(BaseModel):
    sname: str
