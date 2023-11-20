from models import *
from datetime import datetime, timedelta
from services.db import engine
from utils.create_db import create_db
from sqlalchemy.orm import Session
from sqlalchemy import delete, func, Result, ScalarResult, select, text, update

if (__name__ == "__main__"):
   create_db()

def inserir_registros(session: Session) -> None:
   '''Inserir ao menos 6 registros em cada uma das tabelas do banco de dados'''
   servidores = [
      Servidor(
         nome="PUCPR"
      ),
      Servidor(
         nome="UNIANDRADE"
      ),
      Servidor(
         nome="UFPR"
      ),
      Servidor(
         nome="UP"
      ),
      Servidor(
         nome="UTFPR"
      ),
      Servidor(
         nome="UTP"
      )
   ]
   session.add_all(servidores)

   monstros = [
      Personagem(
         nome="Antônio David Viniski",
         pontos_vida=101,
         velocidade=11,
         posicao_x = 1, posicao_y = 1, posicao_z = 1,
         personagem__monstro=Monstro(
            ataque=1,
            defesa=11
         )
      ),
      Personagem(
         nome="Andrey Cabral Meira",
         pontos_vida=102,
         velocidade=12,
         posicao_x = 2, posicao_y = 2, posicao_z = 2,
         personagem__monstro=Monstro(
            ataque=2,
            defesa=12
         )
      ),
      Personagem(
         nome="Jose Eduardo Nunes Lino",
         pontos_vida=103,
         velocidade=13,
         posicao_x = 3, posicao_y = 3, posicao_z = 3,
         personagem__monstro=Monstro(
            ataque=3,
            defesa=13
         )
      ),
      Personagem(
         nome="Haroldo Osmar de Paula Junior",
         pontos_vida=104,
         velocidade=14,
         posicao_x = 4, posicao_y = 4, posicao_z = 4,
         personagem__monstro=Monstro(
            ataque=4,
            defesa=14
         )
      ),
      Personagem(
         nome="Jhonatan Geremias",
         pontos_vida=105,
         velocidade=15,
         posicao_x = 5, posicao_y = 5, posicao_z = 5,
         personagem__monstro=Monstro(
            ataque=5,
            defesa=15
         )
      ),
      Personagem(
         nome="Alcides Calsavara",
         pontos_vida=106,
         velocidade=16,
         posicao_x = 6, posicao_y = 6, posicao_z = 6,
         personagem__monstro=Monstro(
            ataque=6,
            defesa=16
         )
      )
   ]
   session.add_all(monstros)

   session.flush()
   SERVIDOR_ID_PUCPR = session.scalar(select(Servidor.id)
                                      .select_from(Servidor)
                                      .where(Servidor.nome == "PUCPR"))
   servidores_tem_monstros = [
      Servidor_tem_monstro(
         servidor_id=SERVIDOR_ID_PUCPR,
         monstro_id=session.scalar(select(Personagem.id)
                                   .select_from(Personagem)
                                   .where(Personagem.nome == "Antônio David Viniski"))
      ),
      Servidor_tem_monstro(
         servidor_id=SERVIDOR_ID_PUCPR,
         monstro_id=session.scalar(select(Personagem.id)
                                   .select_from(Personagem)
                                   .where(Personagem.nome == "Andrey Cabral Meira"))
      ),
      Servidor_tem_monstro(
         servidor_id=SERVIDOR_ID_PUCPR,
         monstro_id=session.scalar(select(Personagem.id)
                                   .select_from(Personagem)
                                   .where(Personagem.nome == "Jose Eduardo Nunes Lino"))
      ),
      Servidor_tem_monstro(
         servidor_id=SERVIDOR_ID_PUCPR,
         monstro_id=session.scalar(select(Personagem.id)
                                   .select_from(Personagem)
                                   .where(Personagem.nome == "Haroldo Osmar de Paula Junior"))
      ),
      Servidor_tem_monstro(
         servidor_id=SERVIDOR_ID_PUCPR,
         monstro_id=session.scalar(select(Personagem.id)
                                   .select_from(Personagem)
                                   .where(Personagem.nome == "Jhonatan Geremias"))
      ),
      Servidor_tem_monstro(
         servidor_id=SERVIDOR_ID_PUCPR,
         monstro_id=session.scalar(select(Personagem.id)
                                   .select_from(Personagem)
                                   .where(Personagem.nome == "Alcides Calsavara"))
      )
   ]
   session.add_all(servidores_tem_monstros)

   classes = [
      Classe(
         nome="BCC 2U",
         ataque=21,
         defesa=31
      ),
      Classe(
         nome="BCC 2A",
         ataque=22,
         defesa=32
      ),
      Classe(
         nome="BCC 2B",
         ataque=23,
         defesa=33
      ),
      Classe(
         nome="BCS 2U",
         ataque=24,
         defesa=34
      ),
      Classe(
         nome="BCC 3B",
         ataque=25,
         defesa=35
      ),
      Classe(
         nome="TRANCADO",
         ataque=6,
         defesa=6
      )
   ]
   session.add_all(classes)

   habilidades = [
      Habilidade(
         nome="Colocar Casaco",
         dano=1
      ),
      Habilidade(
         nome="Tirar Casaco",
         dano=2
      ),
      Habilidade(
         nome="Desenhar na Aula",
         dano=3
      ),
      Habilidade(
         nome="Chegar Atrasada(o)",
         dano=4
      ),
      Habilidade(
         nome="Comer Coxinha",
         dano=5
      ),
      Habilidade(
         nome="Faltar Aula",
         dano=6
      )
   ]
   session.add_all(habilidades)

   session.flush()
   CLASSE_ID_BCC_2A = session.scalar(select(Classe.id)
                                     .select_from(Classe)
                                     .where(Classe.nome == "BCC 2A"))
   CLASSE_ID_BCC_2B = session.scalar(select(Classe.id)
                                     .select_from(Classe)
                                     .where(Classe.nome == "BCC 2B"))
   classes_tem_habilidades = [
      Classe_tem_habilidade(
         classe_id=CLASSE_ID_BCC_2A,
         habilidade_id=session.scalar(select(Habilidade.id)
                                      .select_from(Habilidade)
                                      .where(Habilidade.nome == "Colocar Casaco")),
         modificador_dano=0.5
      ),
      Classe_tem_habilidade(
         classe_id=CLASSE_ID_BCC_2A,
         habilidade_id=session.scalar(select(Habilidade.id)
                                      .select_from(Habilidade)
                                      .where(Habilidade.nome == "Tirar Casaco")),
         modificador_dano=1.1
      ),
      Classe_tem_habilidade(
         classe_id=CLASSE_ID_BCC_2A,
         habilidade_id=session.scalar(select(Habilidade.id)
                                      .select_from(Habilidade)
                                      .where(Habilidade.nome == "Desenhar na Aula")),
      ),
      Classe_tem_habilidade(
         classe_id=CLASSE_ID_BCC_2B,
         habilidade_id=session.scalar(select(Habilidade.id)
                                      .select_from(Habilidade)
                                      .where(Habilidade.nome == "Chegar Atrasada(o)")),
      ),
      Classe_tem_habilidade(
         classe_id=CLASSE_ID_BCC_2B,
         habilidade_id=session.scalar(select(Habilidade.id)
                                      .select_from(Habilidade)
                                      .where(Habilidade.nome == "Comer Coxinha")),
      ),
      Classe_tem_habilidade(
         classe_id=CLASSE_ID_BCC_2B,
         habilidade_id=session.scalar(select(Habilidade.id)
                                      .select_from(Habilidade)
                                      .where(Habilidade.nome == "Faltar Aula")),
         modificador_dano=0.2
      )
   ]
   session.add_all(classes_tem_habilidades)

   contas = [
      Conta(
         email="bruno@cobol.br",
         hash_senha="111111",
         criada_em='2021-01-01'
      ),
      Conta(
         email="eduardo@cobol.br",
         hash_senha="222222"
      ),
      Conta(
         email="henrique@cobol.br",
         hash_senha="333333"
      ),
      Conta(
         email="stephano@cobol.br",
         hash_senha="444444"
      ),
      Conta(
         email="thiago@cobol.br",
         hash_senha="555555"
      ),
      Conta(
         email="intrusa@cobol.br",
         hash_senha="666666",
         criada_em='2016-06-06'
      )
   ]
   session.add_all(contas)

   session.flush()
   personagens_jogaveis = [
      Personagem(
         nome="Bruno",
         pontos_vida=1001,
         velocidade=101,
         posicao_x = -111, posicao_y = -111, posicao_z = -1,
         personagem__personagem_jogavel=Personagem_jogavel(
            nivel=11,
            dinheiro=11001,
            sexo="masculino",
            classe_id=CLASSE_ID_BCC_2B,
            conta_id=session.scalar(select(Conta.id)
                                    .select_from(Conta)
                                    .where(Conta.email == "bruno@cobol.br")),
            servidor_id=SERVIDOR_ID_PUCPR
         )
      ),
      Personagem(
         nome="Eduardo",
         pontos_vida=2002,
         velocidade=202,
         posicao_x = -222, posicao_y = -222, posicao_z = -2,
         personagem__personagem_jogavel=Personagem_jogavel(
            nivel=22,
            dinheiro=22002,
            sexo="feminino",
            classe_id=CLASSE_ID_BCC_2A,
            conta_id=session.scalar(select(Conta.id)
                                    .select_from(Conta)
                                    .where(Conta.email == "eduardo@cobol.br")),
            servidor_id=SERVIDOR_ID_PUCPR
         )
      ),
      Personagem(
         nome="Henrique",
         pontos_vida=3003,
         velocidade=303,
         posicao_x = -333, posicao_y = -333, posicao_z = -3,
         personagem__personagem_jogavel=Personagem_jogavel(
            nivel=33,
            dinheiro=33003,
            sexo="masculino",
            classe_id=CLASSE_ID_BCC_2B,
            conta_id=session.scalar(select(Conta.id)
                                    .select_from(Conta)
                                    .where(Conta.email == "henrique@cobol.br")),
            servidor_id=SERVIDOR_ID_PUCPR
         )
      ),
      Personagem(
         nome="Stéphano",
         pontos_vida=4004,
         velocidade=404,
         posicao_x = -444, posicao_y = -444, posicao_z = -4,
         personagem__personagem_jogavel=Personagem_jogavel(
            nivel=44,
            dinheiro=44004,
            sexo="masculino",
            classe_id=CLASSE_ID_BCC_2B,
            conta_id=session.scalar(select(Conta.id)
                                    .select_from(Conta)
                                    .where(Conta.email == "stephano@cobol.br")),
            servidor_id=SERVIDOR_ID_PUCPR
         )
      ),
      Personagem(
         nome="Thiago",
         pontos_vida=5005,
         velocidade=505,
         posicao_x = -555, posicao_y = -555, posicao_z = -5,
         personagem__personagem_jogavel=Personagem_jogavel(
            nivel=55,
            dinheiro=55005,
            sexo="masculino",
            classe_id=CLASSE_ID_BCC_2A,
            conta_id=session.scalar(select(Conta.id)
                                    .select_from(Conta)
                                    .where(Conta.email == "thiago@cobol.br")),
            servidor_id=SERVIDOR_ID_PUCPR
         )
      ),
      Personagem(
         nome="Intrusa",
         pontos_vida=6006,
         velocidade=606,
         posicao_x = -666, posicao_y = -666, posicao_z = -6,
         personagem__personagem_jogavel=Personagem_jogavel(
            nivel=66,
            dinheiro=66006,
            sexo="feminino",
            classe_id=session.scalar(select(Classe.id)
                                     .select_from(Classe)
                                     .where(Classe.nome == "TRANCADO")),
            conta_id=session.scalar(select(Conta.id)
                                    .select_from(Conta)
                                    .where(Conta.email == "intrusa@cobol.br")),
            servidor_id=SERVIDOR_ID_PUCPR
         )
      )
   ]
   session.add_all(personagens_jogaveis)

   itens = [
      Item(
         nome="Casacão Branco do Papa",
         valor=1111,
         ataque=0,
         defesa=11
      ),
      Item(
         nome="Botina da Louis Vuitton",
         valor=2222,
         ataque=0,
         defesa=22
      ),
      Item(
         nome="Óclinhos do Clark Kent",
         valor=3333,
         ataque=0,
         defesa=33
      ),
      Item(
         nome="Avaliação Corrigida",
         valor=4444,
         ataque=44,
         defesa=0
      ),
      Item(
         nome="Controle do Projetor",
         valor=5555,
         ataque=55,
         defesa=0
      ),
      Item(
         nome="Lancheira do Homem-Aranha",
         valor=6666,
         ataque=66,
         defesa=0
      )
   ]
   session.add_all(itens)

   session.flush()
   personagens_tem_itens = [
      Personagem_tem_item(
         personagem_id=session.scalar(select(Personagem.id)
                                      .select_from(Personagem)
                                      .where(Personagem.nome == "Eduardo")),
         item_id=session.scalar(select(Item.id)
                                .select_from(Item)
                                .where(Item.nome == "Casacão Branco do Papa")),
         quantidade_item=8
      ),
      Personagem_tem_item(
         personagem_id=session.scalar(select(Personagem.id)
                                      .select_from(Personagem)
                                      .where(Personagem.nome == "Jose Eduardo Nunes Lino")),
         item_id=session.scalar(select(Item.id)
                                .select_from(Item)
                                .where(Item.nome == "Botina da Louis Vuitton")),
         quantidade_item=2
      ),
      Personagem_tem_item(
         personagem_id=session.scalar(select(Personagem.id)
                                      .select_from(Personagem)
                                      .where(Personagem.nome == "Henrique")),
         item_id=session.scalar(select(Item.id)
                                .select_from(Item)
                                .where(Item.nome == "Óclinhos do Clark Kent")),
      ),
      Personagem_tem_item(
         personagem_id=session.scalar(select(Personagem.id)
                                      .select_from(Personagem)
                                      .where(Personagem.nome == "Bruno")),
         item_id=session.scalar(select(Item.id)
                                .select_from(Item)
                                .where(Item.nome == "Óclinhos do Clark Kent")),
      ),
      Personagem_tem_item(
         personagem_id=session.scalar(select(Personagem.id)
                                      .select_from(Personagem)
                                      .where(Personagem.nome == "Bruno")),
         item_id=session.scalar(select(Item.id)
                                .select_from(Item)
                                .where(Item.nome == "Lancheira do Homem-Aranha")),
         quantidade_item=4
      ),
      Personagem_tem_item(
         personagem_id=session.scalar(select(Personagem.id)
                                      .select_from(Personagem)
                                      .where(Personagem.nome == "Antônio David Viniski")),
         item_id=session.scalar(select(Item.id)
                                .select_from(Item)
                                .where(Item.nome == "Controle do Projetor")),
      )
   ]
   session.add_all(personagens_tem_itens)
   session.commit()
   print("[*] Registros adicionados!")

