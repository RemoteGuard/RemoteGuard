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
    qtdprocessos INT,
    processos LONGTEXT,
    boot_time DATETIME,
	numero_nucleos INT, 
    media_ponderada DOUBLE,
    tempo_alerta_cpu DOUBLE,
    tempo_alerta_ram DOUBLE,
    tempo_alerta_disco DOUBLE,
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

CREATE TABLE dadosAna (
id INT primary key AUTO_INCREMENT,
processo longtext,
dt date,
hora time,
fkFunc INT,
CONSTRAINT fkFuncionarioProcesso FOREIGN KEY (fkFunc) 
REFERENCES funcionario(idFuncionario)
);

INSERT INTO notebook (hostname, marca, modelo, memoriaRAM, processador) VALUES
('notebook1', 'HP', 'Pavilion', 8, 'AMD Ryzen 5'),
('notebook2', 'Acer', 'Aspire', 16, 'Intel Core i7'),
('notebook3', 'Asus', 'ZenBook', 16, 'Intel Core i5'),
('notebook4', 'HP', 'Pavilion', 8, 'AMD Ryzen 5'),
('notebook5', 'Acer', 'Aspire', 16, 'Intel Core i7'),
('notebook6', 'Asus', 'ZenBook', 16, 'Intel Core i5'),
('notebook7', 'HP', 'Pavilion', 8, 'AMD Ryzen 5'),
('notebook8', 'Acer', 'Aspire', 16, 'Intel Core i7'),
('notebook9', 'Asus', 'ZenBook', 16, 'Intel Core i5'),
('notebook10', 'HP', 'Pavilion', 8, 'AMD Ryzen 5'),
('notebook11', 'Acer', 'Aspire', 16, 'Intel Core i7'),
('notebook12', 'Asus', 'ZenBook', 16, 'Intel Core i5');

INSERT INTO empresa (razaoSocial, nomeFantasia, cep, numero, telefone, email, cnpj, token) VALUES 
    ('Amazon', 'Amazon', '98765432', '2350', '11999999999', 'amazon@gmail.com', '88888888888888', '123456789'),
    ('Google', 'Google', '98765432', '2390', '11956999999', 'google@gmail.com', '2882288283888', '987654321');

INSERT INTO dados (fkNotebook, tempo_inatividade_cpu, porcentagem_cpu, bytes_ram, porcentagem_ram, bytes_disco, porcentagem_disco, qtdprocessos, boot_time, numero_nucleos) VALUES
    (2, 0.5, 25.3, 8388608, 60.4, 500000000, 45.0, 150, '2024-11-10 08:30:00', 4),
    (4, 0.8, 35.2, 16384000, 70.8, 1000000000, 60.0, 200, '2024-11-10 08:35:00', 8);

INSERT INTO dados (porcentagem_cpu,porcentagem_ram,porcentagem_disco,qtdprocessos,tempo_alerta_cpu,tempo_alerta_ram,tempo_alerta_disco,fkNotebook) VALUES
(83,100,100,70,2,2,2,1);

INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa, fkNotebook) VALUES 
('Analista De Sistemas', 'Maria Santos', '12345678902', 'maria.santos@empresa.com', 'senha123', 1, 2),
('Analista De Sistemas', 'Carlos Oliveira', '12345678903', 'carlos.oliveira@empresa.com', 'senha123', 2, 3),
('Analista De Sistemas', 'Ana Costa', '12345678904', 'ana.costa@empresa.com', 'senha123', 2, 4),
('Analista De Sistemas', 'Lucas Pereira', '12345678905', 'lucas.pereira@empresa.com', 'senha123', 1, 5),
('Analista De Sistemas', 'Fernanda Lima', '12345678906', 'fernanda.lima@empresa.com', 'senha123', 1, 6);

select * from funcionario;


INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-27 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-27 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-27 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-27 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-26 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-26 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-26 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-26 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-24 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-24 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-24 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-24 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-23 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-23 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-23 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-23 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-22 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-22 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-22 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-22 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-21 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-21 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-21 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-21 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-20 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-20 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-20 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-20 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-19 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-19 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-19 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-19 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-18 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-18 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-18 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-18 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-17 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-17 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-17 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-17 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-16 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-16 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-16 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-16 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-15 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-15 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-15 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-15 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-14 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-14 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-14 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-14 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-13 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-13 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-13 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-13 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-12 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-12 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-12 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-12 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-11 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-11 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-11 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-11 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-10 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-10 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-10 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-10 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-09 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-09 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-09 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-09 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-08 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-08 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-08 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-08 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-07 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-07 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-07 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-07 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-06 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-06 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-06 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-06 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-05 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-05 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-05 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-05 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-04 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-04 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-04 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-04 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-03 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-03 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-03 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-03 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-02 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-02 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-02 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-02 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-11-01 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-11-01 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-11-01 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-01 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-10-31 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-10-31 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-10-31 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-10-31 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-10-30 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-10-30 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-10-30 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-10-30 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-001', 'Recurso: uso de CPU', 2, '2024-10-29 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-002', 'Recurso: uso de memória RAM', 3, '2024-10-29 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-003', 'Recurso: uso de disco próximo da capacidade máxima', 4, '2024-10-29 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-10-29 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 6, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 7, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 8, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 9, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 10, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 1, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 2, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 3, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 4, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 6, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 7, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 8, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 9, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 10, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook, dataHora) VALUES ('CS-004', 'Processo indevido em execução', 5, '2024-11-25 23:54:03');
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);
INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES ('CS-001', 'Recurso: uso de CPU', 2);


INSERT INTO dadosAna (processo, dt, hora, fkFunc) VALUES
-- Dia 1 de novembro
('python', '2024-11-01', '08:30', 1),
('vscode', '2024-11-01', '09:00', 1),
('chrome', '2024-11-01', '10:00', 1),
('fortnite.exe', '2024-11-01', '11:05', 1),
('fortnite.exe', '2024-11-01', '12:20', 1),
('gitbash', '2024-11-01', '13:15', 1),
('sql', '2024-11-01', '14:40', 1),

-- Dia 4 de novembro
('python', '2024-11-04', '08:25', 1),
('vscode', '2024-11-04', '09:10', 1),
('chrome', '2024-11-04', '10:35', 1),
('pubg.exe', '2024-11-04', '11:30', 1),
('pubg.exe', '2024-11-04', '12:45', 1),
('gitbash', '2024-11-04', '13:50', 1),
('sql', '2024-11-04', '15:00', 1),

-- Dia 5 de novembro
('python', '2024-11-05', '08:40', 1),
('vscode', '2024-11-05', '09:30', 1),
('chrome', '2024-11-05', '10:50', 1),
('valorant.exe', '2024-11-05', '11:55', 1),
('valorant.exe', '2024-11-05', '13:00', 1),
('gitbash', '2024-11-05', '14:10', 1),
('sql', '2024-11-05', '15:30', 1),

-- Dia 6 de novembro
('python', '2024-11-06', '08:15', 1),
('vscode', '2024-11-06', '09:25', 1),
('chrome', '2024-11-06', '10:10', 1),
('apex_legends.exe', '2024-11-06', '11:40', 1),
('apex_legends.exe', '2024-11-06', '12:50', 1),
('gitbash', '2024-11-06', '14:00', 1),
('sql', '2024-11-06', '15:05', 1),

-- Dia 7 de novembro
('python', '2024-11-07', '08:20', 1),
('vscode', '2024-11-07', '09:10', 1),
('chrome', '2024-11-07', '10:30', 1),
('dota2.exe', '2024-11-07', '11:10', 1),
('dota2.exe', '2024-11-07', '12:25', 1),
('gitbash', '2024-11-07', '13:05', 1),
('sql', '2024-11-07', '14:30', 1),

