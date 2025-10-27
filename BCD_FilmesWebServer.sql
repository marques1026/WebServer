
CREATE DATABASE IF NOT EXISTS filmes_db;
USE filmes_db; 
SELECT * FROM Filme;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'senai';

FLUSH PRIVILEGES;



SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Filme_pais, Filme_genero, filme_linguagem, filme_diretor, Filme_ator, filme_produtora;
DROP TABLE IF EXISTS Filme, Ator, Diretor, Produtora, genero, linguagem, pais;
SET FOREIGN_KEY_CHECKS=1;


-- Entidades Principais
CREATE TABLE Ator (
    id_ator INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    genero VARCHAR(255),
    data_de_nascimento DATE,
    nacionalidade VARCHAR(255)
);

CREATE TABLE Diretor (
    id_diretor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    sobrenome VARCHAR(255),
    nacionalidade VARCHAR(255),
    data_nascimento DATE,
    genero VARCHAR(255)
);

CREATE TABLE Produtora (
    id_produtora INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    data_fundacao DATE,
    pais_de_origem VARCHAR(255)
);

CREATE TABLE genero (
    id_genero INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE linguagem (
    id_linguagem INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE pais (
    id_pais INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Filme (
    id_filme INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    orcamento BIGINT,
    tempo_de_duracao INT, -- em minutos
    ano_de_lancamento INT,
    poster VARCHAR(255)
);

-- Tabelas de Junção
CREATE TABLE filme_produtora (
    id_filme_pro INT PRIMARY KEY AUTO_INCREMENT,
    id_filme INT NOT NULL,
    id_produtora INT NOT NULL,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (id_produtora) REFERENCES Produtora(id_produtora)
);

CREATE TABLE Filme_ator (
    id_filme_ator INT PRIMARY KEY AUTO_INCREMENT,
    id_filme INT NOT NULL,
    id_ator INT NOT NULL,
    personagem VARCHAR(255),
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (id_ator) REFERENCES Ator(id_ator)
);

CREATE TABLE filme_diretor (
    id_filme_diretor INT PRIMARY KEY AUTO_INCREMENT,
    id_filme INT NOT NULL,
    id_diretor INT NOT NULL,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (id_diretor) REFERENCES Diretor(id_diretor)
);

CREATE TABLE filme_linguagem (
    id_filme_ling INT PRIMARY KEY AUTO_INCREMENT,
    id_filme INT NOT NULL,
    id_linguagem INT NOT NULL,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (id_linguagem) REFERENCES linguagem(id_linguagem)
);

CREATE TABLE Filme_genero (
    id_filme_gen INT PRIMARY KEY AUTO_INCREMENT,
    id_filme INT NOT NULL,
    id_genero INT NOT NULL,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (id_genero) REFERENCES genero(id_genero)
);

CREATE TABLE Filme_pais (
    id_filme_pais INT PRIMARY KEY AUTO_INCREMENT,
    id_filme INT NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);


INSERT INTO genero (nome) VALUES 
('Animação'), ('Aventura'), ('Fantasia'), ('Infantil'), ('Ação'), 
('Drama'), ('Comédia'), ('Família'), ('Terror'), ('Ficção Científica'), 
('Musical'), ('Suspense'), ('Policial');

INSERT INTO linguagem (nome) VALUES 
('Inglês'), ('Mandarim'), ('Português');

INSERT INTO pais (nome) VALUES 
('EUA'), ('China'), ('Hong Kong'), ('Reino Unido'), ('Brasil');

INSERT INTO Ator (nome, nacionalidade) VALUES
('Chris Pine', 'EUA'), ('Jaden Smith', 'EUA'), ('Jackie Chan', 'Hong Kong'),
('Steve Carell', 'EUA'), ('Sandra Bullock', 'EUA'), ('Patrick Wilson', 'EUA'),
('Vera Farmiga', 'EUA'), ('Matthew McConaughey', 'EUA'), ('Kelly Macdonald', 'Reino Unido'),
('Mia Wasikowska', 'Austrália'), ('Johnny Depp', 'EUA'), ('Larissa Manoela', 'Brasil'),
('Jean Paulo Campos', 'Brasil'), ('Benedict Cumberbatch', 'Reino Unido'), ('Tom Holland', 'Reino Unido'),
('Jake Gyllenhaal', 'EUA'), ('Adam Sandler', 'EUA'), ('Dakota Fanning', 'EUA'),
('Jason Lee', 'EUA'), ('Owen Wilson', 'EUA'), ('Auli\'i Cravalho', 'EUA'),
('Dwayne Johnson', 'EUA'), ('Denzel Washington', 'EUA'), ('Amy Adams', 'Itália/EUA'),
('Sam Neill', 'Nova Zelândia'), ('Marlon Brando', 'EUA'), ('Al Pacino', 'EUA');

INSERT INTO Diretor (nome, sobrenome, nacionalidade) VALUES
('Peter', 'Ramsey', 'EUA'), ('Harald', 'Zwart', 'Noruega'), ('Pierre', 'Coffin', 'França'),
('Chris', 'Renaud', 'EUA'), ('Kyle', 'Balda', 'EUA'), ('James', 'Wan', 'Malásia/Austrália'),
('Christopher', 'Nolan', 'Reino Unido/EUA'), ('Brenda', 'Chapman', 'EUA'), ('Tim', 'Burton', 'EUA'),
('Alexandre', 'Boury', 'Brasil'), ('Mauricio', 'Eça', 'Brasil'), ('Scott', 'Derrickson', 'EUA'),
('Jon', 'Watts', 'EUA'), ('Dennis', 'Dugan', 'EUA'), ('Henry', 'Selick', 'EUA'),
('Mike', 'Mitchell', 'EUA'), ('John', 'Lasseter', 'EUA'), ('Ron', 'Clements', 'EUA'),
('John', 'Musker', 'EUA'), ('Antoine', 'Fuqua', 'EUA'), ('Denis', 'Villeneuve', 'Canadá'),
('Steven', 'Spielberg', 'EUA'), ('Francis Ford', 'Coppola', 'EUA');

INSERT INTO Produtora (nome, pais_de_origem) VALUES
('DreamWorks Animation', 'EUA'), ('Overbrook Entertainment', 'EUA'), ('China Film Group Corporation', 'China'),
('Columbia Pictures', 'EUA'), ('Illumination Entertainment', 'EUA'), ('Warner Bros.', 'EUA'),
('Paramount Pictures', 'EUA'), ('Pixar Animation Studios', 'EUA'), ('Walt Disney Pictures', 'EUA'),
('Roth Films', 'EUA'), ('Downtown Filmes', 'Brasil'), ('Paris Filmes', 'Brasil'),
('Marvel Studios', 'EUA'), ('Pascal Pictures', 'EUA'), ('Laika', 'EUA'),
('Fox Film', 'EUA'), ('Walt Disney Animation Studios', 'EUA'), ('Universal Pictures', 'EUA');

-- PPOPULAÇÃO DOS 20 FILMES E RELACIONAMENTOS
-- 1. A Origem dos Guardiões ID do Filme: 1
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('A Origem dos Guardiões', 2012, 97, 145000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (1, 1); -- DreamWorks
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (1, 1, 'Jack Frost (Voz)'); -- Chris Pine
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (1, 1); -- Peter Ramsey
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (1, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (1, 1), (1, 2), (1, 3), (1, 4); -- Animação, Aventura, Fantasia, Infantil
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (1, 1); -- EUA

-- 2. Karate Kid (2010) ID do Filme: 2
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Karatê Kid', 2010, 140, 40000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (2, 2), (2, 3), (2, 4); -- Overbrook, China Film, Columbia
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (2, 2, 'Dre Parker'), (2, 3, 'Mr. Han'); -- Jaden Smith, Jackie Chan
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (2, 2); -- Harald Zwart
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (2, 1), (2, 2); -- Inglês, Mandarim
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (2, 5), (2, 6); -- Ação, Drama
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (2, 1), (2, 2), (2, 3); -- EUA, China, Hong Kong

-- 3. Meu Malvado Favorito 2 ID do Filme: 3
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Meu Malvado Favorito 2', 2013, 98, 76000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (3, 5); -- Illumination
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (3, 4, 'Gru (Voz)'); -- Steve Carell
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (3, 3), (3, 4); -- Pierre Coffin, Chris Renaud
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (3, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (3, 1), (3, 7), (3, 8); -- Animação, Comédia, Família
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (3, 1); -- EUA

-- 4. Minions (ID do Filme: 4)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Minions', 2015, 91, 74000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (4, 5); -- Illumination
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (4, 5, 'Scarlet Overkill (Voz)'); -- Sandra Bullock
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (4, 3), (4, 5); -- Pierre Coffin, Kyle Balda
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (4, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (4, 1), (4, 7), (4, 8); -- Animação, Comédia, Família
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (4, 1); -- EUA

-- 5. Invocação do Mal (ID do Filme: 5)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Invocação do Mal', 2013, 112, 20000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (5, 6); -- Warner Bros.
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (5, 6, 'Ed Warren'), (5, 7, 'Lorraine Warren'); -- Patrick Wilson, Vera Farmiga
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (5, 6); -- James Wan
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (5, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (5, 9), (5, 12); -- Terror, Suspense
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (5, 1); -- EUA

-- 6. Interestellar (ID do Filme: 6)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Interestellar', 2014, 169, 165000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (6, 6), (6, 7); -- Warner Bros., Paramount
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (6, 8, 'Cooper'); -- Matthew McConaughey
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (6, 7); -- Christopher Nolan
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (6, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (6, 2), (6, 6), (6, 10); -- Aventura, Drama, Ficção Científica
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (6, 1), (6, 4); -- EUA, Reino Unido

-- 7. Valente (ID do Filme: 7)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Valente', 2012, 93, 185000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (7, 8), (7, 9); -- Pixar, Disney
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (7, 9, 'Merida (Voz)'); -- Kelly Macdonald
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (7, 8); -- Brenda Chapman
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (7, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (7, 1), (7, 2), (7, 3); -- Animação, Aventura, Fantasia
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (7, 1); -- EUA

-- 8. Alice no País das Maravilhas (2010) (ID do Filme: 8)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Alice no País das Maravilhas', 2010, 108, 200000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (8, 9), (8, 10); -- Disney, Roth Films
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (8, 10, 'Alice Kingsleigh'), (8, 11, 'Chapeleiro Maluco'); -- Mia Wasikowska, Johnny Depp
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (8, 9); -- Tim Burton
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (8, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (8, 2), (8, 3), (8, 8); -- Aventura, Fantasia, Família
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (8, 1); -- EUA

-- 9. Carrossel o Filme (ID do Filme: 9)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao) VALUES ('Carrossel o Filme', 2015, 93);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (9, 11), (9, 12); -- Downtown, Paris Filmes
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (9, 12, 'Maria Joaquina'), (9, 13, 'Cirilo'); -- Larissa Manoela, Jean Paulo Campos
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (9, 10), (9, 11); -- Alexandre Boury, Mauricio Eça
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (9, 3); -- Português
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (9, 4), (9, 7), (9, 8); -- Infantil, Comédia, Família
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (9, 5); -- Brasil

-- 10. Doutor Estranho (ID do Filme: 10)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Doutor Estranho', 2016, 115, 165000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (10, 13); -- Marvel Studios
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (10, 14, 'Dr. Stephen Strange'); -- Benedict Cumberbatch
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (10, 12); -- Scott Derrickson
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (10, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (10, 5), (10, 2), (10, 3); -- Ação, Aventura, Fantasia
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (10, 1); -- EUA

-- 11. Homem-Aranha: Longe de Casa (ID do Filme: 11)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Homem-Aranha: Longe de Casa', 2019, 129, 160000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (11, 4), (11, 13), (11, 14); -- Columbia, Marvel, Pascal
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (11, 15, 'Peter Parker'), (11, 16, 'Mysterio'); -- Tom Holland, Jake Gyllenhaal
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (11, 13); -- Jon Watts
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (11, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (11, 5), (11, 2), (11, 10); -- Ação, Aventura, Ficção Científica
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (11, 1); -- EUA

-- 12. Gente Grande (ID do Filme: 12)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Gente Grande', 2010, 102, 80000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (12, 4); -- Columbia
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (12, 17, 'Lenny Feder'); -- Adam Sandler
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (12, 14); -- Dennis Dugan
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (12, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (12, 7); -- Comédia
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (12, 1); -- EUA

-- 13. Coraline (ID do Filme: 13)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Coraline e o Mundo Secreto', 2009, 100, 60000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (13, 15); -- Laika
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (13, 18, 'Coraline Jones (Voz)'); -- Dakota Fanning
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (13, 15); -- Henry Selick
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (13, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (13, 1), (13, 3), (13, 12); -- Animação, Fantasia, Suspense
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (13, 1); -- EUA

-- 14. Alvin e os Esquilos 3 (ID do Filme: 14)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Alvin e os Esquilos 3', 2011, 87, 75000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (14, 16); -- Fox Film
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (14, 19, 'Dave Seville'); -- Jason Lee
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (14, 16); -- Mike Mitchell
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (14, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (14, 1), (14, 7), (14, 8); -- Animação, Comédia, Família
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (14, 1); -- EUA

-- 15. Carros (ID do Filme: 15)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Carros', 2006, 117, 120000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (15, 8), (15, 9); -- Pixar, Disney
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (15, 20, 'Relâmpago McQueen (Voz)'); -- Owen Wilson
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (15, 17); -- John Lasseter
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (15, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (15, 1), (15, 7), (15, 2); -- Animação, Comédia, Aventura
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (15, 1); -- EUA

-- 16. Moana (ID do Filme: 16)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Moana: Um Mar de Aventuras', 2016, 107, 150000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (16, 17); -- Walt Disney Animation Studios
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (16, 21, 'Moana (Voz)'), (16, 22, 'Maui (Voz)'); -- Auli'i Cravalho, Dwayne Johnson
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (16, 18), (16, 19); -- Ron Clements, John Musker
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (16, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (16, 1), (16, 11), (16, 2), (16, 3); -- Animação, Musical, Aventura, Fantasia
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (16, 1); -- EUA

-- 17. O Protetor (ID do Filme: 17)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('O Protetor', 2014, 132, 55000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (17, 4); -- Columbia
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (17, 23, 'Robert McCall'); -- Denzel Washington
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (17, 20); -- Antoine Fuqua
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (17, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (17, 5), (17, 12); -- Ação, Suspense
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (17, 1); -- EUA

-- 18. A Chegada (ID do Filme: 18)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('A Chegada', 2016, 116, 47000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (18, 7); -- Paramount
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (18, 24, 'Dra. Louise Banks'); -- Amy Adams
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (18, 21); -- Denis Villeneuve
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (18, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (18, 10), (18, 6), (18, 12); -- Ficção Científica, Drama, Suspense
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (18, 1); -- EUA

-- 19. Jurassic Park (ID do Filme: 19)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('Jurassic Park: O Parque dos Dinossauros', 1993, 127, 63000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (19, 18); -- Universal
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (19, 25, 'Dr. Alan Grant'); -- Sam Neill
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (19, 22); -- Steven Spielberg
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (19, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (19, 2), (19, 10); -- Aventura, Ficção Científica
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (19, 1); -- EUA

-- 20. O Poderoso Chefão (ID do Filme: 20)
INSERT INTO Filme (titulo, ano_de_lancamento, tempo_de_duracao, orcamento) VALUES ('O Poderoso Chefão', 1972, 175, 6000000);
INSERT INTO filme_produtora (id_filme, id_produtora) VALUES (20, 7); -- Paramount
INSERT INTO Filme_ator (id_filme, id_ator, personagem) VALUES (20, 26, 'Vito Corleone'), (20, 27, 'Michael Corleone'); -- Marlon Brando, Al Pacino
INSERT INTO filme_diretor (id_filme, id_diretor) VALUES (20, 23); -- Francis Ford Coppola
INSERT INTO filme_linguagem (id_filme, id_linguagem) VALUES (20, 1); -- Inglês
INSERT INTO Filme_genero (id_filme, id_genero) VALUES (20, 6), (20, 13); -- Drama, Policial
INSERT INTO Filme_pais (id_filme, id_pais) VALUES (20, 1); -- EUA