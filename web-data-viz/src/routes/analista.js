var express = require("express");
var router = express.Router();
var analistaController = require("../controllers/analistaController");

router.post("/listarPorcentagemRAM", analistaController.listarPorcentagemRAMPorNotebook);
router.post("/listarPorcentagemCPU", analistaController.listarPorcentagemCPUPorNotebook);
router.post("/listarPorcentagemDisco", analistaController.listarPorcentagemDiscoPorNotebook);
router.post("/listarDadosBarra", analistaController.listarDadosBarra);
router.post("/listarNomeResponsavel", analistaController.listarNomeResponsavel);
router.post("/listarQuantidadeProcessos", analistaController.listarQuantidadeProcessos);
router.post("/listarInformacaoesFuncionario", analistaController.listarInformacaoesFuncionario);
router.post("/listarInformacaoesNotebook", analistaController.listarInformacaoesNotebook);
router.post("/listarNumeroNucleos", analistaController.listarNumeroNucleos);
router.post("/listarNotebook", analistaController.listarNotebooks);
module.exports = router;
