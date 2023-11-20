USE rpg;

-- Inserir ao menos 6 registros em cada uma das tabelas do banco de dados
INSERT INTO rpg.servidor
(nome)
VALUES
('PUCPR'),
('UNIANDRADE'),
('UFPR'),
('UP'),
('UTFPR'),
('UTP');


SET @servidor_id_pucpr := (SELECT servidor.id
                           FROM rpg.servidor
                           WHERE servidor.nome = 'PUCPR');

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade)
VALUES
('Antônio David Viniski', 101, 11);
INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 1, 11);
INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID());

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade)
VALUES
('Andrey Cabral Meira', 102, 12);
INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 2, 12);
INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID());

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade)
VALUES
('Jose Eduardo Nunes Lino', 103, 13);
INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 3, 13);
INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID());

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade)
VALUES
('Haroldo Osmar de Paula Junior', 104, 14);
INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 4, 14);
INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID());

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade)
VALUES
('Jhonatan Geremias', 105, 15);
INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 5, 15);
INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID());

INSERT INTO rpg.personagem
(nome, pontos_vida, velocidade)
VALUES
('Alcides Calsavara', 106, 16);
INSERT INTO rpg.monstro
(id, ataque, defesa)
VALUES
(LAST_INSERT_ID(), 6, 16);
INSERT INTO rpg.servidor_tem_monstro
(servidor_id, monstro_id)
VALUES
(@servidor_id_pucpr, LAST_INSERT_ID());


INSERT INTO rpg.classe
(nome, ataque, defesa)
VALUES
('BCC 2U', 21, 31),
('BCC 2A', 22, 32),
('BCC 2B', 23, 33),
('BCS 2U', 24, 34),
('BCC 3B', 25, 35),
('TRANCADO', 6, 6);


SET @classe_id_bcc_2a := (SELECT classe.id
                          FROM rpg.classe
                          WHERE classe.nome = 'BCC 2A');
SET @classe_id_bcc_2b := (SELECT classe.id
                          FROM rpg.classe
                          WHERE classe.nome = 'BCC 2B');

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Colocar Casaco', 1);
INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id, modificador_dano)
VALUES
(@classe_id_bcc_2a, LAST_INSERT_ID(), 0.5);

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Tirar Casaco', 2);
INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id, modificador_dano)
VALUES
(@classe_id_bcc_2a, LAST_INSERT_ID(), 1.1);

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Desenhar na Aula', 3);
INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id)
VALUES
(@classe_id_bcc_2a, LAST_INSERT_ID());

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Chegar Atrasada(o)', 4);
INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id)
VALUES
(@classe_id_bcc_2b, LAST_INSERT_ID());

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Comer Coxinha', 5);
INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id)
VALUES
(@classe_id_bcc_2b, LAST_INSERT_ID());

INSERT INTO rpg.habilidade
(nome, dano)
VALUES
('Faltar Aula', 6);
INSERT INTO rpg.classe_tem_habilidade
(classe_id, habilidade_id, modificador_dano)
VALUES
(@classe_id_bcc_2b, LAST_INSERT_ID(), 0.2);


SET @classe_id_trancado := (SELECT classe.id
                            FROM rpg.classe
                            WHERE classe.nome = 'TRANCADO');

INSERT INTO rpg.conta
(email, hash_senha, criada_em)
VALUES
('bruno@cobol.br', '111111', '2021-01-01');
SET @conta_id := LAST_INSERT_ID();
INSERT INTO rpg.personagem
(nome, posicao_x, posicao_y, posicao_z)
VALUES
('Bruno', -111, -111, -1);
INSERT INTO rpg.personagem_jogavel
(id, nivel, dinheiro, sexo, classe_id, conta_id, servidor_id)
VALUES
(LAST_INSERT_ID(), 11, 11001, 'masculino', @classe_id_bcc_2b, @conta_id, @servidor_id_pucpr);

INSERT INTO rpg.conta
(email, hash_senha)
VALUES
('eduardo@cobol.br', '222222');
SET @conta_id := LAST_INSERT_ID();
INSERT INTO rpg.personagem
(nome, posicao_x, posicao_y, posicao_z)
VALUES
('Eduardo', -222, -222, -2);
INSERT INTO rpg.personagem_jogavel
(id, nivel, dinheiro, sexo, classe_id, conta_id, servidor_id)
VALUES
(LAST_INSERT_ID(), 22, 22002, 'feminino', @classe_id_bcc_2a, @conta_id, @servidor_id_pucpr);

INSERT INTO rpg.conta
(email, hash_senha)
VALUES
('henrique@cobol.br', '333333');
SET @conta_id := LAST_INSERT_ID();
INSERT INTO rpg.personagem
(nome, posicao_x, posicao_y, posicao_z)
VALUES
('Henrique', -333, -333, -3);
INSERT INTO rpg.personagem_jogavel
(id, nivel, dinheiro, sexo, classe_id, conta_id, servidor_id)
VALUES
(LAST_INSERT_ID(), 33, 33003, 'masculino', @classe_id_bcc_2b, @conta_id, @servidor_id_pucpr);

INSERT INTO rpg.conta
(email, hash_senha)
VALUES
('stephano@cobol.br', '444444');
SET @conta_id := LAST_INSERT_ID();
INSERT INTO rpg.personagem
(nome, posicao_x, posicao_y, posicao_z)
VALUES
('Stéphano', -444, -444, -4);
INSERT INTO rpg.personagem_jogavel
(id, nivel, dinheiro, sexo, classe_id, conta_id, servidor_id)
VALUES
(LAST_INSERT_ID(), 44, 44004, 'masculino', @classe_id_bcc_2b, @conta_id, @servidor_id_pucpr);

