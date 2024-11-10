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

function listarDadosPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT porcentagem_cpu, porcentagem_ram, porcentagem_disco, data_captura FROM dados WHERE fkNotebook = ${fkNotebook} ORDER BY data_captura DESC LIMIT 1;`;
  return database.executar(instrucaoSql);
}

function listarNomeResponsavel(fkNotebook) {
  const instrucaoSql = `
      SELECT funcionario.nome AS nome_funcionario
      FROM funcionario
      JOIN notebook ON funcionario.fkNotebook = notebook.idNotebook
      WHERE notebook.idNotebook = ${fkNotebook};
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
}

module.exports = { listarPorcentagemRAMPorNotebook,listarPorcentagemCPUPorNotebook,listarPorcentagemDiscoPorNotebook,listarDadosPorNotebook,listarNomeResponsavel};
