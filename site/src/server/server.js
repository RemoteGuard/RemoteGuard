var express = require("express");
var cors = require("cors");
let porta = 3303;

// É necessário instalar as bibliotecas EXPRESS e CORS para poder inicializar o servidor!!!
// Não se esqueça de instalar a biblioteca mysql2 para executar a query com o Banco!

var app = express();

// var usuarioRouter = require("./src/routes/usuarios");

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
// app.use(express.static(path.join(__dirname, "public")));

app.use(cors());

// app.use("/", indexRouter);
// app.use("/usuarios", usuarioRouter);

app.listen(porta, ()=> {
    console.log('Servidor RemoteGuard rodando!');
});