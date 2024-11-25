package school.sptech;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class CsvWriter implements WriteableFile<DadosJson> {

    @Override
    public ByteArrayOutputStream writeFile(List<DadosJson> dadosDoJson) throws IOException {
        // Criando um CSV em Memória:
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, StandardCharsets.UTF_8));
        CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT.withHeader("inatividadeCPU", "porcentagemCPU", "gbRAM", "porcentagemRAM", "gbDisco", "porcentagemDisco", "processos"));

        // Processando e Escrevendo cada Tupla em CSV:
        for (DadosJson dadoAtual : dadosDoJson) {
            csvPrinter.printRecord(
                    dadoAtual.tempoInatividadeCpuEmMinutos(), dadoAtual.getPorcentagemCPU(), dadoAtual.converterRAM(), dadoAtual.getPorcentagemRAM(), dadoAtual.converterDisco(), dadoAtual.getPorcentagemDisco(), dadoAtual.getProcessos()
            );
        }

        // Fechando o CSV para parar o Processamento e Garantir que todos os Dados sejam Escritos:
        csvPrinter.flush();
        writer.close();

        // Retornando o CSV Gerado:
        return outputStream;
    }
}
