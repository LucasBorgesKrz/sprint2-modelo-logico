-- =====================================================================
-- Sprint 2 - Modelo Lógico e SQL (DML)
-- Executar DEPOIS do 01_ddl.sql (os id_conteudo abaixo assumem a tabela
-- vazia, pois a PK é gerada automaticamente a partir de 1).
-- =====================================================================

-- ---------------------------------------------------------------------
-- INSERTs (primeiro as tabelas "pai", depois a que tem FK)
-- ---------------------------------------------------------------------

-- As senhas abaixo são hashes fictícios, só para exemplo.
INSERT INTO usuario (email, senha, data_nascimento) VALUES
    ('marina.souza@email.com',   '$2b$10$hashficticio.marina',  '1995-03-14'),
    ('carlos.almeida@email.com', '$2b$10$hashficticio.carlos',  '1988-11-02'),
    ('beatriz.lima@email.com',   '$2b$10$hashficticio.beatriz', '2000-07-25'),
    ('rafael.costa@email.com',   '$2b$10$hashficticio.rafael',  '1992-01-30');

INSERT INTO conteudo (titulo, genero, tipo, duracao) VALUES
    ('Interestelar',    'Ficção Científica', 'FILME', 169),  -- id 1
    ('Breaking Bad',    'Crime',             'SERIE',  47),  -- id 2
    ('Cidade de Deus',  'Crime',             'FILME', 130),  -- id 3
    ('Our Planet',      'Documentário',      'SERIE',  50),  -- id 4
    ('Stranger Things', 'Ficção Científica', 'SERIE',  50);  -- id 5

INSERT INTO avaliacao (email_usuario, id_conteudo, data_avaliacao, nota, comentario) VALUES
    ('marina.souza@email.com',   1, '2026-08-10', 5, 'Visual e trilha sonora incríveis.'),
    ('marina.souza@email.com',   2, '2026-08-12', 4, 'Ótima construção de personagens.'),
    ('marina.souza@email.com',   4, '2026-08-15', 5, NULL),
    ('carlos.almeida@email.com', 1, '2026-08-11', 4, 'Bom, mas achei o final confuso.'),
    ('carlos.almeida@email.com', 3, '2026-08-20', 5, 'Clássico do cinema nacional.'),
    ('beatriz.lima@email.com',   2, '2026-08-18', 5, NULL),
    ('beatriz.lima@email.com',   3, '2026-08-22', 4, 'Roteiro forte e direção precisa.'),
    ('rafael.costa@email.com',   4, '2026-08-25', 3, 'Bonito, porém um pouco arrastado.');

-- ---------------------------------------------------------------------
-- SELECTs com JOIN
-- ---------------------------------------------------------------------

-- 1) Quem avaliou o quê: junta as 3 tabelas (INNER JOIN).
SELECT  u.email       AS usuario,
        c.titulo      AS conteudo,
        c.genero,
        a.nota,
        a.data_avaliacao
FROM    avaliacao a
JOIN    usuario   u ON u.email       = a.email_usuario
JOIN    conteudo  c ON c.id_conteudo = a.id_conteudo
ORDER BY a.data_avaliacao;

-- 2) Ranking: nota média e quantidade de avaliações por conteúdo.
SELECT  c.titulo,
        c.tipo,
        COUNT(a.nota)         AS total_avaliacoes,
        ROUND(AVG(a.nota), 2) AS nota_media
FROM    conteudo  c
JOIN    avaliacao a ON a.id_conteudo = c.id_conteudo
GROUP BY c.titulo, c.tipo
ORDER BY nota_media DESC, total_avaliacoes DESC;

-- 3) Extra: conteúdos que ainda não receberam nenhuma avaliação (LEFT JOIN).
SELECT  c.titulo, c.tipo
FROM    conteudo  c
LEFT JOIN avaliacao a ON a.id_conteudo = c.id_conteudo
WHERE   a.id_conteudo IS NULL;