-- Dia 8 de novembro
('python', '2024-11-08', '08:00', 1),
('vscode', '2024-11-08', '09:20', 1),
('chrome', '2024-11-08', '10:15', 1),
('minecraft.exe', '2024-11-08', '11:05', 1),
('minecraft.exe', '2024-11-08', '12:35', 1),
('gitbash', '2024-11-08', '13:50', 1),
('sql', '2024-11-08', '14:40', 1),

-- Dia 11 de novembro
('python', '2024-11-11', '08:35', 1),
('vscode', '2024-11-11', '09:15', 1),
('chrome', '2024-11-11', '10:05', 1),
('fortnite.exe', '2024-11-11', '11:25', 1),
('fortnite.exe', '2024-11-11', '12:50', 1),
('gitbash', '2024-11-11', '13:10', 1),
('sql', '2024-11-11', '14:35', 1),

-- Dia 12 de novembro
('python', '2024-11-12', '08:50', 1),
('vscode', '2024-11-12', '09:40', 1),
('chrome', '2024-11-12', '10:30', 1),
('pubg.exe', '2024-11-12', '11:00', 1),
('pubg.exe', '2024-11-12', '12:20', 1),
('gitbash', '2024-11-12', '13:00', 1),
('sql', '2024-11-12', '14:10', 1),

-- Dia 13 de novembro
('python', '2024-11-13', '08:30', 1),
('vscode', '2024-11-13', '09:10', 1),
('chrome', '2024-11-13', '10:05', 1),
('valorant.exe', '2024-11-13', '11:20', 1),
('valorant.exe', '2024-11-13', '12:45', 1),
('gitbash', '2024-11-13', '13:40', 1),
('sql', '2024-11-13', '14:50', 1),

-- Dia 14 de novembro
('python', '2024-11-14', '08:45', 1),
('vscode', '2024-11-14', '09:25', 1),
('chrome', '2024-11-14', '10:10', 1),
('apex_legends.exe', '2024-11-14', '11:30', 1),
('apex_legends.exe', '2024-11-14', '12:40', 1),
('gitbash', '2024-11-14', '13:15', 1),
('sql', '2024-11-14', '14:25', 1),

-- Dia 15 de novembro
('python', '2024-11-15', '08:50', 1),
('vscode', '2024-11-15', '09:35', 1),
('chrome', '2024-11-15', '10:20', 1),
('dota2.exe', '2024-11-15', '10:00', 1),
('dota2.exe', '2024-11-15', '12:00', 1),
('gitbash', '2024-11-15', '13:00', 1),
('sql', '2024-11-15', '14:45', 1),

-- Dia 18 de novembro
('python', '2024-11-18', '08:40', 1),
('vscode', '2024-11-18', '09:00', 1),
('chrome', '2024-11-18', '10:10', 1),
('fortnite.exe', '2024-11-18', '11:15', 1),
('fortnite.exe', '2024-11-18', '12:30', 1),
('gitbash', '2024-11-18', '13:40', 1),
('sql', '2024-11-18', '14:50', 1),

-- Dia 19 de novembro
('python', '2024-11-19', '08:20', 1),
('vscode', '2024-11-19', '09:25', 1),
('chrome', '2024-11-19', '10:35', 1),
('pubg.exe', '2024-11-19', '11:00', 1),
('pubg.exe', '2024-11-19', '12:10', 1),
('gitbash', '2024-11-19', '13:30', 1),
('sql', '2024-11-19', '14:40', 1),

-- Inserção para o dia 20 de novembro (quarta-feira)
('python', '2024-11-20', '08:30', 1),
('vscode', '2024-11-20', '09:00', 1),
('chrome', '2024-11-20', '09:30', 1),
('valorant.exe', '2024-11-20', '10:00', 1),
('valorant.exe', '2024-11-20', '12:15', 1),
('gitbash', '2024-11-20', '13:00', 1),
('sql', '2024-11-20', '13:30', 1),

-- Inserção para o dia 21 de novembro (quinta-feira)
('python', '2024-11-21', '08:30', 1),
('vscode', '2024-11-21', '10:15', 1),
('chrome', '2024-11-21', '12:00', 1),
('apex_legends.exe', '2024-11-21', '13:45', 1),
('apex_legends.exe', '2024-11-21', '15:30', 1),
('gitbash', '2024-11-21', '17:00', 1),
('sql', '2024-11-21', '18:00', 1),

-- Inserção para o dia 22 de novembro (sexta-feira)
('python', '2024-11-22', '08:45', 1),
('vscode', '2024-11-22', '10:30', 1),
('chrome', '2024-11-22', '12:15', 1),
('valorant.exe', '2024-11-20', '13:00', 1),
('valorant.exe', '2024-11-20', '14:15', 1),
('gitbash', '2024-11-22', '16:00', 1),
('sql', '2024-11-22', '17:45', 1),

-- Inserção para o dia 25 de novembro (segunda-feira)
('python', '2024-11-25', '08:30', 1),
('vscode', '2024-11-25', '09:45', 1),
('chrome', '2024-11-25', '11:00', 1),
('fortnite.exe', '2024-11-25', '12:30', 1),
('fortnite.exe', '2024-11-25', '14:00', 1),
('gitbash', '2024-11-25', '15:30', 1),
('sql', '2024-11-25', '17:00', 1),

-- Inserção para o dia 26 de novembro (terça-feira)
('python', '2024-11-26', '08:00', 1),
('vscode', '2024-11-26', '09:30', 1),
('chrome', '2024-11-26', '11:15', 1),
('pubg.exe', '2024-11-26', '12:45', 1),
('pubg.exe', '2024-11-26', '14:15', 1),
('gitbash', '2024-11-26', '15:30', 1),
('sql', '2024-11-26', '17:00', 1),

-- Inserção para o dia 27 de novembro (quarta-feira)
('python', '2024-11-27', '08:30', 1),
('vscode', '2024-11-27', '10:00', 1),
('chrome', '2024-11-27', '11:30', 1),
('valorant.exe', '2024-11-27', '13:00', 1),
('valorant.exe', '2024-11-27', '14:30', 1),
('gitbash', '2024-11-27', '16:00', 1),
('sql', '2024-11-27', '17:30', 1),

-- Inserção para o dia 28 de novembro (quinta-feira)
('python', '2024-11-28', '08:45', 1),
('vscode', '2024-11-28', '10:30', 1),
('chrome', '2024-11-28', '12:00', 1),
('apex_legends.exe', '2024-11-28', '13:45', 1),
('apex_legends.exe', '2024-11-28', '15:00', 1),
('gitbash', '2024-11-28', '16:30', 1),
('sql', '2024-11-28', '17:45', 1),

-- Inserção para o dia 29 de novembro (sexta-feira)
('python', '2024-11-29', '08:00', 1),
('vscode', '2024-11-29', '09:30', 1),
('chrome', '2024-11-29', '11:00', 1),
('dota2.exe', '2024-11-29', '12:30', 1),
('dota2.exe', '2024-11-29', '14:00', 1),
('gitbash', '2024-11-29', '15:30', 1),
('sql', '2024-11-29', '17:00', 1),

-- Inserção para o dia 2 de dezembro (segunda-feira)
('python', '2024-12-02', '08:15', 1),
('vscode', '2024-12-02', '09:45', 1),
('chrome', '2024-12-02', '11:00', 1),
('fortnite.exe', '2024-12-02', '12:30', 1),
('fortnite.exe', '2024-12-02', '14:00', 1),
('gitbash', '2024-12-02', '15:45', 1),
('sql', '2024-12-02', '17:30', 1),

-- Inserção para o dia 3 de dezembro (terça-feira)
('python', '2024-12-03', '08:30', 1),
('vscode', '2024-12-03', '09:45', 1),
('chrome', '2024-12-03', '11:00', 1),
('pubg.exe', '2024-12-03', '12:45', 1),
('pubg.exe', '2024-12-03', '14:30', 1),
('gitbash', '2024-12-03', '16:00', 1),
('sql', '2024-12-03', '17:30', 1),

