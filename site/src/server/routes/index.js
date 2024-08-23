var express = require("express");
var router = express.Router();
let path = require("path");


router.get("/", function (req, res) {
    // res.render("index");
    res.sendFile(path.join(__dirname, "../../../public/index.html"));
    // Sera necessário configurar a view corretamente
});

module.exports = router;