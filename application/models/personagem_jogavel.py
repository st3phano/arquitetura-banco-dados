import models as rpg
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.dialects.mysql import BOOLEAN, ENUM, INTEGER, TINYINT
from sqlalchemy import desc, ForeignKey, func, select

class Personagem_jogavel(rpg.Base):
   __tablename__ = "personagem_jogavel"
   id: Mapped[int] = mapped_column(INTEGER(unsigned=True), ForeignKey(rpg.Personagem.id), primary_key=True)
   nivel: Mapped[int] = mapped_column(INTEGER(unsigned=True), nullable=False, server_default="1")
   dinheiro: Mapped[int] = mapped_column(INTEGER(unsigned=True), nullable=False, server_default="0")
   sexo: Mapped[int] = mapped_column(ENUM("feminino", "masculino"), nullable=False)
   online: Mapped[bool] = mapped_column(BOOLEAN(), nullable=False, server_default="0")
   classe_id: Mapped[int] = mapped_column(TINYINT(unsigned=True), ForeignKey(rpg.Classe.id), nullable=False)
   conta_id: Mapped[int] = mapped_column(INTEGER(unsigned=True), ForeignKey(rpg.Conta.id), nullable=False)
   servidor_id: Mapped[int] = mapped_column(TINYINT(unsigned=True), ForeignKey(rpg.Servidor.id), nullable=False)


   @classmethod
   def listar_maior_nivel(cls, quantidade: int):
      '''Quais os personagens com maior nível?'''
      return (select(rpg.Personagem.nome,
                     rpg.Servidor.nome,
                     cls.nivel)
              .select_from(cls)
              .join(rpg.Servidor,
                    cls.servidor_id == rpg.Servidor.id)
              .join(rpg.Personagem,
                    cls.id == rpg.Personagem.id)
              .order_by(desc(cls.nivel))
              .limit(quantidade))

   @classmethod
   def somar_valor_itens(cls):
      '''Qual a soma do valor dos itens de cada personagem?'''
      return (select(rpg.Personagem.nome,
                     func.coalesce(func.sum(rpg.Personagem_tem_item.quantidade_item * rpg.Item.valor),
                                   0)
                     .label("soma_valor_itens"))
              .select_from(cls)
              .join(rpg.Personagem,
                    cls.id == rpg.Personagem.id)
              .join(rpg.Personagem_tem_item,
                    cls.id == rpg.Personagem_tem_item.personagem_id,
                    isouter=True)
              .join(rpg.Item,
                    rpg.Personagem_tem_item.item_id == rpg.Item.id,
                    isouter=True)
              .group_by(cls.id)
              .order_by(desc("soma_valor_itens")))

   @classmethod
   def listar_mais_ricos(cls, quantidade: int):
      '''Quais os personagens mais ricos?'''
      subquery_somar_valor_itens = cls.somar_valor_itens().subquery()
      return (select(rpg.Personagem.nome,
                     rpg.Servidor.nome,
                     func.sum(cls.dinheiro + subquery_somar_valor_itens.c.soma_valor_itens)
                     .label("dinheiro_total"))
              .select_from(cls,            # cross join (produto cartesiano) + filtros,
                           rpg.Personagem, # pode ser menos eficiente que inner join
                           rpg.Servidor,
                           subquery_somar_valor_itens)
              .where(cls.id == rpg.Personagem.id)
              .where(cls.servidor_id == rpg.Servidor.id)
              .where(rpg.Personagem.nome == subquery_somar_valor_itens.c.nome)
              .group_by(cls.id)
              .order_by(desc("dinheiro_total"))
              .limit(quantidade))

   @classmethod
   def calcular_quantidade_personagens(cls):
      '''Quantos personagens existem?'''
      return (select(func.count(cls.id))
              .select_from(cls))

   @classmethod
   def listar_porcentagem_sexo(cls):
      '''Qual a porcentagem de personagens de cada sexo?'''
      subquery_calcular_quantidade_personagens = cls.calcular_quantidade_personagens().scalar_subquery()
      return (select(cls.sexo,
                     func.count(cls.id) / subquery_calcular_quantidade_personagens)
              .select_from(cls)
              .group_by(cls.sexo))

   @classmethod
   def listar_com_item(cls, item: str):
      '''Quais personagens tem um determinado item?'''
      return (select(rpg.Personagem.nome,
                     rpg.Personagem_tem_item.quantidade_item)
              .select_from(cls)
              .join(rpg.Personagem,
                    cls.id == rpg.Personagem.id)
              .join(rpg.Personagem_tem_item,
                    cls.id == rpg.Personagem_tem_item.personagem_id)
              .join(rpg.Item,
                    rpg.Personagem_tem_item.item_id == rpg.Item.id)
              .where(rpg.Item.nome == item)
              .order_by(desc(rpg.Personagem_tem_item.quantidade_item)))

   @classmethod
   def listar_classe_maior_nivel(cls):
      '''Qual(is) a(s) classe(s) do(s) personagem(s) de maior nível?'''
      return (select(rpg.Classe.nome,
                     rpg.Personagem.nome,
                     cls.nivel)
              .select_from(cls)
              .join(rpg.Classe,
                    cls.classe_id == rpg.Classe.id)
              .join(rpg.Personagem,
                    cls.id == rpg.Personagem.id)
              .where(cls.nivel == (select(func.max(cls.nivel))
                                   .select_from(cls))
                                   .scalar_subquery()))
