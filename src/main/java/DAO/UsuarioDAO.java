package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.NamingException;

import Conexao.ConectionDataBases;
import Model.Clientepedido;
import Model.Empresa;
import Model.PasswordUtil;
import Model.Usuario;

public class UsuarioDAO {

	private Connection con;
	private ConectionDataBases connectionFactory;

	public UsuarioDAO(String databaseName) throws NamingException {
		this.connectionFactory = new ConectionDataBases(databaseName);
		try {
			this.con = connectionFactory.getConectionDataBases();
		} catch (SQLException e) {
			e.printStackTrace(); // Trate a exceção conforme necessário
		}
	}

	@SuppressWarnings("static-access")
	public boolean efetuarLogin(String usuario, String senha, String empresa) throws ClassNotFoundException {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		boolean loginValido = false;

		try {

			// Conectar ao MySQL sem especificar um banco de dados
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "walan", "359483wa@");

			// Usar o banco de dados dinamicamente com base no nome da empresa
			String useDatabase = "USE " + empresa;
			Statement stmtUse = con.createStatement();
			stmtUse.execute(useDatabase);
			System.out.println("Banco de dados selecionado: " + empresa); // Confirmação do banco de dados

			// Preparar a query para verificar o login
			String sql = "SELECT SENHA FROM tb_usuario WHERE EMAIL = ?";
			System.out.println("Query: " + sql); // Exibe a query para debug
			stmt = con.prepareStatement(sql);
			stmt.setString(1, usuario);

			// Executar a query
			rs = stmt.executeQuery();

			// Verificar se o usuário foi encontrado e comparar a senha
			if (rs.next()) {
				String senhaHash = rs.getString("SENHA");

				// Criar instância de PasswordUtil para comparar o hash
				PasswordUtil passUtil = new PasswordUtil();
				String senhaHashFornecida = PasswordUtil.hashPassword(senha);

				// Comparar o hash armazenado com o hash da senha fornecida
				if (senhaHash.equals(senhaHashFornecida)) {
					System.out.println("Usuário encontrado e senha correta!"); // Verifica se o login é válido
					loginValido = true;
				} else {
					System.out.println("Senha incorreta!"); // Senha não coincide com o hash
				}
			} else {
				System.out.println("Usuário não encontrado!"); // Usuário não encontrado no banco de dados
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// Fechar os recursos
			try {
				if (rs != null) {
					rs.close();
				}
				if (stmt != null) {
					stmt.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return loginValido;
	}

	public boolean enviaEmail(String email, String empresa) throws SQLException, ClassNotFoundException, NamingException {
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		boolean usuarioEmail = false;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "walan", "359483wa@");
			// Inicialize a conexão com o banco de dados
			this.con = connectionFactory.getConectionDataBases(); // Certifique-se de que ConnectionFactory está correto

			// Seleciona a base de dados correta
			String useDatabase = "USE " + empresa;
			Statement stmtUse = con.createStatement(); // Aqui pode ocorrer o erro
			stmtUse.execute(useDatabase);

			// Verifica se o usuário existe
			String sql = "SELECT * FROM tb_usuario WHERE email = ?";
			stmt = con.prepareStatement(sql);
			stmt.setString(1, email);
			rs = stmt.executeQuery();

			if (rs.next()) {
				usuarioEmail = true;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// Fechar os recursos
			try {
				if (rs != null) {
					rs.close();
				}
				if (stmt != null) {
					stmt.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return usuarioEmail;
	}

	@SuppressWarnings("static-access")
	public Usuario recuperaSenha(String senha, String email, String empresa) throws SQLException {
	    Connection con = null;
	    PreparedStatement stmt = null;
	    Usuario usuarioSenha = new Usuario();

	    try {
	        // Carrega o driver JDBC do MySQL
	        Class.forName("com.mysql.cj.jdbc.Driver");

	        // Conecta ao MySQL sem um banco de dados específico
	        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "walan", "359483wa@");

	        // Seleciona o banco de dados dinamicamente com base na empresa
	        String useDatabase = "USE " + empresa;
	        Statement stmtUse = con.createStatement();
	        stmtUse.execute(useDatabase);

	        // Gera o hash da nova senha
	        PasswordUtil passUtil = new PasswordUtil();
	        String senhaHashed = PasswordUtil.hashPassword(senha);

	        // Atualiza a senha no banco de dados
	        String sql = "UPDATE tb_usuario SET senha = ? WHERE email = ?";
	        stmt = con.prepareStatement(sql);
	        stmt.setString(1, senhaHashed);
	        stmt.setString(2, email); // Agora você está passando o email como parâmetro corretamente

	        // Executa a atualização
	        int rowsAffected = stmt.executeUpdate();

	        if (rowsAffected > 0) {
	            System.out.println("Senha atualizada com sucesso.");
	            usuarioSenha.setSenha(senhaHashed); // Define a nova senha no objeto Usuario
	            usuarioSenha.setEmail(email);       // Define o email no objeto Usuario
	        } else {
	            System.out.println("Erro ao atualizar a senha. Usuário não encontrado.");
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (stmt != null) {
				stmt.close();
			}
	        if (con != null) {
				con.close();
			}
	    }

	    return usuarioSenha;
	}
	public int cidugoUsuario(Usuario usuario, String empresa) throws SQLException, ClassNotFoundException {
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + empresa, "walan", "359483wa@");

	    String sql = "SELECT id FROM tb_usuario WHERE email = ?";

	    try {
	        PreparedStatement stmt = con.prepareStatement(sql);
	        stmt.setString(1, usuario.getEmail());
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	            return rs.getInt("id");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0; // Retorna 0 se o usuário não for encontrado
	}
	public int cidcliPedido(Clientepedido clienetepedido, String empresa) throws SQLException, ClassNotFoundException {
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + empresa, "walan", "359483wa@");

	    String sql = "SELECT id FROM tb_cliente_pedido WHERE email = ?";

	    try {
	        PreparedStatement stmt = con.prepareStatement(sql);
	        stmt.setString(1, clienetepedido.getEmail());
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	            return rs.getInt("id");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0; // Retorna 0 se o usuário não for encontrado
	}



	public Usuario retornUser(Usuario usuario, String empresa,int idUser) throws SQLException, ClassNotFoundException {
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + empresa, "walan", "359483wa@");

	    String sql = "SELECT nome FROM tb_usuario WHERE email = ?";

	    try {
	        PreparedStatement stmt = con.prepareStatement(sql);
	        stmt.setString(1, usuario.getEmail());
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	           usuario.setNome(rs.getString("nome"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		return usuario;


	}
	
	public Clientepedido retornClipedido(Clientepedido clienetepedido, String empresa,int idUser) throws SQLException, ClassNotFoundException {
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + empresa, "walan", "359483wa@");

	    String sql = "SELECT id FROM tb_cliente_pedido WHERE email = ?";

	    try {
	        PreparedStatement stmt = con.prepareStatement(sql);
	        stmt.setString(1, clienetepedido.getEmail());
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	        	clienetepedido.setId(rs.getInt("id"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		return clienetepedido;


	}
	 public Empresa retornCompany(Empresa emp, String empresaNome, int codigo) throws SQLException, ClassNotFoundException {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + empresaNome, "walan", "359483wa@");

	        String sql = "SELECT id FROM tb_empresa LIMIT 1";

	        try (PreparedStatement stmt = con.prepareStatement(sql);
	             ResultSet rs = stmt.executeQuery()) {

	            if (rs.next()) {
	                Empresa empresaRetornada = new Empresa();
	                empresaRetornada.setId(rs.getInt("id"));
	                return empresaRetornada;
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            if (con != null) {
	                try {
	                    con.close();
	                } catch (SQLException e) {
	                    e.printStackTrace();
	                }
	            }
	        }
	        return null;
	    }
	 public boolean efetuarLoginPedido(String usuario, String senha, String empresa) throws ClassNotFoundException {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = null;
			PreparedStatement stmt = null;
			ResultSet rs = null;
			boolean loginValido = false;

			try {

				// Conectar ao MySQL sem especificar um banco de dados
				con = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "walan", "359483wa@");

				// Usar o banco de dados dinamicamente com base no nome da empresa
				String useDatabase = "USE " + empresa;
				Statement stmtUse = con.createStatement();
				stmtUse.execute(useDatabase);
				System.out.println("Banco de dados selecionado: " + empresa); // Confirmação do banco de dados

				// Preparar a query para verificar o login
				String sql = "SELECT senha FROM tb_cliente_pedido WHERE EMAIL = ?";
				System.out.println("Query: " + sql); // Exibe a query para debug
				stmt = con.prepareStatement(sql);
				stmt.setString(1, usuario);

				// Executar a query
				rs = stmt.executeQuery();

				// Verificar se o usuário foi encontrado e comparar a senha
				if (rs.next()) {
					String senhaHash = rs.getString("SENHA");

					// Criar instância de PasswordUtil para comparar o hash
					PasswordUtil passUtil = new PasswordUtil();
					String senhaHashFornecida = PasswordUtil.hashPassword(senha);

					// Comparar o hash armazenado com o hash da senha fornecida
					if (senhaHash.equals(senhaHashFornecida)) {
						System.out.println("Usuário encontrado e senha correta!"); // Verifica se o login é válido
						loginValido = true;
					} else {
						System.out.println("Senha incorreta!"); // Senha não coincide com o hash
					}
				} else {
					System.out.println("Usuário não encontrado!"); // Usuário não encontrado no banco de dados
				}

			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				// Fechar os recursos
				try {
					if (rs != null) {
						rs.close();
					}
					if (stmt != null) {
						stmt.close();
					}
					if (con != null) {
						con.close();
					}
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			return loginValido;
		}


}