-- Inserção para o dia 4 de dezembro (quarta-feira)
('python', '2024-12-04', '08:00', 1),
('vscode', '2024-12-04', '09:30', 1),
('chrome', '2024-12-04', '11:00', 1),
('valorant.exe', '2024-12-04', '12:30', 1),
('valorant.exe', '2024-12-04', '14:00', 1),
('gitbash', '2024-12-04', '15:30', 1),
('sql', '2024-12-04', '17:00', 1),

-- Inserção para o dia 5 de dezembro (quinta-feira)
('python', '2024-12-05', '08:15', 1),
('vscode', '2024-12-05', '09:45', 1),
('chrome', '2024-12-05', '11:00', 1),
('apex_legends.exe', '2024-12-05', '12:30', 1),
('apex_legends.exe', '2024-12-05', '14:00', 1),
('gitbash', '2024-12-05', '15:30', 1),
('sql', '2024-12-05', '17:00', 1),


-- Inserção para o dia 1º de novembro (sexta-feira)
('python', '2024-11-01', '08:10', 2),
('vscode', '2024-11-01', '09:55', 2),
('chrome', '2024-11-01', '11:40', 2),
('apex_legends.exe', '2024-11-01', '13:25', 2),
('apex_legends.exe', '2024-11-01', '14:55', 2),
('gitbash', '2024-11-01', '16:05', 2),
('sql', '2024-11-01', '17:50', 2),

-- Inserção para o dia 4 de novembro (segunda-feira)
('python', '2024-11-04', '08:35', 2),
('vscode', '2024-11-04', '09:10', 2),
('chrome', '2024-11-04', '10:40', 2),
('valorant.exe', '2024-11-04', '12:25', 2),
('valorant.exe', '2024-11-04', '14:00', 2),
('gitbash', '2024-11-04', '15:30', 2),
('sql', '2024-11-04', '17:10', 2),

-- Inserção para o dia 5 de novembro (terça-feira)
('python', '2024-11-05', '08:45', 2),
('vscode', '2024-11-05', '10:00', 2),
('chrome', '2024-11-05', '11:30', 2),
('fortnite.exe', '2024-11-05', '13:40', 2),
('fortnite.exe', '2024-11-05', '15:05', 2),
('gitbash', '2024-11-05', '16:30', 2),
('sql', '2024-11-05', '17:55', 2),

-- Inserção para o dia 6 de novembro (quarta-feira)
('python', '2024-11-06', '08:55', 2),
('vscode', '2024-11-06', '10:25', 2),
('chrome', '2024-11-06', '11:50', 2),
('dota2.exe', '2024-11-06', '13:00', 2),
('dota2.exe', '2024-11-06', '14:45', 2),
('gitbash', '2024-11-06', '16:10', 2),
('sql', '2024-11-06', '17:30', 2),

-- Inserção para o dia 7 de novembro (quinta-feira)
('python', '2024-11-07', '08:05', 2),
('vscode', '2024-11-07', '09:40', 2),
('chrome', '2024-11-07', '11:15', 2),
('pubg.exe', '2024-11-07', '12:40', 2),
('pubg.exe', '2024-11-07', '14:00', 2),
('gitbash', '2024-11-07', '15:30', 2),
('sql', '2024-11-07', '16:50', 2),

-- Inserção para o dia 8 de novembro (sexta-feira)
('python', '2024-11-08', '08:20', 2),
('vscode', '2024-11-08', '09:50', 2),
('chrome', '2024-11-08', '11:10', 2),
('valorant.exe', '2024-11-08', '12:30', 2),
('valorant.exe', '2024-11-08', '14:10', 2),
('gitbash', '2024-11-08', '15:45', 2),
('sql', '2024-11-08', '17:00', 2),

-- Inserção para o dia 11 de novembro (segunda-feira)
('python', '2024-11-11', '08:50', 2),
('vscode', '2024-11-11', '09:25', 2),
('chrome', '2024-11-11', '10:55', 2),
('apex_legends.exe', '2024-11-11', '12:10', 2),
('apex_legends.exe', '2024-11-11', '13:50', 2),
('gitbash', '2024-11-11', '15:25', 2),
('sql', '2024-11-11', '17:00', 2),

-- Inserção para o dia 12 de novembro (terça-feira)
('python', '2024-11-12', '08:35', 2),
('vscode', '2024-11-12', '09:50', 2),
('chrome', '2024-11-12', '11:15', 2),
('fortnite.exe', '2024-11-12', '12:50', 2),
('fortnite.exe', '2024-11-12', '14:30', 2),
('gitbash', '2024-11-12', '16:00', 2),
('sql', '2024-11-12', '17:40', 2),

-- Inserção para o dia 13 de novembro (quarta-feira)
('python', '2024-11-13', '08:15', 2),
('vscode', '2024-11-13', '09:55', 2),
('chrome', '2024-11-13', '11:25', 2),
('pubg.exe', '2024-11-13', '13:40', 2),
('pubg.exe', '2024-11-13', '14:50', 2),
('gitbash', '2024-11-13', '16:10', 2),
('sql', '2024-11-13', '17:30', 2),

-- Inserção para o dia 14 de novembro (quinta-feira)
('python', '2024-11-14', '08:00', 2),
('vscode', '2024-11-14', '09:10', 2),
('chrome', '2024-11-14', '10:50', 2),
('valorant.exe', '2024-11-14', '12:30', 2),
('valorant.exe', '2024-11-14', '13:55', 2),
('gitbash', '2024-11-14', '15:25', 2),
('sql', '2024-11-14', '16:50', 2),

-- Inserção para o dia 15 de novembro (sexta-feira)
('python', '2024-11-15', '08:30', 2),
('vscode', '2024-11-15', '09:45', 2),
('chrome', '2024-11-15', '11:05', 2),
('valorant.exe', '2024-11-14', '11:00', 2),
('valorant.exe', '2024-11-14', '13:00', 2),
('gitbash', '2024-11-15', '15:20', 2),
('sql', '2024-11-15', '16:45', 2),

-- Inserção para o dia 18 de novembro (segunda-feira)
('python', '2024-11-18', '08:10', 2),
('vscode', '2024-11-18', '09:25', 2),
('chrome', '2024-11-18', '11:00', 2),
('dota2.exe', '2024-11-19', '12:30', 2),
('dota2.exe', '2024-11-19', '14:00', 2),
('gitbash', '2024-11-18', '15:10', 2),
('sql', '2024-11-18', '16:30', 2),

-- Inserção para o dia 19 de novembro (terça-feira)
('python', '2024-11-19', '08:25', 2),
('vscode', '2024-11-19', '09:50', 2),
('chrome', '2024-11-19', '11:20', 2),
('fortnite.exe', '2024-11-18', '12:30', 2),
('fortnite.exe', '2024-11-18', '13:30', 2),
('gitbash', '2024-11-19', '15:40', 2),

-- Inserção para o dia 20 de novembro (quarta-feira)
('python', '2024-11-20', '08:30', 2),
('vscode', '2024-11-20', '09:55', 2),
('chrome', '2024-11-20', '11:40', 2),
('apex_legends.exe', '2024-11-20', '13:00', 2),
('apex_legends.exe', '2024-11-20', '14:35', 2),
('gitbash', '2024-11-20', '16:00', 2),
('sql', '2024-11-20', '17:25', 2),

-- Inserção para o dia 21 de novembro (quinta-feira)
('python', '2024-11-21', '08:45', 2),
('vscode', '2024-11-21', '09:30', 2),
('chrome', '2024-11-21', '11:00', 2),
('valorant.exe', '2024-11-21', '12:10', 2),
('valorant.exe', '2024-11-21', '13:30', 2),
('gitbash', '2024-11-21', '15:05', 2),
('sql', '2024-11-21', '16:50', 2),

