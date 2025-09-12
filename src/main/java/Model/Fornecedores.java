package Model;

public class Fornecedores extends Clientes {
	public Fornecedores() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Fornecedores(int id, String nome, String rg, String cpf, String email, String telefone, String celular,
			String cep, String endereco, int numero, String complemento, String bairro, String cidade, String uf) {
		super(id, nome, rg, cpf, email, telefone, celular, cep, endereco, numero, complemento, bairro, cidade, uf);
		// TODO Auto-generated constructor stub
	}

	public Fornecedores(String cnpj) {
		super();
		this.cnpj = cnpj;

	}
	private String cnpj;
	 private boolean modoEdicao;

    //atributos//
 public String getCnpj() {
     return cnpj;
 }

 //gets e stter/
 public void setCnpj(String cnpj) {
     this.cnpj = cnpj;
 }
 @Override
 public String toString(){
  return this.getNome();

 }
 public boolean isModoEdicao() {
     return modoEdicao;
 }
 public void setModoEdicao(boolean modoEdicao) {
     this.modoEdicao = modoEdicao;
 }


}