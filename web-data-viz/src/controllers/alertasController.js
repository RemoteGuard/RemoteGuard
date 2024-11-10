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

module.exports = {
    buscarEmpresaDoGerenteLogado,
    listarFuncionarios
}