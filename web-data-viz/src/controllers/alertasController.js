var alertasModel = require("../models/alertasModel");

function buscarEmpresaDoGerenteLogado(req, res) {
    var idUsuarioModel = req.body.idUsuarioServer
    alertasModel.buscarEmpresaDoGerenteLogado(idUsuarioModel)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}

function listarFuncionarios(req, res) {
    var empresaModel = req.body.empresaServer
    alertasModel.listarFuncionarios(empresaModel)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}

function buscarNotebookDoFuncionario(req, res) {
    var fkNotebookModel = req.body.fkNotebookServer
    alertasModel.buscarNotebookDoFuncionario(fkNotebookModel)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}

function exibirTotalAlertasHardware(req, res) {
    const { fkNotebook } = req.params
    alertasModel.exibirTotalAlertasHardware(fkNotebook)
    .then(function (resultado) {
        res.json(resultado);
    })
    .catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar os alertas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

function exibirTotalAlertasProcessos(req, res) {
    const { fkNotebook } = req.params
    alertasModel.exibirTotalAlertasProcessos(fkNotebook)
    .then(function (resultado) {
        res.json(resultado);
    })
    .catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar os alertas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

function exibirMediaAlertas(req, res) {
    alertasModel.exibirMediaAlertas()
    .then(function (resultado) {
        res.json(resultado);
    })
    .catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as ultimas medidas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

function exibirRankingFuncionarios(req, res) {
    alertasModel.exibirRankingFuncionarios()
    .then(function (resultado) {
        res.json(resultado);
    })
    .catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as ultimas medidas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

module.exports = {
    buscarEmpresaDoGerenteLogado,
    listarFuncionarios,
    buscarNotebookDoFuncionario,
    exibirTotalAlertasHardware,
    exibirTotalAlertasProcessos,
    exibirMediaAlertas,
    exibirRankingFuncionarios
}