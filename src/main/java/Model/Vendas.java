package Model;

import java.math.BigDecimal;

public class Vendas {

    //atributos//
    private int id;
    private Clientes cliente;
    private String data_venda;
    private double total_venda;
    private String obs;
    private double desconto;
    private String formaPagamento;
    private Usuario usuario;
    public String getExternalReference() {
		return ExternalReference;
	}

	public void setExternalReference(String externalReference) {
		ExternalReference = externalReference;
	}

	public BigDecimal getPgTotalOnline() {
		return pgTotalOnline;
	}

	public void setPgTotalOnline(BigDecimal pgTotalOnline) {
		this.pgTotalOnline = pgTotalOnline;
	}

	public String getSetStatusVenda() {
		return setStatusVenda;
	}

	public void setSetStatusVenda(String setStatusVenda) {
		this.setStatusVenda = setStatusVenda;
	}

	private String  ExternalReference;
    private BigDecimal pgTotalOnline;
    private String setStatusVenda;

    public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public String getFormaPagamento() {
		return formaPagamento;
	}

	public String getformaPagamento() {
        return formaPagamento;
    }

    public void setFormaPagamento(String formaPagamento) {
        this.formaPagamento = formaPagamento;
    }



    public double getDesconto() {
        return desconto;
    }

    public void setDesconto(double desconto) {
        this.desconto = desconto;
    }

    //getrs e setrss//

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Clientes getCliente() {
        return cliente;
    }

    public void setCliente(Clientes cliente) {
        this.cliente = cliente;
    }

    public String getData_venda() {
        return data_venda;
    }

    public void setData_venda(String data_venda) {
        this.data_venda = data_venda;
    }

    public double getTotal_venda() {
        return total_venda;
    }

    public void setTotal_venda(double total_venda) {
        this.total_venda = total_venda;
    }

    public String getObs() {
        return obs;
    }

    public void setObs(String obs) {
        this.obs = obs;
    }


}