-- Inserção para o dia 22 de novembro (sexta-feira)
('python', '2024-11-22', '08:30', 2),
('vscode', '2024-11-22', '09:55', 2),
('chrome', '2024-11-22', '11:40', 2),
('apex_legends.exe', '2024-11-22', '13:00', 2),
('apex_legends.exe', '2024-11-22', '14:35', 2),
('gitbash', '2024-11-22', '16:00', 2),
('sql', '2024-11-22', '17:25', 2),

-- Inserção para o dia 25 de novembro (segunda-feira)
('python', '2024-11-25', '08:10', 2),
('vscode', '2024-11-25', '09:40', 2),
('chrome', '2024-11-25', '11:05', 2),
('valorant.exe', '2024-11-25', '12:30', 2),
('valorant.exe', '2024-11-25', '14:00', 2),
('gitbash', '2024-11-25', '15:35', 2),
('sql', '2024-11-25', '16:50', 2),

-- Inserção para o dia 26 de novembro (terça-feira)
('python', '2024-11-26', '08:20', 2),
('vscode', '2024-11-26', '09:45', 2),
('chrome', '2024-11-26', '11:25', 2),
('fortnite.exe', '2024-11-26', '12:50', 2),
('fortnite.exe', '2024-11-26', '14:15', 2),
('gitbash', '2024-11-26', '15:50', 2),
('sql', '2024-11-26', '17:05', 2),

-- Inserção para o dia 27 de novembro (quarta-feira)
('python', '2024-11-27', '08:30', 2),
('vscode', '2024-11-27', '09:10', 2),
('chrome', '2024-11-27', '11:00', 2),
('dota2.exe', '2024-11-27', '12:40', 2),
('dota2.exe', '2024-11-27', '14:00', 2),
('gitbash', '2024-11-27', '15:25', 2),
('sql', '2024-11-27', '16:50', 2),

-- Inserção para o dia 28 de novembro (quinta-feira)
('python', '2024-11-28', '08:15', 2),
('vscode', '2024-11-28', '09:50', 2),
('chrome', '2024-11-28', '11:35', 2),
('pubg.exe', '2024-11-28', '13:05', 2),
('pubg.exe', '2024-11-28', '14:30', 2),
('gitbash', '2024-11-28', '15:55', 2),
('sql', '2024-11-28', '17:00', 2),

-- Inserção para o dia 29 de novembro (sexta-feira)
('python', '2024-11-29', '08:45', 2),
('vscode', '2024-11-29', '09:25', 2),
('chrome', '2024-11-29', '11:05', 2),
('apex_legends.exe', '2024-11-29', '12:25', 2),
('apex_legends.exe', '2024-11-29', '14:00', 2),
('gitbash', '2024-11-29', '15:40', 2),
('sql', '2024-11-29', '17:15', 2),

-- Inserção para o dia 02 de dezembro (segunda-feira)
('python', '2024-12-02', '08:30', 2),
('vscode', '2024-12-02', '09:55', 2),
('chrome', '2024-12-02', '11:25', 2),
('valorant.exe', '2024-12-02', '12:40', 2),
('valorant.exe', '2024-12-02', '14:00', 2),
('gitbash', '2024-12-02', '15:30', 2),
('sql', '2024-12-02', '17:00', 2),

-- Inserção para o dia 03 de dezembro (terça-feira)
('python', '2024-12-03', '08:00', 2),
('vscode', '2024-12-03', '09:40', 2),
('chrome', '2024-12-03', '11:10', 2),
('fortnite.exe', '2024-12-03', '12:35', 2),
('fortnite.exe', '2024-12-03', '14:05', 2),
('gitbash', '2024-12-03', '15:40', 2),
('sql', '2024-12-03', '17:25', 2),

-- Inserção para o dia 04 de dezembro (quarta-feira)
('python', '2024-12-04', '08:30', 2),
('vscode', '2024-12-04', '09:45', 2),
('chrome', '2024-12-04', '11:30', 2),
('dota2.exe', '2024-12-04', '13:05', 2),
('dota2.exe', '2024-12-04', '14:45', 2),
('gitbash', '2024-12-04', '16:00', 2),
('sql', '2024-12-04', '17:10', 2),

-- Inserção para o dia 05 de dezembro (quinta-feira)
('python', '2024-12-05', '08:20', 2),
('vscode', '2024-12-05', '09:55', 2),
('chrome', '2024-12-05', '11:00', 2),
('valorant.exe', '2024-12-05', '12:20', 2),
('valorant.exe', '2024-12-05', '13:40', 2),
('gitbash', '2024-12-05', '15:30', 2),
('sql', '2024-12-05', '17:00', 2),

-- Inserção para o dia 1 de novembro (sexta-feira)
('python', '2024-11-01', '08:10', 3),
('vscode', '2024-11-01', '09:20', 3),
('chrome', '2024-11-01', '10:30', 3),
('pubg.exe', '2024-11-01', '11:40', 3),
('pubg.exe', '2024-11-01', '12:50', 3),
('gitbash', '2024-11-01', '13:30', 3),
('sql', '2024-11-01', '14:45', 3),

-- Inserção para o dia 4 de novembro (segunda-feira)
('python', '2024-11-04', '08:25', 3),
('vscode', '2024-11-04', '09:35', 3),
('chrome', '2024-11-04', '10:20', 3),
('valorant.exe', '2024-11-04', '11:00', 3),
('valorant.exe', '2024-11-04', '12:10', 3),
('gitbash', '2024-11-04', '13:05', 3),
('sql', '2024-11-04', '14:20', 3),

-- Inserção para o dia 5 de novembro (terça-feira)
('python', '2024-11-05', '08:40', 3),
('vscode', '2024-11-05', '09:50', 3),
('chrome', '2024-11-05', '10:40', 3),
('fortnite.exe', '2024-11-05', '11:15', 3),
('fortnite.exe', '2024-11-05', '12:30', 3),
('gitbash', '2024-11-05', '13:40', 3),
('sql', '2024-11-05', '14:55', 3),

-- Inserção para o dia 6 de novembro (quarta-feira)
('python', '2024-11-06', '08:05', 3),
('vscode', '2024-11-06', '09:10', 3),
('chrome', '2024-11-06', '10:15', 3),
('apex_legends.exe', '2024-11-06', '11:25', 3),
('apex_legends.exe', '2024-11-06', '12:35', 3),
('gitbash', '2024-11-06', '13:45', 3),
('sql', '2024-11-06', '14:50', 3),

-- Inserção para o dia 7 de novembro (quinta-feira)
('python', '2024-11-07', '08:30', 3),
('vscode', '2024-11-07', '09:40', 3),
('chrome', '2024-11-07', '10:50', 3),
('dota2.exe', '2024-11-07', '11:15', 3),
('dota2.exe', '2024-11-07', '12:05', 3),
('gitbash', '2024-11-07', '13:20', 3),
('sql', '2024-11-07', '14:35', 3),

-- Inserção para o dia 8 de novembro (sexta-feira)
('python', '2024-11-08', '08:15', 3),
('vscode', '2024-11-08', '09:25', 3),
('chrome', '2024-11-08', '10:35', 3),
('dota2.exe', '2024-11-08', '11:05', 3),
('dota2.exe', '2024-11-08', '12:15', 3),
('gitbash', '2024-11-08', '13:25', 3),
('sql', '2024-11-08', '14:40', 3),

-- Inserção para o dia 11 de novembro (segunda-feira)
('python', '2024-11-11', '08:50', 3),
('vscode', '2024-11-11', '09:55', 3),
('chrome', '2024-11-11', '10:25', 3),
('apex_legends.exe', '2024-11-11', '11:45', 3),
('apex_legends.exe', '2024-11-11', '12:20', 3),
('gitbash', '2024-11-11', '13:10', 3),
('sql', '2024-11-11', '14:25', 3),

