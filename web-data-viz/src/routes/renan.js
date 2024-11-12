var express = require("express");
var router = express.Router();
var renanController = require("../controllers/renanController");


router.post("/processos", function (req, res) {
    renanController.processos(req, res);
})
module.exports = router;