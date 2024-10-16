var express = require("express");
var router = express.Router();

var usuarioController = require("../controllers/usuarioController");

router.post("/cadastrar", function (req, res) {
    usuarioController.cadastrar(req, res);
})

router.post("/autenticar", function (req, res) {
    usuarioController.autenticar(req, res);
});

router.post("/chamar_usuario", function (req, res) {
    usuarioController.chamar_usuario(req, res);
});

router.post("/listarGerente", function (req, res) {
    usuarioController.listarGerente(req, res);
});

router.post("/listarUsuarios", function (req, res) {
    usuarioController.listarUsuarios(req, res);
});

module.exports = router;