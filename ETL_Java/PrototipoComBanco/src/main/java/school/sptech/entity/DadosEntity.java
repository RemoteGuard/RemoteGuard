package school.sptech.entity;

import java.time.LocalDateTime;

public class DadosEntity {
  private LocalDateTime dataHora;
  private Double tempoInatividade;
  private Double perCPU;
  private Double usedRAM;
  private Double percRAM;
  private Double usedDisk;
  private Double percDisk;
  private Integer fkNotebook;

  public LocalDateTime getDataHora() {
    return dataHora;
  }

  public Double getTempoInatividade() {
    return tempoInatividade;
  }

  public Double getPerCPU() {
    return perCPU;
  }

  public Double getUsedRAM() {
    return usedRAM;
  }

  public Double getPercRAM() {
    return percRAM;
  }

  public Double getUsedDisk() {
    return usedDisk;
  }

  public Double getPercDisk() {
    return percDisk;
  }

  public Integer getFkNotebook() {
    return fkNotebook;
  }
}

