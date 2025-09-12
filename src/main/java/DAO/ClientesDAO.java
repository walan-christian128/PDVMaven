package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;
import javax.swing.JOptionPane;

import Conexao.ConectionDataBases;
import Model.Clientes;

/**
 *
 * @author Walan
 */
public class ClientesDAO {

    private Connection con;
    private ConectionDataBases connectionFactory;

    public ClientesDAO(String dataBaseNames) throws ClassNotFoundException, NamingException {
    	 // Inicialize a conexão com o banco de dados
        this.connectionFactory = new ConectionDataBases(dataBaseNames);
        try {
            this.con = connectionFactory.getConectionDataBases();
        } catch (SQLException e) {
            e.printStackTrace(); // Trate a exceção conforme necessário
        }
    }

    //Metodo consultar Cliente//
    public Clientes consultarClientes(String nome) {
        try {
            String sql = "select*from tb_clientes where nome like ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, nome);


            ResultSet rs = stmt.executeQuery();
            Clientes obj = new Clientes();

            if (rs.next()) {

                obj.setId(rs.getInt("id"));
                obj.setNome(rs.getString("nome"));
                obj.setRg(rs.getString("rg"));
                obj.setCpf(rs.getString("cpf"));
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
            JOptionPane.showMessageDialog(null, "CLIENTE NÃO ENCONTRADO" + erro);
            return null;
        }
    }



     public Clientes consultarClientesPorcpf(String cpf) {
        try {
            String sql = "select*from tb_clientes where cpf like ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, cpf);


            ResultSet rs = stmt.executeQuery();
            Clientes obj = new Clientes();

            if (rs.next()) {

                obj.setId(rs.getInt("id"));
                obj.setNome(rs.getString("nome"));
                obj.setRg(rs.getString("rg"));
                obj.setCpf(rs.getString("cpf"));
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

            return null;
        }
    }

    //Metodo cadaastra Cliente//
    public void cadastrarCliente(Clientes obj) {
        //comendo SQL//
        try {
            String sql = "INSERT INTO tb_clientes(nome,rg,cpf,email,telefone,celular,cep,endereco,numero,complemento,bairro,cidade,estado)"
                    + "                    VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
            //Organização SQL e Conexão //
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, obj.getNome());
            stmt.setString(2, obj.getRg());
            stmt.setString(3, obj.getCpf());
            stmt.setString(4, obj.getEmail());
            stmt.setString(5, obj.getTelefone());
            stmt.setString(6, obj.getCelular());
            stmt.setString(7, obj.getCep());
            stmt.setString(8, obj.getEndereco());
            stmt.setInt(9, obj.getNumero());
            stmt.setString(10, obj.getComplemento());
            stmt.setString(11, obj.getBairro());
            stmt.setString(12, obj.getCidade());
            stmt.setString(13, obj.getUf());

            //Execução//
            stmt.execute();
            stmt.close();



        } catch (SQLException erro) {

        }

    }

    //Metodo Alterar Cliente//
    public void alterarCliente(Clientes obj) {
        try {
            String sql = "UPDATE tb_clientes set nome=?,rg=?,cpf=?,email=?,telefone=?,celular=?,cep=?"
                    + ",endereco=?,numero=?,complemento=?,bairro=?,cidade=?,estado=? WHERE ID=?";

            //Organização SQL e Conexão //
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, obj.getNome());
            stmt.setString(2, obj.getRg());
            stmt.setString(3, obj.getCpf());
            stmt.setString(4, obj.getEmail());
            stmt.setString(5, obj.getTelefone());
            stmt.setString(6, obj.getCelular());
            stmt.setString(7, obj.getCep());
            stmt.setString(8, obj.getEndereco());
            stmt.setInt(9, obj.getNumero());
            stmt.setString(10, obj.getComplemento());
            stmt.setString(11, obj.getBairro());
            stmt.setString(12, obj.getCidade());
            stmt.setString(13, obj.getUf());
            stmt.setInt(14, obj.getId());

            //Execução//
            stmt.executeUpdate();
            stmt.close();



        } catch (SQLException erro) {
        	 erro.printStackTrace();

        }
    }
    //Metodo Ecluir Cliente//

    public void excluirCliente(Clientes obj) {
        try {
            String sql = "DELETE FROM tb_clientes where id = ?";
            //Organização SQL e Conexão //
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, obj.getId());

            //Execução//
            stmt.execute();
            stmt.close();



        } catch (SQLException erro) {

        }

    }

    // Listar Clinetes - retorna uma lista //
    public List<Clientes> listaClientes() {
        try {
            List<Clientes> lista = new ArrayList<>();

            //criando sql//
            String sql = "SELECT * FROM tb_clientes";
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Clientes obj = new Clientes();
                obj.setId(rs.getInt("id"));
                obj.setNome(rs.getString("nome"));
                obj.setRg(rs.getString("rg"));
                obj.setCpf(rs.getString("cpf"));
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
//Metodo Buscar Cliente Por Nome//

    public List<Clientes> BuscarClientePorNome(String nome) {
        try {
            List<Clientes> lista = new ArrayList<>();

            //criando sql//
            String sql = "SELECT * FROM tb_clientes WHERE nome LIKE ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, "%" + nome + "%" );
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Clientes obj = new Clientes();
                obj.setId(rs.getInt("id"));
                obj.setNome(rs.getString("nome"));
                obj.setRg(rs.getString("rg"));
                obj.setCpf(rs.getString("cpf"));
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
    public void modalClientes(Clientes obj) {
        try {


            //criando sql//
            String sql = "SELECT * FROM tb_clientes where id = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, obj.getId());
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {

                obj.setId(rs.getInt("id"));
                obj.setNome(rs.getString("nome"));
                obj.setRg(rs.getString("rg"));
                obj.setCpf(rs.getString("cpf"));
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
    }







}