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
        bds.setUrl("jdbc:mysql://localhost:3306/remote_guard");
        bds.setUsername("server");
        bds.setPassword("");

        jdbcTemplate = new JdbcTemplate(bds);
    }

    public JdbcTemplate getTemplate() {
        return jdbcTemplate;
    }

}
