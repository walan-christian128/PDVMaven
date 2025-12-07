package DAO;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.NamingException;

import Conexao.ConectionDataBases;
import Model.Clientes;
import Model.ItensVenda;
import Model.Produtos;
import Model.Vendas;

public class VendasDAO {

	 private Connection con;
	 private ConectionDataBases connectionFactory;

	 public VendasDAO(String databaseName) throws NamingException {
	        // Inicialize a conexão com o banco de dados
	        this.connectionFactory = new ConectionDataBases(databaseName);
	        try {
	            this.con = connectionFactory.getConectionDataBases();
	        } catch (SQLException e) {
	            e.printStackTrace(); // Trate a exceção conforme necessário
	        }
	    }
	 public String getStatusVendaPorId(String orderId) throws SQLException {
		    String sql = "SELECT statusVenda FROM tb_vendas WHERE external_reference = ?";
		    try (PreparedStatement stmt = con.prepareStatement(sql)) {
		        stmt.setString(1, orderId);
		        ResultSet rs = stmt.executeQuery();
		        if (rs.next()) {
		            return rs.getString("statusVenda");
		        }
		    }
		    System.out.println(sql);
		    return null;
		}

	 public String getStatusVenda() throws SQLException {
	     String status = "unknown"; // Valor padrão caso não encontre
	     String sql = "SELECT statusVenda FROM tb_vendas WHERE id = (SELECT max(id) FROM tb_vendas)";
	     
	     // A sua query não usa um parâmetro (?), então não precisa de PreparedStatement.
	     try (Statement stmt = con.createStatement();
	          ResultSet rs = stmt.executeQuery(sql)) {
	         
	         if (rs.next()) {
	             status = rs.getString("statusVenda");
	         }
	     }
	     
	     return status;
	 }
	 public String getStatusVendaPorId(int vendaId) throws SQLException {
		    String status = "unknown";
		    String sql = "SELECT statusVenda FROM tb_vendas WHERE id = ?";

		    try (PreparedStatement stmt = con.prepareStatement(sql)) {
		        stmt.setInt(1, vendaId);
		        try (ResultSet rs = stmt.executeQuery()) {
		            if (rs.next()) {
		                status = rs.getString("statusVenda");
		            }
		        }
		    }
		    return status;
		}

