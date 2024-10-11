package school.sptech;


import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class CsvWriter {

    public ByteArrayOutputStream writeCsv(List<Dados> dados) throws IOException {
        // Criar um CSV em memória utilizando ByteArrayOutputStream
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, StandardCharsets.UTF_8));
        CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT.withHeader("inatividadeCPU", "porcentagemCPU", "gbRAM", "porcentagemRAM", "gbDisco", "porcentagemDisco", "processos"));

        // Processar e escrever cada objeto no CSV
        for (Dados dadoAtual : dados) {
            csvPrinter.printRecord(
                    dadoAtual.tempoInatividadeCpuEmMinutos(), dadoAtual.getPorcentagemCPU(), dadoAtual.converterRAM(), dadoAtual.getPorcentagemRAM(), dadoAtual.converterDisco(), dadoAtual.getPorcentagemDisco(), dadoAtual.getProcessos()
            );
        }

        // Fechar o CSV para garantir que todos os dados sejam escritos
        csvPrinter.flush();
        writer.close();

        // Retornar o ByteArrayOutputStream que contém o CSV gerado
        return outputStream;
    }
}
