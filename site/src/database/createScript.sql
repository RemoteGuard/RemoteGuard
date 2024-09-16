DROP DATABASE IF EXISTS RemoteGuard;

CREATE DATABASE remoteGuard;

USE remoteGuard;

CREATE TABLE empresa(
	idEmpresa int primary key  auto_increment,
    razaoSocial VARCHAR(100) NOT NULL,
    nomeFantasia VARCHAR(100),
    cep CHAR(8) NOT NULL,
    numero VARCHAR(4) NOT NULL,
    telefone CHAR(11) NOT NULL,
    email VARCHAR(40) NOT NULL,
    cnpj CHAR(14)
);

CREATE TABLE funcionario(
	idfuncionario INT auto_increment NOT NULL,
    cargo VARCHAR(45) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(45) NOT NULL,
    senha VARCHAR(45) NOT NULL,
    fotoPerfil text,
    fkEmpresa INT NOT NULL,
    fkSupervisor INT,
    CONSTRAINT pkFuncionario primary key (idFuncionario, fkEmpresa),
    CONSTRAINT fkEmpresaSupervisor foreign key (fkEmpresa) references empresa(idEmpresa),
    CONSTRAINT fkSupervisorFuncionario foreign key (fkSupervisor) references funcionario(idFuncionario), 
    CONSTRAINT ckCargo CHECK (cargo IN ("gerente","analista","funcionario"))

);


select * from notebook;
CREATE TABLE notebook(
	idNotebook int primary key,
    nome varchar(100),
    marca VARCHAR(30) NOT NULL,
    modelo VARCHAR(45) NOT NULL,
    memoriaRAM INT NOT NULL,
    processador VARCHAR(25) NOT NULL
);

CREATE TABLE armazenamento(
	idArmazenamento INT auto_increment,
    tipo VARCHAR(45) NOT NULL,
    tamanho INT NOT NULL, 
    fkNotebook int,
    CONSTRAINT pkArmazenamento  primary key(idArmazenamento, fkNotebook),
    CONSTRAINT fkNotebookArmazenamento foreign key (fkNotebook) references notebook(idNotebook),
    CONSTRAINT chkTipo CHECK (tipo IN ('SSD', 'HD'))
);



CREATE TABLE controleFluxo(
	idControleFluxo INT NOT NULL auto_increment,
    dtInicio timestamp default current_timestamp,
    dtSaida DATE,
    fkFuncionario INT NOT NULL,
    fkNotebook int NOT NULL,
    CONSTRAINT pkControleFluxo primary key (idControleFluxo, fkFuncionario, fkNotebook),
    CONSTRAINT fkFuncionarioControleFluxo foreign key (fkFuncionario) references funcionario(idFuncionario),
    CONSTRAINT fkNotebookControleFluxo foreign key (fkNotebook) references notebook(idNotebook)
);

CREATE TABLE dados(
	idDados int auto_increment,
	dataHora timestamp default current_timestamp,
	percCPU decimal(5,2),
    tempoInativo decimal(10,2),
	percRAM decimal(5,2),
    usedRAM decimal(7,2),
    percDisc decimal(5,2),
    usedDisc decimal(7,2),
    fkNotebook int,
    constraint pkDados primary key (idDados, fkNotebook),
    constraint fkNotebookDados foreign key (fkNotebook) references notebook(idNotebook)
    );

CREATE TABLE processos(
	idProcesso int auto_increment,
    dataHora timestamp default current_timestamp,
    nomeProcesso varchar(80),
	fkNotebook int,
    constraint pkProcessos primary key (idProcesso, fkNotebook),
    constraint fkNotebookProcessos foreign key (fkNotebook) references notebook(idNotebook)
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



