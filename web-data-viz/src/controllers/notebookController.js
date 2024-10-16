var notebookModel = require("../models/notebookModel");

function cadastrarNote(req, res) {
    var marca = req.body.marcaServer;
    var modelo = req.body.modeloServer;
    var processador = req.body.processadorServer;
    var ram = req.body.ramServer;

    if (marca == undefined) {
        res.status(400).send("A marca está undefined!");
    } else if (modelo == undefined) {
        res.status(400).send("O modelo está undefined!");
    } else if (processador == undefined) {
        res.status(400).send("O processador está undefined!");
    } else if (ram == undefined) {
        res.status(400).send("A ram está undefined!");
    } 
    else {
        notebookModel.cadastrarNote(marca, modelo, ram, processador)
            .then(
                function (resultado) {
                    res.json(resultado);
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log(
                        "\nHouve um erro ao realizar o cadastro do notebook! Erro: ",
                        erro.sqlMessage
                    );
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }
}

function buscarNotebook(req, res) {
    var requisicaoPadrao = req.body.requisicaoPadraoServer
    notebookModel.buscarNotebook(requisicaoPadrao)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}



module.exports = {
   cadastrarNote,
   buscarNotebook
}