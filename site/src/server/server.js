var express = require("express");
var cors = require("cors");
let porta = 3303;
let usuarioRouter = require("./routes/usuarios");
let indexRouter = require("./routes/index");
let path = require("path");
// É necessário instalar as bibliotecas EXPRESS e CORS para poder inicializar o servidor!!!
// Não se esqueça de instalar a biblioteca mysql2 para executar a query com o Banco!

var app = express();

app.use(express.json());
app.use(cors());

app.use("/", indexRouter);
app.use("/usuarios", usuarioRouter);

// Configurando a view para que o servidor consiga renderizar o site construido e exibir ao usuário
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "../../public")));


app.listen(porta, ()=> {
    console.log("Servidor rodando");
});