package school.sptech;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

// Interface Genérica para Mapear tanto JSON quanto CSV.
public interface MappableFile<T> {

    List<T> mapFile(InputStream inputStream) throws IOException;
}
