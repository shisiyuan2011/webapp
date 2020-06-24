from starlette.requests import Request
from starlette.templating import Jinja2Templates
from datetime import datetime, timedelta
import jwt
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.staticfiles import StaticFiles
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jwt import PyJWTError
from passlib.context import CryptContext
from pydantic import BaseModel

from sqlalchemy.orm import Session

from . import crud, models, schemas, mysqlsp
from .database import SessionLocal, engine
from .schemas import *

from fastapi.middleware.cors import CORSMiddleware

from fastapi import FastAPI, File, UploadFile
from fastapi.responses import HTMLResponse

models.Base.metadata.create_all(bind=engine)

# to get a string like this run:
# openssl rand -hex 32
SECRET_KEY = "09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


fake_users_db = {
    "superuser": {
        "username": "superuser",
        "full_name": "John Doe",
        "email": "johndoe@example.com",
        "hashed_password": "$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW",
        "disabled": False,
    }
}

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/token")

app = FastAPI()

origins = [
    "http://localhost:8080",
    "http://127.0.0.1:8080"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

templates = Jinja2Templates(directory="templates")
app.mount("/assets", StaticFiles(directory="assets"), name="assets")
app.mount("/vendors", StaticFiles(directory="vendors"), name="vendors")
app.mount("/css", StaticFiles(directory="css"), name="css")
app.mount("/js", StaticFiles(directory="js"), name="js")
app.mount("/images", StaticFiles(directory="images"), name="images")

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ###################################################################################
# 
# User Auth
#
# ###################################################################################
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    return pwd_context.hash(password)


def get_user(db, username: str):
    if username in db:
        user_dict = db[username]
        return UserInDB(**user_dict)


def authenticate_user(fake_db, username: str, password: str):
    user = get_user(fake_db, username)
    if not user:
        return False
    if not verify_password(password, user.hashed_password):
        return False
    return user


def create_access_token(*, data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except PyJWTError:
        raise credentials_exception
    user = get_user(fake_users_db, username=token_data.username)
    if user is None:
        raise credentials_exception
    return user


async def get_current_active_user(current_user: schemas.User = Depends(get_current_user)):
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    refresh_token = create_access_token(
        data={"sub": current_user.username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return {"refresh_token": refresh_token, "token_type": "bearer"}
    # return current_user


@app.post("/login", response_model=schemas.Token)
async def login_for_access(user: schemas.UserVerify):
    user = authenticate_user(fake_users_db, user.username, user.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@app.post("/token", response_model=schemas.Token)
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    user = authenticate_user(fake_users_db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@app.get("/users/me/", response_model=schemas.RefreshToken)
async def read_users_me(rt: RefreshToken = Depends(get_current_active_user)):
    return rt


# ###################################################################################
# 
# Experiment
#
# ###################################################################################

@app.get("/experiment/list")
async def exp_list(request: Request):
    return templates.TemplateResponse('experiment/list.html', {'request': request})

@app.get("/experiment/new")
async def exp_new(request: Request):
    return templates.TemplateResponse('experiment/new.html', {'request': request})

@app.get("/experiment/detail/{eid}")
async def exp_detail(request: Request, eid : int):
    return templates.TemplateResponse('experiment/detail.html', {'request': request, 'eid': eid})

@app.get("/experiment/ndetail/{ename}")
async def exp_ndetail(request: Request, ename : str):
    return templates.TemplateResponse('experiment/ndetail.html', {'request': request, 'ename': ename})

@app.get("/experiment/modify/{eid}")
async def exp_modify(request: Request, eid : int):
    return templates.TemplateResponse('experiment/modify.html', {'request': request, 'eid': eid})

@app.get("/vexpbrf", response_model=List[schemas.VExperimentBrief])
def exp_get_all_v_brief(db: Session = Depends(get_db)):
    exp_brief = crud.exp_get_all_v_brief(db)
    return exp_brief

@app.get("/vexpbrf/m/{mid}", response_model=List[schemas.VExperimentBrief])
def exp_get_v_by_material(mid: int, db: Session = Depends(get_db)):
    exp = crud.exp_get_v_by_material(db, mid)
    return exp

@app.get("/vexpdetail/{eid}", response_model=schemas.VExperimentDetail)
def exp_get_one_v_detail(eid: int, db: Session = Depends(get_db)):
    exp = crud.exp_get_one_v_detail(db, eid)
    return exp

@app.get("/ename/{ename}", response_model=schemas.VExperimentDetail)
def exp_get_one_v_detail_by_name(ename: str, db: Session = Depends(get_db)):
    print(ename)
    exp = crud.exp_get_one_v_detail_by_name(db, ename)
    print(exp, exp.eid, exp.ename)
    return exp

@app.get("/expdetail/{eid}", response_model=schemas.Experiment)
def exp_get_one(eid: int, db: Session = Depends(get_db)):
    exp = crud.exp_get_one(db, eid)
    return exp

@app.get("/delexp/{eid}")
def exp_delete(eid: int, db: Session = Depends(get_db)):
    try:
        crud.exp_delete(db, eid)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/newexp")
def newexp(exp: schemas.Experiment, db: Session = Depends(get_db)):
    try:
        crud.exp_new(db, exp)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/updateexp")
def exp_update(exp: schemas.Experiment, db: Session = Depends(get_db)):
    try:
        crud.exp_update(db, exp)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

# ###################################################################################
# 
# Specimen
#
# ###################################################################################

@app.get("/specimen/list")
async def spc_list_page(request: Request):
    return templates.TemplateResponse('specimen/list.html', {'request': request})

@app.get("/specimen/new")
async def spc_new_page(request: Request):
    return templates.TemplateResponse('specimen/new.html', {'request': request})

@app.get("/specimen/modify/{sid}")
async def spc_modify_page(request: Request, sid : int):
    return templates.TemplateResponse('specimen/modify.html', {'request': request, 'sid': sid})

@app.get("/specimen/nmodify/{sname}")
async def spc_nmodify_page(request: Request, sname : str):
    return templates.TemplateResponse('specimen/nmodify.html', {'request': request, 'sname': sname})

@app.get("/vspecimen", response_model=List[schemas.SpecimenDetail])
def spc_get_all_v(db: Session = Depends(get_db)):
    specimens = crud.spc_get_all_v(db)
    return specimens

@app.get("/vspecimen/m/{mid}", response_model=List[schemas.SpecimenDetail])
def spc_get_v_by_material(mid: int, db: Session = Depends(get_db)):
    specimens = crud.spc_get_v_by_material(db, mid)
    return specimens

@app.get("/specimen/{sid}", response_model=schemas.Specimen)
def spc_get_sepcimen(sid: int, db: Session = Depends(get_db)):
    spc = crud.spc_get_one(db, sid)
    return spc

@app.get("/sname/{sname}", response_model=schemas.Specimen)
def spc_get_sepcimen_by_name(sname: str, db: Session = Depends(get_db)):
    spc = crud.spc_get_one_bye_name(db, sname)
    return spc

@app.get("/delspc/{sid}")
def spc_delete(sid: int, db: Session = Depends(get_db)):
    try:
        crud.spc_delete(db, sid)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/newspc")
def spc_new(spc: schemas.Specimen, db: Session = Depends(get_db)):
    try:
        crud.spc_new(db, spc)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/updatespc")
def update_exp(spc: schemas.Specimen, db: Session = Depends(get_db)):
    try:
        crud.spc_update(db, spc)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

# ###################################################################################
# 
# Material
#
# ###################################################################################
@app.get("/material/list")
async def mtr_list(request: Request):
    return templates.TemplateResponse('material/list.html', {'request': request})

@app.get("/material/new")
async def mtr_new(request: Request):
    return templates.TemplateResponse('material/new.html', {'request': request})

@app.get("/material/modify/{mid}")
async def mtr_modify(request: Request, mid : int):
    return templates.TemplateResponse('material/modify.html', {'request': request, 'mid': mid})

@app.get("/material/analysis/{mid}")
async def mtr_analysis(request: Request, mid : int):
    return templates.TemplateResponse('material/analysis.html', {'request': request, 'mid': mid})

@app.get("/material/nmodify/{mname}")
async def mtr_nmodify(request: Request, mname : str):
    return templates.TemplateResponse('material/nmodify.html', {'request': request, 'mname': mname})

@app.get("/delmtr/{mid}")
def delete_material(mid: int, db: Session = Depends(get_db)):
    crud.mtr_delete(db, mid)
    return {"message": "ok"}

@app.post("/newmtr")
def newmtr(mtr: schemas.Material, db: Session = Depends(get_db)):
    try:
        crud.mtr_new(db, mtr)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/updatemtr")
def mtr_update(mtr: schemas.Material, db: Session = Depends(get_db)):
    try:
        crud.mtr_update(db, mtr)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.get("/material", response_model=List[schemas.Material])
def mtr_get_all(db: Session = Depends(get_db)):
    material = crud.mtr_get_all(db)
    return material

@app.get("/material/{mid}", response_model=schemas.Material)
def mtr_get_one(mid: int, db: Session = Depends(get_db)):
    mtr = crud.mtr_get_one(db, mid)
    return mtr

@app.get("/mname/{mname}", response_model=schemas.Material)
def mtr_get_one_by_name(mname: str, db: Session = Depends(get_db)):
    mtr = crud.mtr_get_one_by_name(db, mname)
    return mtr


# ###################################################################################
# 
# Hysteresis Loops
#
# ###################################################################################
@app.get("/hloops/{eid}")
async def hloops_page(request: Request, eid : int):
    return templates.TemplateResponse('analysis/hloop.html', {'request': request, 'eid': eid})

@app.get("/prediction/{mid}")
async def prediction_page(request: Request, mid : int, db: Session = Depends(get_db)):
    mtr = crud.mtr_get_one(db, mid)
    return templates.TemplateResponse('analysis/predict.html',
                                    {'request': request, 'mid': mtr.mid, 'mname': mtr.mname})

@app.get("/loop/{eid}")
def get_analysis_pic_web_path(eid: int, db: Session = Depends(get_db), response_model=AnalysisRawData):
    exp = crud.exp_get_one_v_detail(db, eid)
    res = mysqlsp.get_analysis_pic_web_path(exp)
    return res


# ###################################################################################
# 
# Rotating
#
# ###################################################################################
@app.get("/rotating/list")
async def rotating_list(request: Request):
    return templates.TemplateResponse('rotating/list.html', {'request': request})

@app.get("/rotating/new")
async def rotating_new(request: Request):
    return templates.TemplateResponse('rotating/new.html', {'request': request})

@app.get("/rotating/modify/{rtid}")
async def rotating_modify(request: Request, rtid : int):
    return templates.TemplateResponse('rotating/modify.html', {'request': request, 'rtid': rtid})

@app.get("/rotating/detail/{rtid}")
async def rotating_detail(request: Request, rtid : int):
    return templates.TemplateResponse('rotating/detail.html', {'request': request, 'rtid': rtid})

@app.get("/rotating/nmodify/{sname}")
async def rotating_nmodify(request: Request, sname : str):
    return templates.TemplateResponse('rotating/nmodify.html', {'request': request, 'sname': sname})

@app.get("/delrt/{rtid}")
def delete_rotating(rtid: int, db: Session = Depends(get_db)):
    crud.rotating_delete(db, rtid)
    return {"message": "ok"}

@app.post("/newrt")
def newrt(rotating: schemas.Rotating, db: Session = Depends(get_db)):
    try:
        crud.rotating_new(db, rotating)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/updatert")
def rotating_update(rotating: schemas.Rotating, db: Session = Depends(get_db)):
    try:
        crud.rotating_update(db, rotating)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.get("/vrotating", response_model=List[schemas.VRotating])
def rotating_get_all(db: Session = Depends(get_db)):
    rotating = crud.rotating_get_all(db)
    return rotating

@app.get("/vrotating/{rtid}", response_model=schemas.VRotating)
def vrotating_get_one(rtid: int, db: Session = Depends(get_db)):
    rotating = crud.vrotating_get_one(db, rtid)
    return rotating

@app.get("/rotating/{rtid}", response_model=schemas.Rotating)
def rotating_get_one(rtid: int, db: Session = Depends(get_db)):
    rotating = crud.rotating_get_one(db, rtid)
    return rotating


@app.get("/vrotating/{sname}", response_model=schemas.VRotating)
def rotating_get_one_by_name(sname: str, db: Session = Depends(get_db)):
    rotating = crud.rotating_get_one_by_name(db, sname)
    return rotating


# ###################################################################################
# 
# Torsion
#
# ###################################################################################
@app.get("/torsion/list")
async def torsion_list(request: Request):
    return templates.TemplateResponse('torsion/list.html', {'request': request})

@app.get("/torsion/new")
async def torsion_new(request: Request):
    return templates.TemplateResponse('torsion/new.html', {'request': request})

@app.get("/torsion/modify/{torsion_id}")
async def torsion_modify(request: Request, torsion_id : int):
    return templates.TemplateResponse('torsion/modify.html', {'request': request, 'torsion_id': torsion_id})

@app.get("/torsion/detail/{torsion_id}")
async def torsion_detail(request: Request, torsion_id : int):
    return templates.TemplateResponse('torsion/detail.html', {'request': request, 'torsion_id': torsion_id})

@app.get("/torsion/nmodify/{sname}")
async def torsion_nmodify(request: Request, sname : str):
    return templates.TemplateResponse('torsion/nmodify.html', {'request': request, 'sname': sname})

@app.get("/deltrs/{torsion_id}")
def delete_torsion(torsion_id: int, db: Session = Depends(get_db)):
    crud.torsion_delete(db, torsion_id)
    return {"message": "ok"}

@app.post("/newtrs")
def newtrs(torsion: schemas.Torsion, db: Session = Depends(get_db)):
    try:
        crud.torsion_new(db, torsion)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/updatetrs")
def torsion_update(torsion: schemas.Torsion, db: Session = Depends(get_db)):
    try:
        crud.torsion_update(db, torsion)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.get("/vtorsion", response_model=List[schemas.VTorsion])
def torsion_get_all(db: Session = Depends(get_db)):
    torsion = crud.torsion_get_all(db)
    return torsion

@app.get("/vtorsion/{torsion_id}", response_model=schemas.VTorsion)
def vtorsion_get_one(torsion_id: int, db: Session = Depends(get_db)):
    torsion = crud.vtorsion_get_one(db, torsion_id)
    return torsion

@app.get("/torsion/{torsion_id}", response_model=schemas.Torsion)
def torsion_get_one(torsion_id: int, db: Session = Depends(get_db)):
    torsion = crud.torsion_get_one(db, torsion_id)
    return torsion


@app.get("/vtorsion/{sname}", response_model=schemas.VTorsion)
def torsion_get_one_by_name(sname: str, db: Session = Depends(get_db)):
    torsion = crud.torsion_get_one_by_name(db, sname)
    return torsion


# ###################################################################################
# 
# Tension
#
# ###################################################################################
@app.get("/tension/list")
async def tension_list(request: Request):
    return templates.TemplateResponse('tension/list.html', {'request': request})

@app.get("/tension/new")
async def tension_new(request: Request):
    return templates.TemplateResponse('tension/new.html', {'request': request})

@app.get("/tension/modify/{tension_id}")
async def tension_modify(request: Request, tension_id : int):
    return templates.TemplateResponse('tension/modify.html', {'request': request, 'tension_id': tension_id})

@app.get("/tension/detail/{tension_id}")
async def tension_detail(request: Request, tension_id : int):
    return templates.TemplateResponse('tension/detail.html', {'request': request, 'tension_id': tension_id})

@app.get("/tension/nmodify/{sname}")
async def tension_nmodify(request: Request, sname : str):
    return templates.TemplateResponse('tension/nmodify.html', {'request': request, 'sname': sname})

@app.get("/deltns/{tension_id}")
def delete_tension(tension_id: int, db: Session = Depends(get_db)):
    crud.tension_delete(db, tension_id)
    return {"message": "ok"}

@app.post("/newtns")
def newtns(tension: schemas.Tension, db: Session = Depends(get_db)):
    try:
        crud.tension_new(db, tension)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.post("/updatetns")
def tension_update(tension: schemas.Tension, db: Session = Depends(get_db)):
    try:
        crud.tension_update(db, tension)
        return {"message": "ok"}
    except:
        return {"message": "bad"}

@app.get("/vtension", response_model=List[schemas.VTension])
def tension_get_all(db: Session = Depends(get_db)):
    tension = crud.tension_get_all(db)
    return tension

@app.get("/vtension/{tension_id}", response_model=schemas.VTension)
def vtension_get_one(tension_id: int, db: Session = Depends(get_db)):
    tension = crud.vtension_get_one(db, tension_id)
    return tension

@app.get("/tension/{tension_id}", response_model=schemas.Tension)
def tension_get_one(tension_id: int, db: Session = Depends(get_db)):
    tension = crud.tension_get_one(db, tension_id)
    return tension


@app.get("/vtension/{sname}", response_model=schemas.VTension)
def tension_get_one_by_name(sname: str, db: Session = Depends(get_db)):
    tension = crud.tension_get_one_by_name(db, sname)
    return tension



# ###################################################################################
# 
# Pages
#
# ###################################################################################
@app.get("/")
async def main_default_root(request: Request):
    return templates.TemplateResponse('index.html', {'request': request})

@app.get("/main")
async def main_default_main(request: Request):
    return templates.TemplateResponse('main.html', {'request': request})

@app.get("/main/{user}")
async def main_user(request: Request, user: str):
    return templates.TemplateResponse('main.html', {'request': request, 'user': user})

@app.get("/material/content/{mid}")
async def material_content(request: Request, mid: int, db: Session = Depends(get_db)):
    mtr = crud.mtr_get_one(db, mid)
    return templates.TemplateResponse('material/content.html', {'request': request,
                                    'mid': mid, 'mname': mtr.mname})

@app.get("/trysearch", response_model=List[Avatar])
async def try_search():
    return [
      Avatar(id = 1, name = "AAA", race = "Hobbit", avatar = "https://upload.wikimedia.org/wikipedia/en/thumb/4/4e/Elijah_Wood_as_Frodo_Baggins.png/220px-Elijah_Wood_as_Frodo_Baggins.png"),
      Avatar(id = 2, name = "BBB", race = "Hobbit", avatar = "https://upload.wikimedia.org/wikipedia/en/thumb/7/7b/Sean_Astin_as_Samwise_Gamgee.png/200px-Sean_Astin_as_Samwise_Gamgee.png"),
      Avatar(id = 3, name = "DDD", race = "Maia"  , avatar = "https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Gandalf600ppx.jpg/220px-Gandalf600ppx.jpg"),
      Avatar(id = 4, name = "CCC", race = "Human",  avatar = "https://upload.wikimedia.org/wikipedia/en/thumb/3/35/Aragorn300ppx.png/150px-Aragorn300ppx.png")
    ]


@app.get("/mnames")
async def try_mnames(db: Session = Depends(get_db)):
    mname = crud.get_all_mname(db)
    return mname

@app.get("/enames")
async def try_enames(db: Session = Depends(get_db)):
    ename = crud.get_all_ename(db)
    return ename


@app.get("/snames")
async def try_snames(db: Session = Depends(get_db)):
    sname = crud.get_all_sname(db)
    return sname

# @app.get("/upload")
# async def try_upload(request: Request):
#     return templates.TemplateResponse('upload.html', {'request': request})




# @app.post("/files/")
# async def create_files(files: List[bytes] = File(...)):
#     return {"file_sizes": [len(file) for file in files]}


@app.post("/uploadfiles/")
async def upload_rotating_files(myfile: List[UploadFile] = File(...)):
    for file in myfile:
        content = await file.read()
        with open('E:\\webapp\\images\\rotating\\' + file.filename, 'wb') as f:
            f.write(content)

    return {"filenames": [file.filename for file in myfile]}

@app.post("/uptorsion/")
async def upload_torsion_files(myfile: List[UploadFile] = File(...)):
    for file in myfile:
        content = await file.read()
        with open('E:\\webapp\\images\\torsion\\' + file.filename, 'wb') as f:
            f.write(content)

    return {"filenames": [file.filename for file in myfile]}

@app.post("/uptension/")
async def upload_torsion_files(myfile: List[UploadFile] = File(...)):
    for file in myfile:
        content = await file.read()
        with open('E:\\webapp\\images\\tension\\' + file.filename, 'wb') as f:
            f.write(content)

    return {"filenames": [file.filename for file in myfile]}

'''
@app.get("/uuu")
async def uuu():
    content = """
<body>
<form action="/files/" enctype="multipart/form-data" method="post">
<input name="files" type="file">
<input type="submit" value="upload">
</form>
<form action="/uploadfiles/" enctype="multipart/form-data" method="post">
<input name="files" type="file">
<input type="submit" value="upload">
</form>
</body>
    """
    return HTMLResponse(content=content)
'''

if __name__ == '__main__':
    import uvicorn
    uvicorn.run('cloudlab:app', port=22888, host='127.0.0.1', reload=True)
