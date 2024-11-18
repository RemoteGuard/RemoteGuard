//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package school.sptech;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.lambda.runtime.events.models.s3.S3EventNotification;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.List;

public class Main implements RequestHandler<S3Event, String> {
    private final AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
    private static final String DESTINATION_BUCKET = "trusted-stocks-ana";

    public Main() {
    }

    public String handleRequest(S3Event s3Event, Context context) {
        String sourceBucket = ((S3EventNotification.S3EventNotificationRecord)s3Event.getRecords().get(0)).getS3().getBucket().getName();
        String sourceKey = ((S3EventNotification.S3EventNotificationRecord)s3Event.getRecords().get(0)).getS3().getObject().getKey();

        try {
            InputStream s3InputStream = this.s3Client.getObject(sourceBucket, sourceKey).getObjectContent();
            Mapper mapper = new Mapper();
            List<Dados> dados = mapper.map(s3InputStream);
            CsvWriter csvWriter = new CsvWriter();
            ByteArrayOutputStream csvOutputStream = csvWriter.writeCsv(dados);
            InputStream csvInputStream = new ByteArrayInputStream(csvOutputStream.toByteArray());
            this.s3Client.putObject("trusted-stocks-ana", sourceKey.replace(".json", ".csv"), csvInputStream, (ObjectMetadata)null);
            return "Sucesso no processamento";
        } catch (Exception var11) {
            Exception e = var11;
            context.getLogger().log("Erro: " + e.getMessage());
            return "Erro no processamento";
        }
    }
}
//