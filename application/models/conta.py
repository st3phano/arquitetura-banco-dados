import models as rpg
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.mysql import INTEGER, TIMESTAMP, VARCHAR
from datetime import datetime
from sqlalchemy import func, select

class Conta(rpg.Base):
   __tablename__ = "conta"
   id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True, autoincrement=True)
   email: Mapped[str] = mapped_column(VARCHAR(45), nullable=False, unique=True)
   hash_senha: Mapped[str] = mapped_column(VARCHAR(45), nullable=False)
   criada_em: Mapped[datetime] = mapped_column(TIMESTAMP(), nullable=False, server_default=func.now())

   conta__personagem_jogavel: Mapped[list["rpg.Personagem_jogavel"]] = relationship("Personagem_jogavel", backref="conta")


   @classmethod
   def contar_criadas_em(cls, data_hora_inicio: str, data_hora_fim: str):
      '''Quantas contas foram criadas em um período?'''
      return (select(func.count())
              .select_from(cls)
              .where(cls.criada_em.between(data_hora_inicio,
                                           data_hora_fim)))

   @classmethod
   def calcular_nivel_medio_personagens_de(cls, email: str):
      '''Qual o nível médio dos personagens de uma conta?'''
      return (select(func.avg(rpg.Personagem_jogavel.nivel))
              .select_from(cls)
              .join(rpg.Personagem_jogavel,
                    cls.id == rpg.Personagem_jogavel.conta_id)
              .where(cls.email == email))

   @classmethod
   def contar_personagens_de(cls, email: str):
      '''Quantos personagens uma conta possui?'''
      return (select(func.count())
              .select_from(cls)
              .join(rpg.Personagem_jogavel,
                    cls.id == rpg.Personagem_jogavel.conta_id)
              .where(cls.email == email))
