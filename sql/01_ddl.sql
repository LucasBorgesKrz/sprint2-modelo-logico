-- =====================================================================
-- Sprint 2 - Modelo Lógico e SQL (DDL)
-- Tema: Radar de Dados - streaming de filmes e séries
-- SGBD: PostgreSQL 14+
-- Base: modelo conceitual da Sprint 1 (Usuario, Conteudo, Avaliacao)
-- =====================================================================

DROP TABLE IF EXISTS avaliacao CASCADE;
DROP TABLE IF EXISTS conteudo  CASCADE;
DROP TABLE IF EXISTS usuario   CASCADE;

-- ---------------------------------------------------------------------
-- USUARIO
-- PK natural: email (conforme o MER da Sprint 1)
-- ---------------------------------------------------------------------
CREATE TABLE usuario (
    email            VARCHAR(150) NOT NULL,
    senha            VARCHAR(255) NOT NULL,  -- deve guardar o HASH da senha, nunca o texto puro
    data_nascimento  DATE         NOT NULL,

    CONSTRAINT pk_usuario       PRIMARY KEY (email),
    CONSTRAINT ck_usuario_email CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT ck_usuario_nasc  CHECK (data_nascimento >= DATE '1900-01-01')
);

-- ---------------------------------------------------------------------
-- CONTEUDO (filmes e séries)
-- ---------------------------------------------------------------------
CREATE TABLE conteudo (
    id_conteudo  INTEGER GENERATED ALWAYS AS IDENTITY,
    titulo       VARCHAR(150) NOT NULL,
    genero       VARCHAR(50)  NOT NULL,
    tipo         VARCHAR(10)  NOT NULL,
    duracao      INTEGER      NOT NULL,   -- em minutos (série: duração média do episódio)

    CONSTRAINT pk_conteudo        PRIMARY KEY (id_conteudo),
    CONSTRAINT uq_conteudo_titulo UNIQUE (titulo, tipo),
    CONSTRAINT ck_conteudo_tipo   CHECK (tipo IN ('FILME', 'SERIE')),
    CONSTRAINT ck_conteudo_dur    CHECK (duracao > 0)
);

-- ---------------------------------------------------------------------
-- AVALIACAO (entidade associativa da relação N:N Usuario x Conteudo)
-- PK composta: um usuário avalia um mesmo conteúdo uma única vez.
-- ---------------------------------------------------------------------
CREATE TABLE avaliacao (
    email_usuario   VARCHAR(150) NOT NULL,
    id_conteudo     INTEGER      NOT NULL,
    data_avaliacao  DATE         NOT NULL DEFAULT CURRENT_DATE,
    nota            SMALLINT     NOT NULL,
    comentario      TEXT,

    CONSTRAINT pk_avaliacao          PRIMARY KEY (email_usuario, id_conteudo),
    CONSTRAINT ck_avaliacao_nota     CHECK (nota BETWEEN 1 AND 5),
    CONSTRAINT fk_avaliacao_usuario  FOREIGN KEY (email_usuario)
        REFERENCES usuario (email)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_avaliacao_conteudo FOREIGN KEY (id_conteudo)
        REFERENCES conteudo (id_conteudo)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
