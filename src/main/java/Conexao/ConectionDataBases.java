package Conexao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConectionDataBases {

    private String databaseName;

    // Construtor
    public ConectionDataBases(String databaseName) {
        this.databaseName = databaseName;
    }

    // Método que tenta a conexão
    public Connection getConectionDataBases() throws SQLException {
        Connection con = null;
        try {
            // AQUI ESTÁ O PONTO CRÍTICO:
            // O nome da base DEVE ser passado corretamente na URL
            String url = "jdbc:mysql://localhost:3306/" + databaseName;
            
            // Tenta carregar o driver (Embora não obrigatório no JDBC 4+, é bom garantir)
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            
            // Se o databaseName for null ou vazio, resultará em erro,
            // exceto para o Login que passa a URL base.
            
            // Use suas credenciais de acesso ao MySQL
            con = DriverManager.getConnection(url, "walan", "359483wa@"); 
            
            return con;
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC não encontrado.", e);
        } catch (SQLException e) {
            // Este catch é o que está capturando a mensagem "base não existe"
            System.err.println("Erro ao conectar ao banco de dados " + databaseName + ": " + e.getMessage());
            throw new SQLException("Master: A base de dados '" + databaseName + "' não existe ou ocorreu um erro de conexão.", e);
        }
    }
}