var usuarioModel = require("../models/usuarioModel");

function chamar_usuario(req, res) {
    var id_Usuario = req.body.id_UsuarioServer
    usuarioModel.chamar_usuario(id_Usuario)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}

function listarGerente(req, res) {
    var idUsuarioModel = req.body.idUsuarioServer
    usuarioModel.listarGerente(idUsuarioModel)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}

function listarUsuarios(req, res) {
    var empresaModel = req.body.empresaServer
    usuarioModel.listarUsuarios(empresaModel)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}

function autenticar(req, res) {
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está indefinida!");
    } else {

        usuarioModel.autenticar(email, senha)
            .then(
                function (resultadoAutenticar) {
                    console.log(`\nResultados encontrados: ${resultadoAutenticar.length}`);
                    console.log(`Resultados: ${JSON.stringify(resultadoAutenticar)}`); // transforma JSON em String

                    if (resultadoAutenticar.length == 1) {
                        console.log(resultadoAutenticar);
                        res.json({
                            idFuncionario: resultadoAutenticar[0].idFuncionario,
                            email: resultadoAutenticar[0].email,
                            nome: resultadoAutenticar[0].nome,
                            senha: resultadoAutenticar[0].senha
                        });

                    } else if (resultadoAutenticar.length == 0) {
                        res.status(403).send("Email e/ou senha inválido(s)");
                    } else {
                        res.status(403).send("Mais de um usuário com o mesmo login e senha!");
                    }
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log("\nHouve um erro ao realizar o login! Erro: ", erro.sqlMessage);
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }

}

function cadastrar(req, res) {
    var nome = req.body.nomeServer;
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;
    var cargo = req.body.cargoServer;
    var cpf = req.body.cpfServer;
    var fkEmpresa = req.body.empresaServer;

    if (nome == undefined) {
        res.status(400).send("Seu nome está undefined!");
    } else if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está undefined!");
    } else {

        var cpfSemMascara = cpf.replace(/\D/g, '');
        usuarioModel.cadastrar(cargo, nome, cpfSemMascara, email, senha, fkEmpresa)
            .then(
                function (resultado) {
                    res.json(resultado);
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log(
                        "\nHouve um erro ao realizar o cadastro! Erro: ",
                        erro.sqlMessage
                    );
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }
}


module.exports = {
    autenticar,
    cadastrar,
    chamar_usuario,
    listarGerente,
    listarUsuarios
}