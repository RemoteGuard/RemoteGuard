var express = require("express");
var router = express.Router();
var renanController = require("../controllers/renanController");


router.post("/processos", function (req, res) {
    renanController.processos(req, res);
})

router.post("/ultimosDados", function (req, res) {
    renanController.ultimosDados(req, res);
})
module.exports = router;