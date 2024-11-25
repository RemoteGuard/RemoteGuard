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
    marca VARCHAR(30) NOT NULL,
    modelo VARCHAR(45) NOT NULL,
    memoriaRAM INT NOT NULL,
    processador VARCHAR(25) NOT NULL
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
    total_disco DOUBLE NOT NULL, 
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

Select porcentagem_cpu,porcentagem_ram,porcentagem_disco,tempo_alerta_cpu,tempo_alerta_ram,tempo_alerta_disco from dados where fkNotebook =1 order by data_captura desc limit 1;


INSERT INTO notebook (hostname, marca, modelo, memoriaRAM, processador) VALUES
('notebook1', 'Dell', 'XPS 13', 16, 'Intel Core i7'),
('notebook2', 'Apple', 'MacBook Pro', 32, 'Apple M1'),
('notebook3', 'Lenovo', 'ThinkPad X1', 16, 'Intel Core i5');

INSERT INTO empresa (razaoSocial, nomeFantasia, cep, numero, telefone, email, cnpj, token) VALUES 
    ('Amazon', 'Amazon', '98765432', '2350', '11999999999', 'amazon@gmail.com', '88888888888888', '123456789'),
    ('Google', 'Google', '98765432', '2390', '11956999999', 'google@gmail.com', '2882288283888', '987654321');

SELECT porcentagem_ram FROM dados WHERE fkNotebook = 1;


INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa, fkNotebook)
VALUES 
('Analista De Sitemas', 'João Silva', '12345678901', 'joao.silva@empresa.com', 'senha123', 1, 1);

INSERT INTO notebook (hostname, marca, modelo, memoriaRAM, processador) VALUES
('notebook4', 'HP', 'Pavilion', 8, 'AMD Ryzen 5'),
('notebook5', 'Acer', 'Aspire', 16, 'Intel Core i7'),
('notebook6', 'Asus', 'ZenBook', 16, 'Intel Core i5');

INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa, fkNotebook)
VALUES 

('Analista De Sistemas', 'Maria Santos', '12345678902', 'maria.santos@empresa.com', 'senha123', 1, 2),
('Analista De Sistemas', 'Carlos Oliveira', '12345678903', 'carlos.oliveira@empresa.com', 'senha123', 2, 3),
('Analista De Sistemas', 'Ana Costa', '12345678904', 'ana.costa@empresa.com', 'senha123', 2, 4),
('Analista De Sistemas', 'Lucas Pereira', '12345678905', 'lucas.pereira@empresa.com', 'senha123', 1, 5),
('Analista De Sistemas', 'Fernanda Lima', '12345678906', 'fernanda.lima@empresa.com', 'senha123', 1, 6);


    
       SELECT funcionario.nome AS nome_funcionario,
       funcionario.email AS email_funcionario,
       funcionario.cargo AS cargo_funcionario
        FROM funcionario
        WHERE funcionario.fkNotebook = 1;


SELECT * FROM empresa;
SELECT * FROM notebook;
SELECT * FROM funcionario;
SELECT * FROM armazenamento;
SELECT * FROM processos;
SELECT * FROM dados;

SELECT qtdprocessos, data_captura FROM dados WHERE fkNotebook =  1 ORDER BY   data_captura DESC  LIMIT 1;

SELECT porcentagem_ram, data_captura FROM dados WHERE fkNotebook =  1 ORDER BY data_captura DESC LIMIT 10;

SELECT numero_nucleos from dados where fkNotebook =4 ORDER BY data_captura DESC LIMIT 1;
   SELECT 
    n.hostname, n.marca, n.modelo, n.memoriaRAM, n.processador, a.qtdDiscos, a.total_disco
FROM 
    notebook n
JOIN 
    armazenamento a ON n.idNotebook = 2
WHERE 
    a.fkNotebook = 2;  




SELECT idNotebook FROM notebook;
INSERT INTO dados (fkNotebook, tempo_inatividade_cpu, porcentagem_cpu, bytes_ram, porcentagem_ram, bytes_disco, porcentagem_disco, qtdprocessos, boot_time, numero_nucleos)
VALUES
    (2, 0.5, 25.3, 8388608, 60.4, 500000000, 45.0, 150, '2024-11-10 08:30:00', 4),
    (4, 0.8, 35.2, 16384000, 70.8, 1000000000, 60.0, 200, '2024-11-10 08:35:00', 8);



insert into dados (porcentagem_cpu,porcentagem_ram,porcentagem_disco,qtdprocessos,tempo_alerta_cpu,tempo_alerta_ram,tempo_alerta_disco,fkNotebook) values
(83,100,100,70,2,2,2,1);


 SELECT 
		ROUND(AVG(porcentagem_cpu)) AS media_cpu, 
      ROUND(AVG(porcentagem_ram)) AS media_ram, 
      ROUND(AVG(porcentagem_disco)) AS media_disco
    FROM dados;
SELECT 
    ROUND(porcentagem_cpu), 
    ROUND(porcentagem_ram), 
    ROUND(porcentagem_disco) 
FROM dados
WHERE fkNotebook = 1 Order by data_captura Desc Limit 1  ;

SELECT n.idNotebook, f.nome AS nomeFuncionario
FROM notebook n
JOIN funcionario f ON n.idNotebook = f.fkNotebook;

    SELECT 
          AVG(porcentagem_cpu) AS media_cpu,
          AVG(porcentagem_ram) AS media_ram,
          AVG(porcentagem_disco) AS media_disco
      FROM dados;
      
  
SELECT dados.porcentagem_disco, dados.data_captura, armazenamento.total_disco
FROM dados
JOIN armazenamento ON dados.fkNotebook = armazenamento.fkNotebook
WHERE dados.fkNotebook = 1
ORDER BY dados.data_captura DESC
LIMIT 1;
     
