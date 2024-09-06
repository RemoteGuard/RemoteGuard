package sptech.aulaJava.dao;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import sptech.aulaJava.ConexaoComBanco;
import sptech.aulaJava.Dados;
import java.util.List;

public class DadosDao {
    private JdbcTemplate acessDao;

    public DadosDao(){
        ConexaoComBanco conexaoRG = new ConexaoComBanco();
        this.acessDao = conexaoRG.getTemplate();
    }

    public List selectDadosPrincipais(){
        List<Dados> lista = acessDao.
                query("SELECT percCPU, percRAM, percDisc FROM dados;",
                new BeanPropertyRowMapper<>(Dados.class));
        return lista;
    }
}
