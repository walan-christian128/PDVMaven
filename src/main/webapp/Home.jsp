<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Model.Vendas"%>
<%@ page import="Model.ItensVenda"%>
<%@ page import="DAO.VendasDAO"%>
<%@ page import="Model.Produtos"%>
<%@ page import="DAO.ProdutosDAO"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<%
String empresa = (String) session.getAttribute("empresa");
if (empresa == null || empresa.isEmpty()) {
    RequestDispatcher rd = request.getRequestDispatcher("LoginExpirou.html");
    rd.forward(request, response);
    return; // Certifique-se de que o código pare de executar após o redirecionamento
}
List<Vendas> lista;
VendasDAO Vdao = new VendasDAO(empresa);
lista = Vdao.listarVendasdoDia();
%>

<%
List<Produtos> prodp; // Declara a lista
ProdutosDAO daop = new ProdutosDAO(empresa);
prodp = daop.listarProdutos(); // Atribui o resultado da busca à lista exibida na tabela
%>

<%
double totalVendasDia = 0;

// Formatar data para yyyy-MM-dd
SimpleDateFormat dataEUA = new SimpleDateFormat("yyyy-MM-dd");
String datamysql = dataEUA.format(new Date());

// Converter a string formatada para LocalDate
DateTimeFormatter formato = DateTimeFormatter.ofPattern("yyyy-MM-dd");
LocalDate data_venda = LocalDate.parse(datamysql, formato);

// Instanciar o DAO e obter o total de vendas
VendasDAO dao = new VendasDAO(empresa);
totalVendasDia = dao.retornaTotalVendaPorDia(data_venda);

// Definir o total de vendas como atributo da requisição
request.setAttribute("totalVendido", totalVendasDia);
%>



<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
<!-- Link para o Bootstrap 5 -->
<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="bootstrap/js/bootstrap.bundle.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Q/jnqA9/ctw53zwTwj9tdG1x8czgkF+4hJbUBt1ZZbPr42N2zrgfmjjM+KAX1nbj" crossorigin="anonymous">
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">
   
	<%@ include file="menu.jsp"%>

	<div class="container mt-4">
		<div class="row">
			<div class="col-md-6">
				<h2>Vendas do Dia</h2>
				<table class="table table-dark table-striped table-hover">
					<thead>
						<tr>
							<th>Código</th>
							<th>Nome</th>
							<th>Data</th>
							<th>Total</th>
							<th>Observações</th>
							<th>Desconto</th>
							<th>Forma De Pagamento</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (lista != null && !lista.isEmpty()) {
							for (int i = 0; i < lista.size(); i++) {
						%>
						<tr id="<%=lista.get(i).getId()%>" class="linha-editar"
							data-id="<%=lista.get(i).getId()%>">
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getId()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getCliente() != null && lista.get(i).getCliente().getNome() != null ? lista.get(i).getCliente().getNome() : "" %></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getData_venda()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getTotal_venda()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getObs()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getDesconto()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getformaPagamento()%></a></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="6">Não há vendas disponíveis na data de hoje.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				
				<div class="mb-3 p-3">
					<label class="form-label">Total Diário Vendido: </label> <input
						type="text" class="form-control bg-dark text-white"
						name="totalVendido"
						value="<%=request.getAttribute("totalVendido") != null ? request.getAttribute("totalVendido").toString() : ""%>"
						aria-label="Sizing example input"
						aria-describedby="inputGroup-sizing-sm">
				</div>
			</div>
			

			<div class="col-md-6">
				<h2>Produtos em Estoque</h2>
				<table class="table table-dark table-striped table-hover">
					<thead>
						<tr>
							<th>Código</th>
							<th>Descrição</th>
							<th>Quantidade</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (prodp != null && !prodp.isEmpty()) {
							for (int i = 0; i < prodp.size(); i++) {
						%>
						<tr id="<%=prodp.get(i).getId()%>" class="linha-editar"
							data-id="<%=prodp.get(i).getId()%>">
							<td><a href="select?id=<%=prodp.get(i).getId()%>"  class="text-white text-decoration-none"><%=prodp.get(i).getId()%></a></td>
							<td><a href="select?id=<%=prodp.get(i).getId()%>"  class="text-white text-decoration-none"><%=prodp.get(i).getDescricao()%></a></td>
							<td><a href="select?id=<%=prodp.get(i).getId()%>"  class="text-white text-decoration-none"><%=prodp.get(i).getQtd_estoque()%></a></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="6">Não há produtos disponíveis no estoque.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
		<div class="col-md-6">
					<input type="text" class="form-control bg-dark text-white"
						name="Usuarionome"
						value="<%
                                // Volte a esperar um objeto Model.Usuario aqui
                                Model.Usuario usuario = (Model.Usuario) session.getAttribute("usuarioNome");
                                if (usuario != null) {
	                                String nomeUsuario = usuario.getNome();
	                                out.println("Usuario : " + nomeUsuario); // Ou out.print(nomeUsuario); dependendo do que você quer no input value
                                } else {
	                                out.println("Usuário não encontrado na sessão.");
                                }
                            %>"
						aria-label="Sizing example input"
						aria-describedby="inputGroup-sizing-sm">
				</div>
			</div>
		</div>
	</div>

	<!-- Link para o Bootstrap 5 JS -->
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz4fnFO9gybP6mFfFFjwB9wdKzRzj6pU1nFJWcXyYn3xU8gD0VYqzZp7O9K" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-cuOtV/3TIq0zEgmMdx4KhD2a6CZIBIc4OS1FtOSY//z5fPiDF1OC5Y+dIRejkKe0" crossorigin="anonymous"></script>
	
</body>

</html>
