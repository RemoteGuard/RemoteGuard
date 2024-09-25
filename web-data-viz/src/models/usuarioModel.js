var database = require("../database/config")

function autenticar(email, senha) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ", email, senha)
    var instrucaoSql = `
        SELECT idFuncionario, nome, email, fkEmpresa as empresaId FROM funcionario WHERE email = '${email}' AND senha = '${senha}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

// Coloque os mesmos parâmetros aqui. Vá para a var instrucaoSql
function cadastrar(cargo, nome, cpf, email, senha, fkEmpresa) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function cadastrar():", cargo, nome, cpf, email, senha, fkEmpresa);
    
    var instrucaoSql = `
        INSERT INTO funcionario (cargo, nome, cpf, email, senha, fkEmpresa) 
        VALUES ('${cargo}', '${nome}', '${cpf}', '${email}', '${senha}', '${fkEmpresa}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}
function chamar_usuario(id_Usuario) {
    console.log("Executando a instrução SQL: \n" + instrucaoSql3);
    var instrucaoSql3 = `
    SELECT cargo from funcionario WHERE idFuncionario = ${id_Usuario};
`;
    return database.executar(instrucaoSql3);
}
module.exports = {
    autenticar,
    cadastrar,
    chamar_usuario
};