-- Inserção para o dia 12 de novembro (terça-feira)
('python', '2024-11-12', '08:20', 3),
('vscode', '2024-11-12', '09:30', 3),
('chrome', '2024-11-12', '10:50', 3),
('valorant.exe', '2024-11-12', '11:10', 3),
('valorant.exe', '2024-11-12', '12:40', 3),
('gitbash', '2024-11-12', '13:50', 3),
('sql', '2024-11-12', '14:15', 3),

-- Inserção para o dia 13 de novembro (quarta-feira)
('python', '2024-11-13', '08:10', 3),
('vscode', '2024-11-13', '09:25', 3),
('chrome', '2024-11-13', '10:35', 3),
('fortnite.exe', '2024-11-13', '11:50', 3),
('fortnite.exe', '2024-11-13', '12:30', 3),
('gitbash', '2024-11-13', '13:15', 3),
('sql', '2024-11-13', '14:05', 3),

-- Inserção para o dia 14 de novembro (quinta-feira)
('python', '2024-11-14', '08:30', 3),
('vscode', '2024-11-14', '09:50', 3),
('chrome', '2024-11-14', '10:55', 3),
('apex_legends.exe', '2024-11-14', '11:35', 3),
('apex_legends.exe', '2024-11-14', '12:20', 3),
('gitbash', '2024-11-14', '13:40', 3),
('sql', '2024-11-14', '14:50', 3),

-- Inserção para o dia 15 de novembro (sexta-feira)
('python', '2024-11-15', '08:15', 3),
('vscode', '2024-11-15', '09:45', 3),
('chrome', '2024-11-15', '10:20', 3),
('dota2.exe', '2024-11-15', '11:05', 3),
('dota2.exe', '2024-11-15', '12:00', 3),
('gitbash', '2024-11-15', '13:30', 3),
('sql', '2024-11-15', '14:40', 3),

-- Inserção para o dia 18 de novembro (segunda-feira)
('python', '2024-11-18', '08:40', 3),
('vscode', '2024-11-18', '09:50', 3),
('chrome', '2024-11-18', '10:30', 3),
('valorant.exe', '2024-11-18', '11:00', 3),
('valorant.exe', '2024-11-18', '12:00', 3),
('gitbash', '2024-11-18', '13:15', 3),
('sql', '2024-11-18', '14:25', 3),

-- Inserção para o dia 19 de novembro (terça-feira)
('python', '2024-11-19', '08:25', 3),
('vscode', '2024-11-19', '09:40', 3),
('chrome', '2024-11-19', '10:50', 3),
('fortnite.exe', '2024-11-19', '11:30', 3),
('fortnite.exe', '2024-11-19', '12:45', 3),
('gitbash', '2024-11-19', '13:05', 3),
('sql', '2024-11-19', '14:30', 3),

-- Inserção para o dia 20 de novembro (quarta-feira)
('python', '2024-11-20', '08:05', 3),
('vscode', '2024-11-20', '09:15', 3),
('chrome', '2024-11-20', '10:25', 3),
('fortnite.exe', '2024-11-20', '11:35', 3),
('fortnite.exe', '2024-11-20', '12:45', 3),
('gitbash', '2024-11-20', '13:50', 3),
('sql', '2024-11-20', '14:55', 3),

-- Inserção para o dia 21 de novembro (quinta-feira)
('python', '2024-11-21', '08:30', 3),
('vscode', '2024-11-21', '09:40', 3),
('chrome', '2024-11-21', '10:50', 3),
('apex_legends.exe', '2024-11-21', '11:20', 3),
('apex_legends.exe', '2024-11-21', '12:30', 3),
('gitbash', '2024-11-21', '13:40', 3),
('sql', '2024-11-21', '14:50', 3),

-- Inserção para o dia 22 de novembro (sexta-feira)
('python', '2024-11-22', '08:10', 3),
('vscode', '2024-11-22', '09:20', 3),
('chrome', '2024-11-22', '10:30', 3),
('dota2.exe', '2024-11-22', '11:00', 3),
('dota2.exe', '2024-11-22', '12:15', 3),
('gitbash', '2024-11-22', '13:30', 3),
('sql', '2024-11-22', '14:40', 3),

-- Inserção para o dia 25 de novembro (segunda-feira)
('python', '2024-11-25', '08:25', 3),
('vscode', '2024-11-25', '09:35', 3),
('chrome', '2024-11-25', '10:45', 3),
('valorant.exe', '2024-11-25', '11:15', 3),
('valorant.exe', '2024-11-25', '12:05', 3),
('gitbash', '2024-11-25', '13:25', 3),
('sql', '2024-11-25', '14:30', 3),

-- Inserção para o dia 26 de novembro (terça-feira)
('python', '2024-11-26', '08:15', 3),
('vscode', '2024-11-26', '09:30', 3),
('chrome', '2024-11-26', '10:40', 3),
('fortnite.exe', '2024-11-26', '11:50', 3),
('fortnite.exe', '2024-11-26', '12:30', 3),
('gitbash', '2024-11-26', '13:10', 3),
('sql', '2024-11-26', '14:20', 3),

-- Inserção para o dia 27 de novembro (quarta-feira)
('python', '2024-11-27', '08:30', 3),
('vscode', '2024-11-27', '09:40', 3),
('chrome', '2024-11-27', '10:50', 3),
('apex_legends.exe', '2024-11-27', '11:20', 3),
('apex_legends.exe', '2024-11-27', '12:40', 3),
('gitbash', '2024-11-27', '13:30', 3),
('sql', '2024-11-27', '14:45', 3),

-- Inserção para o dia 28 de novembro (quinta-feira)
('python', '2024-11-28', '08:15', 3),
('vscode', '2024-11-28', '09:30', 3),
('chrome', '2024-11-28', '10:40', 3),
('dota2.exe', '2024-11-28', '11:10', 3),
('dota2.exe', '2024-11-28', '12:25', 3),
('gitbash', '2024-11-28', '13:40', 3),
('sql', '2024-11-28', '14:50', 3),

-- Inserção para o dia 29 de novembro (sexta-feira)
('python', '2024-11-29', '08:35', 3),
('vscode', '2024-11-29', '09:50', 3),
('chrome', '2024-11-29', '10:55', 3),
('dota2.exe', '2024-11-29', '11:30', 3),
('dota2.exe', '2024-11-29', '12:45', 3),
('gitbash', '2024-11-29', '13:55', 3),
('sql', '2024-11-29', '15:05', 3),

-- Inserção para o dia 02 de dezembro (segunda-feira)
('python', '2024-12-02', '08:10', 3),
('vscode', '2024-12-02', '09:25', 3),
('chrome', '2024-12-02', '10:35', 3),
('valorant.exe', '2024-12-02', '11:45', 3),
('valorant.exe', '2024-12-02', '12:25', 3),
('gitbash', '2024-12-02', '13:05', 3),
('sql', '2024-12-02', '14:15', 3),

-- Inserção para o dia 03 de dezembro (terça-feira)
('python', '2024-12-03', '08:20', 3),
('vscode', '2024-12-03', '09:30', 3),
('chrome', '2024-12-03', '10:40', 3),
('fortnite.exe', '2024-12-03', '11:00', 3),
('fortnite.exe', '2024-12-03', '12:15', 3),
('gitbash', '2024-12-03', '13:30', 3),
('sql', '2024-12-03', '14:40', 3),

-- Inserção para o dia 04 de dezembro (quarta-feira)
('python', '2024-12-04', '08:25', 3),
('vscode', '2024-12-04', '09:40', 3),
('chrome', '2024-12-04', '10:50', 3),
('apex_legends.exe', '2024-12-04', '11:15', 3),
('apex_legends.exe', '2024-12-04', '12:35', 3),
('gitbash', '2024-12-04', '13:45', 3),
('sql', '2024-12-04', '14:50', 3),

