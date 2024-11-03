var analistaModel = require("../models/analistaModel");

function listarPorcentagemRAMPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;


    // Verificar se fkNotebook foi passado e é um número
    if (!fkNotebook || typeof fkNotebook !== 'number') {
        return res.status(400).json({ mensagem: "fkNotebook deve ser um número." });
    }

    analistaModel.listarPorcentagemRAMPorNotebook(fkNotebook)
        .then(function (resultado) {
            if (resultado.length > 0) {
                res.json(resultado);
            } else {
                res.status(404).json({ mensagem: "Nenhum dado encontrado para o notebook especificado." });
            }
        })
        .catch(function (erro) {
            console.error("Erro ao buscar porcentagem de RAM por notebook: ", erro);
            res.status(500).json({ erro: "Erro ao buscar porcentagem de RAM" });
        });
}

function listarPorcentagemCPUPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;

    if (!fkNotebook || typeof fkNotebook !== 'number') {
        return res.status(400).json({ mensagem: "fkNotebook deve ser um número." });
    }

    analistaModel.listarPorcentagemCPUPorNotebook(fkNotebook)
        .then(function (resultado) {
            if (resultado.length > 0) {
                res.json(resultado);
            } else {
                res.status(404).json({ mensagem: "Nenhum dado encontrado para o notebook especificado." });
            }
        })
        .catch(function (erro) {
            console.error("Erro ao buscar porcentagem de CPU por notebook: ", erro);
            res.status(500).json({ erro: "Erro ao buscar porcentagem de CPU" });
        });
}

function listarPorcentagemDiscoPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;

    if (!fkNotebook || typeof fkNotebook !== 'number') {
        return res.status(400).json({ mensagem: "fkNotebook deve ser um número." });
    }

    analistaModel.listarPorcentagemDiscoPorNotebook(fkNotebook)
        .then(function (resultado) {
            if (resultado.length > 0) {
                res.json(resultado[0]); 
            } else {
                res.status(404).json({ mensagem: "Nenhum dado encontrado para o notebook especificado." });
            }
        })
        .catch(function (erro) {
            console.error("Erro ao buscar porcentagem de disco por notebook: ", erro);
            res.status(500).json({ erro: "Erro ao buscar porcentagem de disco" });
        });
}
module.exports = { listarPorcentagemRAMPorNotebook,listarPorcentagemCPUPorNotebook,listarPorcentagemDiscoPorNotebook};
