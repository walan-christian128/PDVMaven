package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Conexao.ConectionDataBases;
import Model.ApiConfig;
import Model.Empresa;

public class ApiConfigDAO {

	 private Connection con;

	 // =========================================================
	 // CONSTRUTOR
	 // =========================================================
	 public ApiConfigDAO(String nomeBase) throws Exception {
	     ConectionDataBases connectionFactory = new ConectionDataBases(nomeBase);
	     try {
	         this.con = connectionFactory.getConectionDataBases();
	     } catch (SQLException e) {
	         // Lança a exceção para que o JSP/Servlet saiba que a conexão falhou.
	         System.err.println("Falha ao obter conexão para a base " + nomeBase + ": " + e.getMessage());
	         throw new Exception("Erro de conexão com o banco de dados.", e);
	     }
	 }

	 // =========================================================
	 // SALVAR OU ATUALIZAR CONFIGURAÇÃO (UPDATE/INSERT)
	 // USANDO A TABELA funcition_wpp
	 // =========================================================
	 public int salvarOuAtualizarConfig(ApiConfig config) throws Exception {

		    String updateSql =
		        "UPDATE funcition_wpp " +
		        "SET access_token = ?, session_status = ?, numero_whatsapp = ? " +
		        "WHERE id_empresa = ?";

		    String insertSql =
		        "INSERT INTO funcition_wpp " +
		        "(id_empresa, session_name, access_token, session_status, numero_whatsapp) " +
		        "VALUES (?, ?, ?, ?, ?)";

		    int rowsAffected;

		    // UPDATE
		    try (PreparedStatement updateStmt = con.prepareStatement(updateSql)) {
		        updateStmt.setString(1, config.getAccessToken());
		        updateStmt.setString(2, config.getSessionStatus());
		        updateStmt.setString(3, config.getNumeroWhatsapp());
		        updateStmt.setInt(4, config.getEmpresa().getId());

		        rowsAffected = updateStmt.executeUpdate();
		    }

		    // INSERT
		    if (rowsAffected == 0) {
		        try (PreparedStatement insertStmt = con.prepareStatement(insertSql)) {
		            insertStmt.setInt(1, config.getEmpresa().getId());
		            insertStmt.setString(2, config.getSessionName());
		            insertStmt.setString(3, config.getAccessToken());
		            insertStmt.setString(4, config.getSessionStatus());
		            insertStmt.setString(5, config.getNumeroWhatsapp());

		            rowsAffected = insertStmt.executeUpdate();
		        }
		    }

		    return rowsAffected;
		}


	 // =========================================================
	 // BUSCAR CONFIGURAÇÃO
	 // =========================================================
	 public ApiConfig buscarConfigPorBase(String sessionName) throws Exception {

		    ApiConfig config = null;

		    String sql =
		        "SELECT id_connection, id_empresa, session_name, access_token, session_status, numero_whatsapp " +
		        "FROM funcition_wpp WHERE session_name = ?";

		    try (PreparedStatement stmt = con.prepareStatement(sql)) {
		        stmt.setString(1, sessionName);

		        try (ResultSet rs = stmt.executeQuery()) {
		            if (rs.next()) {
		                config = new ApiConfig();
		                config.setId(rs.getInt("id_connection"));
		                config.setSessionName(rs.getString("session_name"));
		                config.setAccessToken(rs.getString("access_token"));
		                config.setSessionStatus(rs.getString("session_status"));
		                config.setNumeroWhatsapp(rs.getString("numero_whatsapp"));

		                Empresa empresa = new Empresa();
		                empresa.setId(rs.getInt("id_empresa"));
		                config.setEmpresa(empresa);
		            }
		        }
		    }

		    return config;
		}
	 public ApiConfig buscarConfigPorEmpresa(int idEmpresa) throws Exception {

		    ApiConfig config = null;

		    String sql =
		        "SELECT id_connection, id_empresa, session_name, access_token, session_status, numero_whatsapp " +
		        "FROM funcition_wpp WHERE id_empresa = ?";

		    try (PreparedStatement stmt = con.prepareStatement(sql)) {
		        stmt.setInt(1, idEmpresa);

		        try (ResultSet rs = stmt.executeQuery()) {
		            if (rs.next()) {
		                config = new ApiConfig();
		                config.setId(rs.getInt("id_connection"));
		                config.setSessionName(rs.getString("session_name"));
		                config.setAccessToken(rs.getString("access_token"));
		                config.setSessionStatus(rs.getString("session_status"));
		                config.setNumeroWhatsapp(rs.getString("numero_whatsapp"));

		                Empresa empresa = new Empresa();
		                empresa.setId(rs.getInt("id_empresa"));
		                config.setEmpresa(empresa);
		            }
		        }
		    }

		    return config;
		}


	 
	 // =========================================================
	 // OBTER TOKEN
	 // =========================================================
	 public String obterApiAccessToken(String nomeBase) throws Exception {
	     ApiConfig config = buscarConfigPorBase(nomeBase);
	     return (config != null) ? config.getAccessToken() : null;
	 }
	 
	 // =========================================================
	 // ATUALIZAR STATUS
	 // =========================================================
	 public void atualizarStatus(String nomeBase, String novoStatus) throws Exception {
	     // Ajustado para usar a tabela e colunas corretas
	     String sql = "UPDATE funcition_wpp SET session_status = ? WHERE session_name = ?";
	     try (PreparedStatement stmt = con.prepareStatement(sql)) {
	         stmt.setString(1, novoStatus);
	         stmt.setString(2, nomeBase); // Assumindo nomeBase = session_name
	         stmt.executeUpdate();
	     }
	 }
	 
	 // =========================================================
	 // FECHAR CONEXÃO (CRÍTICO PARA SERVIDOR WEB)
	 // =========================================================
	 public void close() {
	     if (this.con != null) {
	         try {
	             this.con.close();
	         } catch (SQLException e) {
	             e.printStackTrace();
	         }
	     }
	 }
}