-- Inserção para o dia 05 de dezembro (quinta-feira)
('python', '2024-12-05', '08:30', 3),
('vscode', '2024-12-05', '09:50', 3),
('chrome', '2024-12-05', '10:55', 3),
('dota2.exe', '2024-12-05', '11:25', 3),
('dota2.exe', '2024-12-05', '12:45', 3),
('gitbash', '2024-12-05', '13:50', 3),
('sql', '2024-12-05', '14:55', 3),

-- Inserção para o dia 1º de novembro (sexta-feira)
('python', '2024-11-01', '10:30', 4),
('vscode', '2024-11-01', '11:15', 4),
('chrome', '2024-11-01', '09:45', 4),
('valorant.exe', '2024-11-01', '09:30', 4),
('valorant.exe', '2024-11-01', '10:00', 4),
('gitbash', '2024-11-01', '11:45', 4),
('sql', '2024-11-01', '12:30', 4),

-- Inserção para o dia 4 de novembro (segunda-feira)
('python', '2024-11-04', '08:45', 4),
('vscode', '2024-11-04', '09:30', 4),
('chrome', '2024-11-04', '10:00', 4),
('apex_legends.exe', '2024-11-04', '09:15', 4),
('apex_legends.exe', '2024-11-04', '10:30', 4),
('gitbash', '2024-11-04', '11:00', 4),
('sql', '2024-11-04', '12:30', 4),

-- Inserção para o dia 5 de novembro (terça-feira)
('python', '2024-11-05', '10:45', 4),
('vscode', '2024-11-05', '08:30', 4),
('chrome', '2024-11-05', '09:15', 4),
('fortnite.exe', '2024-11-05', '09:00', 4),
('fortnite.exe', '2024-11-05', '10:30', 4),
('gitbash', '2024-11-05', '11:15', 4),
('sql', '2024-11-05', '12:30', 4),

-- Inserção para o dia 6 de novembro (quarta-feira)
('python', '2024-11-06', '09:00', 4),
('vscode', '2024-11-06', '10:00', 4),
('chrome', '2024-11-06', '08:45', 4),
('fortnite.exe', '2024-11-06', '09:30', 4),
('fortnite.exe', '2024-11-06', '10:15', 4),
('gitbash', '2024-11-06', '11:00', 4),
('sql', '2024-11-06', '12:30', 4),

-- Inserção para o dia 7 de novembro (quinta-feira)
('python', '2024-11-07', '10:00', 4),
('vscode', '2024-11-07', '09:00', 4),
('chrome', '2024-11-07', '09:45', 4),
('valorant.exe', '2024-11-07', '09:30', 4),
('valorant.exe', '2024-11-07', '10:15', 4),
('gitbash', '2024-11-07', '11:30', 4),
('sql', '2024-11-07', '12:30', 4),

-- Inserção para o dia 8 de novembro (sexta-feira)
('python', '2024-11-08', '09:15', 4),
('vscode', '2024-11-08', '10:00', 4),
('chrome', '2024-11-08', '08:30', 4),
('apex_legends.exe', '2024-11-08', '09:30', 4),
('apex_legends.exe', '2024-11-08', '10:15', 4),
('gitbash', '2024-11-08', '11:00', 4),
('sql', '2024-11-08', '12:00', 4),

-- Inserção para o dia 11 de novembro (segunda-feira)
('python', '2024-11-11', '10:15', 4),
('vscode', '2024-11-11', '08:30', 4),
('chrome', '2024-11-11', '09:00', 4),
('dota2.exe', '2024-11-11', '09:30', 4),
('dota2.exe', '2024-11-11', '10:00', 4),
('gitbash', '2024-11-11', '11:30', 4),
('sql', '2024-11-11', '15:30', 4),

-- Inserção para o dia 12 de novembro (terça-feira)
('python', '2024-11-12', '09:00', 4),
('vscode', '2024-11-12', '10:00', 4),
('chrome', '2024-11-12', '08:30', 4),
('valorant.exe', '2024-11-12', '09:00', 4),
('valorant.exe', '2024-11-12', '10:30', 4),
('gitbash', '2024-11-12', '11:15', 4),
('sql', '2024-11-12', '14:30', 4),

-- Inserção para o dia 13 de novembro (quarta-feira)
('python', '2024-11-13', '09:15', 4),
('vscode', '2024-11-13', '10:00', 4),
('chrome', '2024-11-13', '08:45', 4),
('apex_legends.exe', '2024-11-13', '09:30', 4),
('apex_legends.exe', '2024-11-13', '10:15', 4),
('gitbash', '2024-11-13', '11:00', 4),
('sql', '2024-11-13', '12:30', 4),

-- Inserção para o dia 14 de novembro (quinta-feira)
('python', '2024-11-14', '09:00', 4),
('vscode', '2024-11-14', '08:30', 4),
('chrome', '2024-11-14', '10:00', 4),
('dota2.exe', '2024-11-14', '09:30', 4),
('dota2.exe', '2024-11-14', '10:15', 4),
('gitbash', '2024-11-14', '11:00', 4),
('sql', '2024-11-14', '12:30', 4),

-- Inserção para o dia 15 de novembro (sexta-feira)
('python', '2024-11-15', '09:15', 4),
('vscode', '2024-11-15', '10:00', 4),
('chrome', '2024-11-15', '08:30', 4),
('fortnite.exe', '2024-11-15', '11:00', 4),
('fortnite.exe', '2024-11-15', '12:00', 4),
('gitbash', '2024-11-15', '13:30', 4),
('sql', '2024-11-15', '12:30', 4),

-- Inserção para o dia 18 de novembro (segunda-feira)
('python', '2024-11-18', '09:00', 4),
('vscode', '2024-11-18', '08:30', 4),
('chrome', '2024-11-18', '10:00', 4),
('pubg.exe', '2024-11-18', '09:00', 4),
('pubg.exe', '2024-11-18', '10:00', 4),
('gitbash', '2024-11-18', '11:30', 4),
('sql', '2024-11-18', '12:30', 4),

-- Inserção para o dia 19 de novembro (terça-feira)
('python', '2024-11-19', '09:00', 4),
('vscode', '2024-11-19', '08:30', 4),
('chrome', '2024-11-19', '10:00', 4),
('valorant.exe', '2024-11-19', '09:30', 4),
('valorant.exe', '2024-11-19', '11:15', 4),
('gitbash', '2024-11-19', '11:00', 4),
('sql', '2024-11-19', '12:30', 4),

-- Inserção para o dia 20 de novembro (quarta-feira)
('python', '2024-11-20', '09:15', 4),
('vscode', '2024-11-20', '10:00', 4),
('chrome', '2024-11-20', '08:45', 4),
('valorant.exe', '2024-11-20', '13:00', 4),
('valorant.exe', '2024-11-20', '14:15', 4),
('gitbash', '2024-11-20', '11:00', 4),
('sql', '2024-11-20', '09:30', 4),

-- Inserção para o dia 21 de novembro (quinta-feira)
('python', '2024-11-21', '09:30', 4),
('vscode', '2024-11-21', '08:45', 4),
('chrome', '2024-11-21', '09:00', 4),
('apex_legends.exe', '2024-11-21', '09:15', 4),
('apex_legends.exe', '2024-11-21', '10:30', 4),
('gitbash', '2024-11-21', '11:15', 4),
('sql', '2024-11-21', '12:30', 4),

-- Inserção para o dia 22 de novembro (sexta-feira)
('python', '2024-11-22', '09:00', 4),
('vscode', '2024-11-22', '10:00', 4),
('chrome', '2024-11-22', '08:30', 4),
('dota2.exe', '2024-11-22', '09:45', 4),
('dota2.exe', '2024-11-22', '10:55', 4),
('gitbash', '2024-11-22', '11:30', 4),
('sql', '2024-11-22', '12:30', 4),

