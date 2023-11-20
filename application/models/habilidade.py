import models as rpg
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.mysql import SMALLINT, VARCHAR

class Habilidade(rpg.Base):
   __tablename__ = "habilidade"
   id: Mapped[int] = mapped_column(SMALLINT(unsigned=True), primary_key=True, autoincrement=True)
   nome: Mapped[str] = mapped_column(VARCHAR(45), nullable=False, unique=True)
   dano: Mapped[int] = mapped_column(SMALLINT(unsigned=True), nullable=False)

   habilidade__classe_tem_habilidade: Mapped[list["rpg.Classe_tem_habilidade"]] = relationship("Classe_tem_habilidade", backref="habilidade")
