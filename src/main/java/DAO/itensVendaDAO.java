package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Conexao.ConectionDataBases;
import Model.ItensVenda;
import Model.Produtos;
import Model.Vendas;

public class itensVendaDAO {
	private Connection con;
	 private ConectionDataBases connectionFactory;

    public itensVendaDAO(String dataBaseNames) throws ClassNotFoundException {
    	  // Inicialize a conexão com o banco de dados
        this.connectionFactory = new ConectionDataBases(dataBaseNames);
        try {
            this.con = connectionFactory.getConectionDataBases();
        } catch (SQLException e) {
            e.printStackTrace(); // Trate a exceção conforme necessário
        }

    }

    // Metodo que Cadastra Itens //
    public void cadastraItem(ItensVenda obj) {
        try {

            String sql = "insert into tb_itensvendas(venda_id,produto_id,qtd,subtotal)values(?,?,?,?)";
            PreparedStatement stmt = con.prepareStatement(sql);

            stmt.setInt(1, obj.getVenda().getId());
            stmt.setInt(2, obj.getProduto().getId());
            stmt.setInt(3, obj.getQtd());
            stmt.setDouble(4, obj.getSubtotal());


            stmt.execute();

            stmt.close();

        } catch (Exception erro) {

        }

    }

    //Metodo que lista vendidos de uma venda em detalhes //
    public List<ItensVenda> listarItensPorVendao(int venda_id) {
        try {

            //1 passo criar lista de Vendas//
            List<ItensVenda> lista = new ArrayList<>();

            String sql = "select i.id, i.venda_id, p.descricao, i.qtd, p.preco_de_venda, i.subtotal from tb_itensvendas as i"
                    + " inner join tb_produtos as p on(i.produto_id = p.id)"
                    + " inner join tb_vendas   as v on (v.id = i.venda_id) where i.venda_id = ?";

            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, venda_id);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
            	Vendas vendas = new Vendas();
            	ItensVenda item = new ItensVenda();
                Produtos prod =  new Produtos();

                item.setId(rs.getInt("i.id"));
                vendas.setId(rs.getInt("i.venda_id"));
                prod.setDescricao(rs.getString("p.descricao"));
                item.setQtd(rs.getInt("i.qtd"));
                prod.setPreco_de_venda(rs.getDouble("p.preco_de_venda"));
                item.setSubtotal(rs.getDouble("i.subtotal"));


                item.setProduto(prod);
                item.setVenda(vendas);

                lista.add(item);

            }

            return lista;

        } catch (SQLException erro) {
        	System.out.println("erro"+erro);
            return null;


        }

    }
}