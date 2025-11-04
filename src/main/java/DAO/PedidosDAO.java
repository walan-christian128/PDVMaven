package DAO; // Ajuste o pacote conforme a sua estrutura

import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import Conexao.ConectionDataBases; // Ajuste o pacote para onde sua classe ConectionDataBases está
import Model.Clientepedido; // Ajuste o pacote para onde sua classe Clientepedido está
import Model.Empresa;
import Model.Pedidos;     // Ajuste o pacote para onde sua classe Pedidos está
// import Model.Vendas; // Não usada na classe fornecida, pode ser removida se não for necessária
import Model.Vendas;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PedidosDAO {
	
	private Connection con;
	private ConectionDataBases connectionFactory;

	// Construtor: Inicializa a conexão
	public PedidosDAO(String dataBaseName) throws ClassNotFoundException, SQLException {
        this.connectionFactory = new ConectionDataBases(dataBaseName);
        System.out.println("DEBUG_PEDIDO_DAO: Construtor PedidosDAO iniciado para banco: " + dataBaseName); // <-- NOVO LOG
        try {
            this.con = connectionFactory.getConectionDataBases();
            if (this.con == null || this.con.isClosed()) {
               
            } else {
              
            }
        } catch (SQLException e) {
           
            throw e; 
        }
    }
	
	public int cadastrarPedido(Pedidos obj) throws SQLException {
		
		String sql = "INSERT INTO pedidos(clientepedido_id, data_pedido, status, observacoes, forma_pagamento, total_pedido,empresa_id) VALUES(?, NOW(), ?, ?, ?, ?,?)"; 
        int idGerado = -1; // Valor padrão para indicar falha

        try (PreparedStatement stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, obj.getClientepedido().getId());
            stmt.setString(2, obj.getStatus());
            stmt.setString(3, obj.getObservacoes());
            stmt.setString(4, obj.getFormapagamento());
            stmt.setDouble(5, obj.getTotalPedido());
            stmt.setInt(6, obj.getEmpresa().getId());

            int linhasAfetadas = stmt.executeUpdate(); 

            if (linhasAfetadas > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                    	idGerado = rs.getInt(1); 
                        obj.setIdPedido(idGerado); 
                        
                    }
                }
            }
        } catch (SQLException e) {
            
            e.printStackTrace(); 
            throw e; 
        } finally {
            
            try {
                if (con != null && !con.isClosed()) {
                    // con.close(); // Se você quer fechar a conexão após CADA operação
                    // System.out.println("PedidosDAO: Conexão fechada após cadastrarPedido.");
                }
            } catch (SQLException e) {
                System.err.println("PedidosDAO: ERRO ao fechar a conexão após cadastrarPedido: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return idGerado;
    }
	
    public List<Pedidos> listarPedidosPorCliente(int clienteId) {
        List<Pedidos> listaPedidos = new ArrayList<>();
        String sql;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String dataAtualStr = sdf.format(new Date());

        sql = "SELECT id_pedido, " 
                + "       DATE_FORMAT(data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
                + "       status, "
                + "       observacoes, "
                + "       forma_pagamento " 
                + "FROM pedidos " 
                + "WHERE clientepedido_id = ? " 
                + "  AND DATE(data_pedido) = ? "
                + "ORDER BY data_pedido DESC";

        try (PreparedStatement stmt = con.prepareStatement(sql)) { 
            stmt.setInt(1, clienteId);
            stmt.setString(2, dataAtualStr);
       
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    Pedidos pedido = new Pedidos();
                    pedido.setIdPedido(rs.getInt("id_pedido")); 
                    pedido.setDataPeedido(rs.getString("data_formatada")); // Verifique se é setDataPeedido ou setDataPedido
                    pedido.setStatus(rs.getString("status"));
                    pedido.setObservacoes(rs.getString("observacoes"));
                    pedido.setFormapagamento(rs.getString("forma_pagamento"));

                    Clientepedido cliente = new Clientepedido();
                    cliente.setId(clienteId); // Já temos o ID do cliente
                    pedido.setClientepedido(cliente);

                    listaPedidos.add(pedido);
                    count++;
                }
                System.out.println("PedidosDAO: Total de pedidos encontrados para cliente " + clienteId + " na data " + dataAtualStr + ": " + count);
            }
        } catch (SQLException e) {
            System.err.println("PedidosDAO: ERRO ao listar pedidos por cliente e data: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    // con.close(); // Decida se quer fechar a conexão aqui
                    // System.out.println("PedidosDAO: Conexão fechada após listarPedidosPorCliente.");
                }
            } catch (SQLException e) {
               
                e.printStackTrace();
            }
        }
        return listaPedidos;
    }
    
    public List<Pedidos> listaTodosPedidosDoDia() {
        List<Pedidos> listaPedidos = new ArrayList<>();
        String sql;

        sql = " SELECT   "
        		+ " ped.id_pedido as codigo_pedido,   "
        		+ " ped.total_pedido as total,   "
        		+ " cli.nome as nome_cliente,   "
        		+ " ped.clientepedido_id as codigo_cliente,   "
        		+ " DATE_FORMAT(ped.data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada,   "
        		+ " ped.status as status,   "
        		+ " ped.observacoes as observacoes,   "
        		+ " ped.forma_pagamento as forma_pagamento,   "
        		+ " ped.pagamentoPedido as pedido_pagamento   "
        		+ " FROM pedidos as ped   "
        		+ " INNER JOIN tb_cliente_pedido as cli ON cli.id = ped.clientepedido_id   "
        		+ " WHERE DATE(ped.data_pedido) = CURDATE()  "
        		+ " AND ped.status = 'Pendente'   "
        		+ "AND (ped.pagamentoPedido IN ('APROVADA','APPROVED')  "
        		+ "     OR ped.pagamentoPedido IS NULL  "
        		+ "     OR ped.pagamentoPedido = '')"; 

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
          
            
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    Pedidos pedido = new Pedidos();
                    Clientepedido cliente = new Clientepedido();

                    pedido.setIdPedido(rs.getInt("codigo_pedido"));
                    cliente.setNome(rs.getString("nome_cliente"));
                    cliente.setId(rs.getInt("codigo_cliente")); 

                    pedido.setDataPeedido(rs.getString("data_formatada")); 
                    pedido.setStatus(rs.getString("status"));
                    pedido.setObservacoes(rs.getString("observacoes"));
                    pedido.setFormapagamento(rs.getString("forma_pagamento"));
                    pedido.setPagamentoPedido(rs.getString("pedido_pagamento"));
                    pedido.setTotalPedido(rs.getDouble("total"));

                    pedido.setClientepedido(cliente); 

                    listaPedidos.add(pedido);
                    count++; 
                }
                System.out.println("DEBUG_PEDIDO_DAO: Total de pedidos encontrados em listaTodosPedidosDoDia: " + count);
            }
        } catch (SQLException e) {
            System.err.println("DEBUG_PEDIDO_DAO: ERRO ao listar todos os pedidos do dia: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    con.close(); 
                    System.out.println("DEBUG_PEDIDO_DAO: Conexão fechada após listaTodosPedidosDoDia.");
                }
            } catch (SQLException e) {
                System.err.println("DEBUG_PEDIDO_DAO: ERRO ao fechar a conexão após listaTodosPedidosDoDia: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return listaPedidos;
    }
    public int retornaUltimoPedido() {
    	// NOTE: É importante que a conexão 'con' esteja aberta ao chamar este método.
    	// Se você fechou a conexão em outros 'finally's, este método pode falhar.
    	// Uma abordagem melhor é ter uma conexão gerenciada que é aberta e fechada uma vez por requisição
    	// ou por ciclo de vida de um DAO, e não por método.
        try {
            int idPedido = 0;
            String sql = "SELECT MAX(id_pedido) as id FROM pedidos"; // Use MAX() para obter o maior ID

            try (PreparedStatement stmt = con.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    idPedido = rs.getInt("id"); // Obtém o ID do alias
                }
            } return idPedido;
        } catch (SQLException e) {
           
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar o último pedido: " + e.getMessage(), e);
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    // con.close(); // Decida se quer fechar a conexão aqui
                    // System.out.println("PedidosDAO: Conexão fechada após retornaUltimoPedido.");
                }
            } catch (SQLException e) {
             
                e.printStackTrace();
            }
        }
    } 
    
    public void atualizaPedido(Pedidos ped){
    String sql ="UPDATE pedidos set status=?,observacoes=? where id_pedido=?";   
    
    try {
		PreparedStatement stmt = con.prepareStatement(sql);
		
		stmt.setString(1, ped.getStatus());
		stmt.setString(2,ped.getObservacoes());
		stmt.setInt(3, ped.getIdPedido());
		
		stmt.executeUpdate();
		stmt.close();
	} catch (Exception e) {
		// TODO: handle exception
	}
    	
    	
    }
    public void atualizaPedidoStatus(Pedidos ped){
        String sql ="UPDATE pedidos set status=? where id_pedido=?";   
        
        try {
    		PreparedStatement stmt = con.prepareStatement(sql);
    		
    		stmt.setString(1, ped.getStatus());
    		stmt.setInt(2, ped.getIdPedido());
    		
    		stmt.executeUpdate();
    		stmt.close();
    	} catch (Exception e) {
    		// TODO: handle exception
    	}
        	
        	
        }
 // Supondo que 'con' seja sua Connection
    public List<Pedidos> pedidoEntregue() { // Removido 'Pedidos pedido' do parâmetro, pois você não precisa passar um objeto vazio
    	 List<Pedidos> listaPedidos = new ArrayList<>();
         String sql;

         sql = "SELECT "
                 + "ped.id_pedido as codigo_pedido, "
         		+ "ped.total_pedido as total, "
                 + "cli.nome as nome_cliente, "
                 + "ped.clientepedido_id as codigo_cliente, "
                 + "DATE_FORMAT(ped.data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
                 + "ped.status as status, "
                 + "ped.observacoes as observacoes, "
                 + "ped.forma_pagamento as forma_pagamento, "
                 + "ped.pagamentoPedido as pedido_pagamento "
                 + "FROM pedidos as ped "
                 + "INNER JOIN tb_cliente_pedido as cli ON cli.id = ped.clientepedido_id "
                 + "where status = 'Entregue'"; 

         try (PreparedStatement stmt = con.prepareStatement(sql)) {
           
             
             try (ResultSet rs = stmt.executeQuery()) {
                 int count = 0;
                 while (rs.next()) {
                     Pedidos pedido = new Pedidos();
                     Clientepedido cliente = new Clientepedido();

                     pedido.setIdPedido(rs.getInt("codigo_pedido"));
                     cliente.setNome(rs.getString("nome_cliente"));
                     cliente.setId(rs.getInt("codigo_cliente")); 

                     pedido.setDataPeedido(rs.getString("data_formatada")); 
                     pedido.setStatus(rs.getString("status"));
                     pedido.setObservacoes(rs.getString("observacoes"));
                     pedido.setFormapagamento(rs.getString("forma_pagamento"));
                     pedido.setPagamentoPedido(rs.getString("pedido_pagamento"));
                     pedido.setTotalPedido(rs.getDouble("total"));

                     pedido.setClientepedido(cliente); 

                     listaPedidos.add(pedido);
                     count++; 
                 }
                 System.out.println("DEBUG_PEDIDO_DAO: Total de pedidos encontrados em listaTodosPedidosDoDia: " + count);
             }
         } catch (SQLException e) {
             System.err.println("DEBUG_PEDIDO_DAO: ERRO ao listar todos os pedidos do dia: " + e.getMessage());
             e.printStackTrace();
         } finally {
             try {
                 if (con != null && !con.isClosed()) {
                     con.close(); 
                     System.out.println("DEBUG_PEDIDO_DAO: Conexão fechada após listaTodosPedidosDoDia.");
                 }
             } catch (SQLException e) {
                 System.err.println("DEBUG_PEDIDO_DAO: ERRO ao fechar a conexão após listaTodosPedidosDoDia: " + e.getMessage());
                 e.printStackTrace();
             }
         }
        return listaPedidos;
    }
    
    public List<Pedidos> pedidoPreparacao() { // Removido 'Pedidos pedido' do parâmetro, pois você não precisa passar um objeto vazio
   	 List<Pedidos> listaPedidos = new ArrayList<>();
        String sql;

        sql = "SELECT "
                + "ped.id_pedido as codigo_pedido, "
        		+ "ped.total_pedido as total, "
                + "cli.nome as nome_cliente, "
                + "ped.clientepedido_id as codigo_cliente, "
                + "DATE_FORMAT(ped.data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
                + "ped.status as status, "
                + "ped.observacoes as observacoes, "
                + "ped.forma_pagamento as forma_pagamento, "
                + "ped.pagamentoPedido as pedido_pagamento "
                + "FROM pedidos as ped "
                + "INNER JOIN tb_cliente_pedido as cli ON cli.id = ped.clientepedido_id "
                + "where status = 'Em Preparo'"; 

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
          
            
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    Pedidos pedido = new Pedidos();
                    Clientepedido cliente = new Clientepedido();

                    pedido.setIdPedido(rs.getInt("codigo_pedido"));
                    cliente.setNome(rs.getString("nome_cliente"));
                    cliente.setId(rs.getInt("codigo_cliente")); 

                    pedido.setDataPeedido(rs.getString("data_formatada")); 
                    pedido.setStatus(rs.getString("status"));
                    pedido.setObservacoes(rs.getString("observacoes"));
                    pedido.setFormapagamento(rs.getString("forma_pagamento"));
                    pedido.setPagamentoPedido(rs.getString("pedido_pagamento"));
                    pedido.setTotalPedido(rs.getDouble("total"));

                    pedido.setClientepedido(cliente); 

                    listaPedidos.add(pedido);
                    count++; 
                }
                System.out.println("DEBUG_PEDIDO_DAO: Total de pedidos encontrados em listaTodosPedidosDoDia: " + count);
            }
        } catch (SQLException e) {
            System.err.println("DEBUG_PEDIDO_DAO: ERRO ao listar todos os pedidos do dia: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    con.close(); 
                    System.out.println("DEBUG_PEDIDO_DAO: Conexão fechada após listaTodosPedidosDoDia.");
                }
            } catch (SQLException e) {
                System.err.println("DEBUG_PEDIDO_DAO: ERRO ao fechar a conexão após listaTodosPedidosDoDia: " + e.getMessage());
                e.printStackTrace();
            }
        }
       return listaPedidos;
   }
    public List<Pedidos> pedidoReprovados() { // Removido 'Pedidos pedido' do parâmetro, pois você não precisa passar um objeto vazio
      	 List<Pedidos> listaPedidos = new ArrayList<>();
           String sql;

           sql = "SELECT "
                   + "ped.id_pedido as codigo_pedido, "
            		+ "ped.total_pedido as total, "
                    + "cli.nome as nome_cliente, "
                    + "ped.clientepedido_id as codigo_cliente, "
                    + "DATE_FORMAT(ped.data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
                    + "ped.status as status, "
                    + "ped.observacoes as observacoes, "
                    + "ped.forma_pagamento as forma_pagamento, "
                    + "ped.pagamentoPedido as pedido_pagamento "
                   + "FROM pedidos as ped "
                   + "INNER JOIN tb_cliente_pedido as cli ON cli.id = ped.clientepedido_id "
                   + "where status = 'Reprovado'"; 

           try (PreparedStatement stmt = con.prepareStatement(sql)) {
             
               
               try (ResultSet rs = stmt.executeQuery()) {
                   int count = 0;
                   while (rs.next()) {
                       Pedidos pedido = new Pedidos();
                       Clientepedido cliente = new Clientepedido();

                       pedido.setIdPedido(rs.getInt("codigo_pedido"));
                       cliente.setNome(rs.getString("nome_cliente"));
                       cliente.setId(rs.getInt("codigo_cliente")); 

                       pedido.setDataPeedido(rs.getString("data_formatada")); 
                       pedido.setStatus(rs.getString("status"));
                       pedido.setObservacoes(rs.getString("observacoes"));
                       pedido.setFormapagamento(rs.getString("forma_pagamento"));
                       pedido.setPagamentoPedido(rs.getString("pedido_pagamento"));
                       pedido.setTotalPedido(rs.getDouble("total"));

                       pedido.setClientepedido(cliente); 

                       listaPedidos.add(pedido);
                       count++; 
                   }
                   System.out.println("DEBUG_PEDIDO_DAO: Total de pedidos encontrados em listaTodosPedidosDoDia: " + count);
               }
           } catch (SQLException e) {
               System.err.println("DEBUG_PEDIDO_DAO: ERRO ao listar todos os pedidos do dia: " + e.getMessage());
               e.printStackTrace();
           } finally {
               try {
                   if (con != null && !con.isClosed()) {
                       con.close(); 
                       System.out.println("DEBUG_PEDIDO_DAO: Conexão fechada após listaTodosPedidosDoDia.");
                   }
               } catch (SQLException e) {
                   System.err.println("DEBUG_PEDIDO_DAO: ERRO ao fechar a conexão após listaTodosPedidosDoDia: " + e.getMessage());
                   e.printStackTrace();
               }
           }
          return listaPedidos;
      }
    
    public List<Pedidos> pedidoEmRota() { // Removido 'Pedidos pedido' do parâmetro, pois você não precisa passar um objeto vazio
   	 List<Pedidos> listaPedidos = new ArrayList<>();
        String sql;

        sql = "SELECT "
                + "ped.id_pedido as codigo_pedido, "
        		+ "ped.total_pedido as total, "
                + "cli.nome as nome_cliente, "
                + "ped.clientepedido_id as codigo_cliente, "
                + "DATE_FORMAT(ped.data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
                + "ped.status as status, "
                + "ped.observacoes as observacoes, "
                + "ped.forma_pagamento as forma_pagamento, "
                + "ped.pagamentoPedido as pedido_pagamento "
                + "FROM pedidos as ped "
                + "INNER JOIN tb_cliente_pedido as cli ON cli.id = ped.clientepedido_id "
                + "where status = 'Em Rota de Entrega'"; 

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
          
            
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    Pedidos pedido = new Pedidos();
                    Clientepedido cliente = new Clientepedido();

                    pedido.setIdPedido(rs.getInt("codigo_pedido"));
                    cliente.setNome(rs.getString("nome_cliente"));
                    cliente.setId(rs.getInt("codigo_cliente")); 

                    pedido.setDataPeedido(rs.getString("data_formatada")); 
                    pedido.setStatus(rs.getString("status"));
                    pedido.setObservacoes(rs.getString("observacoes"));
                    pedido.setFormapagamento(rs.getString("forma_pagamento"));
                    pedido.setPagamentoPedido(rs.getString("pedido_pagamento"));
                    pedido.setTotalPedido(rs.getDouble("total"));

                    pedido.setClientepedido(cliente); 

                    listaPedidos.add(pedido);
                    count++; 
                }
                System.out.println("DEBUG_PEDIDO_DAO: Total de pedidos encontrados em listaTodosPedidosDoDia: " + count);
            }
        } catch (SQLException e) {
            System.err.println("DEBUG_PEDIDO_DAO: ERRO ao listar todos os pedidos do dia: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    con.close(); 
                    System.out.println("DEBUG_PEDIDO_DAO: Conexão fechada após listaTodosPedidosDoDia.");
                }
            } catch (SQLException e) {
                System.err.println("DEBUG_PEDIDO_DAO: ERRO ao fechar a conexão após listaTodosPedidosDoDia: " + e.getMessage());
                e.printStackTrace();
            }
        }
       return listaPedidos;
   }
    public List<Pedidos> pedidoPendentes() { // Removido 'Pedidos pedido' do parâmetro, pois você não precisa passar um objeto vazio
   	 List<Pedidos> listaPedidos = new ArrayList<>();
        String sql;

        sql = "SELECT "
                + "ped.id_pedido as codigo_pedido, "
        		+ "ped.total_pedido as total, "
                + "cli.nome as nome_cliente, "
                + "ped.clientepedido_id as codigo_cliente, "
                + "DATE_FORMAT(ped.data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
                + "ped.status as status, "
                + "ped.observacoes as observacoes, "
                + "ped.forma_pagamento as forma_pagamento, "
                + "ped.pagamentoPedido as pedido_pagamento "
                + "FROM pedidos as ped "
                + "INNER JOIN tb_cliente_pedido as cli ON cli.id = ped.clientepedido_id "
                + "where status = 'Pendente' "; 

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
          
            
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    Pedidos pedido = new Pedidos();
                    Clientepedido cliente = new Clientepedido();

                    pedido.setIdPedido(rs.getInt("codigo_pedido"));
                    cliente.setNome(rs.getString("nome_cliente"));
                    cliente.setId(rs.getInt("codigo_cliente")); 

                    pedido.setDataPeedido(rs.getString("data_formatada")); 
                    pedido.setStatus(rs.getString("status"));
                    pedido.setObservacoes(rs.getString("observacoes"));
                    pedido.setFormapagamento(rs.getString("forma_pagamento"));
                    pedido.setPagamentoPedido(rs.getString("pedido_pagamento"));
                    pedido.setTotalPedido(rs.getDouble("total"));

                    pedido.setClientepedido(cliente); 

                    listaPedidos.add(pedido);
                    count++; 
                }
                System.out.println("DEBUG_PEDIDO_DAO: Total de pedidos encontrados em listaTodosPedidosDoDia: " + count);
            }
        } catch (SQLException e) {
            System.err.println("DEBUG_PEDIDO_DAO: ERRO ao listar todos os pedidos do dia: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    con.close(); 
                    System.out.println("DEBUG_PEDIDO_DAO: Conexão fechada após listaTodosPedidosDoDia.");
                }
            } catch (SQLException e) {
                System.err.println("DEBUG_PEDIDO_DAO: ERRO ao fechar a conexão após listaTodosPedidosDoDia: " + e.getMessage());
                e.printStackTrace();
            }
        }
       return listaPedidos;
   }
    public List<Pedidos> todosEntregue() { // Removido 'Pedidos pedido' do parâmetro, pois você não precisa passar um objeto vazio
   	 List<Pedidos> listaPedidos = new ArrayList<>();
        String sql;

        sql = "SELECT "
                + "ped.id_pedido as codigo_pedido, "
        		+ "ped.total_pedido as total, "
                + "cli.nome as nome_cliente, "
                + "ped.clientepedido_id as codigo_cliente, "
                + "DATE_FORMAT(ped.data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada, "
                + "ped.status as status, "
                + "ped.observacoes as observacoes, "
                + "ped.forma_pagamento as forma_pagamento, "
                + "ped.pagamentoPedido as pedido_pagamento "
                + "FROM pedidos as ped "
                + "INNER JOIN tb_cliente_pedido as cli ON cli.id = ped.clientepedido_id "; 

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
          
            
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    Pedidos pedido = new Pedidos();
                    Clientepedido cliente = new Clientepedido();

                    pedido.setIdPedido(rs.getInt("codigo_pedido"));
                    cliente.setNome(rs.getString("nome_cliente"));
                    cliente.setId(rs.getInt("codigo_cliente")); 

                    pedido.setDataPeedido(rs.getString("data_formatada")); 
                    pedido.setStatus(rs.getString("status"));
                    pedido.setObservacoes(rs.getString("observacoes"));
                    pedido.setFormapagamento(rs.getString("forma_pagamento"));
                    pedido.setPagamentoPedido(rs.getString("pedido_pagamento"));
                    pedido.setTotalPedido(rs.getDouble("total"));

                    pedido.setClientepedido(cliente); 

                    listaPedidos.add(pedido);
                    count++; 
                }
                System.out.println("DEBUG_PEDIDO_DAO: Total de pedidos encontrados em listaTodosPedidosDoDia: " + count);
            }
        } catch (SQLException e) {
            System.err.println("DEBUG_PEDIDO_DAO: ERRO ao listar todos os pedidos do dia: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    con.close(); 
                    System.out.println("DEBUG_PEDIDO_DAO: Conexão fechada após listaTodosPedidosDoDia.");
                }
            } catch (SQLException e) {
                System.err.println("DEBUG_PEDIDO_DAO: ERRO ao fechar a conexão após listaTodosPedidosDoDia: " + e.getMessage());
                e.printStackTrace();
            }
        }
       return listaPedidos;
   }
   
   
    public int codigoPedido() {
        int idPedido = 0;
        String sql = "SELECT id_pedido FROM pedidos ORDER BY id_pedido DESC LIMIT 1"; // pega o último ID
        
        try (PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                idPedido = rs.getInt("id_pedido");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Melhor que deixar vazio
        }
        
        return idPedido;
    }
    public Pedidos buscarPorId(int idPedido) throws SQLException {
        String sql = "SELECT p.idPedido, p.totalPedido, p.status, p.dataPeedido, p.observacoes, p.id_cliente, p.id_empresa " +
                     "FROM pedidos p " +
                     "WHERE p.idPedido = ?";
        Pedidos pedido = null;

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, idPedido);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    pedido = new Pedidos();
                    pedido.setIdPedido(rs.getInt("idPedido"));
                    pedido.setTotalPedido(rs.getDouble("totalPedido"));
                    pedido.setStatus(rs.getString("status"));
                    pedido.setDataPeedido(rs.getString("dataPeedido"));
                    pedido.setObservacoes(rs.getString("observacoes"));
                    
                    // Recupera o cliente e a empresa associados
                    Clientepedido cliente = new Clientepedido();
                    cliente.setId(rs.getInt("id_cliente"));
                    pedido.setClientepedido(cliente);
                    
                    Empresa empresaObj = new Empresa();
                    empresaObj.setId(rs.getInt("id_empresa"));
                    pedido.setEmpresa(empresaObj);
                }
            }
        }
        return pedido;
    }

    public void atualizarStatus(int idPedido, String novoStatus) throws SQLException {
        String sql = "UPDATE pedidos SET status = ? WHERE idPedido = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, novoStatus);
            stmt.setInt(2, idPedido);
            stmt.executeUpdate();
        }
    }
    public BigDecimal retornaPedidoValor() {
	    String sql = "SELECT TOTAL_PEDIDO FROM pedidos WHERE id_pedido = (SELECT MAX(id_pedido) FROM pedidos)";
	    BigDecimal valorPedido = BigDecimal.ZERO;

	    try (PreparedStatement stmt = con.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {

	        if (rs.next()) {
	        	valorPedido = rs.getBigDecimal("TOTAL_PEDIDO"); // pega direto como BigDecimal
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return valorPedido;
	}
    public boolean atualizarPedidoOnline(int idPedido, Pedidos pedido) {
        String sql = "UPDATE pedidos SET pagamentoPedido = ?, referenciaPedido = ?, pgTotalPedidoOnline = ? WHERE id_pedido = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, pedido.getPagamentoPedido());
            if (pedido.getReferecialPedido() != null) {
                stmt.setString(2, pedido.getReferecialPedido());
            } else {
                stmt.setNull(2, java.sql.Types.DECIMAL);
            }
            stmt.setBigDecimal(3, pedido.getPgTotalPedidoOnline());
            stmt.setInt(4, idPedido);

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar venda online: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean atualizarPedidoOnlineStatus(String externalReference, String novoStatus) {
        String sql = "UPDATE pedidos SET pagamentoPedido = ?, referenciaPedido = ?, pgTotalPedidoOnline = ? WHERE id_pedido = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, novoStatus);
            stmt.setString(2, externalReference);
            int rows = stmt.executeUpdate();
            if (rows == 0) {
                System.err.println("Nenhuma pedido encontrada com externalReference " + externalReference);
            } else {
                System.out.println("Status do pedido " + externalReference + " atualizado para " + novoStatus);
                return true;
            }
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar pedido online: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public boolean atualizarStatuspedido(int idPedido, String novoStatus) throws SQLException {
        String sql = "UPDATE pedidos SET pagamentoPedido = ? WHERE id_pedido = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, novoStatus);
            stmt.setInt(2, idPedido);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }
    public String getStatusPedidoPorId(String orderId) throws SQLException {
	    String sql = "SELECT pagamentoPedido FROM pedidos WHERE referencialPedido = ?";
	    try (PreparedStatement stmt = con.prepareStatement(sql)) {
	        stmt.setString(1, orderId);
	        ResultSet rs = stmt.executeQuery();
	        if (rs.next()) {
	            return rs.getString("pagamentoPedido");
	        }
	    }
	    System.out.println(sql);
	    return null;
	}
	 public String consultarStatusPedido(int PedidoId) {
	        String sql = "SELECT pagamentoPedido FROM pedidos WHERE id = ?";
	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            stmt.setInt(1, PedidoId);
	            ResultSet rs = stmt.executeQuery();
	            if (rs.next()) {
	                return rs.getString("pagamentoPedido");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return "pendente";
	    }

}