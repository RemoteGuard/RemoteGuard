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
('notebook3', 'Lenovo', 'ThinkPad X1', 16, 'Intel Core i5');

INSERT INTO empresa (razaoSocial, nomeFantasia, cep, numero, telefone, email, cnpj, token) VALUES 
    ('Amazon', 'Amazon', '98765432', '2350', '11999999999', 'amazon@gmail.com', '88888888888888', '123456789'),
    ('Google', 'Google', '98765432', '2390', '11956999999', 'google@gmail.com', '2882288283888', '987654321');

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

insert into alerta (descricao,fkNotebook) values 
('Recurso: CPU acima da capacidade ideal na Máquina (IsabelaGoulart).', 1);

SELECT COUNT(idAlerta) FROM alerta WHERE fkNotebook = 4 AND descricao LIKE "Processo indevido%";
SELECT COUNT(idAlerta) FROM alerta WHERE fkNotebook = 1 AND descricao LIKE "Recurso%";

SELECT TRUNCATE(AVG(qtdAlertas), 2) AS mediaAlertas
FROM (
    SELECT COUNT(idAlerta) AS qtdAlertas
    FROM alerta
    WHERE dataHora >= NOW() - INTERVAL 7 DAY
    GROUP BY fkNotebook
) AS mediaAlertas;

SELECT f.nome AS nome, COUNT(a.idAlerta) AS qtdAlertas
FROM alerta AS a
JOIN notebook AS n ON a.fkNotebook = n.idNotebook
JOIN funcionario AS f ON f.fkNotebook = n.idNotebook
GROUP BY f.idFuncionario
ORDER BY qtdAlertas DESC;



-- Inserindo mais 5 funcionários
INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa, fkNotebook)
VALUES 
    ('Analista', 'João Silva', '11111111111', 'joao.silva@empresa.com', 'senha123', 1, 1),
    ('Gerente', 'Maria Oliveira', '22222222222', 'maria.oliveira@empresa.com', 'senha456', 1, 2),
    ('Desenvolvedor', 'Carlos Santos', '33333333333', 'carlos.santos@empresa.com', 'senha789', 2, 3),
    ('Suporte', 'Ana Souza', '44444444444', 'ana.souza@empresa.com', 'senha101', 2, 1),
    ('Coordenador', 'Pedro Lima', '55555555555', 'pedro.lima@empresa.com', 'senha202', 2, 2);

-- Inserindo pelo menos um alerta para o notebook de cada funcionário
INSERT INTO alerta (codigo, descricao, fkNotebook)
VALUES 
    ('A01', 'Recurso:uso de CPU acima do limite', 1),
    ('A02', 'Recurso:uso de memória RAM alto', 2),
    ('A03', 'Recurso:uso disco próximo da capacidade máxima', 3),
    ('A04', 'Processo indevido em execução', 1);






