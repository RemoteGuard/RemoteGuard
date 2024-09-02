USE remoteGuard;

insert into empresa values (default, 'TechConsult','TechSolutions Consultoria','01523500', 498,'11998123456','techConsult@gmail.com', '05720367000101' );

insert into funcionario values (default, 'gerente', 'Fernando Brandão', '32312345678', 'brandao@gmail.com', 'teste#123', './../img/site/dashboard/perfil.png',1, null);
insert into funcionario values (default, 'analista', 'Marcio Oliveira', '98312345678', 'marcio@gmail.com', 'teste#123', null,1, null);
insert into funcionario values 
	(default, 'funcionario', 'Ivan Rangel', '32312345678', 'ivan@gmail.com', 'teste#123', null,1, 1),
	(default, 'funcionario', 'Lucas Alves', '32398765678', 'lucas@gmail.com', 'teste#123', null,1, 1),
	(default, 'funcionario', 'Raul Reis',   '32313445678', 'raul@gmail.com', 'teste#123', null,1, 1),
	(default, 'funcionario', 'VInicius Miralha', '54312345678', 'vinicius@gmail.com', 'teste#123', null,1, 1),
	(default, 'funcionario', 'Felipe Gasparotto', '32765345678', 'felipe@gmail.com', 'teste#123', null,1, 1);
    
insert into notebook values(91755279024, 'samsung', 'GalaxyBook 3 360', 16,'i7-1360P');

insert into armazenamento values(default, 'SSD', 512, 91755279024);

INSERT INTO controleFluxo ( dtSaida, fkFuncionario, fkNotebook) VALUES (null, 3, 91755279024);


select * from empresa;
select * from funcionario;
select * from notebook;
select * from armazenamento;
select * from controleFluxo;
select * from dados;
