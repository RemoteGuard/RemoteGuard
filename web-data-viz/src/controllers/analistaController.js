var analistaModel = require("../models/analistaModel");



function listarNotebooks(req, res) {
    analistaModel.listarNotebook()
        .then(resultado => {
            if (resultado.length > 0) {
                res.json(resultado);
            } 
        })
}





function listarPorcentagemRAMPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;
    analistaModel.listarPorcentagemRAMPorNotebook(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json(resultado);
            } 
        })

}

function listarPorcentagemCPUPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;
    analistaModel.listarPorcentagemCPUPorNotebook(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json(resultado);
            }
        })
    
}

function listarPorcentagemDiscoPorNotebook(req, res) {
    var fkNotebook = req.body.fkNotebook;

    analistaModel.listarPorcentagemDiscoPorNotebook(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json(resultado[0]);
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
      }
    })
  
  }
  function listarNomeResponsavel(req, res) {
    const { fkNotebook } = req.body;
    analistaModel.listarNomeResponsavel(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json({ nome_funcionario: resultado[0].nome_funcionario })
                ;
            } 
        })
    
  }
  
  function listarQuantidadeProcessos(req, res) {
    const { fkNotebook } = req.body;
    analistaModel.listarQuantidadeProcessos(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json({ processos: resultado[0].processos });
            }
        })

}

function listarInformacaoesFuncionario(req, res) {
    const { fkNotebook } = req.body;
    analistaModel.listarInformacaoesFuncionario(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json({
                    nome_funcionario: resultado[0].nome_funcionario,
                    email_funcionario: resultado[0].email_funcionario,
                    cargo_funcionario: resultado[0].cargo_funcionario
                });
            } 
        })
        
}

function listarInformacaoesNotebook(req, res) {
    const { fkNotebook } = req.body;
    analistaModel.listarInformacaoesNotebook(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json({
                    hostname: resultado[0].hostname,
                    marca: resultado[0].marca,
                    modelo: resultado[0].modelo,
                    memoriaRAM: resultado[0].memoriaRAM,
                    processador: resultado[0].processador,
                    qtdDiscos: resultado[0].qtdDiscos,
                    tamanhoTotal: resultado[0].tamanhoTotal
                });
            }
        })
}

function listarNumeroNucleos(req, res) {
    const { fkNotebook } = req.body;
    analistaModel.listarNumeroNucleos(fkNotebook)
        .then(resultado => {
            if (resultado.length > 0) {
                res.json({numero_nucleos : resultado[0].numero_nucleos });
            }
        })

}
  
module.exports = { listarNotebooks,listarPorcentagemRAMPorNotebook, listarPorcentagemCPUPorNotebook, listarPorcentagemDiscoPorNotebook,listarDadosBarra,listarNomeResponsavel,listarQuantidadeProcessos,
    listarInformacaoesFuncionario, listarInformacaoesNotebook,listarNumeroNucleos};
