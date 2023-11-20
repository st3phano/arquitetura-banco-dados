USE rpg;

-- Criar 6 usuários no banco de dados
CREATE USER IF NOT EXISTS 'Antônio'@'localhost'
IDENTIFIED BY '1111';

CREATE USER IF NOT EXISTS 'Bruno'@'localhost'
IDENTIFIED BY '2222';

CREATE USER IF NOT EXISTS 'Eduardo'@'%'
IDENTIFIED BY '3333';

CREATE USER IF NOT EXISTS 'Henrique'@'%'
IDENTIFIED BY '4444';

CREATE USER IF NOT EXISTS 'Stéphano'
IDENTIFIED BY '5555';

CREATE USER IF NOT EXISTS 'Thiago';



-- Criar 4 papéis
CREATE ROLE IF NOT EXISTS 'administrador', 'gerente de jogo', 'desenvolvedor', 'jogador';



-- Conceder privilégios diferentes a cada um dos papéis e justificar os respectivos privilégio
-- Ao menos 1 papel com acesso global
-- Ao menos 1 papel com acesso a um banco de dados específico
-- Ao menos 1 papel para acesso a uma tabela específica

-- 'administrador' é responsável por administrar o servidor de banco de dados
GRANT ALL
ON *.*
TO 'administrador'
WITH GRANT OPTION;

-- 'gerente de jogo' é responsável por administrar o banco de dados do jogo
GRANT ALL
ON rpg.*
TO 'gerente de jogo'
WITH GRANT OPTION;

-- 'desenvolvedor' é responsável pela manutenção do conteúdo do jogo,
-- porém não tem acesso as contas nem aos personagens dos jogadores
SET @privilegios_desenvolvedor = 'Select,Insert,Update,Delete';
INSERT INTO mysql.tables_priv
(`Host`, `Db`, `User`, `Grantor`, `Table_priv`, `Table_name`)
VALUES
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'classe'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'classe_tem_habilidade'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'habilidade'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'item'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'monstro'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'personagem'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'personagem_tem_item'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'servidor'),
('%', 'rpg', 'desenvolvedor', CURRENT_USER, @privilegios_desenvolvedor, 'servidor_tem_monstro');
FLUSH PRIVILEGES;

-- 'jogador' pode consultar apenas o nome, o nível e o sexo de outros jogadores
GRANT SELECT (`nome`)
ON rpg.personagem
TO 'jogador';
GRANT SELECT (`nivel`, `sexo`)
ON rpg.personagem_jogavel
TO 'jogador';



-- Conceder um papel a cada um dos 6 usuários criados anteriormente
GRANT 'administrador'
TO 'Antônio'@'localhost';
SET DEFAULT ROLE 'administrador'
TO 'Antônio'@'localhost';

GRANT 'gerente de jogo'
TO 'Bruno'@'localhost';
SET DEFAULT ROLE ALL
TO 'Bruno'@'localhost';

GRANT 'desenvolvedor'
TO 'Eduardo'@'%';
SET DEFAULT ROLE ALL
TO 'Eduardo'@'%';

GRANT 'desenvolvedor', 'jogador'
TO 'Henrique'@'%';
SET DEFAULT ROLE ALL
TO 'Henrique'@'%';

GRANT 'jogador'
TO 'Stéphano', 'Thiago';
SET DEFAULT ROLE ALL
TO 'Stéphano', 'Thiago';
