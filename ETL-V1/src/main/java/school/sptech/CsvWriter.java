package school.sptech;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

public class CsvWriter {
    public static void main(String[] args) {

        // Ler arquivo pessoas.json
        FileInputStream inputStream = null;
        try {
            inputStream = new FileInputStream("dados.json");
        } catch (FileNotFoundException e) {
            System.out.println("Arquivo não encontrado!");
            // Para a execução do programa
            throw new RuntimeException(e);
        }

        // Cria uma List<Pessoa> para armazenar os dados mapeados
        DadosMapper dadosMapper = new DadosMapper();
        List<Dados> dados = new ArrayList<>();
        try {
            // Mapear o JSON para uma lista de Pessoas
            dados = dadosMapper.mapearDados(inputStream);
        } catch (IOException e) {
            System.out.println("Erro ao mapear os dados " + e.getMessage());
        }

        // Exibir os dados mapeados
        for (Dados dadoAtual : dados) {
            System.out.println(dadoAtual);
        }

        // Cria um arquivo CSV com os dados mapeados
        gerarCsv(dados);

        // Fechar o arquivo
        try {
            inputStream.close();
        } catch (IOException e) {
            System.out.println("Erro ao fechar arquivo");
            throw new RuntimeException(e);
        }
    }

    private static void gerarCsv(List<Dados> dados) {
        CSVFormat formato = CSVFormat.Builder.create()
                // Definindo o cabeçalho do arquivo
                .setHeader("inatividadeCPU", "porcentagemCPU", "bytesRAM", "porcentagemRAM", "bytesDisco", "porcentagemDisco", "processos")
                // Definindo o delimitador das colunas caso necessário
                .setDelimiter(";")
                .build();

        // Utilizando try-with-resources para fechar os recursos automaticamente
        try (
                // Criando um arquivo local "pessoa.csv" para escrita
                FileOutputStream outputStream = new FileOutputStream("dados_trusted.csv");
                BufferedWriter escritor = new BufferedWriter(new OutputStreamWriter(outputStream));

                // Criando um escritor de CSV: CSVPrinter
                // Ele recebe dois parâmetros:
                // o escritor do arquivo (BufferedWriter)
                // formato do CSV(CSVFormat)
                CSVPrinter printer = new CSVPrinter(escritor, formato)) {

            // Para cada pessoa na lista, escrever uma linha no arquivo CSV
            for (Dados dadoAtual : dados) {
                // Imprimir uma linha no arquivo CSV
                // O método printRecord recebe os valores das colunas
                // Sempre siga a ordem do cabeçalho!
                printer.printRecord(dadoAtual.tempoInatividadeCpuEmMinutos(), dadoAtual.getPorcentagemCPU(), dadoAtual.converterRAM(), dadoAtual.getPorcentagemRAM(), dadoAtual.converterDisco(), dadoAtual.getPorcentagemDisco(), dadoAtual.getProcessos());
            }
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }
}
