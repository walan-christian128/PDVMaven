package Model;

public class ItemCarrinho {
    private Produtos produto;
    private int quantidade;
    private double subtotal; // Subtotal deste item (quantidade * preco_de_venda do produto)

    public ItemCarrinho(Produtos produto, int quantidade) {
        this.produto = produto;
        this.quantidade = quantidade;
        // Calcula o subtotal do item no construtor
        if (produto != null) {
            this.subtotal = produto.getPreco_de_venda() * quantidade;
        } else {
            this.subtotal = 0.0;
        }
    }

    // --- Getters ---
    public Produtos getProduto() {
        return produto;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public double getSubtotal() {
        return subtotal;
    }

    // --- Setters (para atualizar quantidade e recalcular subtotal) ---
    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
        // Recalcula o subtotal ao mudar a quantidade
        if (this.produto != null) {
            this.subtotal = this.produto.getPreco_de_venda() * quantidade;
        }
    }
}