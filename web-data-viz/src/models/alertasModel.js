var database = require("../database/config")

function buscarEmpresaDoGerenteLogado(idUsuario) {
    console.log("ACESSEI O ALERTAS MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        SELECT fkEmpresa FROM funcionario WHERE idFuncionario = '${idUsuario}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function listarFuncionarios(empresaModel) {
    console.log("ACESSEI O ALERTAS MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        SELECT * FROM funcionario WHERE fkEmpresa = '${empresaModel}' AND fkNotebook IS NOT null;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarNotebookDoFuncionario(fkNotebookModel) {
    console.log("ACESSEI O ALERTAS MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        SELECT fkNotebook FROM funcionario WHERE idFuncionario = '${fkNotebookModel}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function exibirTotalAlertasHardware(fkNotebook) {
    var instrucaoSql = `SELECT COUNT(idAlerta) AS alertas FROM alerta WHERE fkNotebook = '${fkNotebook}' AND descricao LIKE "Recurso%"`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function exibirTotalAlertasProcessos(fkNotebook) {
    var instrucaoSql = `SELECT COUNT(idAlerta) AS alertas FROM alerta WHERE fkNotebook = '${fkNotebook}' AND descricao LIKE "Processo indevido%";
`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


module.exports = {
    buscarEmpresaDoGerenteLogado,
    listarFuncionarios,
    buscarNotebookDoFuncionario,
    exibirTotalAlertasHardware,
    exibirTotalAlertasProcessos
};