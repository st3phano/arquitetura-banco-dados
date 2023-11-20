import models as rpg
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.mysql import SMALLINT, TINYINT, VARCHAR
from sqlalchemy import desc, func, select

class Classe(rpg.Base):
   __tablename__ = "classe"
   id: Mapped[int] = mapped_column(TINYINT(unsigned=True), primary_key=True, autoincrement=True)
   nome: Mapped[str] = mapped_column(VARCHAR(45), nullable=False, unique=True)
   ataque : Mapped[int] = mapped_column(SMALLINT(unsigned=True), nullable=False)
   defesa : Mapped[int] = mapped_column(SMALLINT(unsigned=True), nullable=False)

   classe__personagem_jogavel: Mapped[list["rpg.Personagem_jogavel"]] = relationship("Personagem_jogavel", backref="classe")
   classe__classe_tem_habilidade: Mapped[list["rpg.Classe_tem_habilidade"]] = relationship("Classe_tem_habilidade", backref="classe")


   @classmethod
   def contar_personagens_vinculados(cls):
      '''Quantos personagens estão vinculados a cada classe?'''
      return (select(cls.nome,
                     func.count(rpg.Personagem_jogavel.id)
                     .label("personagens"))
              .select_from(cls)
              .join(rpg.Personagem_jogavel,
                    cls.id == rpg.Personagem_jogavel.classe_id,
                    isouter=True)
              .group_by(cls.nome)
              .order_by(desc("personagens")))

   @classmethod
   def listar_maior_numero_habilidades(cls, quantidade: int):
      '''Quais as classes com o maior número de habilidades?'''
      return (select(cls.nome,
                     func.count(rpg.Classe_tem_habilidade.habilidade_id)
                     .label("numero_habilidades"))
              .select_from(cls)
              .join(rpg.Classe_tem_habilidade,
                    cls.id == rpg.Classe_tem_habilidade.classe_id,
                    isouter=True)
              .group_by(cls.id)
              .order_by(desc("numero_habilidades"))
              .limit(quantidade))

   @classmethod
   def listar_habilidade_maior_dano(cls, quantidade: int):
      '''Quais classes tem as habilidades de maior dano?'''
      return (select(cls.nome,
                     rpg.Habilidade.nome,
                     func.coalesce((rpg.Habilidade.dano * rpg.Classe_tem_habilidade.modificador_dano),
                                   rpg.Habilidade.dano)
                     .label("dano"))
              .select_from(cls)
              .join(rpg.Classe_tem_habilidade,
                    cls.id == rpg.Classe_tem_habilidade.classe_id)
              .join(rpg.Habilidade,
                    rpg.Classe_tem_habilidade.habilidade_id == rpg.Habilidade.id)
              .order_by(desc("dano"))
              .limit(quantidade))

   @classmethod
   def listar_maior_defesa(cls, quantidade: int):
      '''Quais classes tem a maior defesa?'''
      return (select(cls.nome,
                     cls.defesa)
              .select_from(cls)
              .order_by(desc(cls.defesa))
              .limit(quantidade))
