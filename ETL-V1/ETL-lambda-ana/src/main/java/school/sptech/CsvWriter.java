package school.sptech;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import java.util.HashMap;

public class CsvWriter {

    public CsvWriter() {
    }

    // Método para gerar o CSV a partir de uma lista de Dados
    public ByteArrayOutputStream writeCsv(List<Dados> dadosMapeados) throws IOException {
        // Passo 1: Gerar o mapa de contagens a partir dos dados
        Map<String, String[]> contagemTotalProcessos = gerarCSV(dadosMapeados);

        // Passo 2: Criar o ByteArrayOutputStream para escrever o CSV
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, StandardCharsets.UTF_8));
        // Passo 3: Definir o cabeçalho para o CSV
        CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT.withHeader(new String[]{"Processo", "Contagem", "Data", "Hora"}));

        // Passo 4: Iterar sobre os dados do mapa e escrever cada linha no CSV
        for (Map.Entry<String, String[]> entry : contagemTotalProcessos.entrySet()) {
            String processo = entry.getKey();
            String[] valores = entry.getValue();

            // Escrever os dados no CSV (processo, contagem, data, hora)
            csvPrinter.printRecord(processo, valores[0], valores[1], valores[2]);
        }

        // Passo 5: Finalizar a escrita e fechar os recursos
        csvPrinter.flush();
        writer.close();

        return outputStream;
    }

    // Método para gerar o Map com as contagens de processos
    public static Map<String, String[]> gerarCSV(List<Dados> dadosMapeados) {
        Map<String, String[]> contagemTotalProcessos = new HashMap<>();

        // Iterar sobre os dados mapeados e somar as contagens de processos
        for (Dados dado : dadosMapeados) {
            Map<String, Integer> contagemParcial = dado.getContagemProcessos();
            String data = dado.getFormattedDate();
            String hora = dado.getFormattedTimes();

            for (Map.Entry<String, Integer> entry : contagemParcial.entrySet()) {
                String processo = entry.getKey();
                int contagem = entry.getValue();

                // Atualizar ou inserir a contagem do processo no mapa
                if (contagemTotalProcessos.containsKey(processo)) {
                    String[] valores = contagemTotalProcessos.get(processo);
                    int contagemAtual = Integer.parseInt(valores[0]) + contagem;
                    valores[0] = String.valueOf(contagemAtual);
                    valores[1] = data;
                    valores[2] = hora;
                    contagemTotalProcessos.put(processo, valores);
                } else {
                    contagemTotalProcessos.put(processo, new String[]{String.valueOf(contagem), data, hora});
                }
            }
        }
        return contagemTotalProcessos;
    }
}
