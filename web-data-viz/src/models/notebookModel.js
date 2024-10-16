var database = require("../database/config")

function cadastrarNote(marca, modelo, ram, processador) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function cadastrar():");
    
    var instrucaoSql = `
        INSERT INTO notebook (marca, modelo, memoriaRAM, processador) 
        VALUES ('${marca}', '${modelo}', '${ram}', '${processador}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarNotebook() {
    var instrucaoSql = `SELECT * FROM notebook ORDER BY idNotebook DESC LIMIT 1`;
  
    return database.executar(instrucaoSql);
  }

module.exports = {
    cadastrarNote,
    buscarNotebook
};