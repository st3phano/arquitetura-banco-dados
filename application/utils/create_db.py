import models as rpg
from services.db import engine

def create_db():
   rpg.Base.metadata.create_all(engine)
