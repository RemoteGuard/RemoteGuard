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

router.get("/exibirTotalAlertasHardware/:fkNotebook/:inicio/:fim", function (req, res) {
    alertasController.exibirTotalAlertasHardware(req, res);
});

router.get("/exibirTotalAlertasProcessos/:fkNotebook/:inicio/:fim", function (req, res) {
    alertasController.exibirTotalAlertasProcessos(req, res);
});

router.get("/exibirMediaAlertas/:inicio/:fim", function (req, res) {
    alertasController.exibirMediaAlertas(req, res);
});

router.post("/exibirRankingFuncionarios/:inicio/:fim", function (req, res) {
    alertasController.exibirRankingFuncionarios(req, res);
});

router.get("/buscarDados/:fkNotebook/:inicio/:fim", function (req, res) {
    alertasController.buscarDados(req, res);
})

router.get("/buscarDadosComparacaoAlertas/:inicio/:fim", function (req, res) {
    alertasController.buscarDadosComparacaoAlertas(req, res);
})

module.exports = router;