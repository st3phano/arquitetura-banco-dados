import models as rpg
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import ForeignKey
from sqlalchemy.dialects.mysql import INTEGER, TINYINT

class Servidor_tem_monstro(rpg.Base):
   __tablename__ = "servidor_tem_monstro"
   servidor_id: Mapped[int] = mapped_column(TINYINT(unsigned=True), ForeignKey(rpg.Servidor.id), primary_key=True)
   monstro_id: Mapped[int] = mapped_column(INTEGER(unsigned=True), ForeignKey(rpg.Monstro.id), primary_key=True)
   quantidade_monstro: Mapped[int] = mapped_column(INTEGER(unsigned=True), nullable=False, server_default="1")
