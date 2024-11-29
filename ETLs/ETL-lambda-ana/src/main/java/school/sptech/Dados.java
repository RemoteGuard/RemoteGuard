package school.sptech;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Dados {

    public Object contarProcessos;
    @JsonProperty("processos")
    private List<String> processos;

    @JsonProperty("dataHora")
    private LocalDateTime dataHora;

    public Dados() {
    }

    public List<String> getProcessos() {
        return processos;
    }

    public void setProcessos(List<String> processos) {
        this.processos = processos;
    }

    public LocalDateTime getDataHora() {
        return dataHora;
    }

    public void setDataHora(LocalDateTime dataHora) {
        this.dataHora = dataHora;
    }

    public Dados(LocalDateTime dataHora, List<String> processos) {
        this.dataHora= dataHora;
        this.processos = new ArrayList<>();

        for (int i = 0; i < processos.size(); i++) {
            this.processos.add(processos.get(i));
        }
    }

    public static List<Dados> mapperJson(InputStream arquivoJson) throws IOException {
        // Configura o ObjectMapper para tratar LocalDateTime
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule()); // Registra o módulo que lida com datas LocalDateTime
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS); // Desativa o uso de timestamps para datas

        return mapper.readValue(arquivoJson, new com.fasterxml.jackson.core.type.TypeReference<List<Dados>>() {});
    }

    public String getFormattedTimes() {
        if (dataHora != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
            return dataHora.format(formatter);
        }
        return null; // ou retornar uma string padrão se necessário
    }

    public String getFormattedDate() {
        if (dataHora != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            return dataHora.format(formatter);
        }
        return null; // ou retornar uma string padrão se necessário
    }

    public Map<String, Integer> getContagemProcessos() {
        Map<String, Integer> contagem = new HashMap<>();
        if (processos != null) {
            for (String processo : processos) {
                contagem.put(processo, contagem.getOrDefault(processo, 0) + 1);
            }
        }
        return contagem;
    }

    public static Map<String, String[]> gerarCSV(List<Dados> dadosMapeados) {
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
        return contagemTotalProcessos;
}

}