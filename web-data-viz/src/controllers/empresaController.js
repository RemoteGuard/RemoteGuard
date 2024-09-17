var empresaModel = require("../models/empresaModel");

function listar(req, res) {
  var requisicaoPadrao = req.body.requisicaoPadraoServer

  empresaModel.listar(requisicaoPadrao)
    .then(
      function (resultado) {

        res.json({
          resultado
        });
      }
    )
}


module.exports = {
  listar
};
