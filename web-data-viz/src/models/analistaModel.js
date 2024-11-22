var database = require("../database/config");



  function listarNotebook() {
    const instrucaoSql = `SELECT n.idNotebook, f.nome AS nomeFuncionario
FROM notebook n
JOIN funcionario f ON n.idNotebook = f.fkNotebook
WHERE f.cargo NOT IN ('analista', 'gerente');
;
`;
    return database.executar(instrucaoSql);
  }

function listarPorcentagemRAMPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT porcentagem_ram, data_captura FROM dados WHERE fkNotebook =  ${fkNotebook} ORDER BY data_captura DESC LIMIT 10;
;`; 
  return database.executar(instrucaoSql);
}
function listarPorcentagemCPUPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT porcentagem_cpu, data_captura FROM dados WHERE fkNotebook = ${fkNotebook} ORDER BY data_captura DESC LIMIT 10;`; 
  return database.executar(instrucaoSql);
}

function listarPorcentagemDiscoPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT dados.porcentagem_disco, dados.data_captura, armazenamento.total_disco
  FROM dados
  JOIN armazenamento ON dados.fkNotebook = armazenamento.fkNotebook
  WHERE dados.fkNotebook = ${fkNotebook}
  ORDER BY dados.data_captura DESC
  LIMIT 1;
  `;
  return database.executar(instrucaoSql);
}

function listarDadosPorNotebook(fkNotebook) {
  var instrucaoSql = `SELECT porcentagem_cpu, porcentagem_ram, porcentagem_disco, data_captura FROM dados WHERE fkNotebook = ${fkNotebook} ORDER BY data_captura DESC LIMIT 1;`;
  return database.executar(instrucaoSql);
}

function listarDadosMediaPorNotebooks() {
  var instrucaoSql = `
   SELECT 
    ROUND(AVG(porcentagem_cpu), 2) AS media_cpu,
    ROUND(AVG(porcentagem_ram), 2) AS media_ram,
    ROUND(AVG(porcentagem_disco), 2) AS media_disco
FROM dados;
  `;
  return database.executar(instrucaoSql);
}


function listarNomeResponsavel(fkNotebook) {
  const instrucaoSql = `
      SELECT funcionario.nome AS nome_funcionario
      FROM funcionario
      JOIN notebook ON funcionario.fkNotebook = notebook.idNotebook
      WHERE notebook.idNotebook = ${fkNotebook};
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
}
 function listarQuantidadeProcessos(fkNotebook) {
  const instrucaoSql = `
      SELECT processos, data_captura FROM dados WHERE fkNotebook = ${fkNotebook} 
     ORDER BY   data_captura DESC  LIMIT 1;
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
}

function  listarInformacaoesFuncionario(fkNotebook) {
  const instrucaoSql = `
      SELECT funcionario.nome AS nome_funcionario,
       funcionario.email AS email_funcionario,
       funcionario.cargo AS cargo_funcionario
        FROM funcionario
        WHERE funcionario.fkNotebook = ${fkNotebook};
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
}
function listarInformacaoesNotebook(fkNotebook) {
  const instrucaoSql = `
    SELECT 
    n.hostname, n.marca, n.modelo, n.memoriaRAM, n.processador, a.total_disco 
    FROM 
    notebook n JOIN  armazenamento a ON n.idNotebook = ${fkNotebook} WHERE  a.fkNotebook = ${fkNotebook};  
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
}

function listarNumeroNucleos(fkNotebook) {
  const instrucaoSql = `
SELECT numero_nucleos from dados where fkNotebook = ${fkNotebook} ORDER BY data_captura DESC LIMIT 1;
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
}

 function listarMediaPonderada(fkNotebook) {
  const instrucaoSql = `
  SELECT media_ponderada FROM dados WHERE fkNotebook = ${fkNotebook} ORDER BY data_captura DESC LIMIT 1;
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
  }

 function listarRecursoAlerta(fkNotebook){
  const instrucaoSql = `
Select porcentagem_cpu,porcentagem_ram,porcentagem_disco,tempo_alerta_cpu,tempo_alerta_ram,tempo_alerta_disco from dados where fkNotebook =1 order by data_captura desc limit 1;
  `;
  return database.executar(instrucaoSql, [fkNotebook]);
 }


module.exports = {listarNotebook, listarPorcentagemRAMPorNotebook,listarPorcentagemCPUPorNotebook,listarPorcentagemDiscoPorNotebook,listarDadosPorNotebook,listarNomeResponsavel,listarQuantidadeProcessos,
  listarInformacaoesFuncionario,listarInformacaoesNotebook,listarNumeroNucleos,listarMediaPonderada,listarRecursoAlerta,listarDadosMediaPorNotebooks};
