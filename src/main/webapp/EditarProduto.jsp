<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Fornecedores"%>
<%@ page import="DAO.FornecedoresDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="Model.Produtos"%>
<%@ page import="DAO.ProdutosDAO"%>

<%
String empresa = (String) session.getAttribute("empresa");
if (empresa == null || empresa.isEmpty()) {
    throw new RuntimeException("O nome da empresa não está definido na sessão.");
}
List<Fornecedores> lista;
FornecedoresDAO dao = new FornecedoresDAO(empresa);
lista = dao.listaFornecedores();
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Editar Produto</title>
    <link rel="icon" href="img/2992655_click_computer_currency_dollar_money_icon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
          crossorigin="anonymous">
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

<%@ include file="menu.jsp"%>

<div class="container mt-4">
    <form name="editar" action="updateProduto" method="post" enctype="multipart/form-data">
        <h2>Editar Produto</h2>

        <div class="mb-3">
            <label for="id" class="form-label">Código do Produto:</label>
            <input type="text" class="form-control" name="id" id="id" readonly="readonly"
                   value="<%= request.getAttribute("id") %>">
        </div>

        <div class="mb-3">
            <label for="descricao" class="form-label">Descrição:</label>
            <input type="text" class="form-control" id="descricao" name="descricao"
                   value="<%= request.getAttribute("descricao") %>" required>
        </div>

        <div class="mb-3">
            <label for="quantidade" class="form-label">Quantidade em Estoque:</label>
            <input type="text" class="form-control" id="quantidade" name="qtd_estoque"
                   value="<%= request.getAttribute("qtd_estoque") %>" required>
        </div>

        <div class="mb-3">
            <label for="preco_compra" class="form-label">Preço de Compra:</label>
            <input type="text" class="form-control" id="preco_compra" name="preco_de_compra"
                   value="<%= request.getAttribute("preco_de_compra") %>" required>
        </div>

        <div class="mb-3">
            <label for="preco_venda" class="form-label">Preço de Venda:</label>
            <input type="text" class="form-control" id="preco_venda" name="preco_de_venda"
                   value="<%= request.getAttribute("preco_de_venda") %>" required>
        </div>

			<div class="col-md-4">
				<div class="mb-3">
					<label for="status" class="form-label text-white">Disponivel
						para venda?</label> <select id="status" name="status" class="form-select">
						<%
						String currentStatus = (String) request.getAttribute("status");
						%>
						<option value="ativado"
							<%="ativado".equals(currentStatus) ? "selected" : ""%>>Sim</option>
						<option value="destivado"
							<%="destivado".equals(currentStatus) ? "selected" : ""%>>Não</option>
					</select>
				</div>
			</div>

			<div class="mb-3">
            <label for="fornecedor" class="form-label">Fornecedor:</label>
            <select name="for_id" class="form-select" required>
                <option value="" selected>Selecione o fornecedor</option>
                <%
                String forIdAttribute = (String) request.getAttribute("for_id");
                for (Fornecedores fornecedor : lista) {
                    int fornecedorId = fornecedor.getId();
                    String nomeFornecedorAtual = fornecedor.getNome();
                    boolean isSelected = (forIdAttribute != null && nomeFornecedorAtual.equals(forIdAttribute));
                %>
                    <option value="<%= fornecedorId %>" <%= isSelected ? "selected" : "" %>>
                        <%= nomeFornecedorAtual %>
                    </option>
                <%
                }
                %>
            </select>
        </div>

        <div class="mb-3">
            <label for="logo" class="form-label">Imagem:</label>
            <input type="file" class="form-control" id="logo" name="logo" accept="image/*">
            <%
            Object idProduto = request.getAttribute("id");
            if (idProduto != null) {
            %>
                <img src="exibirImagemProduto?id=<%=idProduto%>"
                     alt="Imagem do produto"
                     style="max-width: 200px; margin-top: 10px; border: 1px solid #ccc;">
            <%
            }
            %>
        </div>

        <!-- Botão que abre o modal -->
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#EditarProduto">
            Salvar
        </button>

        <!-- Modal de Confirmação -->
        <div class="modal fade" tabindex="-1" id="EditarProduto">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Editar Produto</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Deseja realmente editar este produto?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Não</button>
                        <button type="submit" class="btn btn-primary">Sim</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script>
</body>
</html>
