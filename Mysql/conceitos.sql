-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 22/06/2024 às 06:45
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `conceitos`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Filmes_Alugados` (IN `filmeID_Maluco` INT, IN `lojaID_Pancada` INT)   BEGIN
    SELECT COUNT(*) AS total_alugados
    FROM Item i
    JOIN Aluguel a ON i.aluguel_id = a.id
    WHERE i.filme_id = filmeID_Maluco 
      AND a.loja_id = lojaID_Pancada
      AND a.data_devolucao IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Filmes_Em_Estoque` (IN `filmeID_Bang` INT, IN `lojaID_Tranqueira` INT)   BEGIN
    SELECT quantidade 
    FROM Estoque 
    WHERE filme_id = filmeID_Bang AND loja_id = lojaID_Tranqueira;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Listar_Atores` (IN `quantiaDeAtores` INT)   BEGIN
    SELECT nome FROM Ator LIMIT quantiaDeAtores;
END$$

--
-- Funções
--
CREATE DEFINER=`root`@`localhost` FUNCTION `Controle_Inventario` (`itemID_FunGoDoido` INT) RETURNS INT(11)  BEGIN
    DECLARE itens_no_barraco INT;

    -- Conta os itens que estão disponíveis no estoque (não alugados ou devolvidos)
    SELECT COUNT(*)
    INTO itens_no_barraco
    FROM Item i
    LEFT JOIN Aluguel a ON i.aluguel_id = a.id
    WHERE i.id = itemID_FunGoDoido
      AND (i.aluguel_id IS NULL OR a.data_devolucao IS NOT NULL);
    
    -- Verifica se há itens disponíveis e retorna 1 se verdadeiro, caso contrário, 0
    IF itens_no_barraco > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `aluguel`
--

CREATE TABLE `aluguel` (
  `id` int(11) NOT NULL,
  `data` datetime DEFAULT NULL,
  `data_devolucao` datetime DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `funcionario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ator`
--

CREATE TABLE `ator` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `atoresfilmestopzera`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `atoresfilmestopzera` (
`ator` varchar(255)
,`filmes` mediumtext
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `categoria`
--

CREATE TABLE `categoria` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
--

CREATE TABLE `cliente` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cpf` varchar(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT NULL,
  `loja_id` int(11) DEFAULT NULL,
  `criado_em` datetime DEFAULT NULL,
  `atualizado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `cliente`
--
DELIMITER $$
CREATE TRIGGER `cliente_AFTER_UPDATE` AFTER UPDATE ON `cliente` FOR EACH ROW BEGIN
    -- Insere uma mensagem de log na tabela 'Log'.
    -- A mensagem é concatenada com o texto 'Cliente atualizado: ' e o ID do cliente atualizado.
    INSERT INTO Log (msg) VALUES (CONCAT('Cliente atualizado: ', NEW.id));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cliente_before_update` BEFORE UPDATE ON `cliente` FOR EACH ROW BEGIN
    -- Define a coluna 'atualizado_em' para a data e hora atuais (momento da atualização).
    SET NEW.atualizado_em = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `estoque`
--

CREATE TABLE `estoque` (
  `id` int(11) NOT NULL,
  `filme_id` int(11) DEFAULT NULL,
  `loja_id` int(11) DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `filme`
--

CREATE TABLE `filme` (
  `id` int(11) NOT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `ano` year(4) DEFAULT NULL,
  `aluguel_duracao` int(11) DEFAULT NULL,
  `aluguel_taxa` decimal(10,2) DEFAULT NULL,
  `duracao` int(11) DEFAULT NULL,
  `valor_reposicao` decimal(10,2) DEFAULT NULL,
  `classificacao` varchar(10) DEFAULT NULL,
  `caracteristicas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `filmestopzera_categorias_atores`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `filmestopzera_categorias_atores` (
`filme` varchar(255)
,`categorias` mediumtext
,`atores` mediumtext
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `filme_ator`
--

CREATE TABLE `filme_ator` (
  `filme_id` int(11) NOT NULL,
  `ator_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `filme_categoria`
--

CREATE TABLE `filme_categoria` (
  `filme_id` int(11) NOT NULL,
  `categoria_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario`
--

CREATE TABLE `funcionario` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT NULL,
  `login` varchar(255) DEFAULT NULL,
  `senha` varchar(255) DEFAULT NULL,
  `loja_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `item`
--

CREATE TABLE `item` (
  `id` int(11) NOT NULL,
  `filme_id` int(11) DEFAULT NULL,
  `aluguel_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `log`
--

CREATE TABLE `log` (
  `reg` int(11) NOT NULL,
  `msg` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `loja`
--

CREATE TABLE `loja` (
  `id` int(11) NOT NULL,
  `gerente_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pagamento`
--

CREATE TABLE `pagamento` (
  `id` int(11) NOT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  `data_pagamento` datetime DEFAULT NULL,
  `aluguel_id` int(11) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `funcionario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para view `atoresfilmestopzera`
--
DROP TABLE IF EXISTS `atoresfilmestopzera`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `atoresfilmestopzera`  AS SELECT `a`.`nome` AS `ator`, group_concat(`f`.`titulo` separator ', ') AS `filmes` FROM ((`ator` `a` join `filme_ator` `fa` on(`a`.`id` = `fa`.`ator_id`)) join `filme` `f` on(`fa`.`filme_id` = `f`.`id`)) GROUP BY `a`.`nome` ;

-- --------------------------------------------------------

--
-- Estrutura para view `filmestopzera_categorias_atores`
--
DROP TABLE IF EXISTS `filmestopzera_categorias_atores`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `filmestopzera_categorias_atores`  AS SELECT `f`.`titulo` AS `filme`, group_concat(distinct `c`.`nome` separator ', ') AS `categorias`, group_concat(distinct `a`.`nome` separator ', ') AS `atores` FROM ((((`filme` `f` left join `filme_categoria` `fc` on(`f`.`id` = `fc`.`filme_id`)) left join `categoria` `c` on(`fc`.`categoria_id` = `c`.`id`)) left join `filme_ator` `fa` on(`f`.`id` = `fa`.`filme_id`)) left join `ator` `a` on(`fa`.`ator_id` = `a`.`id`)) GROUP BY `f`.`titulo` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `aluguel`
--
ALTER TABLE `aluguel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `funcionario_id` (`funcionario_id`);

--
-- Índices de tabela `ator`
--
ALTER TABLE `ator`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_cliente_cpf` (`cpf`),
  ADD KEY `loja_id` (`loja_id`);

--
-- Índices de tabela `estoque`
--
ALTER TABLE `estoque`
  ADD PRIMARY KEY (`id`),
  ADD KEY `filme_id` (`filme_id`),
  ADD KEY `loja_id` (`loja_id`);

--
-- Índices de tabela `filme`
--
ALTER TABLE `filme`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `filme_ator`
--
ALTER TABLE `filme_ator`
  ADD PRIMARY KEY (`filme_id`,`ator_id`),
  ADD KEY `ator_id` (`ator_id`);

--
-- Índices de tabela `filme_categoria`
--
ALTER TABLE `filme_categoria`
  ADD PRIMARY KEY (`filme_id`,`categoria_id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Índices de tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loja_id` (`loja_id`);

--
-- Índices de tabela `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `filme_id` (`filme_id`),
  ADD KEY `aluguel_id` (`aluguel_id`);

--
-- Índices de tabela `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`reg`);

--
-- Índices de tabela `loja`
--
ALTER TABLE `loja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gerente_id` (`gerente_id`);

--
-- Índices de tabela `pagamento`
--
ALTER TABLE `pagamento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aluguel_id` (`aluguel_id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `funcionario_id` (`funcionario_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `log`
--
ALTER TABLE `log`
  MODIFY `reg` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `aluguel`
--
ALTER TABLE `aluguel`
  ADD CONSTRAINT `aluguel_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`),
  ADD CONSTRAINT `aluguel_ibfk_2` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id`);

--
-- Restrições para tabelas `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`loja_id`) REFERENCES `loja` (`id`);

--
-- Restrições para tabelas `estoque`
--
ALTER TABLE `estoque`
  ADD CONSTRAINT `estoque_ibfk_1` FOREIGN KEY (`filme_id`) REFERENCES `filme` (`id`),
  ADD CONSTRAINT `estoque_ibfk_2` FOREIGN KEY (`loja_id`) REFERENCES `loja` (`id`);

--
-- Restrições para tabelas `filme_ator`
--
ALTER TABLE `filme_ator`
  ADD CONSTRAINT `filme_ator_ibfk_1` FOREIGN KEY (`filme_id`) REFERENCES `filme` (`id`),
  ADD CONSTRAINT `filme_ator_ibfk_2` FOREIGN KEY (`ator_id`) REFERENCES `ator` (`id`);

--
-- Restrições para tabelas `filme_categoria`
--
ALTER TABLE `filme_categoria`
  ADD CONSTRAINT `filme_categoria_ibfk_1` FOREIGN KEY (`filme_id`) REFERENCES `filme` (`id`),
  ADD CONSTRAINT `filme_categoria_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id`);

--
-- Restrições para tabelas `funcionario`
--
ALTER TABLE `funcionario`
  ADD CONSTRAINT `funcionario_ibfk_1` FOREIGN KEY (`loja_id`) REFERENCES `loja` (`id`);

--
-- Restrições para tabelas `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `item_ibfk_1` FOREIGN KEY (`filme_id`) REFERENCES `filme` (`id`),
  ADD CONSTRAINT `item_ibfk_2` FOREIGN KEY (`aluguel_id`) REFERENCES `aluguel` (`id`);

--
-- Restrições para tabelas `loja`
--
ALTER TABLE `loja`
  ADD CONSTRAINT `loja_ibfk_1` FOREIGN KEY (`gerente_id`) REFERENCES `funcionario` (`id`);

--
-- Restrições para tabelas `pagamento`
--
ALTER TABLE `pagamento`
  ADD CONSTRAINT `pagamento_ibfk_1` FOREIGN KEY (`aluguel_id`) REFERENCES `aluguel` (`id`),
  ADD CONSTRAINT `pagamento_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`),
  ADD CONSTRAINT `pagamento_ibfk_3` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
