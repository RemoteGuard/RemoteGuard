var database = require("../database/config");

function listarPorcentagemRAMPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT porcentagem_ram, data_captura FROM dados WHERE fkNotebook =  ${fkNotebook} ORDER BY data_captura DESC LIMIT 10;
;`; 
  return database.executar(instrucaoSql);
}
function listarPorcentagemCPUPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT porcentagem_cpu, data_captura FROM dados WHERE fkNotebook = ${fkNotebook} ORDER BY data_captura DESC LIMIT 10;`; 
  return database.executar(instrucaoSql);
}

function listarPorcentagemDiscoPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT porcentagem_disco, data_captura FROM dados WHERE fkNotebook = ${fkNotebook} ORDER BY data_captura DESC LIMIT 1;`;
  return database.executar(instrucaoSql);
}
module.exports = { listarPorcentagemRAMPorNotebook,listarPorcentagemCPUPorNotebook,listarPorcentagemDiscoPorNotebook};
