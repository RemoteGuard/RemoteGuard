package school.sptech.entity;

public class FuncionarioEntity {
    private Integer idFuncionario;
    private String cargo;
    private String nome;
    private String cpf;
    private String email;
    private String senha;
    private Integer fkEmpresa;
    private Integer fkSupervisor;

/// olha
    public Integer getIdFuncionario() {
        return idFuncionario;
    }

    public String getCargo() {
        return cargo;
    }

    public String getNome() {
        return nome;
    }

    public String getCpf() {
        return cpf;
    }

    public String getEmail() {
        return email;
    }

    public String getSenha() {
        return senha;
    }

    public Integer getFkEmpresa() {
        return fkEmpresa;
    }

    public Integer getFkSupervisor() {
        return fkSupervisor;
    }
}