def atualizar_registros(session: Session) -> None:
   '''Criar 5 instruções de atualização de registros em diferentes tabelas'''
   CLASSE_ID_BCC_2B = session.scalar(select(Classe.id)
                                     .select_from(Classe)
                                     .where(Classe.nome == "BCC 2B"))
   session.execute(update(Personagem_jogavel)
                   .values(classe_id=CLASSE_ID_BCC_2B)
                   .where(Personagem_jogavel.id.in_(session.scalars(select(Personagem.id)
                                                                    .select_from(Personagem)
                                                                    .where(Personagem.nome.in_(("Eduardo", "Thiago")))))))
   session.execute(update(Item)
                   .values(nome="Casacão Esquenta Defunto")
                   .where(Item.nome == "Casacão Branco do Papa"))
   session.execute(update(Habilidade)
                   .values(nome=Habilidade.nome + " de Frango")
                   .where(Habilidade.nome == "Comer Coxinha"))
   session.execute(update(Servidor)
                   .values(online=True)
                   .where(Servidor.nome == "PUCPR"))
   session.execute(text("UPDATE personagem_jogavel\n" +
                        "SET online = TRUE\n" +
                        "WHERE online = FALSE;"))
   session.commit()
   print("[*] Registros atualizados!")

def excluir_registros(session: Session) -> None:
   '''Criar 5 instruções de exclusão de registros em diferentes tabelas'''
   PERSONAGEM_ID_HAROLDO = session.scalar(select(Personagem.id)
                                          .select_from(Personagem)
                                          .where(Personagem.nome == "Haroldo Osmar de Paula Junior"))
   session.execute(delete(Servidor_tem_monstro)
                   .where(Servidor_tem_monstro.monstro_id == PERSONAGEM_ID_HAROLDO))
   session.execute(delete(Monstro)
                   .where(Monstro.id == PERSONAGEM_ID_HAROLDO))
   session.execute(delete(Personagem)
                   .where(Personagem.id == PERSONAGEM_ID_HAROLDO))
   session.delete(session.scalar(select(Servidor)
                                 .select_from(Servidor)
                                 .where(Servidor.nome == "UNIANDRADE")))
   session.delete(session.scalar(select(Classe)
                                 .select_from(Classe)
                                 .where(Classe.nome == "BCC 3B")))
   session.commit()
   print("[*] Registros excluídos!")

