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
    const { inicio } = req.params
    const { fim } = req.params
    alertasModel.exibirTotalAlertasHardware(fkNotebook, inicio, fim)
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
    const { inicio } = req.params
    const { fim } = req.params
    alertasModel.exibirTotalAlertasProcessos(fkNotebook, inicio, fim)
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
    const { inicio } = req.params
    const { fim } = req.params
    alertasModel.exibirMediaAlertas(inicio, fim)
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
    var empresaModel = req.body.empresaServer
    const { inicio } = req.params
    const { fim } = req.params
    alertasModel.exibirRankingFuncionarios(empresaModel, inicio, fim)
    .then(function (resultado) {
        res.json(resultado);
    })
    .catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as ultimas medidas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

function buscarDados(req, res) {
    const { fkNotebook } = req.params
    var empresaModel = req.body.empresaServer
    const { inicio } = req.params
    const { fim } = req.params
    alertasModel.buscarDados(fkNotebook, inicio, fim).then(function (resultado) {
        if (resultado.length > 0) {
            res.status(200).json(resultado);
        } else {
            res.status(204).send("Nenhum resultado encontrado!")
        }
    }).catch(function (erro) {
        console.log(erro);
        res.status(500).json(erro.sqlMessage);
    });
}


function buscarDadosComparacaoAlertas(req, res) {
    const { inicio } = req.params
    const { fim } = req.params
    alertasModel.buscarDadosComparacaoAlertas(inicio, fim)
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
    exibirRankingFuncionarios,
    buscarDados,
    buscarDadosComparacaoAlertas
}