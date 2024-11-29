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
    var instrucaoSql = `SELECT COUNT(idAlerta) as alertas FROM alerta WHERE fkNotebook = '${fkNotebook}' AND descricao LIKE "Recurso%" AND dataHora >= CURDATE() - INTERVAL 7 DAY;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function exibirTotalAlertasProcessos(fkNotebook) {
    var instrucaoSql = `SELECT COUNT(idAlerta) as alertas FROM alerta WHERE fkNotebook = '${fkNotebook}' AND descricao LIKE "Processo indevido%" AND dataHora >= CURDATE() - INTERVAL 7 DAY;
`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function exibirMediaAlertas() {
    var instrucaoSql = `SELECT TRUNCATE(AVG(qtdAlertas), 0) AS mediaAlertas
                        FROM (
                        SELECT COUNT(idAlerta) AS qtdAlertas
                        FROM alerta
                        WHERE dataHora >= NOW() - INTERVAL 7 DAY
                        GROUP BY fkNotebook
                        ) AS mediaAlertas;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function exibirRankingFuncionarios(empresaGerente) {
    var instrucaoSql = `SELECT f.nome AS nome, COUNT(a.idAlerta) AS qtdAlertas
    FROM alerta AS a
    JOIN notebook AS n ON a.fkNotebook = n.idNotebook
    JOIN funcionario AS f ON f.fkNotebook = n.idNotebook
    WHERE dataHora >= NOW() - INTERVAL 7 DAY
    AND fkEmpresa = '${empresaGerente}'
    GROUP BY f.idFuncionario
    ORDER BY qtdAlertas DESC;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarDados(fkNotebook) {
    var instrucaoSql = `SELECT DATE_FORMAT(dataHora, '%W') as DiaSemana,
                        COUNT(idAlerta) as FreqAlertas
                        FROM alerta WHERE fkNotebook = '${fkNotebook}'
                        AND dataHora >= CURDATE() - INTERVAL 7 DAY
                        GROUP BY DATE_FORMAT(dataHora, '%W');`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarDadosComparacaoAlertas() {
    var instrucaoSql = `SELECT DATE_FORMAT(dataHora, '%W') AS DiaSemana,
                        COUNT(CASE WHEN descricao LIKE 'Processo%' THEN 1 END) AS FreqAlertasProcessos,
                        COUNT(CASE WHEN descricao LIKE 'Recurso%' THEN 1 END) AS FreqAlertasHW
                        FROM alerta WHERE dataHora >= CURDATE() - INTERVAL 7 DAY
                        GROUP BY DATE_FORMAT(dataHora, '%W');`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}



module.exports = {
    buscarEmpresaDoGerenteLogado,
    listarFuncionarios,
    buscarNotebookDoFuncionario,
    exibirTotalAlertasHardware,
    exibirTotalAlertasProcessos,
    exibirMediaAlertas,
    exibirRankingFuncionarios,
    buscarDados,
    buscarDadosComparacaoAlertas
};