	 public boolean atualizarStatusVenda(int idVenda, String novoStatus) throws SQLException {
	        String sql = "UPDATE tb_vendas SET statusVenda = ? WHERE id = ?";
	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            stmt.setString(1, novoStatus);
	            stmt.setInt(2, idVenda);
	            int rows = stmt.executeUpdate();
	            return rows > 0;
	        }
	    }

	    public boolean atualizarStatusVenda(Integer vendaId, String novoStatus) {
	        if (vendaId == null) {
	            System.err.println("Erro: ID da venda é nulo.");
	            return false;
	        }
	        String sql = "UPDATE tb_vendas SET statusVenda = ? WHERE id = ?";
	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            stmt.setString(1, novoStatus);
	            stmt.setInt(2, vendaId);
	            int rows = stmt.executeUpdate();
	            if (rows == 0) {
	                System.err.println("Nenhuma venda encontrada com ID " + vendaId);
	            } else {
	                System.out.println("Status da venda " + vendaId + " atualizado para " + novoStatus);
	                return true;
	            }
	        } catch (SQLException e) {
	            System.err.println("Erro ao atualizar status da venda com ID numérico: " + e.getMessage());
	            e.printStackTrace();
	        }
	        return false;
	    }

	    public boolean atualizarStatusVenda(String externalReference, String novoStatus) {
	        String sql = "UPDATE tb_vendas SET statusVenda = ? WHERE external_reference = ?";
	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            stmt.setString(1, novoStatus);
	            stmt.setString(2, externalReference);
	            int rows = stmt.executeUpdate();
	            if (rows == 0) {
	                System.err.println("Nenhuma venda encontrada com externalReference " + externalReference);
	            } else {
	                System.out.println("Status da venda " + externalReference + " atualizado para " + novoStatus);
	                return true;
	            }
	        } catch (SQLException e) {
	            System.err.println("Erro ao atualizar status da venda com external_reference: " + e.getMessage());
	            e.printStackTrace();
	        }
	        return false;
	    }
	    public boolean atualizarVendaOnline(int idVenda, Vendas venda) {
	        String sql = "UPDATE tb_vendas SET external_reference = ?, pgTotalOnline = ?, statusVenda = ? WHERE id = ?";
	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            stmt.setString(1, venda.getExternalReference());
	            if (venda.getPgTotalOnline() != null) {
	                stmt.setBigDecimal(2, venda.getPgTotalOnline());
	            } else {
	                stmt.setNull(2, java.sql.Types.DECIMAL);
	            }
	            stmt.setString(3, venda.getSetStatusVenda());
	            stmt.setInt(4, idVenda);

	            int rows = stmt.executeUpdate();
	            return rows > 0;
	        } catch (SQLException e) {
	            System.err.println("Erro ao atualizar venda online: " + e.getMessage());
	            e.printStackTrace();
	            return false;
	        }
	    }

	// Cadastrar Venda//

	 public void cadastrarVenda(Vendas obj) throws SQLException {
	        String sql = "insert into tb_vendas(cliente_id,data_venda,total_venda,observacoes,desconto,forma_pagamento,idUsuario)values(?,?,?,?,?,?,?)";
	        PreparedStatement stmt = null;
	        try {
	            stmt = con.prepareStatement(sql);

	            if (obj.getCliente() != null) {
	                // Define o cliente_id normalmente
	                stmt.setInt(1, obj.getCliente().getId());
	            } else {
	                // Define NULL para cliente_id se não houver cliente
	                stmt.setNull(1, java.sql.Types.INTEGER);
	            }
	            stmt.setString(2, obj.getData_venda());
	            stmt.setDouble(3, obj.getTotal_venda());
	            stmt.setString(4, obj.getObs());
	            stmt.setDouble(5, obj.getDesconto());
	            stmt.setString(6, obj.getFormaPagamento());
	            stmt.setInt(7, obj.getUsuario().getId());

	            stmt.execute();
	        } finally {
	            if (stmt != null) {
	                stmt.close();
	            }
	        }
	    }
	// Retorna a Ultima venda//

	 public int retornaUltimaVenda() throws SQLException {
	        try {
	            int idvenda = 0;
	            String sql = "select max(id)id from tb_vendas";
	            PreparedStatement ps = con.prepareStatement(sql);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                idvenda = rs.getInt("id");
	            }
	            return idvenda;
	        } catch (Exception e) {
	            throw new RuntimeException(e);
	        }
	    }
	

	// Metodo que filtra venda por datas //
	public List<Vendas> listarVendasPorPeriodo(LocalDate data_inicio, LocalDate data_fim) {
		try {

			// 1 passo criar lista de Vendas//
			List<Vendas> lista = new ArrayList<>();

			String sql = "select v.id,date_format(v.data_venda,'%d/%m/%Y')as data_formatada,c.nome,v.total_venda,v.observacoes,v.desconto from tb_vendas as v "
					+ "inner join tb_clientes as c on(v.cliente_id = c.id)where v.data_venda BETWEEN? AND?";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, data_inicio.toString());
			stmt.setString(2, data_fim.toString());

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Vendas obj = new Vendas();
				Clientes c = new Clientes();

				obj.setId(rs.getInt("v.id"));
				obj.setData_venda(rs.getString("data_formatada"));
				c.setNome(rs.getString("c.nome"));
				obj.setTotal_venda(rs.getDouble("v.total_venda"));
				obj.setObs(rs.getString("v.observacoes"));
				obj.setDesconto(rs.getDouble("v.desconto"));

				obj.setCliente(c);

				lista.add(obj);

			}

			return lista;

		} catch (SQLException e) {

			return null;

		}

	}

	 public List<Vendas> listarVendasdoDia() {
	        List<Vendas> lista = new ArrayList<>();
	        String sql = "select v.id, date_format(v.data_venda, '%d/%m/%Y %H:%i:%s') as data_formatada, "
	                   + "c.nome, v.total_venda, v.observacoes, v.forma_pagamento "
	                   + "from tb_vendas as v "
	                   + "left join tb_clientes as c on (v.cliente_id = c.id) "
	                   + "where date(v.data_venda) = ?";

	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            // Obter a data atual do servidor
	            Date agora = new Date();
	            SimpleDateFormat dataEUA = new SimpleDateFormat("yyyy-MM-dd");
	            String datamysql = dataEUA.format(agora);
	            stmt.setString(1, datamysql);

	            try (ResultSet rs = stmt.executeQuery()) {
	                while (rs.next()) {
	                    Vendas obj = new Vendas();
	                    Clientes c = new Clientes();

	                    obj.setId(rs.getInt("v.id"));
	                    obj.setData_venda(rs.getString("data_formatada"));
	                    c.setNome(rs.getString("c.nome"));
	                    obj.setTotal_venda(rs.getDouble("v.total_venda"));
	                    obj.setObs(rs.getString("v.observacoes"));
	                    obj.setFormaPagamento(rs.getString("v.forma_pagamento"));

	                    obj.setCliente(c);

	                    lista.add(obj);
	                }
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return lista;
	    }

	 public List<Vendas> totalPorPeriodo(Date data_inicio, Date data_fim) {
		    List<Vendas> lista = new ArrayList<>();
		    String sql = "SELECT SUM(total) AS total_periodo, data_formatada " +
		                "FROM ( " +
		                "    SELECT total_venda AS total, DATE_FORMAT(data_venda, '%d/%m/%Y') AS data_formatada " +
		                "    FROM tb_vendas " +
		                "    WHERE data_venda BETWEEN ? AND ? " +
		                "    UNION ALL " +
		                "    SELECT total_pedido AS total, DATE_FORMAT(data_pedido, '%d/%m/%Y') AS data_formatada " +
		                "    FROM pedidos " +
		                "    WHERE data_pedido BETWEEN ? AND ? " +
		                ") AS combined_data " +
		                "GROUP BY data_formatada " +
		                "ORDER BY STR_TO_DATE(data_formatada, '%d/%m/%Y')";

		    try (PreparedStatement stmt = con.prepareStatement(sql)) {
		        stmt.setDate(1, new java.sql.Date(data_inicio.getTime()));
		        stmt.setDate(2, new java.sql.Date(data_fim.getTime()));
		        stmt.setDate(3, new java.sql.Date(data_inicio.getTime()));
		        stmt.setDate(4, new java.sql.Date(data_fim.getTime()));

		        try (ResultSet rs = stmt.executeQuery()) {
		            while (rs.next()) {
		                Vendas obj = new Vendas();
		                obj.setData_venda(rs.getString("data_formatada"));
		                obj.setTotal_venda(rs.getDouble("total_periodo"));
		                lista.add(obj);
		            }
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		        System.out.println("Erro: " + e.getMessage());
		    }

		    return lista;
		}

	// Metodo que calcula total da vendaa por data//
	public double retornaTotalVendaPorData(Date data_venda) {
	    try {
	        double totalvenda = 0;
	        
	        // Converter java.util.Date para java.sql.Date
	        java.sql.Date sqlDate = new java.sql.Date(data_venda.getTime());
	        
	        String sql = "SELECT " +
	                    "    (SELECT COALESCE(SUM(total_venda), 0) FROM tb_vendas WHERE DATE(data_venda) = ?) + " +
	                    "    (SELECT COALESCE(SUM(total_pedido), 0) FROM pedidos WHERE DATE(data_pedido) = ?) as total";
	        
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setDate(1, sqlDate);
	        ps.setDate(2, sqlDate);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            totalvenda = rs.getDouble("total");
	        }

	        return totalvenda;

	    } catch (SQLException e) {
	        throw new RuntimeException(e);
	    }
	}


	public double retornaTotalVendaPorDia(LocalDate data_venda) {
	    try {
	        double totalvenda = 0;

	        String sql = "SELECT SUM(total) as total " +
	                    "FROM ( " +
	                    "    SELECT total_venda as total FROM tb_vendas WHERE DATE(data_venda) = ? " +
	                    "    UNION ALL " +
	                    "    SELECT total_pedido as total FROM pedidos WHERE DATE(data_pedido) = ? " +
	                    ") as combined_totals";

	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, data_venda.toString());
	        ps.setString(2, data_venda.toString()); // mesmo parâmetro repetido

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            totalvenda = rs.getDouble("total");
	        }

	        return totalvenda;

	    } catch (SQLException e) {
	        throw new RuntimeException(e);
	    }
	}

	public void selVendas(String cpf, int idprod) {

		try {
			String sql = "select " + "cli.id, " + "cli.nome, " + "cli.cpf, " + "cli.endereco, " + "cli.numero, "
					+ "prod.id, " + "prod.descricao, " + "prod.preco_de_venda, " + "prod.preco_de_compra "
					+ "from tb_clientes as cli, " + "tb_produtos as prod " + " where cli.cpf like ? "
					+ " and prod.id = ? ";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, cpf);
			stmt.setInt(2, idprod);

			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				Clientes cli = new Clientes();
				Produtos prod = new Produtos();

				cli.setId(rs.getInt("cli.id"));
				cli.setNome(rs.getString("cli.nome"));
				cli.setCpf(rs.getString("cli.cpf"));
				cli.setBairro(rs.getString("cli.endereco"));

				cli.setNumero(rs.getInt("cli.numero"));
				prod.setId(rs.getInt("prod.id"));
				prod.setDescricao(rs.getString("prod.descricao"));
				prod.setPreco_de_venda(rs.getDouble("prod.preco_de_venda"));
				prod.setPreco_de_compra(rs.getDouble("prod.preco_de_compra"));

			}
		} catch (Exception e) {
			// TODO: handle exception
		}

	}
	public List<ItensVenda> maisVendidos(Date dataInicio, Date dataFim){
	    List<ItensVenda> lista = new ArrayList<>();

	    try {
	    	String sql = """
	                SELECT 
	                    SUM(QUANTIDADE) AS QUANTIDADE_TOTAL, 
	                    SUM(QUANTIDADE_VENDAS) AS QUANTIDADE_VENDAS, 
	                    SUM(QUANTIDADE_PEDIDOS) AS QUANTIDADE_PEDIDOS, 
	                    DESCRICAO 
	                FROM ( 
	                    -- Vendas 
	                    SELECT 
	                        ITENS.QTD AS QUANTIDADE, 
	                        ITENS.QTD AS QUANTIDADE_VENDAS, 
	                        0 AS QUANTIDADE_PEDIDOS, 
	                        PRODUTO.DESCRICAO 
	                    FROM TB_ITENSVENDAS AS ITENS 
	                    INNER JOIN TB_PRODUTOS AS PRODUTO ON PRODUTO.ID = ITENS.PRODUTO_ID 
	                    INNER JOIN TB_VENDAS AS VENDAS ON ITENS.VENDA_ID = VENDAS.ID 
	                    WHERE DATE(VENDAS.DATA_VENDA) BETWEEN ? AND ? 
	                    UNION ALL 
	                    -- Pedidos 
	                    SELECT 
	                        PEDIDOS.QUANTIDADE AS QUANTIDADE, 
	                        0 AS QUANTIDADE_VENDAS, 
	                        PEDIDOS.QUANTIDADE AS QUANTIDADE_PEDIDOS, 
	                        PRODUTO.DESCRICAO 
	                    FROM ITENS_PEDIDO AS PEDIDOS 
	                    INNER JOIN TB_PRODUTOS AS PRODUTO ON PRODUTO.ID = PEDIDOS.PRODUTO_ID 
	                    INNER JOIN PEDIDOS AS PED ON PEDIDOS.PEDIDO_ID = PED.ID_PEDIDO 
	                    WHERE DATE(PED.DATA_PEDIDO) BETWEEN ? AND ? 
	                ) AS combined_data 
	                GROUP BY DESCRICAO 
	                ORDER BY QUANTIDADE_TOTAL DESC
	                """;

	        PreparedStatement stmt = con.prepareStatement(sql);
	        stmt.setDate(1, new java.sql.Date(dataInicio.getTime()));
	        stmt.setDate(2, new java.sql.Date(dataFim.getTime()));
	        stmt.setDate(3, new java.sql.Date(dataInicio.getTime()));
	        stmt.setDate(4, new java.sql.Date(dataFim.getTime()));

	        ResultSet rs = stmt.executeQuery();
	        while(rs.next()){
	            Produtos produtos = new Produtos();
	            ItensVenda itensvenda = new ItensVenda();

	            itensvenda.setQtd(rs.getInt("QUANTIDADE_TOTAL"));
	            produtos.setDescricao(rs.getString("DESCRICAO"));

	            itensvenda.setProduto(produtos);
	            lista.add(itensvenda);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return lista;
	}
	public double lucroVenda(int id) {
	    double totalVenda = 0;

	    String sql = "SELECT SUM(produto.preco_de_venda - produto.preco_de_compra) AS lucro_da_venda "
	               + "FROM tb_produtos AS produto "
	               + "INNER JOIN tb_itensvendas AS itens ON itens.produto_id = produto.id "
	               + "WHERE itens.venda_id = ?";

	    try (PreparedStatement stmt = con.prepareStatement(sql)) {
	        stmt.setInt(1, id);
	        try (ResultSet rs = stmt.executeQuery()) {
	            if (rs.next()) { // Só existe um resultado
	                totalVenda = rs.getDouble("lucro_da_venda");
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace(); // Loga o erro no console
	    }

	    return totalVenda;
	}
	public double lucroPorPeriod(Date dataInicio, Date dataFim){

		double totalLucro = 0;

		try {
			String sql =  "   SELECT SUM(PRODUTO.PRECO_DE_VENDA - PRODUTO.PRECO_DE_COMPRA) AS LUCRO_DA_VENDA "
					    + "   FROM TB_PRODUTOS AS PRODUTO "
					    + "   INNER JOIN TB_ITENSVENDAS AS ITENS ON ITENS.PRODUTO_ID = PRODUTO.ID "
					    + "   INNER JOIN TB_VENDAS      AS VENDA ON VENDA.ID = ITENS.VENDA_ID "
					    + "   WHERE "
					    + "   DATE(VENDA.DATA_VENDA) BETWEEN ? AND ? ";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setDate(1, new java.sql.Date(dataInicio.getTime()));
			stmt.setDate(2, new java.sql.Date(dataFim.getTime()));

			ResultSet rs = stmt.executeQuery();
			 if(rs.next()){

				 totalLucro = rs.getDouble("LUCRO_DA_VENDA");






			 }


		} catch (SQLException e) {

		}
		return totalLucro;

	}

	public int retornaVenda() {
	    String sql = "SELECT ID FROM TB_VENDAS ORDER BY ID DESC LIMIT 1"; // Pega a última venda cadastrada
	    int idVenda = 0;

	    try {
	        PreparedStatement stmt = con.prepareStatement(sql);
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	            idVenda = rs.getInt("ID"); // Obtém o ID diretamente
	        }

	        rs.close();
	        stmt.close();
	    } catch (Exception e) {
	        e.printStackTrace(); // Exibe o erro no console para depuração
	    }
	    return idVenda;
	}
	public BigDecimal retornaVendaValor() {
	    String sql = "SELECT TOTAL_VENDA FROM tb_vendas WHERE ID = (SELECT MAX(ID) FROM tb_vendas)";
	    BigDecimal valorVenda = BigDecimal.ZERO;

	    try (PreparedStatement stmt = con.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {

	        if (rs.next()) {
	            valorVenda = rs.getBigDecimal("TOTAL_VENDA"); // pega direto como BigDecimal
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return valorVenda;
	}

	 public String consultarStatusVenda(int vendaId) {
	        String sql = "SELECT statusVenda FROM tb_vendas WHERE id = ?";
	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            stmt.setInt(1, vendaId);
	            ResultSet rs = stmt.executeQuery();
	            if (rs.next()) {
	                return rs.getString("statusVenda");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return "pendente";
	    }



}




