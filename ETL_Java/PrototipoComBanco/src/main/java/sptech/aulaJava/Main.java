package sptech.aulaJava;


import sptech.aulaJava.dao.DadosDao;

public class Main {
    public static void main(String[] args) {
        ConexaoComBanco conexaoRemoreGuard = new ConexaoComBanco();
        DadosDao consultaRemoreGuard = new DadosDao();
        String inicio = """
                + ----------------------------------------------------------+
                | Bem vindo ao protótipo conectado ao banco da Remote Guard |
                + ----------------------------------------------------------+
                """;
        System.out.println(inicio);
        System.out.println(conexaoRemoreGuard.selectAll());
        System.out.println(consultaRemoreGuard.selectDadosPrincipais());
    }
}