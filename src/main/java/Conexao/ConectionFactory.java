package Conexao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConectionFactory {
    private static final String URL_TEMPLATE = "jdbc:mysql://localhost:3306/%s?useSSL=false";
    private static final String USER = "walan";  // Ajuste o usuário do banco de dados
    private static final String PASSWORD = "359483wa@";  // Ajuste a senha do banco de dados

    public Connection getConnection(String databaseName) throws ClassNotFoundException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = String.format(URL_TEMPLATE, databaseName);
            return DriverManager.getConnection(url, USER, PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao conectar ao banco de dados: " + databaseName, e);
        }
    }
}