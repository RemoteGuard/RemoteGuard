var express = require("express");
var router = express.Router();
var anaController = require("../controllers/anaController");

router.get("/processos", anaController.listarProcessos);

router.get("/grafico/:selectProcesso", function(req, res) {
    anaController.obterDadosGraficoDias(req, res)
});

router.get("/graficoSemanas/:selectProcesso", function(req, res) {
    anaController.obterDadosGraficoSemanas(req, res)
});

router.get("/rankingMes/:selectProcesso", function(req, res) {
    anaController.obterRankingMes(req, res)
});

router.get("/rankingSemana/:selectProcesso", function(req, res) {
    anaController.obterRankingSemana(req, res)
});

router.get("/cardTotalDias/:selectProcesso", function(req, res) {
    anaController.ObterTotalDias(req, res)
});

router.get("/cardTotalMes/:selectProcesso", function(req, res) {
    anaController.ObterTotalMes(req, res)
});

router.get("/obterMaiorProcessoSemanas", function(req,res){
    anaController.obterMaiorProcessoSemana(req,res)
})

router.get("/obterMaiorProcessoMensal", function(req,res){
    anaController.obterMaiorProcessoMes(req,res)
})

module.exports = router;