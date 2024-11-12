var database = require("../database/config")

function processos() {
    var instrucaoSql = `select processos from dados order by fkNotebook;`;
  
    return database.executar(instrucaoSql);
  }

module.exports = {
    processos
};