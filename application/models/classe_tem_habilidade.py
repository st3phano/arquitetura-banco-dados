import models as rpg
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import ForeignKey
from sqlalchemy.dialects.mysql import FLOAT, SMALLINT, TINYINT

class Classe_tem_habilidade(rpg.Base):
   __tablename__ = "classe_tem_habilidade"
   classe_id: Mapped[int] = mapped_column(TINYINT(unsigned=True), ForeignKey(rpg.Classe.id), primary_key=True)
   habilidade_id: Mapped[int] = mapped_column(SMALLINT(unsigned=True), ForeignKey(rpg.Habilidade.id), primary_key=True)
   modificador_dano: Mapped[float] = mapped_column(FLOAT(unsigned=True), nullable=True) # 'nullable=True' pois quando não especificado nullable=False
