package school.sptech;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

// Interface Genérica para Processar tanto JSON quanto CSV.
public interface WriteableFile<T> {

    ByteArrayOutputStream writeFile(List<T> dados) throws IOException;
}
