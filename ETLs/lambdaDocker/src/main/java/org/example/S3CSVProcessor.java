package org.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.lambda.runtime.events.models.s3.S3EventNotification;

import java.text.SimpleDateFormat;
import java.util.Random;

import com.opencsv.CSVReader;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;

import java.io.InputStreamReader;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Time;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class S3CSVProcessor implements RequestHandler<S3Event, String> {

    private static final String JDBC_URL = "jdbc:mysql://34.192.145.28:3306/remote_guard";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "remoteguard";

    @Override
    public String handleRequest(S3Event s3Event, Context context) {
        S3Client s3Client = S3Client.create();

        for (S3EventNotification.S3EventNotificationRecord record : s3Event.getRecords()) {
            String bucketName = record.getS3().getBucket().getName();
            String key = record.getS3().getObject().getKey();

            try {
                System.out.println("Processando arquivo: " + key + " do bucket: " + bucketName);

                // Ler o arquivo CSV do S3
                GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                        .bucket(bucketName)
                        .key(key)
                        .build();

                InputStream inputStream = s3Client.getObject(getObjectRequest);

                // Processar o CSV e inserir no banco
                processCSVAndInsertToDB(inputStream);

            } catch (Exception e) {
                System.err.println("Erro ao processar o arquivo: " + e.getMessage());
            }
        }

        return "Processamento concluído";
    }

    private void processCSVAndInsertToDB(InputStream inputStream) {
        try (Connection connection = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);
             CSVReader csvReader = new CSVReader(new InputStreamReader(inputStream))) {

            System.out.println("Conectado ao banco de dados. Processando CSV...");
            String insertQuery = "INSERT INTO dadosAna (processo, dt, hora, fkFunc) VALUES (?, STR_TO_DATE(?, '%d/%m/%Y'), ?, ?)";

            Random random = new Random();
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");

            try (PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
                String[] line;

                while ((line = csvReader.readNext()) != null) {
                    String processo = line[0];  // Processo
                    String rawDate = line[2];  // Data
                    String rawTime = line[3];  // Hora

                    java.sql.Date sqlDate = new java.sql.Date(dateFormat.parse(rawDate).getTime());
                    java.sql.Time sqlTime = new java.sql.Time(timeFormat.parse(rawTime).getTime());

                    // Configura os parâmetros da query
                    preparedStatement.setString(1, processo); // Processo
                    preparedStatement.setDate(2, sqlDate); // Data (formato: dd/MM/yyyy)
                    preparedStatement.setTime(3, sqlTime); // Hora
                    preparedStatement.setInt(4, random.nextInt(5) + 1); // Número aleatório entre 1 e 5 para fkFunc

                    // Adiciona a execução em batch
                    preparedStatement.addBatch();
                }
                // Executa o batch após o loop
                preparedStatement.executeBatch();
                System.out.println("Dados inseridos com sucesso!");

            }
        } catch (Exception e) {
            System.err.println("Erro ao processar o CSV: " + e.getMessage());
        }
    }
}
