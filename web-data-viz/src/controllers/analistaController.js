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

    Promise.all([
        analistaModel.listarDadosPorNotebook(fkNotebookBase),
        analistaModel.listarDadosMediaPorNotebooks() 
    ])
    .then(resultado => {
        const dadosBase = resultado[0];
        const dadosMedia = resultado[1]; 

        if (dadosBase.length > 0 && dadosMedia.length > 0) {
            const dadosBarra = {
                base: {
                    cpu: dadosBase[0].porcentagem_cpu,
                    ram: dadosBase[0].porcentagem_ram,
                    disco: dadosBase[0].porcentagem_disco,
                   
                },
                media: {
                    cpu: dadosMedia[0].media_cpu,
                    ram: dadosMedia[0].media_ram,
                    disco: dadosMedia[0].media_disco,
                   
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

function listarMediaPonderada(req, res) {
    const { fkNotebook } = req.body;
    analistaModel.listarMediaPonderada(fkNotebook)
    .then(resultado => {
        if (resultado.length > 0) {
            res.json({media_ponderada : resultado[0].media_ponderada });
            }
        })
            }
            function listarRecursoAlerta(req, res) {
                const { fkNotebook } = req.body;  // Garantir que fkNotebook está sendo recebido corretamente.
                analistaModel.listarRecursoAlerta(fkNotebook)
                    .then(resultado => {
                        if (resultado.length > 0) {
                            const dadosRecurso = resultado[0];
                            const recursoAlerta = [
                                {
                                    recurso: 'CPU',
                                    porcentagem: dadosRecurso.porcentagem_cpu,
                                    tempoEmAlerta: dadosRecurso.tempo_alerta_cpu
                                },
                                {
                                    recurso: 'RAM',
                                    porcentagem: dadosRecurso.porcentagem_ram,
                                    tempoEmAlerta: dadosRecurso.tempo_alerta_ram
                                },
                                {
                                    recurso: 'Disco',
                                    porcentagem: dadosRecurso.porcentagem_disco,
                                    tempoEmAlerta: dadosRecurso.tempo_alerta_disco
                                }
                            ];
                            res.json({ recurso_alerta: recursoAlerta });
                        } else {
                            res.json({ recurso_alerta: [] });  
                        }
                    })
                    .catch(error => {
                        console.error("Erro ao listar alertas de recurso:", error);
                        res.status(500).json({ error: "Erro no servidor." });
                    });
            }
            
            

  
module.exports = { listarNotebooks,listarPorcentagemRAMPorNotebook, listarPorcentagemCPUPorNotebook, listarPorcentagemDiscoPorNotebook,listarDadosBarra,listarNomeResponsavel,listarQuantidadeProcessos,
    listarInformacaoesFuncionario, listarInformacaoesNotebook,listarNumeroNucleos,listarMediaPonderada,listarRecursoAlerta};
