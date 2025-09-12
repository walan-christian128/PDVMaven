package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import Conexao.ConectionDataBases;
import Model.Clientepedido;
import Model.PasswordUtil;
import Model.Pedidos;
import Model.Produtos;

public class ClientesPedidosDAO {
	  private Connection con;
	    private ConectionDataBases connectionFactory;

	    public ClientesPedidosDAO(String dataBaseNames) throws ClassNotFoundException, NamingException {
	    	 // Inicialize a conexão com o banco de dados
	        this.connectionFactory = new ConectionDataBases(dataBaseNames);
	        try {
	            this.con = connectionFactory.getConectionDataBases();
	        } catch (SQLException e) {
	            e.printStackTrace(); // Trate a exceção conforme necessário
	        }
	        
	    }
	    
	    public boolean alteraSenha(String senha, String email) {
	        String senhaHashed = PasswordUtil.hashPassword(senha);
	        String sql = "UPDATE tb_cliente_pedido SET senha = ? WHERE email = ?";

	        // Usando try-with-resources para garantir que o PreparedStatement seja fechado automaticamente
	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            stmt.setString(1, senhaHashed);
	            stmt.setString(2, email);

	            // executeUpdate() retorna o número de linhas afetadas.
	            int linhasAfetadas = stmt.executeUpdate();

	            // Se o número de linhas afetadas for maior que 0, a alteração foi bem-sucedida.
	            return linhasAfetadas > 0;

	        } catch (Exception e) {
	            e.printStackTrace();
	            // Se ocorrer uma exceção, a operação falhou.
	            return false;
	        }
	    }
	    public boolean enviarEmailCliente(String email) {
	        String sql = "select * from tb_cliente_pedido where email = ?";
	        boolean clienteEmail = false;

	        try (PreparedStatement stmt = con.prepareStatement(sql)) {
	            // Define o parâmetro **antes** de executar a consulta
	            stmt.setString(1, email);
	            
	            try (ResultSet rs = stmt.executeQuery()) {
	                if (rs.next()) {
	                    clienteEmail = true;
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace(); // É fundamental para depurar
	        }
	        return clienteEmail;
	    }
	   
	    public void Clientepedido(Clientepedido obj) {
	    
	    	String sql = "insert INTO tb_cliente_pedido(nome,telefone,endereco,numero,bairro,cidade,estado,email,senha)value(?,?,?,?,?,?,?,?,?)";
	    	
	    	try {
	    		PreparedStatement stmt = con.prepareStatement(sql);
	    		
	    		stmt.setString(1, obj.getNome());
	    		stmt.setString(2, obj.getTelefone());
	    		stmt.setString(3, obj.getEndereco());
	    		stmt.setInt(4, obj.getNumero());
	    		stmt.setString(5, obj.getBairro());
	    		stmt.setString(6, obj.getCidade());
	    		stmt.setString(7, obj.getUf());
	    		stmt.setString(8, obj.getEmail());
	    		stmt.setString(9, PasswordUtil.hashPassword(obj.getSenha()));
	    		
	    		
	    		stmt.execute();
	    		stmt.close();
	    		
	    		
	    		
			} catch (SQLException erro) {
				// TODO: handle exception
			}
	    	
	    	
	    }
public Clientepedido selecionaClientePedido(int codigo) {
	
	String sql = " select id,nome,telefone,email,endereco,numero,bairro,cidade,estado from tb_cliente_pedido where id = ? ";
	Clientepedido cp = new Clientepedido();
	try {
		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setInt(1, codigo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			
			cp.setId(rs.getInt("id"));
			cp.setNome(rs.getString("nome"));
			cp.setCelular(rs.getString("telefone"));
			cp.setEmail(rs.getString("email"));
			cp.setEndereco(rs.getString("endereco"));
			cp.setNumero(rs.getInt("numero"));
			cp.setBairro(rs.getString("bairro"));
			cp.setCidade(rs.getString("cidade"));
			cp.setUf(rs.getString("estado"));
			
			System.out.println("Nome do cliente no DAO: " + cp.getNome());
			
		}
		return cp;
		
	} catch (Exception e) {
		return null;
	}
	
}

public List<Pedidos> pedidosCliente(int codigo) {

    List<Pedidos> lista = new ArrayList<>();
    String sql = "SELECT id_pedido, "
            + "date_format(data_pedido, '%d/%m/%Y %H:%i:%s') AS data_formatada,"
            + "status,"
            + "observacoes,"
            + "forma_Pagamento,"
            + "total_pedido "
            + "FROM pedidos "
            + "WHERE clientepedido_id = ?";

    try (PreparedStatement stmt = con.prepareStatement(sql)) {
        // Define o valor do parâmetro
        stmt.setInt(1, codigo);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Pedidos ped = new Pedidos();
                ped.setIdPedido(rs.getInt("id_pedido"));
                ped.setDataPeedido(rs.getString("data_formatada"));
                ped.setStatus(rs.getString("status"));
                ped.setObservacoes(rs.getString("observacoes"));
                ped.setTotalPedido(rs.getDouble("total_pedido"));
                // Defina o pagamento aqui, pois ele está no SQL
                ped.setFormapagamento(rs.getString("forma_Pagamento")); 
                lista.add(ped);
            }
        }
    } catch (Exception e) {
        e.printStackTrace(); // É importante imprimir o erro para depuração
    }

    return lista;
}
public void alteraClientePedido(Clientepedido obj) {
	
	String sql = " update tb_cliente_pedido set nome=?,telefone=?,endereco=?,numero=?,bairro=?,cidade=?,estado=?,email=? where id = ? " ;
	
	try {
		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, obj.getNome());
		stmt.setString(2, obj.getCelular());
		stmt.setString(3, obj.getEndereco());
		stmt.setInt(4, obj.getNumero());
		stmt.setString(5, obj.getBairro());
		stmt.setString(6, obj.getCidade());
		stmt.setString(7, obj.getUf());
		stmt.setString(8, obj.getEmail());
		stmt.setInt(9, obj.getId());
		
		stmt.executeUpdate();
		stmt.close();
		
		
	} catch (Exception e) {
		// TODO: handle exception
	}

	
	
}

}
