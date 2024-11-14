var renanModel = require("../models/renanModel");

function processos(req, res) {
    var requisicaoPadrao = req.body.requisicaoPadraoServer
  
    renanModel.processos(requisicaoPadrao)
      .then(
        function (resultado) {
          res.json({
            resultado
          });
        }
      )
  }

function ultimosDados(req, res) {
    var requisicaoPadrao = req.body.requisicaoPadraoServer
  
    renanModel.ultimosDados(requisicaoPadrao)
      .then(
        function (resultado) {
          res.json({
            resultado
          });
        }
      )
  }

  function plotarGrafico(req, res) {
    var requisicaoPadrao = req.body.requisicaoPadraoServer
  
    renanModel.plotarGrafico(requisicaoPadrao)
      .then(
        function (resultado) {
          res.json({
            resultado
          });
        }
      )
  }


  
module.exports = {
    processos,
    ultimosDados,
    plotarGrafico
}