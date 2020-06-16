from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"
# SQLALCHEMY_DATABASE_URL = "postgresql://user:password@postgresserver/db"
# SQLALCHEMY_DATABASE_URL = "mysql://username:password@server/db"
SQLALCHEMY_DATABASE_URL = "mysql://cloudlab:cloudlab-!@#$@localhost:33369/cloudlab?charset=utf8"
# SQLALCHEMY_DATABASE_URL = "mysql://cloudlab:cloudlab-!@#$@localhost:33996/cloudlab?charset=utf8"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()