-- Inserção para o dia 25 de novembro (segunda-feira)
('python', '2024-11-25', '09:30', 4),
('vscode', '2024-11-25', '08:45', 4),
('chrome', '2024-11-25', '09:00', 4),
('pubg.exe', '2024-11-25', '09:30', 4),
('pubg.exe', '2024-11-25', '10:15', 4),
('gitbash', '2024-11-25', '11:00', 4),
('sql', '2024-11-25', '12:30', 4),

-- Inserção para o dia 26 de novembro (terça-feira)
('python', '2024-11-26', '09:15', 4),
('vscode', '2024-11-26', '10:00', 4),
('chrome', '2024-11-26', '08:30', 4),
('valorant.exe', '2024-11-26', '09:30', 4),
('valorant.exe', '2024-11-26', '10:30', 4),
('gitbash', '2024-11-26', '11:15', 4),
('sql', '2024-11-26', '12:30', 4),

-- Inserção para o dia 27 de novembro (quarta-feira)
('python', '2024-11-27', '09:00', 4),
('vscode', '2024-11-27', '10:00', 4),
('chrome', '2024-11-27', '08:45', 4),
('fortnite.exe', '2024-11-27', '09:30', 4),
('fortnite.exe', '2024-11-27', '10:15', 4),
('gitbash', '2024-11-27', '11:00', 4),
('sql', '2024-11-27', '12:30', 4),

-- Inserção para o dia 28 de novembro (quinta-feira)
('python', '2024-11-28', '09:30', 4),
('vscode', '2024-11-28', '08:30', 4),
('chrome', '2024-11-28', '09:00', 4),
('valorant.exe', '2024-11-28', '09:15', 4),
('valorant.exe', '2024-11-28', '10:00', 4),
('gitbash', '2024-11-28', '11:30', 4),
('sql', '2024-11-28', '12:30', 4),

-- Inserção para o dia 29 de novembro (sexta-feira)
('python', '2024-11-29', '09:00', 4),
('vscode', '2024-11-29', '08:30', 4),
('chrome', '2024-11-29', '09:45', 4),
('dota2.exe', '2024-11-29', '09:00', 4),
('dota2.exe', '2024-11-29', '10:15', 4),
('gitbash', '2024-11-29', '11:30', 4),
('sql', '2024-11-29', '12:30', 4),

-- Inserção para o dia 2 de dezembro (segunda-feira)
('python', '2024-12-02', '09:15', 4),
('vscode', '2024-12-02', '10:00', 4),
('chrome', '2024-12-02', '08:45', 4),
('pubg.exe', '2024-12-02', '09:30', 4),
('pubg.exe', '2024-12-02', '10:30', 4),
('gitbash', '2024-12-02', '11:00', 4),
('sql', '2024-12-02', '12:30', 4),

-- Inserção para o dia 3 de dezembro (terça-feira)
('python', '2024-12-03', '09:30', 4),
('vscode', '2024-12-03', '08:45', 4),
('chrome', '2024-12-03', '09:00', 4),
('valorant.exe', '2024-12-03', '09:15', 4),
('valorant.exe', '2024-12-03', '10:00', 4),
('gitbash', '2024-12-03', '11:15', 4),
('sql', '2024-12-03', '12:30', 4),

-- Inserção para o dia 4 de dezembro (quarta-feira)
('python', '2024-12-04', '09:00', 4),
('vscode', '2024-12-04', '10:00', 4),
('chrome', '2024-12-04', '08:30', 4),
('fortnite.exe', '2024-12-04', '09:00', 4),
('fortnite.exe', '2024-12-04', '10:15', 4),
('gitbash', '2024-12-04', '11:00', 4),
('sql', '2024-12-04', '12:30', 4),

-- Inserção para o dia 5 de dezembro (quinta-feira)
('python', '2024-12-05', '09:15', 4),
('vscode', '2024-12-05', '10:00', 4),
('chrome', '2024-12-05', '08:30', 4),
('apex_legends.exe', '2024-12-05', '09:30', 4),
('apex_legends.exe', '2024-12-05', '10:30', 4),
('gitbash', '2024-12-05', '11:15', 4),
('sql', '2024-12-05', '12:30', 4),

-- Inserção para o dia 1º de novembro (sexta-feira)
('python', '2024-11-01', '08:05', 5),
('vscode', '2024-11-01', '09:15', 5),
('chrome', '2024-11-01', '10:30', 5),
('apex_legends.exe', '2024-11-01', '11:40', 5),
('gitbash', '2024-11-01', '13:00', 5),
('apex_legends.exe', '2024-11-01', '14:30', 5),
('sql', '2024-11-01', '16:00', 5),

-- Inserção para o dia 4 de novembro (segunda-feira)
('python', '2024-11-04', '08:30', 5),
('vscode', '2024-11-04', '09:45', 5),
('chrome', '2024-11-04', '11:00', 5),
('fortnite.exe', '2024-11-04', '12:20', 5),
('gitbash', '2024-11-04', '13:50', 5),
('fortnite.exe', '2024-11-04', '15:00', 5),
('sql', '2024-11-04', '16:30', 5),

-- Inserção para o dia 5 de novembro (terça-feira)
('python', '2024-11-05', '08:10', 5),
('vscode', '2024-11-05', '09:00', 5),
('chrome', '2024-11-05', '10:45', 5),
('dota2.exe', '2024-11-05', '12:00', 5),
('gitbash', '2024-11-05', '13:15', 5),
('dota2.exe', '2024-11-05', '14:40', 5),
('sql', '2024-11-05', '16:00', 5),

-- Inserção para o dia 6 de novembro (quarta-feira)
('python', '2024-11-06', '08:20', 5),
('vscode', '2024-11-06', '09:30', 5),
('chrome', '2024-11-06', '11:00', 5),
('pubg.exe', '2024-11-06', '12:15', 5),
('gitbash', '2024-11-06', '13:40', 5),
('pubg.exe', '2024-11-06', '14:50', 5),
('sql', '2024-11-06', '16:10', 5),

-- Inserção para o dia 7 de novembro (quinta-feira)
('python', '2024-11-07', '08:00', 5),
('vscode', '2024-11-07', '09:05', 5),
('chrome', '2024-11-07', '10:35', 5),
('valorant.exe', '2024-11-07', '11:50', 5),
('gitbash', '2024-11-07', '13:10', 5),
('valorant.exe', '2024-11-07', '14:30', 5),
('sql', '2024-11-07', '16:00', 5),

-- Inserção para o dia 8 de novembro (sexta-feira)
('python', '2024-11-08', '08:45', 5),
('vscode', '2024-11-08', '09:50', 5),
('chrome', '2024-11-08', '11:10', 5),
('apex_legends.exe', '2024-11-08', '12:25', 5),
('gitbash', '2024-11-08', '13:45', 5),
('apex_legends.exe', '2024-11-08', '15:00', 5),
('sql', '2024-11-08', '16:30', 5),

-- Inserção para o dia 11 de novembro (segunda-feira)
('python', '2024-11-11', '08:10', 5),
('vscode', '2024-11-11', '09:15', 5),
('chrome', '2024-11-11', '10:30', 5),
('fortnite.exe', '2024-11-11', '11:45', 5),
('gitbash', '2024-11-11', '13:00', 5),
('fortnite.exe', '2024-11-11', '14:20', 5),
('sql', '2024-11-11', '15:50', 5),

-- Inserção para o dia 12 de novembro (terça-feira)
('python', '2024-11-12', '08:00', 5),
('vscode', '2024-11-12', '09:10', 5),
('chrome', '2024-11-12', '10:50', 5),
('dota2.exe', '2024-11-12', '12:00', 5),
('gitbash', '2024-11-12', '13:30', 5),
('dota2.exe', '2024-11-12', '14:40', 5),
('sql', '2024-11-12', '16:00', 5),