INSERT INTO rpg.conta
(email, hash_senha)
VALUES
('thiago@cobol.br', '555555');
SET @conta_id := LAST_INSERT_ID();
INSERT INTO rpg.personagem
(nome, posicao_x, posicao_y, posicao_z)
VALUES
('Thiago', -555, -555, -5);
INSERT INTO rpg.personagem_jogavel
(id, nivel, dinheiro, sexo, classe_id, conta_id, servidor_id)
VALUES
(LAST_INSERT_ID(), 55, 55005, 'masculino', @classe_id_bcc_2a, @conta_id, @servidor_id_pucpr);

INSERT INTO rpg.conta
(email, hash_senha, criada_em)
VALUES
('intrusa@cobol.br', '666666', '2016-06-06');
SET @conta_id := LAST_INSERT_ID();
INSERT INTO rpg.personagem
(nome, posicao_x, posicao_y, posicao_z)
VALUES
('Intrusa', -666, -666, -6);
INSERT INTO rpg.personagem_jogavel
(id, nivel, dinheiro, sexo, classe_id, conta_id, servidor_id)
VALUES
(LAST_INSERT_ID(), 66, 66006, 'feminino', @classe_id_trancado, @conta_id, @servidor_id_pucpr);


SET @personagem_id_eduardo := (SELECT personagem.id
                               FROM rpg.personagem
                               WHERE personagem.nome = 'Eduardo');
SET @personagem_id_henrique := (SELECT personagem.id
                                FROM rpg.personagem
                                WHERE personagem.nome = 'Henrique');
SET @personagem_id_bruno := (SELECT personagem.id
                             FROM rpg.personagem
                             WHERE personagem.nome = 'Bruno');

INSERT INTO rpg.item
(nome, valor, ataque, defesa)
VALUES
('Casacão Branco do Papa', 1111, 0, 11);
INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id, quantidade_item)
VALUES
(@personagem_id_eduardo, LAST_INSERT_ID(), 8);

INSERT INTO rpg.item
(nome, valor, ataque, defesa)
VALUES
('Botina da Louis Vuitton', 2222, 0, 22);
INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id, quantidade_item)
VALUES
((SELECT id FROM rpg.personagem WHERE nome = 'Jose Eduardo Nunes Lino'), LAST_INSERT_ID(), 2);

INSERT INTO rpg.item
(nome, valor, ataque, defesa)
VALUES
('Óclinhos do Clark Kent', 3333, 0, 33);
SET @item_id_oclinhos_clark_kent := LAST_INSERT_ID();
INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id)
VALUES
(@personagem_id_henrique, @item_id_oclinhos_clark_kent);
INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id)
VALUES
(@personagem_id_bruno, @item_id_oclinhos_clark_kent);

INSERT INTO rpg.item
(nome, valor, ataque, defesa)
VALUES
('Avaliação Corrigida', 4444, 44, 0);

INSERT INTO rpg.item
(nome, valor, ataque, defesa)
VALUES
('Controle do Projetor', 5555, 55, 0);
INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id)
VALUES
((SELECT id FROM rpg.personagem WHERE nome = 'Antônio David Viniski'), LAST_INSERT_ID());

INSERT INTO rpg.item
(nome, valor, ataque, defesa)
VALUES
('Lancheira do Homem-Aranha', 6666, 66, 0);
INSERT INTO rpg.personagem_tem_item
(personagem_id, item_id)
VALUES
(@personagem_id_bruno, LAST_INSERT_ID());



-- Criar 5 instruções de atualização de registros em diferentes tabelas
UPDATE rpg.personagem_jogavel
SET personagem_jogavel.classe_id = @classe_id_bcc_2b
WHERE personagem_jogavel.id IN (SELECT personagem.id
                                FROM rpg.personagem
                                WHERE personagem.nome IN ('Eduardo', 'Thiago'));

UPDATE rpg.item
SET item.nome = 'Casacão Esquenta Defunto'
WHERE item.nome = 'Casacão Branco do Papa';

UPDATE rpg.habilidade
SET habilidade.nome = CONCAT(habilidade.nome, ' de Frango')
WHERE habilidade.nome = 'Comer Coxinha';

UPDATE rpg.servidor
SET servidor.`online` = TRUE
WHERE servidor.nome = 'PUCPR';

UPDATE rpg.personagem_jogavel
SET personagem_jogavel.`online` = TRUE
WHERE personagem_jogavel.`online` = FALSE;



-- Criar 5 instruções de exclusão de registros em diferentes tabelas
SET @personagem_id_haroldo := (SELECT personagem.id
                               FROM rpg.personagem
                               WHERE personagem.nome = 'Haroldo Osmar de Paula Junior');

DELETE FROM rpg.servidor_tem_monstro
WHERE servidor_tem_monstro.monstro_id = @personagem_id_haroldo;

DELETE FROM rpg.monstro
WHERE monstro.id = @personagem_id_haroldo;

DELETE FROM rpg.personagem
WHERE personagem.id = @personagem_id_haroldo;

DELETE FROM rpg.servidor
WHERE servidor.nome = 'UNIANDRADE';

DELETE FROM rpg.classe
WHERE classe.nome = 'BCC 3B';
