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


  function updateFunc(funcionario, idMaquina) {
    var instrucaoSql = `UPDATE funcionario SET fkNotebook = '${idMaquina}' WHERE idFuncionario = '${funcionario}';`;
    
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
  }


  function cadastrarDisco(discos, capacidade, fkNotebook) {
    var instrucaoSql = `INSERT INTO armazenamento (qtdDiscos, tamanhoTotal, fkNotebook) VALUES ('${discos}', '${capacidade}', '${fkNotebook}');`;
    
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
  }

module.exports = {
    cadastrarNote,
    updateFunc,
    cadastrarDisco
};