-- Inserção para o dia 13 de novembro (quarta-feira)
('python', '2024-11-13', '08:30', 5),
('vscode', '2024-11-13', '09:40', 5),
('chrome', '2024-11-13', '11:00', 5),
('pubg.exe', '2024-11-13', '12:15', 5),
('gitbash', '2024-11-13', '13:30', 5),
('pubg.exe', '2024-11-13', '14:45', 5),
('sql', '2024-11-13', '16:00', 5),

-- Inserção para o dia 14 de novembro (quinta-feira)
('python', '2024-11-14', '08:20', 5),
('vscode', '2024-11-14', '09:25', 5),
('chrome', '2024-11-14', '10:45', 5),
('valorant.exe', '2024-11-14', '12:00', 5),
('gitbash', '2024-11-14', '13:40', 5),
('valorant.exe', '2024-11-14', '15:00', 5),
('pubg.exe', '2024-11-14', '12:15', 5),
('pubg.exe', '2024-11-14', '12:15', 5),
('sql', '2024-11-14', '16:10', 5),

-- Inserção para o dia 15 de novembro (sexta-feira)
('python', '2024-11-15', '08:30', 5),
('vscode', '2024-11-15', '09:45', 5),
('chrome', '2024-11-15', '11:00', 5),
('apex_legends.exe', '2024-11-15', '14:00', 5),
('gitbash', '2024-11-15', '13:50', 5),
('apex_legends.exe', '2024-11-15', '15:00', 5),
('sql', '2024-11-15', '16:30', 5),

-- Inserção para o dia 18 de novembro (segunda-feira)
('python', '2024-11-18', '08:10', 5),
('vscode', '2024-11-18', '09:30', 5),
('chrome', '2024-11-18', '10:40', 5),
('fortnite.exe', '2024-11-18', '12:00', 5),
('gitbash', '2024-11-18', '13:20', 5),
('fortnite.exe', '2024-11-18', '14:30', 5),
('sql', '2024-11-18', '16:00', 5),

-- Inserção para o dia 19 de novembro (terça-feira)
('python', '2024-11-19', '08:05', 5),
('vscode', '2024-11-19', '09:15', 5),
('chrome', '2024-11-19', '10:35', 5),
('dota2.exe', '2024-11-19', '11:50', 5),
('gitbash', '2024-11-19', '13:00', 5),
('dota2.exe', '2024-11-19', '14:30', 5),
('sql', '2024-11-19', '16:00', 5),

-- Inserção para o dia 20 de novembro (quarta-feira)
('python', '2024-11-20', '08:00', 5),
('vscode', '2024-11-20', '09:10', 5),
('chrome', '2024-11-20', '10:30', 5),
('pubg.exe', '2024-11-20', '11:40', 5),
('gitbash', '2024-11-20', '13:00', 5),
('pubg.exe', '2024-11-20', '14:30', 5),
('sql', '2024-11-20', '16:00', 5),

-- Inserção para o dia 21 de novembro (quinta-feira)
('python', '2024-11-21', '08:30', 5),
('vscode', '2024-11-21', '09:40', 5),
('chrome', '2024-11-21', '11:00', 5),
('valorant.exe', '2024-11-21', '12:15', 5),
('gitbash', '2024-11-21', '13:40', 5),
('valorant.exe', '2024-11-21', '15:00', 5),
('sql', '2024-11-21', '16:20', 5),

-- Inserção para o dia 22 de novembro (sexta-feira)
('python', '2024-11-22', '08:00', 5),
('vscode', '2024-11-22', '09:30', 5),
('chrome', '2024-11-22', '10:45', 5),
('apex_legends.exe', '2024-11-22', '12:00', 5),
('gitbash', '2024-11-22', '13:15', 5),
('apex_legends.exe', '2024-11-22', '14:45', 5),
('sql', '2024-11-22', '16:10', 5),

-- Inserção para o dia 25 de novembro (segunda-feira)
('python', '2024-11-25', '08:15', 5),
('vscode', '2024-11-25', '09:50', 5),
('chrome', '2024-11-25', '11:00', 5),
('fortnite.exe', '2024-11-25', '12:20', 5),
('gitbash', '2024-11-25', '13:40', 5),
('fortnite.exe', '2024-11-25', '15:00', 5),
('sql', '2024-11-25', '16:30', 5),

-- Inserção para o dia 26 de novembro (terça-feira)
('python', '2024-11-26', '08:30', 5),
('vscode', '2024-11-26', '09:45', 5),
('chrome', '2024-11-26', '11:00', 5),
('dota2.exe', '2024-11-26', '12:15', 5),
('gitbash', '2024-11-26', '13:40', 5),
('dota2.exe', '2024-11-26', '14:50', 5),
('sql', '2024-11-26', '16:00', 5),

-- Inserção para o dia 27 de novembro (quarta-feira)
('python', '2024-11-27', '08:05', 5),
('vscode', '2024-11-27', '09:20', 5),
('chrome', '2024-11-27', '10:35', 5),
('pubg.exe', '2024-11-27', '11:50', 5),
('gitbash', '2024-11-27', '13:10', 5),
('pubg.exe', '2024-11-27', '14:30', 5),
('sql', '2024-11-27', '16:00', 5),

-- Inserção para o dia 28 de novembro (quinta-feira)
('python', '2024-11-28', '08:30', 5),
('vscode', '2024-11-28', '09:45', 5),
('chrome', '2024-11-28', '11:05', 5),
('valorant.exe', '2024-11-28', '12:30', 5),
('gitbash', '2024-11-28', '13:50', 5),
('valorant.exe', '2024-11-28', '15:00', 5),
('sql', '2024-11-28', '16:10', 5),

-- Inserção para o dia 29 de novembro (sexta-feira)
('python', '2024-11-29', '08:00', 5),
('vscode', '2024-11-29', '09:20', 5),
('chrome', '2024-11-29', '10:40', 5),
('apex_legends.exe', '2024-11-29', '11:55', 5),
('gitbash', '2024-11-29', '13:10', 5),
('apex_legends.exe', '2024-11-29', '14:30', 5),
('sql', '2024-11-29', '16:00', 5),

-- Inserção para o dia 2 de dezembro (segunda-feira)
('python', '2024-12-02', '08:10', 5),
('vscode', '2024-12-02', '09:30', 5),
('chrome', '2024-12-02', '10:50', 5),
('fortnite.exe', '2024-12-02', '12:10', 5),
('gitbash', '2024-12-02', '13:30', 5),
('fortnite.exe', '2024-12-02', '14:40', 5),
('sql', '2024-12-02', '16:00', 5),

-- Inserção para o dia 3 de dezembro (terça-feira)
('python', '2024-12-03', '08:05', 5),
('vscode', '2024-12-03', '09:15', 5),
('chrome', '2024-12-03', '10:25', 5),
('dota2.exe', '2024-12-03', '11:45', 5),
('gitbash', '2024-12-03', '13:00', 5),
('dota2.exe', '2024-12-03', '14:30', 5),
('sql', '2024-12-03', '16:00', 5),

-- Inserção para o dia 4 de dezembro (quarta-feira)
('python', '2024-12-04', '08:00', 5),
('vscode', '2024-12-04', '09:20', 5),
('chrome', '2024-12-04', '10:40', 5),
('pubg.exe', '2024-12-04', '11:55', 5),
('gitbash', '2024-12-04', '13:10', 5),
('pubg.exe', '2024-12-04', '14:30', 5),
('sql', '2024-12-04', '16:00', 5),

-- Inserção para o dia 5 de dezembro (quinta-feira)
('python', '2024-12-05', '08:10', 5),
('vscode', '2024-12-05', '09:30', 5),
('chrome', '2024-12-05', '10:50', 5),
('valorant.exe', '2024-12-05', '12:00', 5),
('gitbash', '2024-12-05', '13:30', 5),
('valorant.exe', '2024-12-05', '14:45', 5),
('sql', '2024-12-05', '16:00', 5);


