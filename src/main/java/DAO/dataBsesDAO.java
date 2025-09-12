package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import Conexao.ConectionDataBases;

public class dataBsesDAO {
	 private Connection con;
	 private ConectionDataBases connectionFactory;

    public dataBsesDAO(String dataBaseNames) throws ClassNotFoundException, NamingException {
    	 this.connectionFactory = new ConectionDataBases(dataBaseNames);
	        try {
	            this.con = connectionFactory.getConectionDataBases();
	        } catch (SQLException e) {
	            e.printStackTrace(); // Trate a exceção conforme necessário
	        }

    }

    public List<String> listDatabases() {
        List<String> databases = new ArrayList<>();
        String sql = "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME NOT IN ('mysql', 'information_schema', 'performance_schema')";
        try {
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                databases.add(rs.getString("SCHEMA_NAME"));
            }


        } catch (SQLException e) {
            e.printStackTrace(); // Melhor tratamento de exceção
        }
        return databases;


    }
}