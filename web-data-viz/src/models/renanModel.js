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

module.exports = {
    processos, 
    ultimosDados
};