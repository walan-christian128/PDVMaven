<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Model.Vendas"%>
<%@ page import="Model.ItensVenda"%>
<%@ page import="DAO.VendasDAO"%>
<%@ page import="Model.Produtos"%>
<%@ page import="DAO.ProdutosDAO"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>Periodo Detalhe</title>
   <link rel="stylesheet" href="style.css">
   <link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
    <link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">
</head>
<body>
	<%@ include file="menu.jsp"%>
	<div class="table-container">
		<table id="VendaDiaria">
			<thead>
				<tr>
					<th>Data</th>
					<th>Total</th>
					
					

				</tr>
			</thead>
			<tbody>
               <!-- Itera sobre os objetos ItensVenda -->
            <% List<Vendas> peridoVenda = (List<Vendas>)request.getAttribute("periodo");
            if(peridoVenda != null) {
                for(Vendas vendas : peridoVenda) { %>
                    <tr>
                        <td><%= vendas.getData_venda() %></td>
                        <td><%= vendas.getTotal_venda()%></td>
                        
                    </tr>
                <% }
            } %>
             
			</tbody>

		</table>
		
		<div>
		 <a  href="Home.jsp" type="button" class= "btn btn-danger">Voltar</a>
		 </div>
		


	</div>
	
	
   
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script> 
           
            
</body>

</html>