package sptech.school;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class DadosMapper {
    public List<Dados> mapperJson(InputStream arquivoJson) throws IOException {

        ObjectMapper mapper = new ObjectMapper();

        mapper.registerModule(new JavaTimeModule());

        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        List<Dados> dadosList = mapper.readValue(arquivoJson, new TypeReference<List<Dados>>() {});

        return dadosList;
    }
}
