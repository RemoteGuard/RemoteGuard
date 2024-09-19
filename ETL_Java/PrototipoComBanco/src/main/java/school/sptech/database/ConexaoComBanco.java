package school.sptech.database;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import java.util.Map;

public class ConexaoComBanco {
    private JdbcTemplate jdbcTemplate;

    //Para testar, altere o .setUsername() e o .setPassword() para as credenciais da sua máquina
    public ConexaoComBanco() {
        BasicDataSource bds = new BasicDataSource();
        bds.setDriverClassName("com.mysql.cj.jdbc.Driver");
        bds.setUrl("jdbc:mysql://localhost:3306/remoteGuard");
        bds.setUsername("server");
        bds.setPassword("");

        jdbcTemplate = new JdbcTemplate(bds);
    }

    public List selectAll(){
        List<Map<String, Object>> lista = jdbcTemplate.
                queryForList("SELECT * FROM notebook as nb JOIN controleFluxo as cf ON nb.idNotebook = cf.fkNotebook JOIN funcionario as f ON cf.fkFuncionario = f.idFuncionario WHERE nb.idNotebook = 91755279024;");
        return lista;
    }

    public JdbcTemplate getTemplate() {
        return jdbcTemplate;
    }

}
