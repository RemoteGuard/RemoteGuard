var analistaModel = require("../models/analistaModel");

function listarPorcentagemRAMPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;
    analistaModel.listarPorcentagemRAMPorNotebook(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json(resultado);
            } else {
                res.status(404).json({ mensagem: "Nenhum dado encontrado para o notebook especificado." });
            }
        })
      
}

function listarPorcentagemCPUPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;
    analistaModel.listarPorcentagemCPUPorNotebook(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json(resultado);
            } else {
                res.status(404).json({ mensagem: "Nenhum dado encontrado para o notebook especificado." });
            }
        })
    
}

function listarPorcentagemDiscoPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;

    analistaModel.listarPorcentagemDiscoPorNotebook(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json(resultado[0]);
            } else {
                res.status(404).json({ mensagem: "Nenhum dado encontrado para o notebook especificado." });
            }
        })
    
}

module.exports = { listarPorcentagemRAMPorNotebook, listarPorcentagemCPUPorNotebook, listarPorcentagemDiscoPorNotebook };
