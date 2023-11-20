USE rpg;

-- Criar 10 transações explícitas no banco de dados para realização de operações específicas

-- 4 transações com COMMIT

-- 1
START TRANSACTION;

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade, posicao_x, posicao_y, posicao_z)
VALUES
('Bicho Papão', 707, 77, 777, 777, 7);

INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 7, 77);

SET @servidor_id_pucpr := (SELECT servidor.id
                           FROM rpg.servidor
                           WHERE servidor.nome = 'PUCPR');

INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID());

COMMIT;


-- 2
START TRANSACTION;

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Entregar Projeto', 77);

SET @classe_id_bcc_2b := (SELECT classe.id
                          FROM rpg.classe
                          WHERE classe.nome = 'BCC 2B');

INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id, modificador_dano)
VALUES
(@classe_id_bcc_2b, LAST_INSERT_ID(), 2);

COMMIT;


-- 3
START TRANSACTION;

INSERT INTO rpg.conta
(email, hash_senha)
VALUES
('007@cobol.br', '7777777');

SET @conta_id := LAST_INSERT_ID();

INSERT INTO rpg.personagem
(nome, posicao_x, posicao_y, posicao_z)
VALUES
('007', -777, -777, -7);

SET @classe_id_bcc_2a := (SELECT classe.id
                          FROM rpg.classe
                          WHERE classe.nome = 'BCC 2A');

SET @servidor_id_pucpr := (SELECT servidor.id
                           FROM rpg.servidor
                           WHERE servidor.nome = 'PUCPR');

INSERT INTO rpg.personagem_jogavel
(id, nivel, dinheiro, sexo, classe_id, conta_id, servidor_id)
VALUES
(LAST_INSERT_ID(), 77, 7, 'masculino', @classe_id_bcc_2a, @conta_id, @servidor_id_pucpr);

COMMIT;


-- 4
START TRANSACTION;

INSERT INTO rpg.item
(nome, valor, ataque, defesa)
VALUES
('Arminha de Água', 777, 77, 7);

SET @personagem_id_007 := (SELECT personagem.id
                           FROM rpg.personagem
                           WHERE personagem.nome = '007');

INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id)
VALUES
(@personagem_id_007, LAST_INSERT_ID());

COMMIT;



-- 4 transações com ROLLBACK

-- 1
START TRANSACTION;

SET @personagem_id_eduardo := (SELECT personagem.id
                               FROM rpg.personagem
                               WHERE personagem.nome = 'Eduardo');

DELETE FROM rpg.personagem_tem_item
WHERE personagem_tem_item.personagem_id = @personagem_id_eduardo;

DELETE FROM rpg.personagem_jogavel
WHERE personagem_jogavel.id = @personagem_id_eduardo;

DELETE FROM rpg.personagem
WHERE personagem.id = @personagem_id_eduardo;

ROLLBACK;


-- 2
START TRANSACTION;

SET @classe_id_trancado := (SELECT classe.id
                            FROM rpg.classe
                            WHERE classe.nome = 'TRANCADO');

SET @personagem_id_eduardo := (SELECT personagem.id
                               FROM rpg.personagem
                               WHERE personagem.nome = 'Eduardo');
SET @personagem_id_henrique := (SELECT personagem.id
                                FROM rpg.personagem
                                WHERE personagem.nome = 'Henrique');

UPDATE rpg.personagem_jogavel
SET personagem_jogavel.classe_id = @classe_id_trancado
WHERE personagem_jogavel.id = @personagem_id_eduardo;

UPDATE rpg.personagem_jogavel
SET personagem_jogavel.classe_id = @classe_id_trancado
WHERE personagem_jogavel.id = @personagem_id_henrique;

ROLLBACK;


-- 3
START TRANSACTION;

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade)
VALUES
('Coordenador do Curso', 88888, 88888);

INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 8888, 8888);

SET @servidor_id_pucpr := (SELECT servidor.id
                           FROM rpg.servidor
                           WHERE servidor.nome = 'PUCPR');

INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id, quantidade_monstro)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID(), 8);

ROLLBACK;


-- 4
START TRANSACTION;

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Reprovar', 0);

SET @classe_id_bcc_2b := (SELECT classe.id
                          FROM rpg.classe
                          WHERE classe.nome = 'BCC 2B');

INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id)
VALUES
(@classe_id_bcc_2b, LAST_INSERT_ID());

ROLLBACK;



-- 2 transações com ROLLBACK TO SAVEPOINT

-- 1
START TRANSACTION;

INSERT INTO rpg.conta
(email, hash_senha)
VALUES
('aluno_novo@cobol.br', '88888888');
SAVEPOINT conta_criada;

SET @conta_id := LAST_INSERT_ID();

SET @classe_id_bcc_2b := (SELECT classe.id
                          FROM rpg.classe
                          WHERE classe.nome = 'BCC 2B');

SET @servidor_id_pucpr := (SELECT servidor.id
                           FROM rpg.servidor
                           WHERE servidor.nome = 'PUCPR');

CALL rpg.criar_personagem_jogavel('Aluno Novo', 'masculino', @classe_id_bcc_2b, @conta_id, @servidor_id_pucpr);
ROLLBACK TO SAVEPOINT conta_criada;

COMMIT;


-- 2
START TRANSACTION;

UPDATE rpg.classe
SET classe.nome = 'BCC 3B'
WHERE classe.nome = 'BCC 2B';
SAVEPOINT proximo_semestre;

SET @classe_id_trancado := (SELECT classe.id
                            FROM rpg.classe
                            WHERE classe.nome = 'TRANCADO');

SET @personagem_id_thiago := (SELECT personagem.id
                              FROM rpg.personagem
                              WHERE personagem.nome = 'Thiago');

UPDATE rpg.personagem_jogavel
SET personagem_jogavel.classe_id = @classe_id_trancado
WHERE personagem_jogavel.id = @personagem_id_thiago;
ROLLBACK TO SAVEPOINT proximo_semestre;

COMMIT;
