package school.sptech;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import java.io.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DadosCsvMapper implements MappableFile<Map<String, Object>> {

    @Override
    public List<Map<String, Object>> mapFile(InputStream inputStream) throws IOException {
        // Reader e Parser para Ler o CSV:
        Reader reader = new InputStreamReader(inputStream);
        CSVParser parser = new CSVParser(reader, CSVFormat.DEFAULT.withFirstRecordAsHeader());

        // Lista para Armazenar os Dados do CSV:
        List<Map<String, Object>> dadosDoCsv = new ArrayList<>();

        // Para cada tupla do CSV é criado um Map representando um objeto JSON.
        for (CSVRecord record : parser) {
            Map<String, Object> tuplaDoCsv = new LinkedHashMap<>();
            // Coluna do CSV (header):
            for (String header : parser.getHeaderNames()) {
                // Valor da Coluna na Tupla:
                String value = record.get(header);

                // Tratar os Valores Nulos:
                if (value == null || value.isEmpty()) {
                    tuplaDoCsv.put(header, null);
                }
                else {
                    // Se for Valor Inteiro:
                    try {
                        Integer intValue = Integer.parseInt(value);
                        tuplaDoCsv.put(header, intValue);
                    } catch (NumberFormatException e1) {
                        // Se não for Inteiro, Tenta converter para Double:
                        try {
                            Double doubleValue = Double.parseDouble(value);
                            tuplaDoCsv.put(header, doubleValue);
                        } catch (NumberFormatException e2) {
                            // Se não for Inteiro ou Double, insere como String:
                            tuplaDoCsv.put(header, value);
                        }
                    }
                }
            }
            dadosDoCsv.add(tuplaDoCsv);
        }

        // Retornando a Lista de Dados do CSV:
        return dadosDoCsv;
    }
}
