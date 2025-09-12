<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Model.Vendas"%>
<%@ page import="Model.ItensVenda"%>
<%@ page import="DAO.VendasDAO"%>
<%@ page import="Model.Produtos"%>
<%@ page import="DAO.ProdutosDAO"%>

<%
String empresa = (String) session.getAttribute("empresa");
if (empresa == null || empresa.isEmpty()) {
    throw new RuntimeException("O nome da empresa não está definido na sessão.");
}

List<Vendas> lista;
VendasDAO Vdao = new VendasDAO(empresa);
lista = Vdao.listarVendasdoDia();

// Obtém a lista de itens da venda
List<ItensVenda> itensVendaList2 = (List<ItensVenda>) request.getAttribute("tableRows");

int vendaID = -1; // Inicializa com valor inválido
if (itensVendaList2 != null && !itensVendaList2.isEmpty()) {
    vendaID = itensVendaList2.get(0).getVenda().getId(); // Obtém o primeiro ID de venda
}
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <title>Detalhe Venda</title>
    <link rel="icon" href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

    <%@ include file="menu.jsp"%>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-6">
                <div class="table-container">
                    <table id="VendaDiaria" class="table table-dark table-striped table-hover">
                        <thead>
                            <tr>
                               		
                                <th>Descrição</th>
                                <th>Quantidade</th>
                                <th>Preço</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            List<ItensVenda> itensVendaList = (List<ItensVenda>) request.getAttribute("tableRows");
                            if (itensVendaList != null) {
                                for (ItensVenda item : itensVendaList) { %>
                                    <tr>
                                       
                                        <td><%= item.getProduto().getDescricao() %></td>
                                        <td><%= item.getQtd() %></td>
                                        <td><%= item.getProduto().getPreco_de_venda() %></td>
                                        <td><%= item.getSubtotal() %></td>
                                    </tr>
                            <%  }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- ✅ Botão de Imprimir Comprovante Fora da Tabela -->
        <div class="mt-3">
            <a href="Home.jsp" class="btn btn-danger">Voltar</a>
            
            <% if (vendaID != -1) { %>
                <button type="button" class="btn btn-warning" onclick="abrirRelatorio(<%= vendaID %>)">
                    
                     Imprimir Comprovante da Venda
                </button>
            <% } else { %>
                <p style="color: red;">Nenhuma venda selecionada para gerar o comprovante.</p>
            <% } %>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>

    <script>
        function abrirRelatorio(vendaID) {
            if (vendaID !== -1) {
                window.open("compravanteVenda.jsp?vendaID=" + vendaID, "_blank");
            } else {
                alert("Nenhuma venda selecionada.");
            }
        }
    </script>
</body>
</html>
