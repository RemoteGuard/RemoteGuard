var express = require("express");
var router = express.Router();

var alertasController = require("../controllers/alertasController");

router.post("/buscarEmpresaDoGerenteLogado", function (req, res) {
    alertasController.buscarEmpresaDoGerenteLogado(req, res);
});

router.post("/listarFuncionarios", function (req, res) {
    alertasController.listarFuncionarios(req, res);
});

module.exports = router;