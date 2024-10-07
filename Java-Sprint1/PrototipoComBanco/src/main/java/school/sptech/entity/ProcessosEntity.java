package school.sptech.entity;

import java.time.LocalDateTime;

public class ProcessosEntity {
    private Integer idProcesso;
    private LocalDateTime dataHora;
    private String nomeProcesso;
    private Integer fkNotebook;

    public Integer getIdProcesso() {
        return idProcesso;
    }

    public LocalDateTime getDataHora() {
        return dataHora;
    }

    public String getNomeProcesso() {
        return nomeProcesso;
    }

    public Integer getFkNotebook() {
        return fkNotebook;
    }
}