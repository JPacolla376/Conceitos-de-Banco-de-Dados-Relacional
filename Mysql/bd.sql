-- Criação do banco de dados 'conceitos'
CREATE DATABASE conceitos;

-- Seleciona o banco de dados 'conceitos' para uso.
USE conceitos;

-- Criação da tabela Loja
-- Armazena informações sobre cada loja da rede de locadoras.
-- A coluna 'id' é a chave primária que identifica unicamente cada loja.
-- A coluna 'gerente_id' será usada para relacionar cada loja a um gerente específico.
CREATE TABLE Loja (
    id INT PRIMARY KEY,
    gerente_id INT  -- Referencia um funcionário que é o gerente desta loja
);

-- Criação da tabela Cliente
-- Armazena dados dos clientes da locadora.
-- A coluna 'id' é a chave primária que identifica unicamente cada cliente.
-- 'loja_id' é uma chave estrangeira que indica a qual loja o cliente pertence.
-- 'criado_em' registra a data e hora da criação do registro do cliente.
CREATE TABLE Cliente (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(11),
    email VARCHAR(255),
    ativo BOOLEAN,
    loja_id INT,  -- Relaciona o cliente com a loja onde ele foi registrado
    criado_em DATETIME,  -- Armazena a data de criação do registro do cliente
    FOREIGN KEY (loja_id) REFERENCES Loja(id)  -- Define a relação entre Cliente e Loja
);

-- Criação da tabela Funcionario
-- Armazena dados dos funcionários da locadora.
-- A coluna 'id' é a chave primária que identifica unicamente cada funcionário.
-- 'loja_id' é uma chave estrangeira que indica a qual loja o funcionário pertence.
CREATE TABLE Funcionario (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    foto VARCHAR(255),
    email VARCHAR(255),
    ativo BOOLEAN,
    login VARCHAR(255),  -- Dados de login para acesso ao sistema
    senha VARCHAR(255),  -- Senha de acesso ao sistema
    loja_id INT,  -- Relaciona o funcionário com a loja onde trabalha
    FOREIGN KEY (loja_id) REFERENCES Loja(id)  -- Define a relação entre Funcionario e Loja
);

-- Criação da tabela Ator
-- Armazena informações sobre os atores dos filmes.
-- A coluna 'id' é a chave primária que identifica unicamente cada ator.
CREATE TABLE Ator (
    id INT PRIMARY KEY,
    nome VARCHAR(255)  -- Nome do ator
);

-- Criação da tabela Categoria
-- Armazena diferentes categorias de filmes.
-- A coluna 'id' é a chave primária que identifica unicamente cada categoria.
CREATE TABLE Categoria (
    id INT PRIMARY KEY,
    nome VARCHAR(255)  -- Nome da categoria
);

-- Criação da tabela Filme
-- Armazena informações detalhadas sobre os filmes disponíveis na locadora.
-- A coluna 'id' é a chave primária que identifica unicamente cada filme.
CREATE TABLE Filme (
    id INT PRIMARY KEY,
    titulo VARCHAR(255),  -- Título do filme
    descricao TEXT,  -- Descrição do filme
    ano YEAR,  -- Ano de lançamento do filme
    aluguel_duracao INT,  -- Duração do período de aluguel
    aluguel_taxa DECIMAL(10,2),  -- Taxa de aluguel do filme
    duracao INT,  -- Duração total do filme em minutos
    valor_reposicao DECIMAL(10,2),  -- Valor de reposição do filme se perdido ou danificado
    classificacao VARCHAR(10),  -- Classificação indicativa do filme
    caracteristicas TEXT  -- Características adicionais do filme
);