session = Session(engine, autoflush=False)


# inserir_registros(session)
# atualizar_registros(session)
# excluir_registros(session)


def imprimir_numero(resultado_query: int | float) -> None:
   print(f"    {resultado_query}")

def imprimir_linhas(resultado_query: Result | ScalarResult) -> None:
   for linha in resultado_query:
      print(f"    {linha}")

print("[-] Número de servidores:")
imprimir_numero(session.scalar(Servidor.contar()))

print("[-] Nome dos servidores:")
imprimir_linhas(session.scalars(Servidor.listar_nomes()))

data_hora_inicio = datetime.now() - timedelta(days=365)
data_hora_fim = datetime.now()
print(f"[-] Número de contas criadas entre '{data_hora_inicio}' e '{data_hora_fim}':")
imprimir_numero(session.scalar(Conta.contar_criadas_em(data_hora_inicio, data_hora_fim)))

email = "stephano@cobol.br"
print(f"[-] Nível médio dos personagens da conta '{email}':")
imprimir_numero(session.scalar(Conta.calcular_nivel_medio_personagens_de(email)))

print(f"[-] Número de personagens da conta '{email}':")
imprimir_numero(session.scalar(Conta.contar_personagens_de(email)))

print("[-] Número de personagens vinculados a cada servidor:")
imprimir_linhas(session.execute(Servidor.contar_personagens_vinculados()))

