import models as rpg
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.mysql import INTEGER, SMALLINT, TINYINT, VARCHAR
from sqlalchemy import desc, func, select

class Personagem(rpg.Base):
   __tablename__ = "personagem"
   id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True, autoincrement=True)
   nome: Mapped[str] = mapped_column(VARCHAR(45), nullable=False, unique=True)
   pontos_vida: Mapped[int] = mapped_column(INTEGER(unsigned=True), nullable=False, server_default="100")
   velocidade: Mapped[int] = mapped_column(INTEGER(unsigned=True), nullable=False, server_default="10")
   posicao_x: Mapped[int] = mapped_column(SMALLINT(), nullable=False, server_default="0")
   posicao_y: Mapped[int] = mapped_column(SMALLINT(), nullable=False, server_default="0")
   posicao_z: Mapped[int] = mapped_column(TINYINT(), nullable=False, server_default="0")

   personagem__personagem_jogavel: Mapped["rpg.Personagem_jogavel"] = relationship("Personagem_jogavel", backref="personagem", uselist=False)
   personagem__monstro: Mapped["rpg.Monstro"] = relationship("Monstro", backref="personagem", uselist=False)
   personagem__personagem_tem_item: Mapped[list["rpg.Personagem_tem_item"]] = relationship("Personagem_tem_item", backref="personagem")


   @classmethod
   def somar_valor_itens_de(cls, nome: str):
      '''Qual a soma do valor dos itens de um personagem?'''
      return (select(func.coalesce(func.sum(rpg.Personagem_tem_item.quantidade_item * rpg.Item.valor),
                                   0))
              .select_from(cls)
              .join(rpg.Personagem_tem_item,
                    cls.id == rpg.Personagem_tem_item.personagem_id)
              .join(rpg.Item,
                    rpg.Personagem_tem_item.item_id == rpg.Item.id)
              .where(cls.nome == nome))

   # Prova autoria
   @classmethod
   def somar_quantidade_itens(cls):
      '''Qual a quantidade total de itens de cada personagem?'''
      return (select(rpg.Personagem.nome,
                     func.coalesce(func.sum(rpg.Personagem_tem_item.quantidade_item),
                                   0)
                     .label("quantidade_total_itens"))
              .select_from(cls)
              .join(rpg.Personagem_tem_item,
                    cls.id == rpg.Personagem_tem_item.personagem_id,
                    isouter=True)
              .group_by(cls.id)
              .order_by(desc("quantidade_total_itens")))
