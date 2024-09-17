DROP DATABASE IF EXISTS remote_guard;

CREATE DATABASE remote_guard;

USE remote_guard;

CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(100) NOT NULL,
    nomeFantasia VARCHAR(100),
    cep CHAR(8) NOT NULL,
    numero VARCHAR(4) NOT NULL,
    telefone CHAR(11) NOT NULL,
    email VARCHAR(40) NOT NULL,
    cnpj CHAR(14)
) AUTO_INCREMENT = 100;

CREATE TABLE funcionario (
	idFuncionario INT AUTO_INCREMENT,
    cargo VARCHAR(45) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(45) NOT NULL,
    senha VARCHAR(45) NOT NULL,
    fotoPerfil TEXT,
    fkEmpresa INT NOT NULL,
    fkSupervisor INT,
    CONSTRAINT pkFuncionario PRIMARY KEY (idFuncionario, fkEmpresa),
    CONSTRAINT fkEmpresaFuncionario FOREIGN KEY (fkEmpresa) 
		REFERENCES empresa(idEmpresa),
    CONSTRAINT fkSupervisorFuncionario FOREIGN KEY (fkSupervisor) 
		REFERENCES funcionario(idFuncionario)
) AUTO_INCREMENT = 1000;


CREATE TABLE notebook(
	idNotebook INT PRIMARY KEY AUTO_INCREMENT,
    hostname varchar(100)
    -- marca VARCHAR(30) NOT NULL,
    -- modelo VARCHAR(45) NOT NULL,
    -- memoriaRAM INT NOT NULL,
    -- processador VARCHAR(25) NOT NULL
) AUTO_INCREMENT = 1100;

CREATE TABLE armazenamento(
	idArmazenamento INT AUTO_INCREMENT,
    tipo ENUM('SSD', 'HD'),
    tamanho INT NOT NULL, 
    fkNotebook INT,
    CONSTRAINT pkArmazenamento  PRIMARY KEY (idArmazenamento, fkNotebook),
    CONSTRAINT fkNotebookArmazenamento FOREIGN KEY (fkNotebook) 
		REFERENCES notebook(idNotebook)
);

CREATE TABLE controleFluxo(
	idControleFluxo INT AUTO_INCREMENT,
    dtInicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dtSaida DATETIME,
    fkFuncionario INT NOT NULL,
    fkNotebook INT NOT NULL,
    CONSTRAINT pkControleFluxo PRIMARY KEY (idControleFluxo, fkFuncionario, fkNotebook),
    CONSTRAINT fkFuncionarioControleFluxo FOREIGN KEY (fkFuncionario) 
		REFERENCES funcionario(idFuncionario),
    CONSTRAINT fkNotebookControleFluxo FOREIGN KEY (fkNotebook) 
		REFERENCES notebook(idNotebook)
);

CREATE TABLE dados(
	idDados INT AUTO_INCREMENT,
	dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	tempoInatividade DOUBLE,
    percCPU DECIMAL(4,1),
    usedRAM DECIMAL(5,2),
	percRAM DECIMAL(4,1),
    usedDisk DECIMAL(7,2),
    percDisk DECIMAL(4,1),
    fkNotebook INT,
    CONSTRAINT pkDados PRIMARY KEY (idDados, fkNotebook),
    CONSTRAINT fkNotebookDados FOREIGN KEY (fkNotebook) 
		REFERENCES notebook(idNotebook)
    );

CREATE TABLE processos(
	idProcesso INT AUTO_INCREMENT,
    dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nomeProcesso VARCHAR(80),
	fkNotebook INT,
    CONSTRAINT pkProcessos PRIMARY KEY (idProcesso, fkNotebook),
    CONSTRAINT fkNotebookProcessos FOREIGN KEY (fkNotebook) 
		REFERENCES notebook(idNotebook)
);


-- CREATE VIEW notebook_um AS SELECT * FROM teste WHERE notebook = 1;
-- CREATE VIEW notebook_dois AS SELECT * FROM teste WHERE notebook = 2;
-- CREATE VIEW notebook_tres AS SELECT * FROM teste WHERE notebook = 3;
-- CREATE VIEW notebook_quatro AS SELECT * FROM teste WHERE notebook = 4;
-- CREATE VIEW notebook_cinco AS SELECT * FROM teste WHERE notebook = 5;

-- SELECT * FROM notebook_um;
-- SELECT * FROM notebook_dois;
-- SELECT * FROM notebook_tres;
-- SELECT * FROM notebook_quatro;
-- SELECT * FROM notebook_cinco;

SELECT * FROM funcionario;
SELECT * FROM notebook;
SELECT * FROM dados;

INSERT INTO empresa VALUES 
	(DEFAULT, 'Amazon', 'Amazon', '98765432', '2350', '11999999999', 'amazon@gmail.com', '88888888888888');

