DROP DATABASE IF EXISTS remote_guard;
CREATE DATABASE IF NOT EXISTS remote_guard;

USE remote_guard;

CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(100) NOT NULL,
    nomeFantasia VARCHAR(100),
    cep CHAR(8) NOT NULL,
    numero VARCHAR(4) NOT NULL,
    telefone CHAR(11) NOT NULL,
    email VARCHAR(50) NOT NULL,
    cnpj CHAR(14),
    token CHAR(9)
);

CREATE TABLE IF NOT EXISTS notebook (
    idNotebook INT PRIMARY KEY AUTO_INCREMENT,
    hostname VARCHAR(100),
    marca VARCHAR(30) ,
    modelo VARCHAR(45),
    memoriaRAM INT,
    processador VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS funcionario (
    idFuncionario INT AUTO_INCREMENT,
    cargo VARCHAR(45) NOT NULL,
    nome VARCHAR(60) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(50) NOT NULL,
    senha VARCHAR(20) NOT NULL,
    fotoPerfil TEXT,
    fkEmpresa INT NOT NULL,
    fkSupervisor INT,
    fkNotebook INT,
    CONSTRAINT pkFuncionario PRIMARY KEY (idFuncionario),
    CONSTRAINT fkEmpresaFuncionario FOREIGN KEY (fkEmpresa) 
        REFERENCES empresa(idEmpresa),
    CONSTRAINT fkSupervisorFuncionario FOREIGN KEY (fkSupervisor) 
        REFERENCES funcionario(idFuncionario),
    CONSTRAINT fkNotebookFuncionario FOREIGN KEY (fkNotebook)
        REFERENCES notebook(idNotebook)
);

CREATE TABLE IF NOT EXISTS armazenamento (
    idArmazenamento INT AUTO_INCREMENT,
    qtdDiscos INT,
    tamanhoTotal INT NOT NULL, 
    fkNotebook INT,
    CONSTRAINT pkArmazenamento PRIMARY KEY (idArmazenamento),
    CONSTRAINT fkNotebookArmazenamento FOREIGN KEY (fkNotebook) 
        REFERENCES notebook(idNotebook)
);

CREATE TABLE IF NOT EXISTS controleFluxo (
    idControleFluxo INT AUTO_INCREMENT,
    dtInicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dtSaida DATETIME,
    fkFuncionario INT NOT NULL,
    fkNotebook INT NOT NULL,
    CONSTRAINT pkControleFluxo PRIMARY KEY (idControleFluxo),
    CONSTRAINT fkFuncionarioControleFluxo FOREIGN KEY (fkFuncionario) 
        REFERENCES funcionario(idFuncionario),
    CONSTRAINT fkNotebookControleFluxo FOREIGN KEY (fkNotebook) 
        REFERENCES notebook(idNotebook)
);

CREATE TABLE IF NOT EXISTS processos (
    idProcesso INT AUTO_INCREMENT,
    dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nomeProcesso VARCHAR(80),
    fkNotebook INT,
    CONSTRAINT pkProcessos PRIMARY KEY (idProcesso),
    CONSTRAINT fkNotebookProcessos FOREIGN KEY (fkNotebook) 
        REFERENCES notebook(idNotebook)
);

CREATE TABLE IF NOT EXISTS dados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fkNotebook INT,
    tempo_inatividade_cpu FLOAT,
    porcentagem_cpu FLOAT,
    bytes_ram BIGINT,
    porcentagem_ram FLOAT,
    bytes_disco BIGINT,
    porcentagem_disco FLOAT,
    processos INT,
    numero_nucleos INT,
    media_ponderada DOUBLE,
    leitura_disco INT,
    escrita_disco INT,
    boot_time DATETIME,
    data_captura timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fkNotebookDados FOREIGN KEY (fkNotebook) 
        REFERENCES notebook(idNotebook)
);

CREATE TABLE IF NOT EXISTS alerta (
idAlerta INT AUTO_INCREMENT PRIMARY KEY,
dataHora timestamp DEFAULT CURRENT_TIMESTAMP,
codigo VARCHAR(100),
descricao VARCHAR(900),
fkNotebook INT,
CONSTRAINT fkNotebookAlerta FOREIGN KEY (fkNotebook)
	REFERENCES notebook(idNotebook)
);

