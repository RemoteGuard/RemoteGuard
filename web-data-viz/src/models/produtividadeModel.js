var database = require("../database/config")

function buscarEmpresaDoGerenteLogado(idUsuario) {
    console.log("ACESSEI O ALERTAS MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        SELECT fkEmpresa FROM funcionario WHERE idFuncionario = '${idUsuario}';`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarProdutividadeCargo(idEmpresa, cargo) {
    console.log("ACESSEI O ALERTAS MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    
    var instrucaoSql = ''
    
    if (cargo == 'Todos') {
        instrucaoSql = `
        SELECT ROUND((AVG(dp.porcentagem_cpu) + AVG(dp.porcentagem_ram)) / 2, 1) AS produtividade_cargo
        FROM dados_produtividade dp
        JOIN notebook n ON dp.fkNotebook = n.idNotebook
        JOIN funcionario f ON f.fkNotebook = n.idNotebook
        WHERE
		    f.fkEmpresa = ${idEmpresa}
		    AND dp.data_captura BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE();`;
    }
    
    else {
        instrucaoSql = `
        SELECT ROUND((AVG(dp.porcentagem_cpu) + AVG(dp.porcentagem_ram)) / 2, 1) AS produtividade_cargo
        FROM dados_produtividade dp
        JOIN notebook n ON dp.fkNotebook = n.idNotebook
        JOIN funcionario f ON f.fkNotebook = n.idNotebook
        WHERE 
            f.fkEmpresa = ${idEmpresa}
            AND f.cargo = '${cargo}'
            AND dp.data_captura BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE();`;
    }

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarProdutividadeFuncionario(idEmpresa, cargo) {
    console.log("ACESSEI O ALERTAS MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    
    var instrucaoSql = ''

    if (cargo == 'Todos') {
        instrucaoSql = `
        SELECT 
            subquery.nome AS funcionario,
            subquery.cargo AS cargo,
            ROUND((subquery.media_cpu + subquery.media_ram) / 2, 1) AS produtividade
        FROM (
            SELECT 
                f.idFuncionario,
                f.nome,
                f.cargo,
                AVG(dp.porcentagem_cpu) AS media_cpu,
                AVG(dp.porcentagem_ram) AS media_ram
            FROM dados_produtividade dp
            JOIN notebook n ON dp.fkNotebook = n.idNotebook
            JOIN funcionario f ON f.fkNotebook = n.idNotebook
            WHERE 
                f.fkEmpresa = ${idEmpresa}
		        AND dp.data_captura BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
            GROUP BY f.idFuncionario, f.nome, f.cargo
        ) AS subquery;`;
    }

    else {
        instrucaoSql = `
        SELECT 
            subquery.nome AS funcionario,
            subquery.cargo AS cargo,
            ROUND((subquery.media_cpu + subquery.media_ram) / 2, 1) AS produtividade
        FROM (
            SELECT 
                f.idFuncionario,
                f.nome,
                f.cargo,
                AVG(dp.porcentagem_cpu) AS media_cpu,
                AVG(dp.porcentagem_ram) AS media_ram
            FROM dados_produtividade dp
            JOIN notebook n ON dp.fkNotebook = n.idNotebook
            JOIN funcionario f ON f.fkNotebook = n.idNotebook
            WHERE 
                f.fkEmpresa = ${idEmpresa}
                AND f.cargo = '${cargo}' 
		        AND dp.data_captura BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE()
            GROUP BY f.idFuncionario, f.nome, f.cargo
        ) AS subquery;`;
    }

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarProdutividadeCargoCrawler(cargo) {
    console.log("ACESSEI O ALERTAS MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = ''

    if (cargo == 'Todos') {
        instrucaoSql = `
        SELECT ROUND(AVG(media_produtividade), 1) AS produtividade_crawler FROM produtividade_crawler;`;
    }

    else {
        instrucaoSql = `
        SELECT ROUND(media_produtividade, 1) AS produtividade_crawler
	        FROM produtividade_crawler
            WHERE cargo = '${cargo}';`;
    }

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarEmpresaDoGerenteLogado,
    buscarProdutividadeCargo,
    buscarProdutividadeFuncionario,
    buscarProdutividadeCargoCrawler
};


