<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String pedidoIDParam = request.getParameter("id_pedido");
int pedidoID = (pedidoIDParam != null && !pedidoIDParam.isEmpty()) ? Integer.parseInt(pedidoIDParam) : -1;
%>


<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprovante pedido</title>
    <link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden; /* Oculta barras de rolagem extras */
        }

        /* Define o iframe para ocupar 100% da tela */
        iframe {
            width: 100%;
            height: 100%;
            border: none; /* Remove borda do iframe */
        }
    
    </style>
</head>
<body>
    <!-- Carrega o servlet de relatório diretamente nesta página JSP -->
    <iframe id="iframePedido" src="exibirNotaPedido?id_pedido=<%= pedidoID %>"></iframe>

</body>
</html>
