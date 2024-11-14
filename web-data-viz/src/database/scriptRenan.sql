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
    processos LONGTEXT,
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


INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa, fkNotebook)
VALUES 
('analista', 'João Silva', '12345678901', 'joao.silva@empresa.com', 'senha123', 1, 1);

INSERT INTO notebook (hostname, marca, modelo, memoriaRAM, processador) VALUES
('notebook4', 'HP', 'Pavilion', 8, 'AMD Ryzen 5'),
('notebook5', 'Acer', 'Aspire', 16, 'Intel Core i7'),
('notebook6', 'Asus', 'ZenBook', 16, 'Intel Core i5');

INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa, fkNotebook)
VALUES 
('analista', 'Maria Santos', '12345678902', 'maria.santos@empresa.com', 'senha123', 1, 2),
('supervisor', 'Carlos Oliveira', '12345678903', 'carlos.oliveira@empresa.com', 'senha123', 2, 3),
('gerente', 'Ana Costa', '12345678904', 'ana.costa@empresa.com', 'senha123', 2, 4),
('analista', 'Lucas Pereira', '12345678905', 'lucas.pereira@empresa.com', 'senha123', 1, 5),
('assistente', 'Fernanda Lima', '12345678906', 'fernanda.lima@empresa.com', 'senha123', 1, 6);

 insert into dados values (default, 2, 100.0, 10.0, 100, 20.0, 100, 50.0, "joao", default);

       SELECT funcionario.nome AS nome_funcionario
        FROM funcionario
        WHERE funcionario.fkNotebook = 2;


SELECT * FROM empresa;
SELECT * FROM notebook;
SELECT * FROM funcionario;
SELECT * FROM armazenamento;
SELECT * FROM processos;
SELECT * FROM dados;




SELECT * FROM alerta;
SELECT fkNotebook, porcentagem_cpu, porcentagem_ram FROM dados order by fkNotebook limit 1;

SELECT fkNotebook, porcentagem_cpu, porcentagem_ram
FROM dados as dados
JOIN (
    SELECT fkNotebook, MAX(id) as max_id
    FROM dados
    GROUP BY fkNotebook
) AS dados2 ON dados.fkNotebook = dados2.fkNotebook AND dados.id = dados2.max_id;

SELECT funcionario.nome, t1.processos, t1.fkNotebook, t1.porcentagem_cpu, t1.porcentagem_ram
FROM dados AS t1
JOIN (
    SELECT fkNotebook, MAX(id) AS max_id
    FROM dados
    GROUP BY fkNotebook
) AS t2 ON t1.fkNotebook = t2.fkNotebook AND t1.id = t2.max_id
JOIN funcionario where t2.fkNotebook = funcionario.idFuncionario;

select * from funcionario join notebook on fkNotebook = idFuncionario;