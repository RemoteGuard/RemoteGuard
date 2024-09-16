var express = require("express");
var router = express.Router();

var empresaController = require("../controllers/empresaController");

//Recebendo os dados do html e direcionando para a função cadastrar de usuarioController.js
router.post("/listar", function (req, res) {
    empresaController.listar(req, res);
})

module.exports = router;