print("[-] Número de personagens online em cada servidor:")
imprimir_linhas(session.execute(Servidor.contar_personagens_online()))

print("[-] Número de personagens vinculados a cada classe:")
imprimir_linhas(session.execute(Classe.contar_personagens_vinculados()))

quantidade_listar = 4
print(f"[-] Os {quantidade_listar} personagens com maior nível:")
imprimir_linhas(session.execute(Personagem_jogavel.listar_maior_nivel(quantidade_listar)))

print(f"[-] Os {quantidade_listar} personagens mais ricos:")
imprimir_linhas(session.execute(Personagem_jogavel.listar_mais_ricos(quantidade_listar)))

nome_monstro = "Andrey Cabral Meira"
print(f"[-] Valor total dos itens do monstro '{nome_monstro}':")
imprimir_numero(session.scalar(Personagem.somar_valor_itens_de(nome_monstro)))

print("[-] Valor total dos itens de cada personagem:")
imprimir_linhas(session.execute(Personagem_jogavel.somar_valor_itens()))

print("[-] Quantidade de personagens existentes:")
imprimir_numero(session.scalar(Personagem_jogavel.calcular_quantidade_personagens()))

print("[-] Porcentagem de personagens de cada sexo:")
imprimir_linhas(session.execute(Personagem_jogavel.listar_porcentagem_sexo()))

