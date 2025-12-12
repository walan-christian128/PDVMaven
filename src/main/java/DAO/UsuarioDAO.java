package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.naming.NamingException; // Mantido para compatibilidade, se necessário
import Conexao.ConectionDataBases;
import Model.Clientepedido;
import Model.Empresa;
import Model.PasswordUtil;
import Model.Usuario;

public class UsuarioDAO {

	// Conexão principal para operações DML/Query após o login
	private Connection con;

	// O construtor é a única parte que se conecta ao banco específico.
	public UsuarioDAO(String databaseName) throws Exception {
		ConectionDataBases connectionFactory = new ConectionDataBases(databaseName);
		try {
			// A conexão para este DAO é estabelecida aqui.
			this.con = connectionFactory.getConectionDataBases();
		} catch (SQLException e) {
			// CORREÇÃO CRÍTICA: Se a conexão falhar (ex: No suitable driver found, Bad credentials, etc.),
			// lançamos uma exceção clara para o Servlet/JSP, impedindo NullPointerException.
			System.err.println("ERRO DAO: Falha ao obter conexão para a base " + databaseName);
			e.printStackTrace();
			// Relançar como uma exceção mais genérica para o nível superior
			throw new Exception("Erro de conexão com o banco de dados. Detalhes: " + e.getMessage(), e);
		}
	}
    
