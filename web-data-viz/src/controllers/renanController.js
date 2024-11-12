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

  
module.exports = {
    processos
}