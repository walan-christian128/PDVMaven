package Model;

public class Produtos {
	    private int id;
	    private String descricao;
	    private int qtd_estoque;
	    private Fornecedores fornecedor;
	    private double preco_de_compra;
	    private String status;
	    public String getStatus() {
			return status;
		}

		public void setStatus(String status) {
			this.status = status;
		}
		private byte[]imagem;




		public byte[] getImagem() {
			return imagem;
		}

		public void setImagem(byte[] imagem) {
			this.imagem = imagem;
		}

		public int getId() {
	        return id;
	    }

	    public void setId(int id) {
	        this.id = id;
	    }

	    public String getDescricao() {
	        return descricao;
	    }

	    public void setDescricao(String descricao) {
	        this.descricao = descricao;
	    }

	    public int getQtd_estoque() {
	        return qtd_estoque;
	    }

	    public void setQtd_estoque(int qtd_estoque) {
	        this.qtd_estoque = qtd_estoque;
	    }

	    public Fornecedores getFornecedor() {
	        return fornecedor;
	    }

	    public void setFornecedor(Fornecedores fornecedor) {
	        this.fornecedor = fornecedor;


	    }

	    public double getPreco_de_compra() {
	        return preco_de_compra;
	    }

	    public void setPreco_de_compra(double preco_de_compra) {
	        this.preco_de_compra = preco_de_compra;
	    }

	    public double getPreco_de_venda() {
	        return preco_de_venda;
	    }

	    public void setPreco_de_venda(double preco_de_venda) {
	        this.preco_de_venda = preco_de_venda;
	    }
	    private double preco_de_venda;

		public Produtos(int id, String descricao, int qtd_estoque, Fornecedores fornecedor, double preco_de_compra,
				double preco_de_venda) {
			super();
			this.id = id;
			this.descricao = descricao;
			this.qtd_estoque = qtd_estoque;
			this.fornecedor = fornecedor;
			this.preco_de_compra = preco_de_compra;
			this.preco_de_venda = preco_de_venda;
		}

		public Produtos() {
			super();
			// TODO Auto-generated constructor stub
		}

}