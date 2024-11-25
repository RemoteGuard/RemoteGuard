package school.sptech;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class DadosJsonMapper implements MappableFile<DadosJson> {

    @Override
    public List<DadosJson> mapFile(InputStream inputStream) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readValue(inputStream,
                new TypeReference<List<DadosJson>>() {
                });
    }
}



