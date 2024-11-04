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
    email VARCHAR(50) NOT NULL,
    cnpj CHAR(14),
    token char(9)
);
SELECT * FROM empresa;

CREATE TABLE notebook(
	idNotebook INT PRIMARY KEY AUTO_INCREMENT,
    hostname varchar(100),
    marca VARCHAR(30) NOT NULL,
    modelo VARCHAR(45) NOT NULL,
    memoriaRAM INT NOT NULL,
    processador VARCHAR(25) NOT NULL
) AUTO_INCREMENT = 1100;

CREATE TABLE funcionario (
	idFuncionario INT AUTO_INCREMENT,
    cargo VARCHAR(45) NOT NULL,
    nome VARCHAR(60) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(50) NOT NULL,
    senha VARCHAR(20) NOT NULL,
    fotoPerfil TEXT,
    fkEmpresa INT NOT NULL,
    fkSupervisor INT,
    fkNotebook int,
    CONSTRAINT pkFuncionario PRIMARY KEY (idFuncionario, fkEmpresa),
    CONSTRAINT fkEmpresaFuncionario FOREIGN KEY (fkEmpresa) 
		REFERENCES empresa(idEmpresa),
    CONSTRAINT fkSupervisorFuncionario FOREIGN KEY (fkSupervisor) 
		REFERENCES funcionario(idFuncionario),
	CONSTRAINT fkNotebookFuncionario foreign key (fkNotebook)
		REFERENCES notebook(idNotebook)
) AUTO_INCREMENT = 1000;


CREATE TABLE armazenamento(
	idArmazenamento INT AUTO_INCREMENT,
    qtdDiscos int,
    tamanhoTotal INT NOT NULL, 
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



CREATE TABLE processos(
	idProcesso INT AUTO_INCREMENT,
    dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nomeProcesso VARCHAR(80),
	fkNotebook INT,
    CONSTRAINT pkProcessos PRIMARY KEY (idProcesso, fkNotebook),
    CONSTRAINT fkNotebookProcessos FOREIGN KEY (fkNotebook) 
		REFERENCES notebook(idNotebook)
);


CREATE TABLE IF NOT EXISTS dados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hostname VARCHAR(255) NOT NULL,
    fkNotebook INT,
    tempo_inatividade_cpu FLOAT,
    porcentagem_cpu FLOAT,
    bytes_ram BIGINT,
    porcentagem_ram FLOAT,
    bytes_disco BIGINT,
    porcentagem_disco FLOAT,
    processos INT,
    bytes_swap BIGINT,
    porcentagem_swap FLOAT,
    boot_time DATETIME,
    data_captura timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fkNotebookDados FOREIGN KEY (fkNotebook) 
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




INSERT INTO notebook (hostname, marca, modelo, memoriaRAM, processador) VALUES
('notebook1', 'Dell', 'XPS 13', 16, 'Intel Core i7'),
('notebook2', 'Apple', 'MacBook Pro', 32, 'Apple M1'),
('notebook3', 'Lenovo', 'ThinkPad X1', 16, 'Intel Core i5');

INSERT INTO empresa VALUES 
	(DEFAULT, 'Amazon', 'Amazon', '98765432', '2350', '11999999999', 'amazon@gmail.com', '88888888888888', '123456789');

INSERT INTO empresa VALUES 
	(DEFAULT, 'Google', 'Google', '98765432', '2390', '11956999999', 'google@gmail.com', '2882288283888', '987654321');

select * from empresa;
SELECT * FROM funcionario;
select * from armazenamento;
SELECT * FROM notebook;
SELECT * FROM dados;
SELECT * FROM processos;