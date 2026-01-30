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

FornecedoresDAO dao = new FornecedoresDAO(empresa);
List<Fornecedores> lista = dao.listaFornecedores();

// Captura se o produto já tem um fornecedor vinculado
Object forIdObj = request.getAttribute("for_id");
boolean temFornecedor = (forIdObj != null && !forIdObj.toString().isEmpty());
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Editar Produto</title>
    <link rel="icon" href="img/2992655_click_computer_currency_dollar_money_icon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body {
            background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: #f8f9fa;
        }
        .form-container {
            background-color: rgba(33, 37, 41, 0.9);
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 50px;
        }
    </style>
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

<%@ include file="menu.jsp"%>

<div class="container mt-4">
    <div class="form-container">
        <form name="editar" action="updateProduto" method="post" enctype="multipart/form-data">
            <h2 class="mb-4">Editar Produto</h2>

            <div class="row">
                <div class="col-md-2 mb-3">
                    <label for="id" class="form-label text-white">Código:</label>
                    <input type="text" class="form-control" name="id" id="id" readonly value="<%= request.getAttribute("id") %>">
                </div>
                <div class="col-md-10 mb-3">
                    <label for="descricao" class="form-label text-white">Descrição:</label>
                    <input type="text" class="form-control" id="descricao" name="descricao" value="<%= request.getAttribute("descricao") %>" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4 mb-3">
                    <label for="quantidade" class="form-label text-white">Estoque:</label>
                    <input type="number" class="form-control" id="quantidade" name="qtd_estoque" value="<%= request.getAttribute("qtd_estoque") %>" required>
                </div>
					<div class="col-md-4 mb-3">
						<label for="preco_compra" class="form-label text-white">Preço
							Compra:</label> <input type="text" class="form-control money"
							id="preco_compra" name="preco_de_compra"
							value="<%=String.format("%.2f", request.getAttribute("preco_de_compra")).replace(".", ",")%>"
							required>
					</div>
					<div class="col-md-4 mb-3">
						<label for="preco_venda" class="form-label text-white">Preço
							Venda:</label> <input type="text" class="form-control money"
							id="preco_venda" name="preco_de_venda"
							value="<%=String.format("%.2f", request.getAttribute("preco_de_venda")).replace(".", ",")%>"
							required>
					</div>
				</div>

            <div class="row align-items-center">
                <div class="col-md-4 mb-3">
                    <label for="status" class="form-label text-white">Disponível?</label>
                    <select id="status" name="status" class="form-select">
                        <% String currentStatus = (String) request.getAttribute("status"); %>
                        <option value="ativado" <%="ativado".equals(currentStatus) ? "selected" : ""%>>Sim</option>
                        <option value="destivado" <%="destivado".equals(currentStatus) ? "selected" : ""%>>Não</option>
                    </select>
                </div>

                <div class="col-md-8 mb-3">
                    <div class="form-check form-switch mt-4">
                        <input class="form-check-input" type="checkbox" id="checkFornecedor" <%= temFornecedor ? "checked" : "" %>>
                        <label class="form-check-label text-white" for="checkFornecedor">Este produto possui fornecedor?</label>
                    </div>
                </div>
            </div>

            <div class="mb-3" id="divFornecedor" style="<%= temFornecedor ? "" : "display: none;" %>">
                <label for="fornecedor" class="form-label text-white">Fornecedor:</label>
                <select name="for_id" class="form-select" id="fornecedor">
                    <option value="">Selecione o fornecedor</option>
                    <%
                    String forIdAttribute = String.valueOf(request.getAttribute("for_id"));
                    for (Fornecedores fornecedor : lista) {
                        String fId = String.valueOf(fornecedor.getId());
                        // Comparamos IDs para marcar o selecionado
                        boolean isSelected = fId.equals(forIdAttribute);
                    %>
                        <option value="<%= fId %>" <%= isSelected ? "selected" : "" %>>
                            <%= fornecedor.getNome() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="mb-4">
                <label for="logo" class="form-label text-white">Imagem do Produto:</label>
                <input type="file" class="form-control" id="logo" name="logo" accept="image/*">
                <% if (request.getAttribute("id") != null) { %>
                    <div class="mt-2 p-2 bg-white rounded d-inline-block">
                        <img src="exibirImagemProduto?id=<%=request.getAttribute("id")%>" alt="Imagem atual" style="max-height: 100px;">
                    </div>
                <% } %>
            </div>

            <button type="button" class="btn btn-primary btn-lg w-100" data-bs-toggle="modal" data-bs-target="#EditarProduto">
                Salvar Alterações
            </button>

            <div class="modal fade text-dark" id="EditarProduto" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Confirmar Edição</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p>Deseja realmente salvar as alterações deste produto?</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Salvar</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>

<script>
    $(document).ready(function(){
        // Máscaras
        $('#preco_compra, #preco_venda').mask('000.000.000.000.000,00', {reverse: true});

        // Controle do Toggle de Fornecedor
        $('#checkFornecedor').on('change', function() {
            if ($(this).is(':checked')) {
                $('#divFornecedor').slideDown();
            } else {
                $('#divFornecedor').slideUp();
                $('#fornecedor').val(""); // Limpa o ID para enviar nulo no update
            }
        });
    });
</script>
</body>
</html>