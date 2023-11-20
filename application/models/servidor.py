import models as rpg
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.mysql import BOOLEAN, SMALLINT, TINYINT, VARCHAR
from sqlalchemy import case, desc, func, select

class Servidor(rpg.Base):
   __tablename__ = "servidor"
   id: Mapped[int] = mapped_column(TINYINT(unsigned=True), primary_key=True, autoincrement=True)
   nome: Mapped[str] = mapped_column(VARCHAR(45), nullable=False, unique=True)
   populacao_maxima: Mapped[int] = mapped_column(SMALLINT(unsigned=True), nullable=False, server_default="1000")
   online: Mapped[bool] = mapped_column(BOOLEAN(), nullable=False, server_default="0")

   servidor__personagem_jogavel: Mapped[list["rpg.Personagem_jogavel"]] = relationship("Personagem_jogavel", backref= "servidor")
   servidor__servidor_tem_mosntro: Mapped[list["rpg.Servidor_tem_monstro"]] = relationship("Servidor_tem_monstro", backref= "servidor")


   @classmethod
   def contar(cls):
      '''Quantos servidores existem?'''
      return (select(func.count())
              .select_from(cls))

   @classmethod
   def listar_nomes(cls):
      '''Quais os nomes dos servidores?'''
      return (select(cls.nome)
              .select_from(cls))

   @classmethod
   def contar_personagens_vinculados(cls):
      '''Quantos personagens estão vinculados a cada servidor?'''
      return (select(cls.nome,
                     func.count(rpg.Personagem_jogavel.id)
                     .label("personagens_vinculados"))
              .select_from(cls)
              .join(rpg.Personagem_jogavel,
                    cls.id == rpg.Personagem_jogavel.servidor_id,
                    isouter=True)
              .group_by(cls.id)
              .order_by(desc("personagens_vinculados")))

   @classmethod
   def contar_personagens_online(cls):
      '''Quantos personagens estão online em cada servidor?'''
      return (select(cls.nome,
                     func.count(case((rpg.Personagem_jogavel.online == True, 1)))
                     .label("personagens_online"))
              .select_from(cls)
              .join(rpg.Personagem_jogavel,
                    cls.id == rpg.Personagem_jogavel.servidor_id,
                    isouter=True)
              .group_by(cls.id)
              .order_by(desc("personagens_online")))
