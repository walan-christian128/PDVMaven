 package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Conexao.ConectionDataBases;
import Model.Clientepedido;
import Model.ItensPedidos;
import Model.Pedidos;
import Model.Produtos;
import Model.Vendas;

public class ItensPedidoDAO {
	private Connection con;
	 private ConectionDataBases connectionFactory;

   public ItensPedidoDAO(String dataBaseNames) throws ClassNotFoundException {
   	  // Inicialize a conexão com o banco de dados
       this.connectionFactory = new ConectionDataBases(dataBaseNames);
       try {
           this.con = connectionFactory.getConectionDataBases();
       } catch (SQLException e) {
           e.printStackTrace(); // Trate a exceção conforme necessário
       }

   }
   
   public void inserirItensPedidos(ItensPedidos itp) throws SQLException {
       String sql = "INSERT INTO itens_pedido(pedido_id, produto_id, quantidade, preco_unitario) VALUES(?,?,?,?)";

       try (PreparedStatement stmt = con.prepareStatement(sql)) {
           stmt.setInt(1, itp.getPedido().getIdPedido());
           stmt.setInt(2, itp.getProduto().getId());
           stmt.setInt(3, itp.getQuantidade());
           stmt.setDouble(4, itp.getPrecoUnitario());

           stmt.execute();
           // Não precisa de stmt.close() aqui se estiver usando try-with-resources
           // (PreparedStatement stmt = con.prepareStatement(sql)) já faz o auto-close
       } catch (SQLException e) {
           System.err.println("Erro ao inserir itens do pedido: " + e.getMessage());
           throw e; // Relançar para que o Servlet possa tratar
       }
   }
   public List<ItensPedidos> detalhePedido(int pedido) {
	    List<ItensPedidos> lista = new ArrayList<>();
	    String  sql = "SELECT pro.descricao AS nome_produto, "
	            + "       cli.nome AS nome_cliente, "
	            + "       cli.endereco AS endereco, "
	            + "       cli.numero AS numero, "
	            + "       cli.estado AS estado, "
	            + "       cli.telefone AS telefone, "
	            + "       cli.email AS email, "
	            + "       DATE_FORMAT(data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
	            + "       ped.status AS status, "
	            + "       itp.pedido_id AS cd_pedido,        "
	            + "       ped.forma_pagamento AS pagamento, "
	            + "       ped.observacoes AS observacoes, "
	            + "       itp.preco_unitario AS preco, "
	            + "       ped.total_pedido as totalPedido,"
	            + "       itp.quantidade AS qtd "
	            + "FROM tb_produtos pro "
	            + "INNER JOIN itens_pedido itp ON pro.id = itp.produto_id "
	            + "INNER JOIN pedidos ped ON itp.pedido_id = ped.id_pedido "
	            + "INNER JOIN tb_cliente_pedido cli ON ped.clientepedido_id = cli.id "
	            + "WHERE pedido_id = ?";
	    PreparedStatement stmt = null; // Declare fora do try para fechar no finally
	    ResultSet rs = null; // Declare fora do try para fechar no finally
	    try {
	        stmt = con.prepareStatement(sql);
	        stmt.setInt(1, pedido);

	        rs = stmt.executeQuery();
	        while (rs.next()) {
	            Produtos pro = new Produtos();
	            ItensPedidos itp = new ItensPedidos();
	            Clientepedido clip = new Clientepedido();
	            Pedidos pred = new Pedidos();
	            // Pedidos ped = new Pedidos(); // Não usado, pode remover se não for preencher

	            pro.setDescricao(rs.getString("nome_produto"));
	            clip.setNome(rs.getString("nome_cliente"));
	            clip.setEndereco(rs.getString("endereco"));
	            clip.setNumero(rs.getInt("numero"));
	            clip.setUf(rs.getString("estado"));
	            clip.setTelefone(rs.getString("telefone"));
	            clip.setEmail(rs.getString("email"));
	            pred.setDataPeedido(rs.getString("data_formatada"));
	            pred.setStatus(rs.getString("status"));
	            pred.setIdPedido(rs.getInt("cd_pedido"));
	            pred.setFormapagamento(rs.getString("pagamento"));
	            pred.setObservacoes(rs.getString("observacoes"));
	            pred.setTotalPedido(rs.getDouble("totalPedido"));
	            itp.setPrecoUnitario(rs.getDouble("preco"));
	            itp.setQuantidade(rs.getInt("qtd"));
	            itp.setProduto(pro);
	            itp.setPedido(pred);
	            
	            pred.setClientepedido(clip);

	            lista.add(itp);
	        }
	    } catch (SQLException e) { // Capture SQLException especificamente
	        System.err.println("Erro SQL ao buscar detalhes do pedido: " + e.getMessage());
	        e.printStackTrace(); // Imprime o stack trace no console do servidor
	        // Lançar RuntimeException ou um erro customizado aqui pode ser útil
	        // para que o servlet catch a exceção e retorne um erro 500 para o cliente.
	        throw new RuntimeException("Erro ao buscar detalhes do pedido no banco de dados.", e);
	    } finally {
	        // Fechar recursos em blocos finally para garantir que sejam fechados
	        try {
	            if (rs != null) rs.close();
	            if (stmt != null) stmt.close();
	            // Não feche a conexão 'con' aqui se ela for gerenciada em um pool
	            // ou se for usada para outras operações na mesma transação.
	        } catch (SQLException e) {
	            System.err.println("Erro ao fechar recursos do banco de dados: " + e.getMessage());
	        }
	    }
	    return lista;
   }
   