    // =========================================================
	// MÉTODO: efetuarLogin (MÉTODO EXCEÇÃO)
	// Precisa conectar-se à URL MESTRE e usar o comando 'USE <empresa>'
	// =========================================================
	@SuppressWarnings("static-access")
	public boolean efetuarLogin(String usuario, String senha, String empresa) throws SQLException {
		
		Connection conLogin = null; // Conexão temporária para o login
		boolean loginValido = false;
        
        // NOTA: Class.forName("com.mysql.cj.jdbc.Driver"); é desnecessário no JDBC 4+, 
        // mas mantido a lógica para criar uma nova conexão para o comando USE.
        
		try {
            // Cria uma nova conexão usando a fábrica, mas sem um databaseName para iniciar
            ConectionDataBases masterConFactory = new ConectionDataBases("");
			conLogin = masterConFactory.getConectionDataBases(); // Conexão para 'jdbc:mysql://localhost:3306/'
            
			// 1. Usar o banco de dados dinamicamente
			String useDatabase = "USE " + empresa;
			try (Statement stmtUse = conLogin.createStatement()) {
				stmtUse.execute(useDatabase);
			}

			// 2. Preparar a query para verificar o login
			String sql = "SELECT SENHA FROM tb_usuario WHERE EMAIL = ?";
			
			// Uso do bloco try-with-resources para PreparedStatement e ResultSet
			try (PreparedStatement stmt = conLogin.prepareStatement(sql)) {
				stmt.setString(1, usuario);
				
				try (ResultSet rs = stmt.executeQuery()) {
					if (rs.next()) {
						String senhaHash = rs.getString("SENHA");
						
						// Comparar o hash armazenado com o hash da senha fornecida
						if (PasswordUtil.hashPassword(senha).equals(senhaHash)) {
							loginValido = true;
						}
					}
				}
			}

		} catch (Exception e) {
			// Imprimir o erro, mas não relançar, pois o login deve retornar false em caso de falha.
			e.printStackTrace();
		} finally {
			// Fechar a conexão temporária de login
			if (conLogin != null) {
				try { conLogin.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
		}

		return loginValido;
	}

	// =========================================================
	// MÉTODO: enviaEmail
	// =========================================================
	public boolean enviaEmail(String email, String empresa) throws SQLException {
		
		// Garantia contra NullPointerException se o construtor falhou
		if (this.con == null) {
			throw new SQLException("Conexão nula. O DAO falhou na inicialização.");
		}

		String sql = "SELECT * FROM tb_usuario WHERE email = ?";
		
		try (PreparedStatement stmt = this.con.prepareStatement(sql)) {
			stmt.setString(1, email);
			
			try (ResultSet rs = stmt.executeQuery()) {
				return rs.next();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
	}

	// =========================================================
	// MÉTODO: recuperaSenha
	// =========================================================
	@SuppressWarnings("static-access")
	public Usuario recuperaSenha(String senha, String email, String empresa) throws SQLException {
	    Connection conRecupera = null;
	    Usuario usuarioSenha = new Usuario();

	    try {
	        // Conexão temporária (mesma lógica do login)
	        ConectionDataBases masterConFactory = new ConectionDataBases("");
	        conRecupera = masterConFactory.getConectionDataBases();

	        // Seleciona o banco de dados dinamicamente
	        String useDatabase = "USE " + empresa;
	        try (Statement stmtUse = conRecupera.createStatement()) {
	            stmtUse.execute(useDatabase);
	        }

	        // Gera o hash da nova senha
	        String senhaHashed = PasswordUtil.hashPassword(senha);

	        // Atualiza a senha no banco de dados
	        String sql = "UPDATE tb_usuario SET senha = ? WHERE email = ?";
	        
	        try (PreparedStatement stmt = conRecupera.prepareStatement(sql)) {
	            stmt.setString(1, senhaHashed);
	            stmt.setString(2, email);

	            int rowsAffected = stmt.executeUpdate();

	            if (rowsAffected > 0) {
	                usuarioSenha.setSenha(senhaHashed);
	                usuarioSenha.setEmail(email);
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (conRecupera != null) {
				try { conRecupera.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
	    }

	    return usuarioSenha;
	}

	// =========================================================
	// MÉTODO: cidugoUsuario
	// =========================================================
	public int cidugoUsuario(Usuario usuario, String empresa) throws SQLException {
		
		if (this.con == null) {
			throw new SQLException("Conexão nula. O DAO falhou na inicialização.");
		}
		
		String sql = "SELECT id FROM tb_usuario WHERE email = ?";

		try (PreparedStatement stmt = this.con.prepareStatement(sql)) {
			stmt.setString(1, usuario.getEmail());
			
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("id");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}
    
	// =========================================================
	// MÉTODO: cidcliPedido
	// =========================================================
	public int cidcliPedido(Clientepedido clienetepedido, String empresa) throws SQLException {
		
		if (this.con == null) {
			throw new SQLException("Conexão nula. O DAO falhou na inicialização.");
		}

		String sql = "SELECT id FROM tb_cliente_pedido WHERE email = ?";

		try (PreparedStatement stmt = this.con.prepareStatement(sql)) {
			stmt.setString(1, clienetepedido.getEmail());
			
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("id");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	// =========================================================
	// MÉTODO: retornUser
	// =========================================================
	public Usuario retornUser(Usuario usuario, String empresa,int idUser) throws SQLException {
		
		if (this.con == null) {
			throw new SQLException("Conexão nula. O DAO falhou na inicialização.");
		}
		
		String sql = "SELECT nome FROM tb_usuario WHERE email = ?";

		try (PreparedStatement stmt = this.con.prepareStatement(sql)) {
			stmt.setString(1, usuario.getEmail());
			
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					usuario.setNome(rs.getString("nome"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return usuario;
	}
	
	// =========================================================
	// MÉTODO: retornClipedido
	// =========================================================
	public Clientepedido retornClipedido(Clientepedido clienetepedido, String empresa,int idUser) throws SQLException {
		
		if (this.con == null) {
			throw new SQLException("Conexão nula. O DAO falhou na inicialização.");
		}

		String sql = "SELECT id FROM tb_cliente_pedido WHERE email = ?";

		try (PreparedStatement stmt = this.con.prepareStatement(sql)) {
			stmt.setString(1, clienetepedido.getEmail());
			
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					clienetepedido.setId(rs.getInt("id"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return clienetepedido;
	}
    
	// =========================================================
	// MÉTODO: retornCompany
	// =========================================================
	public Empresa retornCompany(Empresa emp, String empresaNome, int codigo) throws SQLException {
		
		if (this.con == null) {
			throw new SQLException("Conexão nula. O DAO falhou na inicialização.");
		}

	    String sql = "SELECT id FROM tb_empresa LIMIT 1";

	    try (PreparedStatement stmt = this.con.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {

	        if (rs.next()) {
	            Empresa empresaRetornada = new Empresa();
	            empresaRetornada.setId(rs.getInt("id"));
	            return empresaRetornada;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        throw e;
	    }
	    return null;
	}
    
	// =========================================================
	// MÉTODO: efetuarLoginPedido
	// =========================================================
	public boolean efetuarLoginPedido(String usuario, String senha, String empresa) throws SQLException {
		
		Connection conLogin = null;
		boolean loginValido = false;

		try {
			// Conexão temporária (mesma lógica do login)
			ConectionDataBases masterConFactory = new ConectionDataBases("");
			conLogin = masterConFactory.getConectionDataBases();

			// Usar o banco de dados dinamicamente
			String useDatabase = "USE " + empresa;
			try (Statement stmtUse = conLogin.createStatement()) {
				stmtUse.execute(useDatabase);
			}

			// Preparar a query para verificar o login
			String sql = "SELECT senha FROM tb_cliente_pedido WHERE EMAIL = ?";
			
			try (PreparedStatement stmt = conLogin.prepareStatement(sql)) {
				stmt.setString(1, usuario);

				try (ResultSet rs = stmt.executeQuery()) {
					if (rs.next()) {
						String senhaHash = rs.getString("SENHA");
						
						// Comparar o hash armazenado com o hash da senha fornecida
						if (PasswordUtil.hashPassword(senha).equals(senhaHash)) {
							loginValido = true;
						}
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Fechar a conexão temporária de login
			if (conLogin != null) {
				try { conLogin.close(); } catch (SQLException e) { e.printStackTrace(); }
			}
		}

		return loginValido;
	}
    
    // =========================================================
	// MÉTODO: close (BOA PRÁTICA)
	// =========================================================
	public void close() {
	    if (this.con != null) {
	        try {
	            this.con.close();
	            this.con = null; // Indica que a conexão foi fechada
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
}