package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JOptionPane;

import Conexao.ConectionFactory;
import Model.Fornecedores;

/**
 *
 * @author Walan
 */
public class FornecedoresDAO {

	private Connection con;

	public FornecedoresDAO( String databaseName) throws ClassNotFoundException {
		this.con = new ConectionFactory().getConnection(databaseName);

	}

	public Fornecedores consultarFornecedores(String nome) {
		try {
			String sql = "select*from tb_fornecedores where nome like ?";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, nome);

			ResultSet rs = stmt.executeQuery();
			Fornecedores obj = new Fornecedores();

			if (rs.next()) {

				obj.setId(rs.getInt("id"));
				obj.setNome(rs.getString("nome"));
				obj.setCnpj(rs.getString("cnpj"));
				obj.setEmail(rs.getString("email"));
				obj.setTelefone(rs.getString("telefone"));
				obj.setCelular(rs.getString("celular"));
				obj.setCep(rs.getString("cep"));
				obj.setEndereco(rs.getString("endereco"));
				obj.setNumero(rs.getInt("Numero"));
				obj.setComplemento(rs.getString("complemento"));
				obj.setBairro(rs.getString("bairro"));
				obj.setCidade(rs.getString("cidade"));
				obj.setUf(rs.getString("estado"));

			}
			return obj;
		} catch (Exception erro) {
			JOptionPane.showMessageDialog(null, "FORNECEDOR NÃO ENCONTRADO" + erro);
			return null;
		}
	}

	public void cadastrarFornecedores(Fornecedores obj) {
		// comendo SQL//
		try {
			String sql = "INSERT INTO tb_fornecedores(nome,cnpj,email,telefone,celular,cep,endereco,numero,complemento,bairro,cidade,estado)"
					+ "                    VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
			// Organização SQL e Conexão //
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, obj.getNome());
			stmt.setString(2, obj.getCnpj());
			stmt.setString(3, obj.getEmail());
			stmt.setString(4, obj.getTelefone());
			stmt.setString(5, obj.getCelular());
			stmt.setString(6, obj.getCep());
			stmt.setString(7, obj.getEndereco());
			stmt.setInt(8, obj.getNumero());
			stmt.setString(9, obj.getComplemento());
			stmt.setString(10, obj.getBairro());
			stmt.setString(11, obj.getCidade());
			stmt.setString(12, obj.getUf());

			// Execução//
			stmt.execute();
			stmt.close();


		} catch (SQLException erro) {
			JOptionPane.showMessageDialog(null, "HOUVE UM ERRO CONFIRA O SQL" + erro);
		}

	}

	public void alterarFornecedores(Fornecedores obj) {
		try {
			String sql = "UPDATE tb_fornecedores set nome=?,cnpj=?,email=?,telefone=?,celular=?,cep=?"
					+ ",endereco=?,numero=?,complemento=?,bairro=?,cidade=?,estado=? WHERE ID=?";

			// Organização SQL e Conexão //
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, obj.getNome());
			stmt.setString(2, obj.getCnpj());
			stmt.setString(3, obj.getEmail());
			stmt.setString(4, obj.getTelefone());
			stmt.setString(5, obj.getCelular());
			stmt.setString(6, obj.getCep());
			stmt.setString(7, obj.getEndereco());
			stmt.setInt(8, obj.getNumero());
			stmt.setString(9, obj.getComplemento());
			stmt.setString(10, obj.getBairro());
			stmt.setString(11, obj.getCidade());
			stmt.setString(12, obj.getUf());
			stmt.setInt(13, obj.getId());

			// Execução//
			stmt.executeUpdate();
			stmt.close();



		} catch (SQLException erro) {


		}
	}

	public void excluirFornecedores(Fornecedores obj) {
		try {
			String sql = "DELETE FROM tb_fornecedores where id = ?";
			// Organização SQL e Conexão //
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, obj.getId());

			// Execução//
			stmt.execute();
			stmt.close();



		} catch (SQLException erro) {

		}

	}

	public List<Fornecedores> listaFornecedores() {
		try {
			List<Fornecedores> lista = new ArrayList<>();

			// criando sql//
			String sql = "SELECT * FROM tb_fornecedores";
			PreparedStatement stmt = con.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Fornecedores obj = new Fornecedores();
				obj.setId(rs.getInt("id"));
				obj.setNome(rs.getString("nome"));
				obj.setCnpj(rs.getString("cnpj"));
				obj.setEmail(rs.getString("email"));
				obj.setTelefone(rs.getString("telefone"));
				obj.setCelular(rs.getString("celular"));
				obj.setCep(rs.getString("cep"));
				obj.setEndereco(rs.getString("endereco"));
				obj.setNumero(rs.getInt("Numero"));
				obj.setComplemento(rs.getString("complemento"));
				obj.setBairro(rs.getString("bairro"));
				obj.setCidade(rs.getString("cidade"));
				obj.setUf(rs.getString("estado"));

				lista.add(obj);

			}
			return lista;
		} catch (SQLException erro) {
			JOptionPane.showMessageDialog(null, "Erro" + erro);
			return null;
		}
	}
	public Fornecedores consultaFornecedores(int id) {
		try {


			// criando sql//
			String sql = "SELECT * FROM tb_fornecedores where id=?";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Fornecedores obj = new Fornecedores();
				obj.setId(rs.getInt("id"));
				obj.setNome(rs.getString("nome"));
				obj.setCnpj(rs.getString("cnpj"));
				obj.setEmail(rs.getString("email"));
				obj.setTelefone(rs.getString("telefone"));
				obj.setCelular(rs.getString("celular"));
				obj.setCep(rs.getString("cep"));
				obj.setEndereco(rs.getString("endereco"));
				obj.setNumero(rs.getInt("Numero"));
				obj.setComplemento(rs.getString("complemento"));
				obj.setBairro(rs.getString("bairro"));
				obj.setCidade(rs.getString("cidade"));
				obj.setUf(rs.getString("estado"));



			}

		} catch (SQLException erro) {
			JOptionPane.showMessageDialog(null, "Erro" + erro);

		}
		return null;
	}
	public Fornecedores modalFornecedores(Fornecedores obj) {
		try {


			// criando sql//
			String sql = "SELECT * FROM tb_fornecedores where id=?";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, obj.getId());
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {

				obj.setId(rs.getInt("id"));
				obj.setNome(rs.getString("nome"));
				obj.setCnpj(rs.getString("cnpj"));
				obj.setEmail(rs.getString("email"));
				obj.setTelefone(rs.getString("telefone"));
				obj.setCelular(rs.getString("celular"));
				obj.setCep(rs.getString("cep"));
				obj.setEndereco(rs.getString("endereco"));
				obj.setNumero(rs.getInt("Numero"));
				obj.setComplemento(rs.getString("complemento"));
				obj.setBairro(rs.getString("bairro"));
				obj.setCidade(rs.getString("cidade"));
				obj.setUf(rs.getString("estado"));



			}

		} catch (SQLException erro) {
			JOptionPane.showMessageDialog(null, "Erro" + erro);

		}
         return null;
	}


	public List<Fornecedores> BuscarFornecedoresPorNome(String nome) {
		try {
			List<Fornecedores> lista = new ArrayList<>();

			// criando sql//
			String sql = "SELECT * FROM tb_fornecedores WHERE nome LIKE ?";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, nome);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Fornecedores obj = new Fornecedores();
				obj.setId(rs.getInt("id"));
				obj.setNome(rs.getString("nome"));
				obj.setCnpj(rs.getString("cnpj"));
				obj.setEmail(rs.getString("email"));
				obj.setTelefone(rs.getString("telefone"));
				obj.setCelular(rs.getString("celular"));
				obj.setCep(rs.getString("cep"));
				obj.setEndereco(rs.getString("endereco"));
				obj.setNumero(rs.getInt("Numero"));
				obj.setComplemento(rs.getString("complemento"));
				obj.setBairro(rs.getString("bairro"));
				obj.setCidade(rs.getString("cidade"));
				obj.setUf(rs.getString("estado"));

				lista.add(obj);

			}
			return lista;
		} catch (SQLException erro) {
			JOptionPane.showMessageDialog(null, "Erro" + erro);
			return null;
		}

	}

	public String consultarProdutosPorFornecedor(int produtoId) {
		String nomeFornecedor = null;

		try {
			String sql = "SELECT f.nome " + "FROM tb_fornecedores f " + "INNER JOIN tb_produtos p ON p.for_id = f.id "
					+ "WHERE p.id = ?";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, produtoId);
			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				nomeFornecedor = rs.getString("nome");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return nomeFornecedor;
	}

}