   public List<ItensPedidos> detalhePedidoCliente(int pedido) {
	    List<ItensPedidos> lista = new ArrayList<>();
	    String  sql = "SELECT pro.descricao AS nome_produto, "
	            + "       DATE_FORMAT(data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
	            + "       ped.status AS status, "
	            + "       itp.pedido_id AS cd_pedido,        "
	            + "       ped.forma_pagamento AS pagamento, "
	            + "       ped.observacoes AS observacoes, "
	            + "       itp.preco_unitario AS preco, "
	            + "       ped.total_pedido as totalPedido,"
	            + "       itp.quantidade AS qtd "
	            + "FROM tb_produtos pro "
	            + "INNER JOIN itens_pedido itp ON pro.id = itp.produto_id "
	            + "INNER JOIN pedidos ped ON itp.pedido_id = ped.id_pedido "
	            + "WHERE pedido_id = ?";
	    PreparedStatement stmt = null; // Declare fora do try para fechar no finally
	    ResultSet rs = null; // Declare fora do try para fechar no finally
	    try {
	        stmt = con.prepareStatement(sql);
	        stmt.setInt(1, pedido);

	        rs = stmt.executeQuery();
	        while (rs.next()) {
	            Produtos pro = new Produtos();
	            ItensPedidos itp = new ItensPedidos();
	            Pedidos pred = new Pedidos();
	            // Pedidos ped = new Pedidos(); // Não usado, pode remover se não for preencher

	            pro.setDescricao(rs.getString("nome_produto"));
	            pred.setDataPeedido(rs.getString("data_formatada"));
	            pred.setStatus(rs.getString("status"));
	            pred.setIdPedido(rs.getInt("cd_pedido"));
	            pred.setFormapagamento(rs.getString("pagamento"));
	            pred.setObservacoes(rs.getString("observacoes"));
	            pred.setTotalPedido(rs.getDouble("totalPedido"));
	            itp.setPrecoUnitario(rs.getDouble("preco"));
	            itp.setQuantidade(rs.getInt("qtd"));
	            itp.setProduto(pro);
	            itp.setPedido(pred);
	            
	            lista.add(itp);
	        }
	    } catch (SQLException e) { // Capture SQLException especificamente
	        System.err.println("Erro SQL ao buscar detalhes do pedido: " + e.getMessage());
	        e.printStackTrace(); // Imprime o stack trace no console do servidor
	        // Lançar RuntimeException ou um erro customizado aqui pode ser útil
	        // para que o servlet catch a exceção e retorne um erro 500 para o cliente.
	        throw new RuntimeException("Erro ao buscar detalhes do pedido no banco de dados.", e);
	    } finally {
	        // Fechar recursos em blocos finally para garantir que sejam fechados
	        try {
	            if (rs != null) rs.close();
	            if (stmt != null) stmt.close();
	            // Não feche a conexão 'con' aqui se ela for gerenciada em um pool
	            // ou se for usada para outras operações na mesma transação.
	        } catch (SQLException e) {
	            System.err.println("Erro ao fechar recursos do banco de dados: " + e.getMessage());
	        }
	    }
	    return lista;
  }
}



