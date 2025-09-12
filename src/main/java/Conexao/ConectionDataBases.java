package Conexao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConectionDataBases {
    private String databaseName;

    // Construtor que aceita o nome do banco de dados
    public ConectionDataBases(String databaseName) {
        this.databaseName = databaseName;
    }

    // Método para obter a conexão com o banco de dados
    public Connection getConectionDataBases() throws SQLException {
        // Crie a URL de conexão utilizando o nome do banco de dados
        String url = "jdbc:mysql://localhost:3306/" + this.databaseName;
        // Retorne a conexão com o banco de dados
        return DriverManager.getConnection(url, "walan", "359483wa@"); // Substitua "username" e "password" conforme necessário
    }
}