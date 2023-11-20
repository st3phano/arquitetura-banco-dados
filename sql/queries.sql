USE rpg;

-- Especificar e implementar as 20 consultas que deseja efetuar no banco de dados

-- Quantos servidores existem?
SELECT COUNT(servidor.id)
FROM rpg.servidor;

-- Quais os nomes dos servidores?
SELECT servidor.nome
FROM rpg.servidor;

-- Quantas contas foram criadas em um determinado período?
SELECT COUNT(conta.id)
FROM rpg.conta
WHERE conta.criada_em BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW();

-- Qual é o nível médio dos personagens jogáveis de uma determinada conta?
SELECT AVG(personagem_jogavel.nivel)
FROM rpg.personagem_jogavel
WHERE personagem_jogavel.conta_id = 1;

-- Quantos personagens jogáveis uma determinada conta possui?
SELECT COUNT(personagem_jogavel.id)
FROM rpg.personagem_jogavel
WHERE personagem_jogavel.conta_id = 1;

-- Quantos personagens jogáveis estão vinculados a um determinado servidor?
SELECT COUNT(personagem_jogavel.id)
FROM rpg.personagem_jogavel
WHERE personagem_jogavel.servidor_id = 1;

-- Quantos personagens jogáveis estão online em um determinado servidor?
SELECT COUNT(personagem_jogavel.id)
FROM rpg.personagem_jogavel
WHERE personagem_jogavel.servidor_id = 1 AND personagem_jogavel.`online` = TRUE;

-- Quantos personagens jogáveis são de uma determinada classe?
-- ALTERAÇÃO:
-- Quantos personagens jogáveis estão vinculados a cada classe?
SELECT classe.nome, COUNT(personagem_jogavel.id)
FROM rpg.classe
INNER JOIN rpg.personagem_jogavel ON classe.id = personagem_jogavel.classe_id
GROUP BY classe.id;

-- Quais são os 3 personagens jogáveis com maior nível?
SELECT personagem.nome, personagem_jogavel.nivel
FROM rpg.personagem_jogavel
INNER JOIN rpg.personagem ON personagem_jogavel.id = personagem.id
ORDER BY personagem_jogavel.nivel DESC
LIMIT 3;

-- Quais são os 3 personagens jogáveis mais ricos?
SELECT personagem.nome,
       (personagem_jogavel.dinheiro + COALESCE(valor_itens_personagem.valor_itens, 0)) AS dinheiro_total
FROM rpg.personagem_jogavel
INNER JOIN rpg.personagem ON personagem_jogavel.id = personagem.id
LEFT JOIN (SELECT personagem_tem_item.personagem_id,
                  SUM(item.valor * personagem_tem_item.quantidade_item) AS valor_itens
           FROM rpg.personagem_tem_item
           INNER JOIN rpg.item ON personagem_tem_item.item_id = item.id
           GROUP BY personagem_tem_item.personagem_id)
          AS valor_itens_personagem ON personagem_jogavel.id = valor_itens_personagem.personagem_id
ORDER BY dinheiro_total DESC
LIMIT 3;

-- Qual a razão entre personagens jogáveis do sexo feminino em relação ao masculino?
-- ALTERAÇÃO:
-- Qual a quantidade de personagens jogáveis de cada sexo?
SELECT personagem_jogavel.sexo, COUNT(personagem_jogavel.sexo)
FROM rpg.personagem_jogavel
GROUP BY personagem_jogavel.sexo;

-- Quais personagens jogáveis possuem o item de maior valor?
SELECT personagem.nome, personagem_tem_item.quantidade_item
FROM rpg.personagem_jogavel
INNER JOIN rpg.personagem ON personagem_jogavel.id = personagem.id
INNER JOIN rpg.personagem_tem_item ON personagem.id = personagem_tem_item.personagem_id
INNER JOIN rpg.item ON personagem_tem_item.item_id = item.id
WHERE item.valor = (SELECT MAX(item.valor)
                    FROM rpg.item)
ORDER BY personagem_tem_item.quantidade_item DESC;

-- Quais monstros carregam o item de maior defesa?
SELECT personagem.nome, personagem_tem_item.quantidade_item
FROM rpg.monstro
INNER JOIN rpg.personagem ON monstro.id = personagem.id
INNER JOIN rpg.personagem_tem_item ON personagem.id = personagem_tem_item.personagem_id
INNER JOIN rpg.item ON personagem_tem_item.item_id = item.id
WHERE item.defesa = (SELECT MAX(item.defesa)
                     FROM rpg.item)
ORDER BY personagem_tem_item.quantidade_item DESC;

-- Quais os itens mais abundantes entre os personagens jogáveis?
SELECT item.nome,
       SUM(personagem_tem_item.quantidade_item) AS quantidade
FROM rpg.item
INNER JOIN rpg.personagem_tem_item ON item.id = personagem_tem_item.item_id
INNER JOIN rpg.personagem_jogavel ON personagem_tem_item.personagem_id = personagem_jogavel.id
GROUP BY item.nome
ORDER BY quantidade DESC;

-- Quais os monstros mais velozes?
SELECT personagem.nome, personagem.velocidade
FROM rpg.monstro
INNER JOIN rpg.personagem ON monstro.id = personagem.id
ORDER BY velocidade DESC;

-- Quais monstros possuem a maior razão entre ataque e pontos de vida?
SELECT personagem.nome, monstro.ataque, personagem.pontos_vida,
       (monstro.ataque / personagem.pontos_vida) as razao
