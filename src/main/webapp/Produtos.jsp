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
    // --- Bloco de Lógica Java para Preparação de Dados ---
    // Verificação de sessão para segurança e redirecionamento
    String empresa = (String) session.getAttribute("empresa");
    if (empresa == null || empresa.isEmpty()) {
        RequestDispatcher rd = request.getRequestDispatcher("LoginExpirado.jsp");
        rd.forward(request, response);
        return; // Garante que o código pare de executar após o redirecionamento
    }

    // Carregamento da lista de Fornecedores para o select do formulário e para exibição na tabela
    List<Fornecedores> listaFornecedores;
    FornecedoresDAO fornecedoresDao = new FornecedoresDAO(empresa);
    listaFornecedores = fornecedoresDao.listaFornecedores();

    // Carregamento da lista de Produtos para exibição na tabela
    List<Produtos> listaProdutos;
    ProdutosDAO produtosDao = new ProdutosDAO(empresa);
    listaProdutos = produtosDao.listarProdutos();

    // Instância de Produtos (pode ser útil para preenchimento de formulário em caso de edição,
    // mas para cadastro puro, pode ser dispensada aqui)
    Produtos produto = new Produtos();

    // Instância de Vendas e lista de Vendas do Dia (Mantenho se houver uso futuro nesta JSP,
    // caso contrário, podem ser removidas para otimização)
    Vendas venda = new Vendas();
    List<Vendas> listaVendasDoDia;
    VendasDAO vendasDao = new VendasDAO(empresa);
    listaVendasDoDia = vendasDao.listarVendasdoDia(); // Carrega vendas do dia
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
            background-size: cover; /* Ajusta a imagem para cobrir todo o corpo */
            background-position: center;
            margin: 0;
            padding: 0;
            min-height: 100vh; /* Garante que o background cubra toda a altura */
            width: 100vw;
            background-attachment: fixed; /* Fixa a imagem de fundo para que não role com o conteúdo */
            color: #f8f9fa; /* Cor do texto padrão para contraste com o fundo escuro */
        }
        .container-fluid {
            padding-top: 20px; /* Espaçamento superior */
            padding-bottom: 20px; /* Espaçamento inferior */
        }
        .table-dark {
            background-color: rgba(33, 37, 41, 0.8); /* Fundo da tabela com transparência para o background aparecer */
        }
        .form-container {
            background-color: rgba(33, 37, 41, 0.9); /* Fundo do formulário com mais transparência */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }
        label.form-label {
            color: #f8f9fa; /* Cor das labels do formulário */
        }
        h2 {
            color: #f8f9fa; /* Cor dos títulos */
        }
    </style>
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

    <%-- Inclui o menu de navegação --%>
    <%@ include file="menu.jsp"%>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-7 mb-4"> <%-- Usando col-md-7 para a tabela ocupar um pouco mais de espaço --%>
                <h2 class="mb-3 text-center">Lista de Produtos</h2>
                <div id="table-container" class="overflow-auto" style="max-height: 500px;">
                    <table id="tabela" class="table table-dark table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Descrição</th>
                                <th>Quantidade</th>
                                <th>Preço Compra</th>
                                <th>Preço Venda</th>
                                <th>Margem</th>
                                <th>Status Para Venda </th>
                                <th>Fornecedor</th>
                                <th>Opções</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listaProdutos != null && !listaProdutos.isEmpty()) { %>
                                <% for (int i = 0; i < listaProdutos.size(); i++) { %>
                                <tr id="row<%=listaProdutos.get(i).getId()%>" class="linha-editar" data-id="<%=listaProdutos.get(i).getId()%>">
                                    <td><%=listaProdutos.get(i).getId()%></td>
                                    <td><%=listaProdutos.get(i).getDescricao()%></td>
                                    <td><%=listaProdutos.get(i).getQtd_estoque()%></td>
                                    <td><%= String.format("R$ %.2f", listaProdutos.get(i).getPreco_de_compra()) %></td>
                                    <td><%= String.format("R$ %.2f", listaProdutos.get(i).getPreco_de_venda()) %></td>
                                    <td>
                                        <script>
                                            var precoCompra = <%= listaProdutos.get(i).getPreco_de_compra() %>;
                                            var precoVenda = <%= listaProdutos.get(i).getPreco_de_venda() %>;
                                            if (precoCompra > 0) {
                                                var porcentagem = ((precoVenda - precoCompra) / precoCompra) * 100;
                                                document.write(porcentagem.toFixed(2) + '%');
                                            } else {
                                                document.write('N/A');
                                            }
                                        </script>
                                    </td>
                                    <td><%=listaProdutos.get(i).getStatus() %></td>
                                    <td>
                                        <% for (Fornecedores fornecedorNaLista : listaFornecedores) {
                                            if (fornecedorNaLista.getId() == listaProdutos.get(i).getFornecedor().getId()) { %>
                                            <%=fornecedorNaLista.getNome()%>
                                        <% break; /* Otimização: sair do loop assim que encontrar o fornecedor */ } } %>
                                    </td>
                                    <td>
                                        <a href="select?id=<%=listaProdutos.get(i).getId()%>" class="btn btn-success btn-sm">Editar</a>
                                        <a href="delete?id=<%=listaProdutos.get(i).getId()%>" class="btn btn-danger btn-sm">Apagar</a>
                                    </td>
                                </tr>
                                <% } %>
                            <% } else { %>
                                <tr><td colspan="8" class="text-center">Nenhum produto cadastrado.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col-md-5 mb-4"> <%-- Usando col-md-5 para o formulário ocupar o restante do espaço --%>
                <div id="form-container" class="form-container">
                    <form name="cadastrarProduto" action="insert" enctype="multipart/form-data" method="post">
                        <h2 class="mb-4 text-center text-white">Cadastro de Produtos</h2>

                        <div class="mb-3">
                            <label for="descricao" class="form-label">Descrição:</label>
                            <input type="text" id="descricao" class="form-control" name="descricao" required>
                        </div>

                        <div class="mb-3">
                            <label for="quantidade" class="form-label">Quantidade em Estoque:</label>
                            <input type="number" id="quantidade" class="form-control" name="qtd_estoque" min="0" required>
                        </div>

                        <div class="mb-3">
                            <label for="preco_compra" class="form-label">Preço de Compra:</label>
                            <input type="text" id="preco_compra" class="form-control" name="preco_de_compra" required>
                        </div>

                        <div class="mb-3">
                            <label for="preco_venda" class="form-label">Preço de Venda:</label>
                            <input type="number" step="0.01" class="form-control" id="preco_venda" name="preco_de_venda">
                        </div>
						<div class="col-md-4">
							<div class="mb-3">
								<label for="status" class="form-label text-white">Disponivel
									para venda?</label> <select id="status" name="status"
									class="form-select">
									<option value="ativado">Sim</option>
									<option value="destivado">Não</option>
								</select>
							</div>
						</div>

						<div class="mb-3">
                            <label for="fornecedor" class="form-label">Fornecedor:</label>
                            <select name="for_id" class="form-select" id="fornecedor">
                                <option value="" selected>Selecione o fornecedor</option>
                                <%
                                    String selectedFornecedorId = request.getParameter("for_id");
                                    if (selectedFornecedorId == null) {
                                        selectedFornecedorId = (String) request.getAttribute("for_id");
                                    }

                                    for (Fornecedores fornecedor : listaFornecedores) {
                                        int fornecedorId = fornecedor.getId();
                                        String nomeFornecedorAtual = fornecedor.getNome();
                                        boolean isSelected = false;
                                        if (selectedFornecedorId != null) {
                                            try {
                                                if (Integer.parseInt(selectedFornecedorId) == fornecedorId) {
                                                    isSelected = true;
                                                }
                                            } catch (NumberFormatException e) {
                                                // Ignora se o valor não for um número válido
                                            }
                                        }
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
                            <label for="logo" class="form-label">Imagem do Produto:</label>
                            <input type="file" class="form-control" id="logo" name="logo" accept="image/*">
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Cadastrar Produto</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script>
    <script src="scripts/buscaProduto.js"></script>
    <script>
        $(document).ready(function(){
            // Inicialização do DataTables
            $('#tabela').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/pt-BR.json"
                },
                "paging": true,
                "searching": true,
                "ordering": true,
                "info": true
            });

            // Aplica máscaras monetárias
            $('#preco_compra').mask('000.000.000.000.000,00', {reverse: true});
            $('#preco_venda').mask('000.000.000.000.000,00', {reverse: true});
        });
    </script>
</body>
</html>