-- Criação da tabela Aluguel
-- Armazena informações sobre cada aluguel realizado na locadora.
-- A coluna 'id' é a chave primária que identifica unicamente cada aluguel.
-- 'cliente_id' indica qual cliente realizou o aluguel.
-- 'funcionario_id' indica qual funcionário registrou o aluguel.
CREATE TABLE Aluguel (
    id INT PRIMARY KEY,
    data DATETIME,  -- Data do aluguel
    data_devolucao DATETIME,  -- Data de devolução do aluguel
    cliente_id INT,  -- Relaciona o aluguel com o cliente que o realizou
    funcionario_id INT,  -- Relaciona o aluguel com o funcionário que o registrou
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id),  -- Define a relação entre Aluguel e Cliente
    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(id)  -- Define a relação entre Aluguel e Funcionario
);

-- Criação da tabela Item
-- Armazena informações sobre os itens específicos de cada aluguel.
-- A coluna 'id' é a chave primária que identifica unicamente cada item.
-- 'filme_id' indica qual filme está sendo alugado.
-- 'aluguel_id' indica a qual aluguel o item pertence.
CREATE TABLE Item (
    id INT PRIMARY KEY,
    filme_id INT,  -- Relaciona o item com o filme que está sendo alugado
    aluguel_id INT,  -- Relaciona o item com o aluguel ao qual pertence
    FOREIGN KEY (filme_id) REFERENCES Filme(id),  -- Define a relação entre Item e Filme
    FOREIGN KEY (aluguel_id) REFERENCES Aluguel(id)  -- Define a relação entre Item e Aluguel
);

-- Criação da tabela Pagamento
-- Armazena informações sobre os pagamentos realizados pelos clientes.
-- A coluna 'id' é a chave primária que identifica unicamente cada pagamento.
-- 'aluguel_id' indica a qual aluguel o pagamento está relacionado.
-- 'cliente_id' indica qual cliente realizou o pagamento.
-- 'funcionario_id' indica qual funcionário registrou o pagamento.
CREATE TABLE Pagamento (
    id INT PRIMARY KEY,
    valor DECIMAL(10,2),  -- Valor do pagamento
    data_pagamento DATETIME,  -- Data em que o pagamento foi realizado
    aluguel_id INT,  -- Relaciona o pagamento com o aluguel associado
    cliente_id INT,  -- Relaciona o pagamento com o cliente que pagou
    funcionario_id INT,  -- Relaciona o pagamento com o funcionário que registrou
    FOREIGN KEY (aluguel_id) REFERENCES Aluguel(id),  -- Define a relação entre Pagamento e Aluguel
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id),  -- Define a relação entre Pagamento e Cliente
    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(id)  -- Define a relação entre Pagamento e Funcionario
);

-- Criação da tabela Estoque
-- Armazena a quantidade de cada filme disponível em cada loja.
-- A coluna 'id' é a chave primária que identifica unicamente cada registro de estoque.
-- 'filme_id' indica qual filme está no estoque.
-- 'loja_id' indica a qual loja o estoque pertence.
CREATE TABLE Estoque (
    id INT PRIMARY KEY,
    filme_id INT,  -- Relaciona o estoque com o filme específico
    loja_id INT,  -- Relaciona o estoque com a loja específica
    quantidade INT,  -- Quantidade do filme em estoque na loja
    FOREIGN KEY (filme_id) REFERENCES Filme(id),  -- Define a relação entre Estoque e Filme
    FOREIGN KEY (loja_id) REFERENCES Loja(id)  -- Define a relação entre Estoque e Loja
);

-- Criação da tabela de relacionamento Filme_Categoria
-- Armazena a relação de muitos para muitos entre filmes e categorias.
-- A combinação das colunas 'filme_id' e 'categoria_id' serve como chave primária composta.
CREATE TABLE Filme_Categoria (
    filme_id INT,  -- Relaciona o filme com a categoria
    categoria_id INT,  -- Relaciona a categoria com o filme
    PRIMARY KEY (filme_id, categoria_id),  -- Define a chave primária composta
    FOREIGN KEY (filme_id) REFERENCES Filme(id),  -- Define a relação entre Filme_Categoria e Filme
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id)  -- Define a relação entre Filme_Categoria e Categoria
);

