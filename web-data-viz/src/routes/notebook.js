var express = require("express");
var router = express.Router();

var notebookController = require("../controllers/notebookController");

router.post("/cadastrarNote", function (req, res) {
    notebookController.cadastrarNote(req, res);
})

router.post("/buscarNotebook", function (req, res) {
    notebookController.buscarNotebook(req, res);
})

router.post("/updateFunc", function (req, res) {
    notebookController.updateFunc(req, res);
})



module.exports = router;