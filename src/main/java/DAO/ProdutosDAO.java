package DAO;

import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import Conexao.ConectionDataBases;
import Model.Fornecedores;
import Model.Produtos;

/**
 *
 * @author Walan
 */
public class ProdutosDAO {

	private Connection con;
	 private ConectionDataBases connectionFactory;

	public ProdutosDAO(String dataBaseName) throws ClassNotFoundException {
		 this.connectionFactory = new ConectionDataBases(dataBaseName);
	        try {
	            this.con = connectionFactory.getConectionDataBases();
	        } catch (SQLException e) {
	            e.printStackTrace(); // Trate a exceção conforme necessário
	        }
	}

	// metodo cadastra produtos//
	public void cadastrar(Produtos obj) {
		try {

			String sql = "insert into tb_produtos(descricao,qtd_estoque,preco_de_compra,preco_de_venda,for_id,imagem,status)values(?,?,?,?,?,?,?)";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, obj.getDescricao());
			stmt.setInt(2, obj.getQtd_estoque());
			stmt.setDouble(3, obj.getPreco_de_compra());
			stmt.setDouble(4, obj.getPreco_de_venda());
			stmt.setInt(5, obj.getFornecedor().getId());
			stmt.setString(7, obj.getStatus());
			
			 if (obj.getImagem() != null) {
	                ByteArrayInputStream bais = new ByteArrayInputStream(obj.getImagem());
	                stmt.setBinaryStream(6, bais, obj.getImagem().length);
	            } else {
	                stmt.setNull(6, Types.BLOB);
	            }

			stmt.execute();

			stmt.close();

		} catch (Exception erro) {

		}

	}

	public List<Produtos> listarProdutosPedido() {
		List<Produtos> lista = new ArrayList<>();
		
		try {

			// 1 passo criar lista de produtos//
			

			String sql = "select p.id,p.descricao,p.qtd_estoque,p.preco_de_compra,p.preco_de_venda,p.imagem,p.status,f.nome,f.id from tb_produtos as p "
					+ "inner join tb_fornecedores as f on (p.for_id=f.id)"
					+ "where p.status = 'ativado'";

			PreparedStatement stmt = con.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Produtos obj = new Produtos();
				Fornecedores f = new Fornecedores();

				obj.setId(rs.getInt("p.id"));
				obj.setDescricao(rs.getString("p.descricao"));
				obj.setQtd_estoque(rs.getInt("p.qtd_estoque"));
				obj.setPreco_de_compra(rs.getDouble("p.preco_de_compra"));
				obj.setPreco_de_venda(rs.getDouble("p.preco_de_venda"));
				byte[] imagemBytes = rs.getBytes("imagem");
				obj.setStatus(rs.getString("p.status"));
				obj.setImagem(imagemBytes);
				f.setId(rs.getInt("f.id"));
				f.setNome(rs.getString(("f.nome")));

				obj.setFornecedor(f);

				lista.add(obj);

			}

			

		} catch (SQLException e) {
			e.printStackTrace();
		

		}
		return lista;

	}
	public List<Produtos> listarProdutos() {
		List<Produtos> lista = new ArrayList<>();
		
		try {

			// 1 passo criar lista de produtos//
			

			String sql = "select p.id,p.descricao,p.qtd_estoque,p.preco_de_compra,p.preco_de_venda,p.imagem,p.status,f.nome,f.id from tb_produtos as p "
					+ "inner join tb_fornecedores as f on (p.for_id=f.id)";

			PreparedStatement stmt = con.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Produtos obj = new Produtos();
				Fornecedores f = new Fornecedores();

				obj.setId(rs.getInt("p.id"));
				obj.setDescricao(rs.getString("p.descricao"));
				obj.setQtd_estoque(rs.getInt("p.qtd_estoque"));
				obj.setPreco_de_compra(rs.getDouble("p.preco_de_compra"));
				obj.setPreco_de_venda(rs.getDouble("p.preco_de_venda"));
				byte[] imagemBytes = rs.getBytes("p.imagem");
				obj.setStatus(rs.getString("p.status"));
				obj.setImagem(imagemBytes);
				f.setId(rs.getInt("f.id"));
				f.setNome(rs.getString(("f.nome")));

				obj.setFornecedor(f);

				lista.add(obj);

			}

			

		} catch (SQLException e) {
			e.printStackTrace();
		

		}
		return lista;

	}

	public void alterarProdutos(Produtos obj) {
	    try {
	        // A ordem dos '?' deve ser a mesma da ordem que você vai setar os parâmetros
	        String sql = "UPDATE tb_produtos SET descricao=?, preco_de_compra=?, preco_de_venda=?, qtd_estoque=?, for_id=?, imagem=?, status=? WHERE id=?";

	        PreparedStatement stmt = con.prepareStatement(sql);

	        // 1. descricao
	        stmt.setString(1, obj.getDescricao());
	        // 2. preco_de_compra
	        stmt.setDouble(2, obj.getPreco_de_compra());
	        // 3. preco_de_venda
	        stmt.setDouble(3, obj.getPreco_de_venda());
	        // 4. qtd_estoque
	        stmt.setInt(4, obj.getQtd_estoque());
	        // 5. for_id
	        stmt.setInt(5, obj.getFornecedor().getId());
	        
	        // 6. imagem
	        if (obj.getImagem() != null) {
	            ByteArrayInputStream bais = new ByteArrayInputStream(obj.getImagem());
	            stmt.setBinaryStream(6, bais, obj.getImagem().length);
	        } else {
	            stmt.setNull(6, Types.BLOB);
	        }

	        // 7. status
	        stmt.setString(7, obj.getStatus());
	        // 8. id
	        stmt.setInt(8, obj.getId());

	        // Execução
	        stmt.executeUpdate();
	        stmt.close();
	    } catch (SQLException erro) {
	        erro.printStackTrace();
	    }
	}

	public void excluir(Produtos obj) {
		try {
			String sql = "delete from tb_produtos where id=?";
			// Organização SQL//

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, obj.getId());

			stmt.execute();
			stmt.close();

		} catch (Exception e) {

		}

	}

	public Produtos consultarPorNome(String nome) {
		try {

			// 1 passo criar lista de produtos//
			String sql = "select p.id,p.descricao,p.qtd_estoque,p.preco_de_compra,p.preco_de_venda,f.nome,f.id from tb_produtos as p "
					+ "inner join tb_fornecedores as f on (p.for_id=f.id) where p.descricao=?";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, nome);
			ResultSet rs = stmt.executeQuery();
			Produtos obj = new Produtos();
			Fornecedores f = new Fornecedores();

			if (rs.next()) {

				obj.setId(rs.getInt("p.id"));
				obj.setDescricao(rs.getString("p.descricao"));
				obj.setQtd_estoque(rs.getInt("p.qtd_estoque"));
				obj.setPreco_de_compra(rs.getDouble("p.preco_de_compra"));
				obj.setPreco_de_venda(rs.getDouble("p.preco_de_venda"));

				f.setNome(rs.getString(("f.nome")));

				obj.setFornecedor(f);

			}

			return obj;

		} catch (SQLException e) {

			return null;

		}

	}

	public Produtos consultarPorCodigo(int id) {
	    try {
	        String sql = "SELECT * FROM tb_produtos WHERE id = ?";

	        PreparedStatement stmt = con.prepareStatement(sql);
	        stmt.setInt(1, id);
	        ResultSet rs = stmt.executeQuery();

	        Produtos obj = new Produtos();
	        Fornecedores f = new Fornecedores();

	        if (rs.next()) {
	            obj.setId(rs.getInt("id"));
	            obj.setDescricao(rs.getString("descricao"));
	            obj.setPreco_de_compra(rs.getDouble("preco_de_compra"));
	            obj.setPreco_de_venda(rs.getDouble("preco_de_venda"));

	            // Recuperar a imagem como byte[]
	            byte[] imagemBytes = rs.getBytes("imagem");
	            obj.setImagem(imagemBytes); // aqui é o ponto chave

	            // Se você quiser associar o fornecedor por ID ou nome:
	            f.setId(rs.getInt("for_id")); // supondo que tenha essa coluna
	            obj.setFornecedor(f);
	        }

	        return obj;

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return null;
	    }
	}

	public void consultarProduto(Produtos obj) {
		try {

			// 1 passo criar lista de produtos//
			String sql = "select p.id,p.descricao,p.qtd_estoque,p.preco_de_compra,p.preco_de_venda,p.imagem,p.status,f.nome,f.id from tb_produtos as p "
					+ "inner join tb_fornecedores as f on (p.for_id=f.id) where p.id=?";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, obj.getId());
			ResultSet rs = stmt.executeQuery();

			Fornecedores f = new Fornecedores();

			if (rs.next()) {

				obj.setId(rs.getInt("p.id"));
				obj.setDescricao(rs.getString("p.descricao"));
				obj.setQtd_estoque(rs.getInt("p.qtd_estoque"));
				obj.setPreco_de_compra(rs.getDouble("p.preco_de_compra"));
				obj.setPreco_de_venda(rs.getDouble("p.preco_de_venda"));
				obj.setStatus(rs.getString("p.status"));
				byte[] imagemBytes = rs.getBytes("imagem");
	            obj.setImagem(imagemBytes);
	            
				f.setNome(rs.getString(("f.nome")));
				f.setId(rs.getInt("f.id"));

				obj.setFornecedor(f);

			}



		} catch (SQLException e) {



		}
	}


	public List<Produtos> listarProdutosPorNome(String nome) {
		try {

			// 1 passo criar lista de produtos//
			List<Produtos> lista = new ArrayList<>();

			String sql = "select p.id,p.descricao,p.qtd_estoque,p.preco_de_compra,p.preco_de_venda,f.nome from tb_produtos as p "
					+ "inner join tb_fornecedores as f on (p.for_id=f.id)where p.descricao like ?";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, nome);

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Produtos obj = new Produtos();
				Fornecedores f = new Fornecedores();

				obj.setId(rs.getInt("p.id"));
				obj.setDescricao(rs.getString("p.descricao"));
				obj.setQtd_estoque(rs.getInt("p.qtd_estoque"));
				obj.setPreco_de_compra(rs.getDouble("p.preco_de_compra"));
				obj.setPreco_de_venda(rs.getDouble("p.preco_de_venda"));

				f.setNome(rs.getString(("f.nome")));

				obj.setFornecedor(f);

				lista.add(obj);

			}

			return lista;

		} catch (SQLException e) {

			return null;

		}

	}

	// METODO DE DAR BAIXO NO ESTOQUE //
	public void baixarEstoque(int id, int qtd_nova) {

		try {
			String sql = "update tb_produtos set qtd_estoque=? where id=?";
			// 2 Passo - conectar o banco de dados e organizar o comando sql//

			PreparedStatement stmt = con.prepareStatement(sql);

			stmt.setInt(1, qtd_nova);
			stmt.setInt(2, id);
			stmt.execute();
			stmt.close();

		} catch (Exception e) {

		}

	}

	// Metodo Retorna Estoque Atual de um produto//
	public int retornaEstoqueAtual(int id) {
		try {
			int qtd_estoque = 0;
			String sql = "select qtd_estoque from tb_produtos where id = ?";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, id);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {

				qtd_estoque = (rs.getInt("qtd_estoque"));

			}

			return qtd_estoque;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}

	}

	public void adicionarEstoque(int id, int qtd_nova) {

		try {
			String sql = "update tb_produtos set qtd_estoque=? where id=?";
			// 2 Passo - conectar o banco de dados e organizar o comando sql//

			PreparedStatement stmt = con.prepareStatement(sql);

			stmt.setInt(1, qtd_nova);
			stmt.setInt(2, id);
			stmt.execute();
			stmt.close();

		} catch (Exception e) {

		}

	}

	public List<Fornecedores> nomeFonecedorProduto(int produtoId) {

		try {
			List<Fornecedores> lista = new ArrayList<>();
			String sql = "SELECT f.nome " + "FROM tb_fornecedores f "
		               + "INNER JOIN tb_produtos p ON p.for_id = f.id "
					   + "WHERE p.id = ?";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, produtoId);
			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				Fornecedores f = new Fornecedores();
				 rs.getString("f.nome");

				 lista.add(f);
			}
			return lista;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}
	public List<Produtos> buscarPorDescricao(String termo) {
	    List<Produtos> lista = new ArrayList<>();
	    String sql = "SELECT * FROM tb_produtos WHERE descricao LIKE ? ";

	    try (PreparedStatement stmt = con.prepareStatement(sql)) {
	    	stmt.setString(1, "%" + termo + "%");

	        ResultSet rs = stmt.executeQuery();

	        while (rs.next()) {
	            Produtos p = new Produtos();
	            p.setId(rs.getInt("id"));
	            p.setDescricao(rs.getString("descricao"));
	            p.setPreco_de_compra(rs.getDouble("preco_de_compra"));
	            p.setPreco_de_venda(rs.getDouble("preco_de_venda"));
	            p.setQtd_estoque(rs.getInt("qtd_estoque"));
	        
	            
	            lista.add(p);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	   
	    return lista;
	}




}