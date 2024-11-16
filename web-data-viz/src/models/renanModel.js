var database = require("../database/config")

function processos() {
    var instrucaoSql = `select processos from dados order by fkNotebook;`;
  
    return database.executar(instrucaoSql);
  }

function ultimosDados() {
    var instrucaoSql = `SELECT funcionario.nome, t1.fkNotebook, t1.porcentagem_cpu, t1.porcentagem_ram
    FROM dados AS t1
    JOIN (
    SELECT fkNotebook, MAX(id) AS max_id
    FROM dados
    GROUP BY fkNotebook
    ) AS t2 ON t1.fkNotebook = t2.fkNotebook AND t1.id = t2.max_id
    JOIN funcionario where t2.fkNotebook = funcionario.idFuncionario;`;
    return database.executar(instrucaoSql);
  }

  // function plotarGrafico() {
  // var instrucaoSql = `SELECT 
  //   funcionario.nome AS nome_funcionario, 
  //   notebook.idNotebook AS fkNotebook, 
  //   dados.processos,
  //   dados.porcentagem_cpu,
  //   dados.porcentagem_ram
  //   FROM 
  //   dados 
  //   JOIN 
  //   notebook ON dados.fkNotebook = notebook.idNotebook 
  //   JOIN 
  //   funcionario ON notebook.idNotebook = funcionario.idFuncionario 
  //   ORDER BY 
  //   funcionario.nome, notebook.idNotebook;`;
  
  //   return database.executar(instrucaoSql);
  // }

 function plotarGrafico() {
  var instrucaoSql = `SELECT funcionario.nome, t1.processos, t1.fkNotebook, t1.porcentagem_cpu, t1.porcentagem_ram
    FROM dados AS t1
    JOIN (
    SELECT fkNotebook, MAX(id) AS max_id
    FROM dados
    GROUP BY fkNotebook
    ) AS t2 ON t1.fkNotebook = t2.fkNotebook AND t1.id = t2.max_id
    JOIN funcionario where t2.fkNotebook = funcionario.idFuncionario;`;
  
    return database.executar(instrucaoSql);
  }
  


module.exports = {
    processos, 
    ultimosDados,
    plotarGrafico
};