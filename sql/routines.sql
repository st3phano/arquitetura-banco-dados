USE rpg;

-- Descrever e implementar 3 procedimentos, um dos procedimentos deve fazer o uso de cursores
-- Os procedimentos precisam ter mais do que uma instrução e devem receber parâmetros

-- Cria um personagem jogável, combinação das tabelas 'personagem' e 'personagem_jogavel'
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS criar_personagem_jogavel
(IN nome VARCHAR(45), IN sexo ENUM('feminino', 'masculino'),
 IN classe_id TINYINT UNSIGNED, IN conta_id INT UNSIGNED, IN servidor_id TINYINT UNSIGNED)
BEGIN
   DECLARE personagem_id INT UNSIGNED DEFAULT NULL;

   IF (CHAR_LENGTH(nome) > 0
      AND nome NOT IN (SELECT personagem.nome FROM rpg.personagem)
      AND sexo IN (SELECT personagem_jogavel.sexo FROM rpg.personagem_jogavel)
      AND classe_id IN (SELECT classe.id FROM rpg.classe)
      AND conta_id IN (SELECT conta.id FROM rpg.conta)
      AND servidor_id IN (SELECT servidor.id FROM rpg.servidor))
      THEN
         INSERT INTO rpg.personagem
         (nome)
         VALUES
         (nome);
         SET personagem_id := LAST_INSERT_ID();

         INSERT INTO rpg.personagem_jogavel
         (id, sexo, classe_id, conta_id, servidor_id)
         VALUES
         (personagem_id, sexo, classe_id, conta_id, servidor_id);
   END IF;
   SELECT personagem_id;
END $$
DELIMITER ;


-- Exclui uma habilidade, tabelas 'classe_tem_habilidade' e 'habilidade'
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS excluir_habilidade
(IN id SMALLINT UNSIGNED)
BEGIN
   DELETE FROM rpg.classe_tem_habilidade
   WHERE classe_tem_habilidade.habilidade_id = id;

   DELETE FROM rpg.habilidade
   WHERE habilidade.id = id;
END $$
DELIMITER ;


-- Exclui uma conta e todos os personagens vinculados a ela,
-- tabelas 'personagem_jogavel', 'personagem_tem_item', 'personagem' e 'conta'
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS excluir_conta
(IN id INT UNSIGNED)
BEGIN
   DECLARE personagem_id INT UNSIGNED;
   DECLARE tem_linhas BOOL DEFAULT TRUE;
   DECLARE linha CURSOR FOR SELECT personagem_jogavel.id
                            FROM rpg.personagem_jogavel
                            WHERE personagem_jogavel.conta_id = id;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET tem_linhas = FALSE;

   OPEN linha;
   FETCH linha INTO personagem_id;
   WHILE tem_linhas DO
      DELETE FROM rpg.personagem_jogavel
      WHERE personagem_jogavel.id = personagem_id;

      DELETE FROM rpg.personagem_tem_item
      WHERE personagem_tem_item.personagem_id = personagem_id;

      DELETE FROM rpg.personagem
      WHERE personagem.id = personagem_id;

      FETCH linha INTO personagem_id;
   END WHILE;
   CLOSE linha;

   DELETE FROM rpg.conta
   WHERE conta.id = id;
END $$
DELIMITER ;



-- Descrever e implementar 3 funções
-- As funções precisam ter no mínimo um parâmetro

-- Soma o valor de todos os itens vinculados a um personagem
DELIMITER $$
CREATE FUNCTION IF NOT EXISTS somar_valor_itens_personagem
(personagem_id INT UNSIGNED)
RETURNS INT UNSIGNED DETERMINISTIC
BEGIN
   RETURN (SELECT COALESCE(SUM(item.valor * personagem_tem_item.quantidade_item), 0)
           FROM rpg.personagem_tem_item
           INNER JOIN rpg.item ON personagem_tem_item.item_id = item.id
           WHERE personagem_tem_item.personagem_id = personagem_id);
END $$
DELIMITER ;


