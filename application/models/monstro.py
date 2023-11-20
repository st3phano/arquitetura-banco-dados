import models as rpg
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.mysql import INTEGER, SMALLINT
from sqlalchemy import desc, ForeignKey, func, select

class Monstro(rpg.Base):
   __tablename__ = "monstro"
   id: Mapped[int] = mapped_column(INTEGER(unsigned=True), ForeignKey(rpg.Personagem.id), primary_key=True)
   ataque: Mapped[int] = mapped_column(SMALLINT(unsigned=True), nullable=False)
   defesa: Mapped[int] = mapped_column(SMALLINT(unsigned=True), nullable=False)

   monstro__servidor_tem_monstro: Mapped[list["rpg.Servidor_tem_monstro"]] = relationship("Servidor_tem_monstro", backref= "monstro")


   @classmethod
   def listar_com_item_maior_defesa(cls):
      '''Quais monstro(s) tem o(s) item(s) de maior defesa?'''
      subquery_item_listar_maior_defesa = rpg.Item.listar_maior_defesa().subquery()
      return (select(rpg.Personagem.nome,
                     rpg.Item.nome,
                     rpg.Item.defesa,
                     rpg.Personagem_tem_item.quantidade_item)
              .select_from(cls)
              .join(rpg.Personagem,
                    cls.id == rpg.Personagem.id)
              .join(rpg.Personagem_tem_item,
                    cls.id == rpg.Personagem_tem_item.personagem_id)
              .join(rpg.Item,
                    rpg.Personagem_tem_item.item_id == rpg.Item.id)
              .join(subquery_item_listar_maior_defesa,
                    rpg.Item.nome == subquery_item_listar_maior_defesa.c.nome))

   @classmethod
   def listar_maior_velocidade(cls, quantidade: int):
      '''Quais os monstros com maior velocidade?'''
      return (select(rpg.Personagem.nome,
                     rpg.Personagem.velocidade)
              .select_from(cls)
              .join(rpg.Personagem,
                    cls.id == rpg.Personagem.id)
              .order_by(desc(rpg.Personagem.velocidade))
              .limit(quantidade))

   @classmethod
   def listar_maior_ataque_por_pontos_vida(cls, quantidade: int):
      '''Quais os monstros com maior ataque por pontos de vida?'''
      return (select(rpg.Personagem.nome,
                     cls.ataque,
                     rpg.Personagem.pontos_vida,
                     (cls.ataque / rpg.Personagem.pontos_vida)
                     .label("ataque_por_pontos_vida"))
              .select_from(cls)
              .join(rpg.Personagem,
                    cls.id == rpg.Personagem.id)
              .order_by(desc("ataque_por_pontos_vida"))
              .limit(quantidade))
