<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Fornecedores"%>
<%@ page import="DAO.FornecedoresDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Model.Produtos"%>
<%@ page import="DAO.ProdutosDAO"%>
<%@ page import="Model.Vendas"%>
<%@ page import="DAO.VendasDAO"%>

<%
    String empresa = (String) session.getAttribute("empresa");
    if (empresa == null || empresa.isEmpty()) {
        RequestDispatcher rd = request.getRequestDispatcher("LoginExpirado.jsp");
        rd.forward(request, response);
        return;
    }

    FornecedoresDAO fornecedoresDao = new FornecedoresDAO(empresa);
    List<Fornecedores> listaFornecedores = fornecedoresDao.listaFornecedores();

    ProdutosDAO produtosDao = new ProdutosDAO(empresa);
    List<Produtos> listaProdutos = produtosDao.listarProdutos();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <title>Gerenciamento de Produtos</title>
    <link rel="icon" href="img/2992655_click_computer_currency_dollar_money_icon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg');
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            width: 100vw;
            background-attachment: fixed;
            color: #f8f9fa;
        }
        .container-fluid { padding-top: 20px; padding-bottom: 20px; }
        .table-dark { background-color: rgba(33, 37, 41, 0.8); }
        .form-container {
            background-color: rgba(33, 37, 41, 0.9);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }
    </style>
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

    <%@ include file="menu.jsp"%>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-7 mb-4">
                <h2 class="mb-3 text-center">Lista de Produtos</h2>
                <div id="table-container" class="overflow-auto" style="max-height: 500px;">
                    <table id="tabela" class="table table-dark table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Descrição</th>
                                <th>Qtd</th>
                                <th>Preço Compra</th>
                                <th>Preço Venda</th>
                                <th>Status</th>
                                <th>Fornecedor</th>
                                <th>Opções</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listaProdutos != null && !listaProdutos.isEmpty()) { 
                                for (Produtos p : listaProdutos) { %>
                                <tr id="row<%=p.getId()%>">
                                    <td><%=p.getId()%></td>
                                    <td><%=p.getDescricao()%></td>
                                    <td><%=p.getQtd_estoque()%></td>
                                    <td><%= String.format("R$ %.2f", p.getPreco_de_compra()) %></td>
                                    <td><%= String.format("R$ %.2f", p.getPreco_de_venda()) %></td>
                                    <td><%= p.getStatus() %></td>
                                    <td>
                                        <% 
                                            // Verificação segura de fornecedor nulo na listagem
                                            if (p.getFornecedor() != null && p.getFornecedor().getId() > 0) {
                                                boolean encontrou = false;
                                                for (Fornecedores f : listaFornecedores) {
                                                    if (f.getId() == p.getFornecedor().getId()) {
                                                        out.print(f.getNome());
                                                        encontrou = true;
                                                        break;
                                                    }
                                                }
                                                if(!encontrou) out.print("<span class='text-muted'>Não encontrado</span>");
                                            } else {
                                                out.print("<span class='badge bg-secondary'>Sem Fornecedor</span>");
                                            }
                                        %>
                                    </td>
                                    <td>
                                        <a href="select?id=<%=p.getId()%>" class="btn btn-success btn-sm">Editar</a>
                                        <a href="delete?id=<%=p.getId()%>" class="btn btn-danger btn-sm">Apagar</a>
                                    </td>
                                </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col-md-5 mb-4">
                <div id="form-container" class="form-container">
                    <form name="cadastrarProduto" action="insert" enctype="multipart/form-data" method="post">
                        <h2 class="mb-4 text-center text-white">Cadastro de Produtos</h2>

                        <div class="mb-3">
                            <label for="descricao" class="form-label text-white">Descrição:</label>
                            <input type="text" id="descricao" class="form-control" name="descricao" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="quantidade" class="form-label text-white">Estoque:</label>
                                <input type="number" id="quantidade" class="form-control" name="qtd_estoque" min="0" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label text-white">Disponível?</label>
                                <select id="status" name="status" class="form-select">
                                    <option value="ativado">Sim</option>
                                    <option value="desativado">Não</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="preco_compra" class="form-label text-white">Preço Compra:</label>
                                <input type="text" id="preco_compra" class="form-control" name="preco_de_compra" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="preco_venda" class="form-label text-white">Preço Venda:</label>
                                <input type="text" id="preco_venda" class="form-control" name="preco_de_venda" required>
                            </div>
                        </div>

                        <div class="mb-3 form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="checkFornecedor">
                            <label class="form-check-label text-white" for="checkFornecedor">Vincular um Fornecedor?</label>
                        </div>

                        <div class="mb-3" id="divFornecedor" style="display: none;">
                            <label for="fornecedor" class="form-label text-white">Fornecedor:</label>
                            <select name="for_id" class="form-select" id="fornecedor">
                                <option value="" selected>Selecione o fornecedor</option>
                                <% for (Fornecedores f : listaFornecedores) { %>
                                    <option value="<%= f.getId() %>"><%= f.getNome() %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="logo" class="form-label text-white">Imagem do Produto:</label>
                            <input type="file" class="form-control" id="logo" name="logo" accept="image/*">
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Cadastrar Produto</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>

    <script>
        $(document).ready(function(){
            // DataTables
            $('#tabela').DataTable({
                "language": { "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/pt-BR.json" }
            });

            // Máscaras
            $('#preco_compra, #preco_venda').mask('000.000.000.000.000,00', {reverse: true});

            // Lógica para mostrar/esconder campo fornecedor
            $('#checkFornecedor').on('change', function() {
                if ($(this).is(':checked')) {
                    $('#divFornecedor').slideDown(); // Abre a gaveta
                } else {
                    $('#divFornecedor').slideUp();   // Fecha a gaveta
                    $('#fornecedor').val("");        // Reseta o valor para nulo
                }
            });
        });
    </script>
</body>
</html>