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


function cadastrarEmpresa(req, res) {
  var razaoSocial = req.body.razaoSocialServer;
  var nomeFantasia = req.body.nomeFantasiaServer;
  var cep = req.body.cepServer;
  var numero = req.body.numeroServer;
  var telefone = req.body.telefoneServer;
  var email = req.body.emailServer;
  var cnpj = req.body.cnpjServer;
  var token = req.body.tokenServer;

    empresaModel.cadastrarEmpresa(razaoSocial, nomeFantasia, cep, numero, telefone, email, cnpj, token)
      .then(
        function (resultado) {
          res.json(resultado);
        }
      ).catch(
        function (erro) {
          console.log(erro);
          console.log(
            "\nHouve um erro ao realizar o cadastro! Erro: ",
            erro.sqlMessage
          );
          res.status(500).json(erro.sqlMessage);
        }
      );
  }

module.exports = {
  listar,
  cadastrarEmpresa
};
