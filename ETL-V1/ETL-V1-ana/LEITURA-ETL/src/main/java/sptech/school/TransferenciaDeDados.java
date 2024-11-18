package sptech.school;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransferenciaDeDados {
    public static void main(String[] args) {

        InputStream inputStream;

        try {
            inputStream = new FileInputStream("/home/aluno/Documentos/Projeto-indiv/ETL-V1-ana/LEITURA-ETL/Dados.json");
        } catch (FileNotFoundException erro){

            System.out.println("Arquivo não encontrado! Verifique o caminho ou o nome do arquivo");
            erro.printStackTrace();
            throw new RuntimeException(erro);

        }

        DadosMapper mapper = new DadosMapper();
        List<Dados> dadosMapeados;

        try {
            dadosMapeados = mapper.mapperJson(inputStream);
        } catch (IOException erro) {
            System.out.println("Houve um erro ao mapear o JSON para objeto Livro" + erro.getMessage());
            erro.printStackTrace();
            throw new RuntimeException(erro);
        }

        for (Dados dado : dadosMapeados){
            System.out.println(dado);
        }

        gerarCSV(dadosMapeados);
    }

    public static void gerarCSV(List<Dados> dadosMapeados) {
//        map mapeia a string com o nome dos processos e a array com a contagem de
//        ocorrencia de todos os processos
        Map<String, String[]> contagemTotalProcessos = new HashMap<>();

        for (Dados dado : dadosMapeados) {
            Map<String, Integer> contagemParcial = dado.getContagemProcessos();
            String data = dado.getFormattedDate();
            String hora = dado.getFormattedTimes();

            for (Map.Entry<String, Integer> entry : contagemParcial.entrySet()) {
                String processo = entry.getKey();
                int contagem = entry.getValue();

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

        try {
            OutputStream outputStream = new FileOutputStream("Dados.csv");
            BufferedWriter escritor = new BufferedWriter(new OutputStreamWriter(outputStream));

            CSVFormat formato = CSVFormat.Builder.create()
                    .setHeader("processo", "Contagem", "Data", "Hora")
                    .setDelimiter(",")
                    .build();

            CSVPrinter printer = new CSVPrinter(escritor, formato);

            for (Map.Entry<String, String[]> entry : contagemTotalProcessos.entrySet()) {
                String processo = entry.getKey();
                String[] valores = entry.getValue();
                printer.printRecord(processo, valores[0], valores[1], valores[2]);
            }

            printer.close();
        } catch (IOException e) {
            throw new RuntimeException("Erro ao gerar o arquivo CSV: " + e.getMessage(), e);
        }
    }
}