INSERT INTO notebook (hostname, marca, modelo, memoriaRAM, processador) VALUES
    ('notebook1', 'Dell', 'XPS 13', 16, 'Intel Core i7'),
    ('notebook2', 'Apple', 'MacBook Pro', 32, 'Apple M1'),
    ('notebook3', 'Lenovo', 'ThinkPad X1', 16, 'Intel Core i5'),
    ('notebook4', 'HP', 'Spectre x360', 8, 'Intel Core i5'),
    ('notebook5', 'Asus', 'ZenBook 14', 16, 'AMD Ryzen 7');


INSERT INTO empresa (razaoSocial, nomeFantasia, cep, numero, telefone, email, cnpj, token) VALUES 
    ('Amazon', 'Amazon', '98765432', '2350', '11999999999', 'amazon@gmail.com', '88888888888888', '123456789'),
    ('Google', 'Google', '98765432', '2390', '11956999999', 'google@gmail.com', '2882288283888', '987654321'),
    ('Microsoft', 'MSFT', '12345678', '4567', '11911122333', 'microsoft@outlook.com', '12312312312312', '112233445'),
    ('Facebook', 'Meta', '23456789', '7890', '11955566777', 'meta@facebook.com', '54354354354321', '998877665'),
    ('Tesla', 'Tesla Motors', '34567890', '1357', '11988889999', 'contact@tesla.com', '77777777777777', '443322110');


INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa, fkSupervisor, fkNotebook) VALUES 
    ('Gerente', 'Ana Silva', '12345678901', 'ana@empresa.com', 'senha123', 1, NULL, 1),
    ('Analista', 'Carlos Souza', '23456789012', 'carlos@empresa.com', 'senha123', 1, 1, 2),
    ('Assistente', 'Isabela Goulart', '34567890123', 'isabela@empresa.com', 'senha123', 2, NULL, 3),
    ('Desenvolvedor', 'João Oliveira', '45678901234', 'joao@empresa.com', 'senha123', 2, 3, 4),
    ('Coordenador', 'Roberta Costa', '56789012345', 'roberta@empresa.com', 'senha123', 3, 2, 5);

INSERT INTO armazenamento (qtdDiscos, tamanhoTotal, fkNotebook) VALUES 
    (2, 512, 1),
    (1, 256, 2),
    (3, 1024, 3),
    (2, 512, 4),
    (4, 2048, 5);

INSERT INTO controleFluxo (dtInicio, dtSaida, fkFuncionario, fkNotebook) VALUES 
    ('2024-11-12 08:00:00', '2024-11-12 17:00:00', 1, 1),
    ('2024-11-12 08:30:00', '2024-11-12 17:30:00', 2, 2),
    ('2024-11-12 09:00:00', '2024-11-12 18:00:00', 3, 3),
    ('2024-11-12 09:30:00', '2024-11-12 18:30:00', 4, 4),
    ('2024-11-12 10:00:00', '2024-11-12 19:00:00', 5, 5);


INSERT INTO processos (nomeProcesso, fkNotebook) VALUES
    ('Chrome', 1),
    ('VSCode', 2),
    ('Slack', 3),
    ('Docker', 4),
    ('Skype', 5);



SELECT porcentagem_ram FROM dados WHERE fkNotebook = 1;


Insert into dados(porcentagem_cpu,porcentagem_ram,porcentagem_disco,fkNotebook) values
(40,50,60,2);
SELECT * FROM empresa;
SELECT * FROM notebook;
SELECT * FROM funcionario;
SELECT * FROM armazenamento;
SELECT * FROM processos;
SELECT * FROM dados;
SELECT * FROM alerta;





insert into alerta (descricao, fkNotebook) values ('Processo indevido rodando na máquina (IsabelaGoulart)!.', 1);
SELECT COUNT(idAlerta) FROM alerta WHERE fkNotebook = 4 AND descricao LIKE "Processo indevido%";
SELECT COUNT(idAlerta) FROM alerta WHERE fkNotebook = 1 AND descricao LIKE "Recurso%";