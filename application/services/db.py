from sqlalchemy_utils import create_database, database_exists
from sqlalchemy import create_engine
from urllib.parse import quote

CAMINHO_ARQUIVO_SENHA = "application/senha.txt"
with open(CAMINHO_ARQUIVO_SENHA, 'r') as arquivo_senha:
   senha_mysql = arquivo_senha.read().strip()
instance: str = f"mysql+pymysql://root:{quote(senha_mysql)}@localhost:3306/rpg"

if (not database_exists(instance)):
   create_database(instance)
engine = create_engine(instance, echo=False)
