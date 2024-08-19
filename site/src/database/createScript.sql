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
    login VARCHAR(45) NOT NULL,
    senha VARCHAR(45) NOT NULL,
    fkEmpresa INT NOT NULL,
    fkSupervisor INT,
    CONSTRAINT pkFuncionario primary key (idFuncionario, fkEmpresa),
    CONSTRAINT fkEmpresaSupervisor foreign key (fkEmpresa) references empresa(idEmpresa),
    CONSTRAINT fkSupervisorFuncionario foreign key (fkSupervisor) references funcionario(idFuncionario), 
    CONSTRAINT ckCargo CHECK (cargo IN ("gerente","analista","funcionario"))

);


CREATE TABLE armazenamento(
	idArmazenamento INT primary key auto_increment,
    tipo VARCHAR(45) NOT NULL,
    tamanho INT NOT NULL, 
    CONSTRAINT chkTipo CHECK (tipo IN ('SSD', 'HD'))
);

CREATE TABLE notebook(
	idNotebook INT auto_increment,
    marca VARCHAR(30) NOT NULL,
    modelo VARCHAR(45) NOT NULL,
    memoriaRAM INT NOT NULL,
    processador VARCHAR(25) NOT NULL,
    fkArmazenamento INT NOT NULL,
    CONSTRAINT fkArmazenamentoNotebook foreign key (fkArmazenamento) references armazenamento(idArmazenamento),
    CONSTRAINT pkNotebook primary key (idNotebook, fkArmazenamento)
);

CREATE TABLE controleFluxo(
	idControleFluxo INT NOT NULL,
    dtInicio DATE NOT NULL,
    dtSaida DATE,
    fkFuncionario INT NOT NULL,
    fkNotebook INT NOT NULL,
    CONSTRAINT pkControleFluxo primary key (idControleFluxo, fkFuncionario, fkNotebook),
    CONSTRAINT fkFuncionarioControleFluxo foreign key (fkFuncionario) references funcionario(idFuncionario),
    CONSTRAINT fkNotebookControleFluxo foreign key (fkNotebook) references notebook(idNotebook)
);

CREATE TABLE dados(
    idDados INT not null,
    processador decimal(5,2),
    armazenamento decimal(5,2),
    RAM decimal(5,2),
    dataHora datetime,
    fkNotebook int,
    constraint pkDados primary key (idDados, fkNotebook),
    constraint fkNotebookDados foreign key (fkNotebook) references notebook(idNotebook)
);

-- TROCAR CEP NA MODELAGEM PARA CHAR RESUMIR NOMES DAS FK
-- COLOCAR DUAS ULTIMAS TABELAS COM NOT NULL