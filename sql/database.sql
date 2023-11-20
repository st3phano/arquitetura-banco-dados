CREATE DATABASE IF NOT EXISTS rpg;
USE rpg;

CREATE TABLE IF NOT EXISTS rpg.servidor (
   id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
   nome VARCHAR(45) NOT NULL,
   populacao_maxima SMALLINT UNSIGNED NOT NULL DEFAULT 1000,
   `online` BOOLEAN NOT NULL DEFAULT FALSE, -- palavra reservada
   PRIMARY KEY (id),
   UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS rpg.conta (
   id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   email VARCHAR(45) NOT NULL,
   hash_senha VARCHAR(45) NOT NULL,
   criada_em TIMESTAMP NOT NULL DEFAULT NOW(),
   PRIMARY KEY (id),
   UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS rpg.personagem (
   id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   nome VARCHAR(45) NOT NULL,
   pontos_vida INTEGER UNSIGNED NOT NULL DEFAULT 100,
   velocidade INTEGER UNSIGNED NOT NULL DEFAULT 10,
   posicao_x SMALLINT NOT NULL DEFAULT 0,
   posicao_y SMALLINT NOT NULL DEFAULT 0,
   posicao_z TINYINT NOT NULL DEFAULT 0,
   PRIMARY KEY (id),
   UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS rpg.classe (
   id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
   nome VARCHAR(45) NOT NULL,
   ataque SMALLINT UNSIGNED NOT NULL,
   defesa SMALLINT UNSIGNED NOT NULL,
   PRIMARY KEY (id),
   UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS rpg.habilidade (
   id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
   nome VARCHAR(45) NOT NULL,
   dano SMALLINT UNSIGNED NOT NULL,
   PRIMARY KEY (id),
   UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS rpg.item (
   id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   nome VARCHAR(45) NOT NULL,
   valor INTEGER UNSIGNED NOT NULL,
   ataque TINYINT NOT NULL,
   defesa TINYINT NOT NULL,
   PRIMARY KEY (id),
   UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS rpg.personagem_jogavel (
   id INTEGER UNSIGNED NOT NULL,
   nivel INTEGER UNSIGNED NOT NULL DEFAULT 1,
   dinheiro INTEGER UNSIGNED NOT NULL DEFAULT 0,
   sexo ENUM('feminino','masculino') NOT NULL,
   `online` BOOLEAN NOT NULL DEFAULT FALSE, -- palavra reservada
   classe_id TINYINT UNSIGNED NOT NULL,
   conta_id INTEGER UNSIGNED NOT NULL,
   servidor_id TINYINT UNSIGNED NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (id) REFERENCES personagem (id),
   FOREIGN KEY (classe_id) REFERENCES classe (id),
   FOREIGN KEY (conta_id) REFERENCES conta (id),
   FOREIGN KEY (servidor_id) REFERENCES servidor (id)
);

CREATE TABLE IF NOT EXISTS rpg.monstro (
   id INTEGER UNSIGNED NOT NULL,
   ataque SMALLINT UNSIGNED NOT NULL,
   defesa SMALLINT UNSIGNED NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (id) REFERENCES personagem (id)
);

CREATE TABLE IF NOT EXISTS rpg.servidor_tem_monstro (
   servidor_id TINYINT UNSIGNED NOT NULL,
   monstro_id INTEGER UNSIGNED NOT NULL,
   quantidade_monstro INTEGER UNSIGNED NOT NULL DEFAULT 1,
   PRIMARY KEY (servidor_id, monstro_id),
   FOREIGN KEY (servidor_id) REFERENCES servidor (id),
   FOREIGN KEY (monstro_id) REFERENCES monstro (id)
);

CREATE TABLE IF NOT EXISTS rpg.classe_tem_habilidade (
   classe_id TINYINT UNSIGNED NOT NULL,
   habilidade_id SMALLINT UNSIGNED NOT NULL,
   modificador_dano FLOAT UNSIGNED,
   PRIMARY KEY (classe_id, habilidade_id),
   FOREIGN KEY (classe_id) REFERENCES classe (id),
   FOREIGN KEY (habilidade_id) REFERENCES habilidade (id)
);

CREATE TABLE IF NOT EXISTS rpg.personagem_tem_item (
   personagem_id INTEGER UNSIGNED NOT NULL,
   item_id INTEGER UNSIGNED NOT NULL,
   quantidade_item INTEGER UNSIGNED NOT NULL DEFAULT 1,
   PRIMARY KEY (personagem_id, item_id),
   FOREIGN KEY (personagem_id) REFERENCES personagem (id),
   FOREIGN KEY (item_id) REFERENCES item (id)
); 
