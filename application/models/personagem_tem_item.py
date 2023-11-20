import models as rpg
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.dialects.mysql import INTEGER
from sqlalchemy import ForeignKey

class Personagem_tem_item(rpg.Base):
   __tablename__ = "personagem_tem_item"
   personagem_id: Mapped[int] = mapped_column(INTEGER(unsigned=True), ForeignKey(rpg.Personagem.id), primary_key=True)
   item_id: Mapped[int] = mapped_column(INTEGER(unsigned=True), ForeignKey(rpg.Item.id), primary_key=True)
   quantidade_item: Mapped[int] = mapped_column(INTEGER(unsigned=True), nullable=False, server_default="1")
