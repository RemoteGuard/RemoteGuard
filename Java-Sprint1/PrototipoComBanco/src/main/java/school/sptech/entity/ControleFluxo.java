package school.sptech.entity;

import org.springframework.cglib.core.Local;

import java.time.LocalDateTime;

public class ControleFluxo {
    private Integer idControleFluxo;
    private LocalDateTime dtInicio;
    private LocalDateTime dtSaida;
    private Integer fkFuncionario;

    public Integer getIdControleFluxo() {
        return idControleFluxo;
    }

    public LocalDateTime getDtInicio() {
        return dtInicio;
    }

    public LocalDateTime getDtSaida() {
        return dtSaida;
    }

    public Integer getFkFuncionario() {
        return fkFuncionario;
    }

    public Integer getFkNotebook() {
        return fkNotebook;
    }

    private Integer fkNotebook;
}