-- Criação da tabela de relacionamento Filme_Ator
-- A combinação das colunas 'filme_id' e 'ator_id' serve como chave primária composta.
CREATE TABLE Filme_Ator (
    filme_id INT,  -- Relaciona o filme com o ator
    ator_id INT,  -- Relaciona o ator com o filme
    PRIMARY KEY (filme_id, ator_id),  -- Define a chave primária composta
    FOREIGN KEY (filme_id) REFERENCES Filme(id),  -- Define a relação entre Filme_Ator e Filme
    FOREIGN KEY (ator_id) REFERENCES Ator(id)  -- Define a relação entre Filme_Ator e Ator
);

-- Alteração da tabela Loja para adicionar uma chave estrangeira para gerente_id
-- Define que 'gerente_id' na tabela Loja referencia 'id' na tabela Funcionario.
-- Isso estabelece que o gerente de uma loja é um funcionário específico.
ALTER TABLE Loja
ADD FOREIGN KEY (gerente_id) REFERENCES Funcionario(id);


-- 2a ) Criar um UNIQUE INDEX para o atributo CPF na tabela Cliente
-- Como critério de avaliação, será aceito nome de variavéis diferentes então acredito que seja repetitivo o nome abaixo e ninguém tenha usado. Se o idx é da tabela clientes, então idx é obvio que é da tabela cliente.

CREATE UNIQUE INDEX idx_cliente_cpf ON Cliente(cpf);


-- 2b) Criação das Views
-- Como critério de avaliação, será aceito nome de variavéis diferentes.

-- Criação de uma visualização (VIEW) chamada "AtoresFilmesTopzera"
-- Esta VIEW lista os nomes dos atores e uma descrição contendo todos os filmes nos quais eles atuaram.
-- A função GROUP_CONCAT é usada para agrupar todos os títulos de filmes de cada ator em uma string separada por vírgulas.

CREATE VIEW AtoresFilmesTopzera AS
SELECT a.nome AS ator, GROUP_CONCAT(f.titulo SEPARATOR ', ') AS filmes
FROM Ator a
JOIN Filme_Ator fa ON a.id = fa.ator_id
JOIN Filme f ON fa.filme_id = f.id
GROUP BY a.nome;

-- Criação de uma visualização (VIEW) chamada "FilmesTopzera_Categorias_Atores"
-- Esta VIEW lista os filmes com suas respectivas categorias e os atores que participaram.
-- GROUP_CONCAT é usado para agrupar nomes de categorias e atores em strings separadas por vírgulas.
CREATE VIEW FilmesTopzera_Categorias_Atores AS
SELECT f.titulo AS filme,
       GROUP_CONCAT(DISTINCT c.nome SEPARATOR ', ') AS categorias,
       GROUP_CONCAT(DISTINCT a.nome SEPARATOR ', ') AS atores
FROM Filme f
LEFT JOIN Filme_Categoria fc ON f.id = fc.filme_id
LEFT JOIN Categoria c ON fc.categoria_id = c.id
LEFT JOIN Filme_Ator fa ON f.id = fa.filme_id
LEFT JOIN Ator a ON fa.ator_id = a.id
GROUP BY f.titulo;

-- Criação de uma função chamada Controle_Inventario
-- Esta função verifica se um item específico (representado por item_id) está disponível em estoque.
-- A função retorna 1 se o item está disponível e 0 caso contrário.

-- 2c Foi implementada no modelo conceitual junto com a criação (Fiz a Leitura antes Niltão)

-- 2d) Função Controle_Inventario
-- A função Controle_Inventario verifica a disponibilidade de um item específico no estoque.
-- Se o item não está associado a um aluguel ativo (ou seja, devolvido ou não alugado), a função retorna 1 (disponível).
-- Caso contrário, retorna 0 (indisponível).

