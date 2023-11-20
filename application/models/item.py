import models as rpg
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.mysql import INTEGER, TINYINT, VARCHAR
from sqlalchemy import func, select

class Item(rpg.Base):
   __tablename__ = "item"
   id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True, autoincrement=True)
   nome: Mapped[str] = mapped_column(VARCHAR(45), nullable=False, unique=True)
   valor: Mapped[int] = mapped_column(INTEGER(unsigned=True), nullable=False)
   ataque: Mapped[int] = mapped_column(TINYINT(), nullable=False)
   defesa: Mapped[int] = mapped_column(TINYINT(), nullable=False)

   item__personagem_tem_item: Mapped[list["rpg.Personagem_tem_item"]] = relationship("Personagem_tem_item", backref="item")


   @classmethod
   def obter_maior_valor(cls):
      '''Qual o maior valor entre os itens?'''
      return (select(func.max(cls.valor))
              .select_from(cls))

   @classmethod
   def listar_maior_valor(cls):
      '''Qual(is) o(s) item(ns) com maior valor?'''
      subquery_obter_maior_valor = cls.obter_maior_valor().scalar_subquery()
      return (select(cls.nome,
                     cls.valor)
              .select_from(cls)
              .where(cls.valor == subquery_obter_maior_valor))

   @classmethod
   def obter_maior_defesa(cls):
      '''Qual a maior defesa entre os itens?'''
      return (select(func.max(cls.defesa))
              .select_from(cls))

   @classmethod
   def listar_maior_defesa(cls):
      '''Qual(is) o(s) item(ns) com maior defesa?'''
      subquery_obter_maior_defesa = cls.obter_maior_defesa().scalar_subquery()
      return (select(cls.nome,
                     cls.defesa)
              .select_from(cls)
              .where(cls.defesa == subquery_obter_maior_defesa))
