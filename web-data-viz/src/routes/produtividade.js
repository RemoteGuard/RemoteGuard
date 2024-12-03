var express = require("express");
var router = express.Router();

var alertasController = require("../controllers/produtividadeController");

router.post("/buscarEmpresaDoGerenteLogado", function (req, res) {
    alertasController.buscarEmpresaDoGerenteLogado(req, res);
});

router.get("/buscarProdutividadeCargo/:idEmpresa/:cargo", function (req, res) {
    alertasController.buscarProdutividadeCargo(req, res);
});

router.get("/buscarProdutividadeFuncionario/:idEmpresa/:cargo", function (req, res) {
    alertasController.buscarProdutividadeFuncionario(req, res);
});

router.get("/buscarProdutividadeCargoCrawler/:cargo", function (req, res) {
    alertasController.buscarProdutividadeCargoCrawler(req, res);
});

module.exports = router;