CREATE FUNCTION Controle_Inventario (itemID_FunGoDoido INT) RETURNS INT
BEGIN
    DECLARE itens_no_barraco INT;
    SELECT COUNT(*) INTO itens_no_barraco
    FROM Item i
    WHERE i.id = itemID_FunGoDoido 
      AND (i.aluguel_id IS NULL OR 
           EXISTS (SELECT 1 FROM Aluguel a WHERE a.id = i.aluguel_id AND a.data_devolucao IS NOT NULL));
           
    -- Estrturinha báica de condição de verdadeiro ou falso
    IF itens_no_barraco > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;


 -- 2e) Procedimento para listar nomes dos atores com limite de registros
-- Lista até 'limite' nomes de atores da tabela Ator.
-- Procedimento Listar_Atores
CREATE PROCEDURE Listar_Atores (IN quantiaDeAtores INT)
BEGIN
    SELECT nome FROM Ator LIMIT quantiaDeAtores;
END;

-- Procedimento Filmes_Em_Estoque
CREATE PROCEDURE Filmes_Em_Estoque (IN filmeID_Bang INT, IN lojaID_Tranqueira INT)
BEGIN
    SELECT quantidade 
    FROM Estoque 
    WHERE filme_id = filmeID_Bang AND loja_id = lojaID_Tranqueira;
END;

-- Procedimento Filmes_Alugados
CREATE PROCEDURE Filmes_Alugados (IN filmeID_Maluco INT, IN lojaID_Pancada INT)
BEGIN
    SELECT COUNT(*) AS total_alugados
    FROM Item i
    JOIN Aluguel a ON i.aluguel_id = a.id
    JOIN Estoque e ON i.filme_id = e.filme_id
    WHERE e.filme_id = filmeID_Maluco AND e.loja_id = lojaID_Pancada AND a.data_devolucao IS NULL;
END;


-- 2f) Adicionar coluna 'criado_em' para registrar a data de criação do cliente.
 -- Modificação na tabella e Triggers
ALTER TABLE Cliente ADD COLUMN criado_em DATETIME;

-- 2g) Trigger que atualiza a coluna 'criado_em' com a data e hora atual antes de cada atualização no registro de Cliente.
CREATE TRIGGER cliente_before_update
BEFORE UPDATE ON Cliente
FOR EACH ROW
BEGIN
    SET NEW.criado_em = NOW(); -- Define a data e hora atuais
END;


-- 2h) Criação da tabela 'Log' para registrar mensagens de log de atualizações em clientes.
CREATE TABLE Log (
    reg INT AUTO_INCREMENT PRIMARY KEY,  -- Coluna auto incrementável para identificar unicamente cada registro.
    msg VARCHAR(255)  -- Coluna para armazenar a mensagem de log.
);

-- 2i) Trigger que insere uma mensagem de log na tabela 'Log' após cada atualização na tabela 'Cliente'.
CREATE TRIGGER cliente_AFTER_UPDATE
AFTER UPDATE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Log (msg) VALUES (CONCAT('Cliente atualizado: ', NEW.id));  -- Registra o ID do cliente atualizado no log.
END;

-- 2j) Criar um novo usuário chamado 'novo_usuario' com uma senha segura.

CREATE USER 'novo_usuario'@'localhost' IDENTIFIED BY 'senha_segura';

GRANT SELECT, INSERT, UPDATE, DELETE ON conceitos.* TO 'novo_usuario'@'localhost';
-- Conceder ao 'novo_usuario' privilégios de SELECT, INSERT, UPDATE, DELETE em todas as tabelas do banco de dados.

REVOKE UPDATE, DELETE, INSERT ON conceitos.Pagamento FROM 'novo_usuario'@'localhost';
-- Revogar os privilégios de UPDATE, DELETE, INSERT especificamente na tabela 'Pagamento' para o 'novo_usuario'.


-- Considerações finais: Essa foi umas das matérias mais desafiodoras desse semestre, que Deus e Niltão tenha piedade dos alunos sofridos por esta matéria. 
 




