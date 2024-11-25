var database = require("../database/config");

function listar() {
  var instrucaoSql = `SELECT * FROM empresa`;

  return database.executar(instrucaoSql);
}

function cadastrarEmpresa(razaoSocial, nomeFantasia, cep, numero, telefone, email, cnpj, token) {
  var instrucaoSql = `INSERT INTO empresa (razaoSocial, nomeFantasia, cep, numero, telefone, email, cnpj, token) VALUES ('${razaoSocial}', '${nomeFantasia}', '${cep}', '${numero}', '${telefone}', '${email}', '${cnpj}', '${token}' ) `;

  return database.executar(instrucaoSql);
}

module.exports = {
  listar,
  cadastrarEmpresa

};
