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


function listarDadosBarra(req, res) {
    var fkNotebookBase = req.body.fkNotebookBase; 
    var fkNotebookComparacao = req.body.fkNotebookComparacao;
  
    Promise.all([
      analistaModel.listarDadosPorNotebook(fkNotebookBase),
      analistaModel.listarDadosPorNotebook(fkNotebookComparacao)
    ])
    .then(resultado => {
      const dadosBase = resultado[0];
      const dadosComparacao = resultado[1];
  
      if (dadosBase.length > 0 && dadosComparacao.length > 0) {
        const dadosBarra = {
          base: {
            cpu: dadosBase[0].porcentagem_cpu,
            ram: dadosBase[0].porcentagem_ram,
            disco: dadosBase[0].porcentagem_disco,
            processos: dadosBase[0].processos
          },
          comparacao: {
            cpu: dadosComparacao[0].porcentagem_cpu,
            ram: dadosComparacao[0].porcentagem_ram,
            disco: dadosComparacao[0].porcentagem_disco,
            processos: dadosComparacao[0].processos
          }
        };
        res.json(dadosBarra);
      } else {
        res.status(404).json({ mensagem: "Nenhum dado encontrado para as máquinas especificadas." });
      }
    })
    .catch(err => {
      res.status(500).json({ mensagem: "Erro ao buscar dados para o gráfico de barra.", erro: err });
    });
  }
  function listarNomeResponsavel(req, res) {
    const { fkNotebook } = req.body;
    analistaModel.listarNomeResponsavel(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json({ nome_funcionario: resultado[0].nome_funcionario });
            } else {
                res.status(404).json({ mensagem: "Nenhum responsável encontrado para o notebook especificado." });
            }
        })
        .catch(erro => {
            console.error("Erro ao buscar o nome do responsável:", erro);
            res.status(500).json({ mensagem: "Erro ao buscar o nome do responsável." });
        });
  }
  
  
module.exports = { listarPorcentagemRAMPorNotebook, listarPorcentagemCPUPorNotebook, listarPorcentagemDiscoPorNotebook,listarDadosBarra,listarNomeResponsavel};
