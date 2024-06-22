-- Criação do banco de dados Conceito

Create DATABASE conceitos;

USE conceitos;

-- Criação das tabelas
CREATE TABLE Loja (
    id INT PRIMARY KEY,
    gerente_id INT
);

CREATE TABLE Cliente (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(11),
    email VARCHAR(255),
    ativo BOOLEAN,
    loja_id INT,
    criado_em DATETIME,
    FOREIGN KEY (loja_id) REFERENCES Loja(id)
);

CREATE TABLE Funcionario (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    foto VARCHAR(255),
    email VARCHAR(255),
    ativo BOOLEAN,
    login VARCHAR(255),
    senha VARCHAR(255),
    loja_id INT,
    FOREIGN KEY (loja_id) REFERENCES Loja(id)
);

CREATE TABLE Ator (
    id INT PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE Categoria (
    id INT PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE Filme (
    id INT PRIMARY KEY,
    titulo VARCHAR(255),
    descricao TEXT,
    ano YEAR,
    aluguel_duracao INT,
    aluguel_taxa DECIMAL(10,2),
    duracao INT,
    valor_reposicao DECIMAL(10,2),
    classificacao VARCHAR(10),
    caracteristicas TEXT
);

CREATE TABLE Aluguel (
    id INT PRIMARY KEY,
    data DATETIME,
    data_devolucao DATETIME,
    cliente_id INT,
    funcionario_id INT,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(id)
);

CREATE TABLE Item (
    id INT PRIMARY KEY,
    filme_id INT,
    aluguel_id INT,
    FOREIGN KEY (filme_id) REFERENCES Filme(id),
    FOREIGN KEY (aluguel_id) REFERENCES Aluguel(id)
);

CREATE TABLE Pagamento (
    id INT PRIMARY KEY,
    valor DECIMAL(10,2),
    data_pagamento DATETIME,
    aluguel_id INT,
    cliente_id INT,
    funcionario_id INT,
    FOREIGN KEY (aluguel_id) REFERENCES Aluguel(id),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(id)
);

CREATE TABLE Estoque (
    id INT PRIMARY KEY,
    filme_id INT,
    loja_id INT,
    quantidade INT,
    FOREIGN KEY (filme_id) REFERENCES Filme(id),
    FOREIGN KEY (loja_id) REFERENCES Loja(id)
);

CREATE TABLE Filme_Categoria (
    filme_id INT,
    categoria_id INT,
    PRIMARY KEY (filme_id, categoria_id),
    FOREIGN KEY (filme_id) REFERENCES Filme(id),
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id)
);

CREATE TABLE Filme_Ator (
    filme_id INT,
    ator_id INT,
    PRIMARY KEY (filme_id, ator_id),
    FOREIGN KEY (filme_id) REFERENCES Filme(id),
    FOREIGN KEY (ator_id) REFERENCES Ator(id)
);

-- Alterações necessárias
ALTER TABLE Loja
ADD FOREIGN KEY (gerente_id) REFERENCES Funcionario(id);
