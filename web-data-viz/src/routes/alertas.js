var express = require("express");
var router = express.Router();

var alertasController = require("../controllers/alertasController");

router.post("/buscarEmpresaDoGerenteLogado", function (req, res) {
    alertasController.buscarEmpresaDoGerenteLogado(req, res);
});

router.post("/listarFuncionarios", function (req, res) {
    alertasController.listarFuncionarios(req, res);
});

router.post("/buscarNotebookDoFuncionario", function (req, res) {
    alertasController.buscarNotebookDoFuncionario(req, res);
});

router.get("/exibirTotalAlertasHardware/:fkNotebook", function (req, res) {
    alertasController.exibirTotalAlertasHardware(req, res);
});

router.get("/exibirTotalAlertasProcessos/:fkNotebook", function (req, res) {
    alertasController.exibirTotalAlertasProcessos(req, res);
});

router.get("/exibirMediaAlertas", function (req, res) {
    alertasController.exibirMediaAlertas(req, res);
});

router.get("/exibirRankingFuncionarios", function (req, res) {
    alertasController.exibirRankingFuncionarios(req, res);
});

router.get("/buscarDados/:fkNotebook", function (req, res) {
    alertasController.buscarDados(req, res);
})

router.get("/obterDadosRegressao/", function (req, res) {
    alertasController.obterDadosRegressao(req, res);
})

module.exports = router;