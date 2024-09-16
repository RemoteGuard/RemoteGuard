USE remoteGuard;

CREATE USER 'server'@'%' identified by ""; 
GRANT ALL PRIVILEGES ON *.* TO 'server'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;


insert into empresa values (default, 'TechConsult','TechSolutions Consultoria','01523500', 498,'11998123456','techConsult@gmail.com', '05720367000101' );

insert into funcionario values (default, 'gerente', 'Fernando Brandão', '32312345678', 'brandao@gmail.com', 'teste#123', './../img/site/dashboard/perfil.png',1, null);
insert into funcionario values (default, 'analista', 'Marcio Oliveira', '98312345678', 'marcio@gmail.com', 'teste#123', null,1, null);
insert into funcionario values 
	(default, 'gerente', 'Lucas Alves', '32398765678', 'lucas@gmail.com', 'teste#123', null,1, null),
	(default, 'analista', 'Ivan Rangel', '32312345678', 'ivan@gmail.com', 'teste#123', null,1,  3),
	(default, 'funcionario', 'Raul Reis',   '32313445678', 'raul@gmail.com', 'teste#123', null,1, 3),
	(default, 'funcionario', 'VInicius Miralha', '54312345678', 'vinicius@gmail.com', 'teste#123', null,1, 3),
	(default, 'funcionario', 'Felipe Gasparotto', '32765345678', 'felipe@gmail.com', 'teste#123', null,1, 3);
    
insert into notebook values(91755279024, 'samsung', 'GalaxyBook 3 360', 16,'i7-1360P');
insert into notebook values(150013896150328, 'dell', 'inspiron 14', '16', 'i5-8');
insert into notebook values(132243596628502, 'dell', 'inspiron 14', '16', 'i5-8');
insert into notebook values(251682014498224, 'dell', 'inspiron 13', 16,'i3-10');
insert into notebook values(102021907832074, 'dell', 'inspiron 13', 16,'i3-10');

insert into armazenamento values(default, 'SSD', 512, 91755279024);
insert into armazenamento values(default, 'SSD', 256, 150013896150328);
insert into armazenamento values(default, 'HD', 960, 150013896150328);
insert into armazenamento values(default, 'SSD', 256, 132243596628502);
insert into armazenamento values(default, 'SSD', 256, 251682014498224);
insert into armazenamento values(default, 'SSD', 256, 102021907832074);
INSERT INTO controleFluxo ( dtSaida, fkFuncionario, fkNotebook) VALUES (null, 4, 91755279024);
INSERT INTO controleFluxo ( dtSaida, fkFuncionario, fkNotebook) VALUES (null, 3, 150013896150328);
INSERT INTO controleFluxo ( dtSaida, fkFuncionario, fkNotebook) VALUES (null, 6, 132243596628502);
INSERT INTO controleFluxo ( dtSaida, fkFuncionario, fkNotebook) VALUES (null, 7, 251682014498224);
INSERT INTO controleFluxo ( dtSaida, fkFuncionario, fkNotebook) VALUES (null, 5, 251682014498224);

select * from empresa;
select * from funcionario;
select * from notebook;
select * from armazenamento;
select * from controleFluxo;
select * from dados;
select * from processos;


SELECT d.*,supervisor.nome as 'nome supervisor', f.nome, f.cargo FROM dados as d 
	JOIN notebook as n
		ON d.fkNotebook = n.idNotebook
	JOIN controleFluxo as cf 
		ON n.idNotebook = cf.fkNotebook 
    JOIN funcionario as f 
		ON cf.fkFuncionario = f.idFuncionario
	JOIN funcionario as supervisor 
		ON f.fkSupervisor = supervisor.idFuncionario
	WHERE supervisor.idFuncionario = 3;
TRUNCATE TABLE processos;
TRUNCATE TABLE dados;

SELECT * FROM notebook as nb 
	JOIN controleFluxo as cf 
		ON nb.idNotebook = cf.fkNotebook 
    JOIN funcionario as f 
		ON cf.fkFuncionario = f.idFuncionario
	WHERE nb.idNotebook = 91755279024;
    
    SELECT * FROM funcionario;
    
    SELECT percCPU, percRAM, percDisc FROM dados;
		
