package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import Conexao.ConectionDataBases;
import Model.ConfigPagamento;

public class ConfigPagamentoDAO {
    private Connection con;

    private ConectionDataBases connectionFactory;

    public ConfigPagamentoDAO(String dataBaseNames) throws ClassNotFoundException, NamingException {
    	 // Inicialize a conexão com o banco de dados
        this.connectionFactory = new ConectionDataBases(dataBaseNames);
        try {
            this.con = connectionFactory.getConectionDataBases();
        } catch (SQLException e) {
            e.printStackTrace(); // Trate a exceção conforme necessário
        }
    }
    public ConfigPagamento buscarPorEmpresa(int empresaId) {
        String sql = "SELECT * FROM configuracoes_pagamento WHERE empresa_id = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, empresaId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ConfigPagamento cfg = new ConfigPagamento();
                    cfg.setId(rs.getInt("id"));
                    cfg.setGateway(rs.getString("gateway"));
                    cfg.setChavePix(rs.getString("chave_pix"));
                    cfg.setClientId(rs.getString("client_id"));
                    cfg.setClientSecret(rs.getString("client_secret"));
                    cfg.setAccessToken(rs.getString("access_token"));
                    cfg.setPublicKey(rs.getString("publickey"));
                    return cfg;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar configuração de pagamento: " + e.getMessage());
        }
        return null;
    }
    public void salvar(ConfigPagamento config) throws SQLException {
        String sql = "INSERT INTO configuracoes_pagamento (empresa_id, gateway,chave_pix, client_id, client_secret, access_token,publickey) VALUES (?, ?, ?, ?, ?,?,?)";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, config.getEmpresaId());
            stmt.setString(2, config.getGateway());
            stmt.setString(3, config.getChavePix());
            stmt.setString(4, config.getClientId());
            stmt.setString(5, config.getClientSecret());
            stmt.setString(6, config.getAccessToken());
            stmt.setString(7, config.getPublicKey());
            stmt.executeUpdate();
        }
    }
    public void atualizar(ConfigPagamento config) throws SQLException {
        String sql = "UPDATE configuracoes_pagamento " +
                     "SET gateway = ?,chave_pix = ?, client_id = ?, client_secret = ?, access_token = ? , publickey = ? " +
                     "WHERE empresa_id = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, config.getGateway());
            stmt.setString(2, config.getChavePix());
            stmt.setString(3, config.getClientId());
            stmt.setString(4, config.getClientSecret());
            stmt.setString(5, config.getAccessToken());
            stmt.setString(6, config.getPublicKey());
            stmt.setInt(7, config.getEmpresaId());
            stmt.executeUpdate();
        }
    }
    
    public String accessToken(int idEmpresa) {
        String sql = "SELECT access_token FROM configuracoes_pagamento WHERE empresa_id = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, idEmpresa);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("access_token"); // ✅ Retorna direto o token
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // caso não encontre
    }
    
   



}