-- Conta a quantidade de personagens jogáveis que estão online em um servidor
DELIMITER $$
CREATE FUNCTION IF NOT EXISTS contar_populacao_online_servidor
(servidor_id TINYINT UNSIGNED)
RETURNS SMALLINT UNSIGNED DETERMINISTIC
BEGIN
   RETURN (SELECT COALESCE(SUM(personagem_jogavel.online = TRUE), 0)
           FROM rpg.personagem_jogavel
           WHERE personagem_jogavel.servidor_id = servidor_id);
END $$
DELIMITER ;


-- Conta a quantidade de contas criadas em um intervalo de tempo
DELIMITER $$
CREATE FUNCTION IF NOT EXISTS contar_contas_criadas_entre
(inicio TIMESTAMP, fim TIMESTAMP)
RETURNS INT UNSIGNED DETERMINISTIC
BEGIN
   RETURN (SELECT COUNT(conta.id)
           FROM rpg.conta
           WHERE conta.criada_em BETWEEN inicio AND fim);
END $$
DELIMITER ;



-- Descrever e implementar 3+ gatilhos, ao menos 1 de INSERT, 1 de UPDATE e 1 de DELETE
-- Os gatilhos devem ser criados em ao menos duas tabelas diferentes

-- Vincula um 'Casacão Esquenta Defunto' a todo personagem jogável inserido
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS personagem_jogavel_inserido
AFTER INSERT ON rpg.personagem_jogavel
FOR EACH ROW
BEGIN
   DECLARE item_id_casacao INT UNSIGNED DEFAULT (SELECT item.id
                                                 FROM rpg.item
                                                 WHERE item.nome = 'Casacão Esquenta Defunto');

   INSERT INTO rpg.personagem_tem_item
   (personagem_id, item_id, quantidade_item)
   VALUES
   (NEW.id, item_id_casacao, 1);
END $$
DELIMITER ;


-- Atualiza os pontos de vida e velocidade de um personagem jogável quando seu nível mudar
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS personagem_jogavel_nivel_atualizado
AFTER UPDATE ON rpg.personagem_jogavel
FOR EACH ROW
BEGIN
   DECLARE diferenca_nivel BIGINT DEFAULT (CAST(NEW.nivel AS SIGNED) - CAST(OLD.nivel AS SIGNED));
   DECLARE pontos_vida_por_nivel BIGINT DEFAULT 10;
   DECLARE velocidade_por_nivel BIGINT DEFAULT 2;

   IF (diferenca_nivel <> 0) THEN
      UPDATE rpg.personagem SET
      pontos_vida = pontos_vida + (diferenca_nivel * pontos_vida_por_nivel),
      velocidade = velocidade + (diferenca_nivel * velocidade_por_nivel)
      WHERE personagem.id = NEW.id;
   END IF;
END $$
DELIMITER ;


-- Antes de excluir um monstro também exclui os vínculos desse monstro com servidores
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS monstro_sera_excluido
BEFORE DELETE ON rpg.monstro
FOR EACH ROW
BEGIN
   DELETE FROM rpg.servidor_tem_monstro
   WHERE servidor_tem_monstro.monstro_id = OLD.id;
END $$
DELIMITER ;


-- Após excluir um monstro também exclui os itens e o personagem vinculados a ele
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS monstro_excluido
AFTER DELETE ON rpg.monstro
FOR EACH ROW
BEGIN
   DELETE FROM rpg.personagem_tem_item
   WHERE personagem_tem_item.personagem_id = OLD.id;

   DELETE FROM rpg.personagem
   WHERE personagem.id = OLD.id;
END $$
DELIMITER ;



-- CALL criar_personagem_jogavel('Stored Procedure', 'feminino', 6, 6, 6);

-- CALL excluir_habilidade(6);

-- CALL excluir_conta(6);

-- SELECT contar_contas_criadas_entre(DATE_SUB(NOW(), INTERVAL 1 YEAR), NOW());

-- SELECT somar_valor_itens_personagem(7);

-- SELECT contar_populacao_online_servidor(1);

-- CALL criar_personagem_jogavel('Stored Procedure', 'feminino', 6, 3, 6);

-- UPDATE rpg.personagem_jogavel
-- SET personagem_jogavel.nivel = personagem_jogavel.nivel - 1
-- WHERE personagem_jogavel.id > 12;

-- DELETE FROM rpg.monstro
-- WHERE monstro.id = 6;
