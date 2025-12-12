package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Conexao.ConectionDataBases;
import Model.ApiConfig;

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
	     
	     // ATENÇÃO: Ajustei os nomes das colunas para a sua tabela funcition_wpp
	     // Se a base de dados usa 'nomeBase' no campo 'session_name' (ou similar) no lugar de 'id_empresa',
	     // ajuste o SQL conforme a estrutura REAL. Presumi que 'nomeBase' é o identificador único.
	     
	     // 1. Tenta atualizar a linha existente (usando session_name como chave única para simplificar)
	     String updateSql = "UPDATE funcition_wpp SET access_token = ?, session_status = ? WHERE session_name = ?";
	     
	     // 2. Se a atualização falhar (0 linhas afetadas), insere uma nova linha
	     String insertSql = "INSERT INTO funcition_wpp (session_name, access_token, session_status) VALUES (?, ?, ?)";
	     
	     int rowsAffected = 0;
	     
	     try (PreparedStatement updateStmt = con.prepareStatement(updateSql)) {
	         updateStmt.setString(1, config.getAccessToken());
	         updateStmt.setString(2, config.getSessionStatus());
	         updateStmt.setString(3, config.getSessionName()); // Usando session_name como chave
	         
	         rowsAffected = updateStmt.executeUpdate();
	     }
	     
	     // Se a atualização não afetou nenhuma linha, insere.
	     if (rowsAffected == 0) {
	         try (PreparedStatement insertStmt = con.prepareStatement(insertSql)) {
	             insertStmt.setString(1, config.getSessionName());
	             insertStmt.setString(2, config.getAccessToken());
	             insertStmt.setString(3, config.getSessionStatus());
	             rowsAffected = insertStmt.executeUpdate();
	         }
	     }
	     
	     return rowsAffected;
	 }

	 // =========================================================
	 // BUSCAR CONFIGURAÇÃO
	 // =========================================================
	 public ApiConfig buscarConfigPorBase(String nomeBase) throws Exception {
	     ApiConfig config = null;
	     
	     // Ajustado para usar as colunas da tabela funcition_wpp
	     String sql = "SELECT id_connection, session_name, access_token, session_status FROM funcition_wpp WHERE session_name = ?";

	     try (PreparedStatement stmt = con.prepareStatement(sql)) {
	         stmt.setString(1, nomeBase); // Assumindo que nomeBase = session_name
	         try (ResultSet rs = stmt.executeQuery()) {
	             if (rs.next()) {
	                 config = new ApiConfig();
	                 config.setId(rs.getInt("id_connection")); // Usando id_connection
	                 config.setSessionName(rs.getString("session_name"));
	                 config.setAccessToken(rs.getString("access_token"));
	                 config.setSessionStatus(rs.getString("session_status"));
	                 // Removi config.setNomeBase(nomeBase) pois ApiConfig deve ter apenas sessionName
	             }
	         }
	     }
	     return config; // Retorna null se não encontrar
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