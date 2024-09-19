package school.sptech.entity;

public class Dados {
    private Double percCPU;
    private Double percRAM;
    private Double percDisc;

    public Double getPercCPU() {
        return percCPU;
    }

    public void setPercCPU(Double percCPU) {
        this.percCPU = percCPU;
    }

    public Double getPercRAM() {
        return percRAM;
    }

    public void setPercRAM(Double percRAM) {
        this.percRAM = percRAM;
    }

    public Double getPercDisc() {
        return percDisc;
    }

    public void setPercDisc(Double percDisc) {
        this.percDisc = percDisc;
    }

    @Override
    public String toString() {
        return """
               Percentual do uso da CPU: %.2f
               Percentual do uso da Memória RAM: %.2f
               Percentual do uso da Disc: %.2f
               """.formatted(percCPU, percRAM, percDisc);
    }
}
