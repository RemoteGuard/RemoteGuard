package school.sptech;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

public class Main implements RequestHandler<S3Event, String> {

    // Bucket de destino para o CSV gerado
    private static final String DESTINATION_BUCKET = "bucket-trusted-rg";
    // Criação do cliente S3 para acessar os buckets
    private final AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();

    @Override
    public String handleRequest(S3Event s3Event, Context context) {

        // Extraindo o Nome do Bucket de Origem e a Chave (nome) do Arquivo:
        String sourceBucket = s3Event.getRecords().get(0).getS3().getBucket().getName();
        String sourceKey = s3Event.getRecords().get(0).getS3().getObject().getKey();

        try {
            // Lendo o Arquivo de do Bucket de Origem:
            System.out.println("Lendo Arquivo do Bucket...");
            InputStream s3InputStream = s3Client.getObject(sourceBucket, sourceKey).getObjectContent();

            // Determinando a Extensão do Arquivo do Bucket de Origem:
            String fileExtension = getFileExtension(sourceKey);

            // Se Arquivo for JSON:
            if (fileExtension.equals(".json")) {
                // Mapeando Dados do JSON:

                System.out.println("Mapeando Dados do JSON...");
                MappableFile<DadosJson> mapper = new DadosJsonMapper();
                List<DadosJson> dadosDoJson = mapper.mapFile(s3InputStream);

                // Gerando Arquivo CSV:
                System.out.println("Processando Dados para Arquivo CSV...");
                WriteableFile<DadosJson> csvWriter = new CsvWriter();
                ByteArrayOutputStream csvOutputStream = csvWriter.writeFile(dadosDoJson);

                // Inserindo o Arquivo CSV na Memória:
                InputStream csvInputStream = new ByteArrayInputStream(csvOutputStream.toByteArray());

                // Transferindo Arquivo CSV para o Bucket:
                System.out.println("Transferindo Arquivo para o Bucket de Destino...");
                ObjectMetadata metadata = new ObjectMetadata();
                metadata.setContentLength(csvOutputStream.size());
                s3Client.putObject(DESTINATION_BUCKET, sourceKey.replace(".json", ".csv"), csvInputStream, metadata);

                return "Arquivo (%s) JSON Processado com Sucesso!".formatted(sourceKey);
            }

            // Se Arquivo for CSV:
            else if (fileExtension.equals(".csv")) {
                // Mapeando Dados do CSV:
                System.out.println("Mapeando Dados do CSV...");
                MappableFile<Map<String, Object>> mapper = new DadosCsvMapper();
                List<Map<String, Object>> dadosDoCsv = mapper.mapFile(s3InputStream);

                // Gerando Arquivo JSON:
                System.out.println("Processando Dados para Arquivo JSON...");
                WriteableFile<Map<String, Object>> jsonWriter = new JsonWriter();
                ByteArrayOutputStream jsonOutputStream = jsonWriter.writeFile(dadosDoCsv);

                // Inserindo o Arquivo JSON na Memória:
                InputStream jsonInputStream = new ByteArrayInputStream(jsonOutputStream.toByteArray());

                // Transferindo Arquivo JSON para o Bucket:
                System.out.println("Transferindo Arquivo para o Bucket de Destino...");
                ObjectMetadata metadata = new ObjectMetadata();
                metadata.setContentLength(jsonOutputStream.size());
                s3Client.putObject(DESTINATION_BUCKET, sourceKey.replace(".csv", ".json"), jsonInputStream, metadata);

                return "Arquivo (%s) CSV Processado com Sucesso!".formatted(sourceKey);
            }

            // Caso o Arquivo não seja Suportado, lança Exceção:
            else throw new IllegalArgumentException("Erro ao Processar Arquivo (%s) Tipo de Arquivo não suportado: %s".formatted(sourceKey, fileExtension));

        } catch (Exception e) {
            // Tratamento de Erros e Log do Contexto em caso de Exceção:
            context.getLogger().log("Erro: " + e.getMessage());
            return "Erro no Processamento do Arquivo: " + sourceKey;
        }
    }

    // --- Método para Determinar a Extensão do Arquivo ---
    private String getFileExtension(String sourceKey) {
        // Buscando o Index do Último Ponto ( . ), que indica a Extensão:
        int lastIndexOfDot = sourceKey.lastIndexOf('.');

        // Caso o Arquivo não tenha Extensão, retorna Vazio:
        if (lastIndexOfDot == -1) {
            return "";
        }

        // Retornando a Extensão em Formato String:
        return sourceKey.substring(lastIndexOfDot);
    }

}

