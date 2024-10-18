var notebookModel = require("../models/notebookModel");

function cadastrarNote(req, res) {
    var marca = req.body.marcaServer;
    var modelo = req.body.modeloServer;
    var processador = req.body.processadorServer;
    var ram = req.body.ramServer;
    var funcionario = req.body.funcionarioServer;
    var discos = req.body.discosServer;
    var capacidade = req.body.capacidadeServer;

    if (marca == undefined) {
        res.status(400).send("A marca está undefined!");
    } else if (modelo == undefined) {
        res.status(400).send("O modelo está undefined!");
    } else if (processador == undefined) {
        res.status(400).send("O processador está undefined!");
    } else if (ram == undefined) {
        res.status(400).send("A ram está undefined!");
    } else if (discos == undefined) {
        res.status(400).send("O disco está undefined!");
    } else if (capacidade == undefined) {
        res.status(400).send("A capacidade está undefined!");
    }
    else {
        notebookModel.cadastrarNote(marca, modelo, ram, processador)
            .then(
                function (resultado) {
                   
                    notebookModel.updateFunc(funcionario, resultado.insertId).catch(
                        function (erro) {
                            console.log(erro);
                            console.log(
                                "\nHouve um erro ao realizar o cadastro! Erro: ",
                                erro.sqlMessage
                            );
                            res.status(500).json(erro.sqlMessage);
                        }
                    )
                    notebookModel.cadastrarDisco(discos, capacidade, resultado.insertId).catch(
                        function (erro) {
                            console.log(erro);
                            console.log(
                                "\nHouve um erro ao realizar o cadastro! Erro: ",
                                erro.sqlMessage
                            );
                            res.status(500).json(erro.sqlMessage);
                        }
                    )

                    res.json(resultado);
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log(
                        "\nHouve um erro ao realizar o cadastro da fkNotebook! Erro: ",
                        erro.sqlMessage
                    );
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }
}



module.exports = {
   cadastrarNote
}