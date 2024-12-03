var produtividadeModel = require("../models/produtividadeModel");

function buscarEmpresaDoGerenteLogado(req, res) {
    var idUsuarioModel = req.body.idUsuarioServer
    produtividadeModel.buscarEmpresaDoGerenteLogado(idUsuarioModel)
        .then(
            function (resultado) {
                res.json({
                    resultado
                });
            }
        )
}

function buscarProdutividadeCargo(req, res) {
    const { idEmpresa } = req.params
    const { cargo } = req.params
    produtividadeModel.buscarProdutividadeCargo(idEmpresa, cargo)
        .then(resultado => {
            res.json(resultado);
        })
        .catch(erro => {
            console.error("Erro ao buscar produtividade:", erro.sqlMessage);
            res.status(500).json({ message: "Erro ao buscar dados de produtividade." });
        });
}

function buscarProdutividadeFuncionario(req, res) {
    const { idEmpresa } = req.params
    const { cargo } = req.params
    produtividadeModel.buscarProdutividadeFuncionario(idEmpresa, cargo)
        .then(resultado => {
            res.json(resultado);
        })
        .catch(erro => {
            console.error("Erro ao buscar produtividade:", erro.sqlMessage);
            res.status(500).json({ message: "Erro ao buscar dados de produtividade." });
        });
}

function buscarProdutividadeCargoCrawler(req, res) {
    const { cargo } = req.params;
    produtividadeModel.buscarProdutividadeCargoCrawler(cargo)
        .then(resultado => {
            res.json(resultado);
        })
        .catch(erro => {
            console.error("Erro ao buscar produtividade:", erro.sqlMessage);
            res.status(500).json({ message: "Erro ao buscar dados de produtividade." });
        });
}


module.exports = {
    buscarEmpresaDoGerenteLogado,
    buscarProdutividadeCargo,
    buscarProdutividadeFuncionario,
    buscarProdutividadeCargoCrawler
};