print("[-] Item(s) de maior valor:")
imprimir_linhas(session.execute(Item.listar_maior_valor()))

nome_item = "Lancheira do Homem-Aranha"
print(f"[-] Personagens que tem o item '{nome_item}':")
imprimir_linhas(session.execute(Personagem_jogavel.listar_com_item(nome_item)))

print("[-] Item(s) de maior defesa:")
imprimir_linhas(session.execute(Item.listar_maior_defesa()))

print("[-] Monstro(s) que tem o(s) item(s) de maior defesa:")
imprimir_linhas(session.execute(Monstro.listar_com_item_maior_defesa()))

print(f"[-] Os {quantidade_listar} monstros com maior velocidade:")
imprimir_linhas(session.execute(Monstro.listar_maior_velocidade(quantidade_listar)))

print(f"[-] Os {quantidade_listar} monstros com maior ataque por pontos de vida:")
imprimir_linhas(session.execute(Monstro.listar_maior_ataque_por_pontos_vida(quantidade_listar)))

print(f"[-] As {quantidade_listar} classes com maior número de habilidades:")
imprimir_linhas(session.execute(Classe.listar_maior_numero_habilidades(quantidade_listar)))

print("[-] A(s) classe(s) do(s) personagem(s) com maior nível:")
imprimir_linhas(session.execute(Personagem_jogavel.listar_classe_maior_nivel()))

print(f"[-] As classes das {quantidade_listar} habilidades com maior dano:")
imprimir_linhas(session.execute(Classe.listar_habilidade_maior_dano(quantidade_listar)))

print(f"[-] As {quantidade_listar} classes com maior defesa:")
imprimir_linhas(session.execute(Classe.listar_maior_defesa(quantidade_listar)))



# Prova autoria
print("[-] Quantidade total de itens de cada personagem:")
imprimir_linhas(session.execute(Personagem.somar_quantidade_itens()))

session.add(
   Personagem_tem_item(
      personagem_id=session.scalar(select(Personagem.id)
                                    .select_from(Personagem)
                                    .where(Personagem.nome == "Antônio David Viniski")),
      item_id=session.scalar(select(Item.id)
                              .select_from(Item)
                              .where(Item.nome == "Avaliação Corrigida")),
      quantidade_item=40
   )
)
session.commit()

print("[-] Quantidade total de itens de cada personagem após adição:")
imprimir_linhas(session.execute(Personagem.somar_quantidade_itens()))

session.close()
