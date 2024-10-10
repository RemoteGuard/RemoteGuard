package school.sptech;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import com.fasterxml.jackson.core.type.TypeReference;

public class DadosMapper {
        public List<Dados> mapearDados(InputStream inputStream) throws IOException {
            ObjectMapper objectMapper = new ObjectMapper();
            List<Dados> DadoDoJson = objectMapper.readValue(inputStream,
                    new TypeReference<List<Dados>>() {
                    });
            return DadoDoJson;
        }
    }



