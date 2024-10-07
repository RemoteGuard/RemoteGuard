package school.sptech;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Dados {

    @JsonProperty("tempoInatividadeCPU")
    private Double tempoInatividadeCPU;

    @JsonProperty("porcentagemCPU")
    private Double porcentagemCPU;

    @JsonProperty("bytesRAM")
    private Double bytesRAM;

    @JsonProperty("porcentagemRAM")
    private Double porcentagemRAM;

    @JsonProperty("bytesDisco")
    private Double bytesDisco;

    @JsonProperty("porcentagemDisco")
    private Double porcentagemDisco;

    @JsonProperty("processos")
    private List<String> processos;

    public Dados(Double tempoInatividadeCPU, Double porcentagemCPU, Double bytesRAM, Double porcentagemRAM, Double bytesDisco, Double porcentagemDisco, List<String> processos) {
        this.tempoInatividadeCPU = tempoInatividadeCPU;
        this.porcentagemCPU = porcentagemCPU;
        this.bytesRAM = bytesRAM;
        this.porcentagemRAM = porcentagemRAM;
        this.bytesDisco = bytesDisco;
        this.porcentagemDisco = porcentagemDisco;
        this.processos = processos;
    }

    public Dados() {
    }

    public Double getTempoInatividadeCPU() {
        return tempoInatividadeCPU;
    }

    public Double getPorcentagemCPU() {
        return porcentagemCPU;
    }

    public Double getBytesRAM() {
        return bytesRAM;
    }

    public Double getPorcentagemRAM() {
        return porcentagemRAM;
    }

    public Double getBytesDisco() {
        return bytesDisco;
    }

    public Double getPorcentagemDisco() {
        return porcentagemDisco;
    }

    public List<String> getProcessos() {
        return processos;
    }

    @Override
    public String toString() {
        return "Dados{" +
                "tempoInatividadeCPU=" + tempoInatividadeCPU +
                ", porcentagemCPU=" + porcentagemCPU +
                ", bytesRAM=" + bytesRAM +
                ", porcentagemRAM=" + porcentagemRAM +
                ", bytesDisco=" + bytesDisco +
                ", porcentagemDisco=" + porcentagemDisco +
                ", processos=" + processos +
                '}';
    }
}