FROM rpg.monstro
INNER JOIN rpg.personagem ON monstro.id = personagem.id
ORDER BY razao DESC;

-- Quais classes possuem a maior quantidade de habilidades?
SELECT classe.nome, COUNT(classe_tem_habilidade.habilidade_id) AS habilidades
FROM rpg.classe
LEFT JOIN rpg.classe_tem_habilidade ON classe.id = classe_tem_habilidade.classe_id
GROUP BY classe.id
ORDER BY habilidades DESC;

-- Quais as classes dos personagens jogáveis de nível mais alto?
SELECT classe.nome, personagem_jogavel.nivel
FROM rpg.classe
INNER JOIN rpg.personagem_jogavel ON classe.id = personagem_jogavel.classe_id
ORDER BY personagem_jogavel.nivel DESC;

-- Quais classes possuem a habilidade que causa o maior dano?
SELECT classe.nome,
       (habilidade.dano * COALESCE(classe_tem_habilidade.modificador_dano, 1)) AS dano_habilidade
FROM rpg.classe
INNER JOIN rpg.classe_tem_habilidade ON classe.id = classe_tem_habilidade.classe_id
INNER JOIN rpg.habilidade ON classe_tem_habilidade.habilidade_id = habilidade.id
WHERE habilidade.dano = (SELECT MAX(habilidade.dano)
                         FROM rpg.habilidade)
ORDER BY dano_habilidade DESC;

-- Quais classes possuem maior defesa?
SELECT classe.nome, classe.defesa
FROM rpg.classe
ORDER BY classe.defesa DESC;



-- Criar 3 views

CREATE OR REPLACE VIEW estatisticas_personagens_por_servidor
(servidor, personagens, personagens_online, personagens_sexo_feminino, personagens_sexo_masculino,
 soma_dinheiro_personagens, nivel_maximo_personagens, nivel_medio_personagens)
AS
SELECT servidor.nome,
       COUNT(personagem_jogavel.servidor_id),
       SUM(personagem_jogavel.online = TRUE),
       SUM(personagem_jogavel.sexo = 'feminino'),
       SUM(personagem_jogavel.sexo = 'masculino'),
       SUM(personagem_jogavel.dinheiro),
       MAX(personagem_jogavel.nivel),
       AVG(personagem_jogavel.nivel)
FROM rpg.servidor
LEFT JOIN rpg.personagem_jogavel ON servidor.id = personagem_jogavel.servidor_id
GROUP BY servidor.id;

SELECT * FROM estatisticas_personagens_por_servidor;


CREATE OR REPLACE VIEW estatisticas_habilidades_por_classe
(classe, habilidades, dano_maximo_habilidades, dano_medio_habilidades)
AS
SELECT classe.nome,
       COUNT(classe_tem_habilidade.habilidade_id),
       ROUND(MAX(habilidade.dano * COALESCE(classe_tem_habilidade.modificador_dano, 1)), 2),
       ROUND(AVG(habilidade.dano * COALESCE(classe_tem_habilidade.modificador_dano, 1)), 2)
FROM rpg.classe
LEFT JOIN rpg.classe_tem_habilidade ON classe.id = classe_tem_habilidade.classe_id
LEFT JOIN rpg.habilidade ON classe_tem_habilidade.habilidade_id = habilidade.id
GROUP BY classe.id;

SELECT * FROM estatisticas_habilidades_por_classe;


CREATE OR REPLACE VIEW estatisticas_personagens_por_conta
(conta, personagens, nivel_maximo_personagens, nivel_medio_personagens,
 soma_dinheiro_personagens, soma_valor_itens_personagens)
AS
SELECT conta.email,
       COUNT(personagem_jogavel.id),
       MAX(personagem_jogavel.nivel),
       ROUND(AVG(personagem_jogavel.nivel), 1),
       SUM(personagem_jogavel.dinheiro),
       SUM(valor_itens_personagem.valor_itens)
FROM rpg.conta
INNER JOIN rpg.personagem_jogavel ON conta.id = personagem_jogavel.conta_id
LEFT JOIN (SELECT personagem_tem_item.personagem_id,
                  SUM(item.valor * personagem_tem_item.quantidade_item) AS valor_itens
           FROM rpg.personagem_tem_item
           INNER JOIN rpg.item ON personagem_tem_item.item_id = item.id
           GROUP BY personagem_tem_item.personagem_id)
          AS valor_itens_personagem ON personagem_jogavel.id = valor_itens_personagem.personagem_id
GROUP BY conta.id;

SELECT * FROM estatisticas_personagens_por_conta;



-- Prova autoria

-- Quantidade total de itens por personagem
SELECT personagem.nome,
       COALESCE(SUM(personagem_tem_item.quantidade_item), 0) AS quantidade_total_itens
FROM rpg.personagem
LEFT JOIN rpg.personagem_tem_item ON personagem.id = personagem_tem_item.personagem_id
GROUP BY personagem.id
ORDER BY quantidade_total_itens DESC;

SET @personagem_id_antonio := (SELECT personagem.id
                               FROM rpg.personagem
                               WHERE personagem.nome = 'Antônio David Viniski');

SET @item_id_avaliacao_corrigida := (SELECT item.id
                                     FROM rpg.item
                                     WHERE item.nome = 'Avaliação Corrigida');

INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id, quantidade_item)
VALUES
(@personagem_id_thiago, @item_id, 60);
