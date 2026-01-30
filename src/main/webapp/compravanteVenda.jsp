<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String vendaIDParam = request.getParameter("vendaID");
int vendaID = (vendaIDParam != null && !vendaIDParam.isEmpty()) ? Integer.parseInt(vendaIDParam) : -1;
%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Relatório de Venda</title>

<link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">

<style>
html, body {
    margin: 0;
    padding: 0;
    height: 100%;
    overflow: hidden;
}

/* Iframe ocupa tudo */
iframe {
    width: 100%;
    height: 100%;
    border: none;
}

/* 🔥 Botão flutuante */
.btn-voltar {
    position: fixed;
    top: 15px;
    left: 15px;
    z-index: 9999;
    background: #2e7d32;
    color: white;
    border: none;
    padding: 10px 16px;
    border-radius: 6px;
    font-size: 14px;
    cursor: pointer;
    box-shadow: 0 2px 6px rgba(0,0,0,0.3);
    transition: 0.2s;
}

.btn-voltar:hover {
    background: #1b5e20;
    transform: scale(1.05);
}
</style>
</head>

<body>

<button class="btn-voltar" onclick="voltarVendas()">⬅ Voltar para detalhe</button>

<iframe id="iframeRelatorio"
    src="relVenda?vendaID=<%= vendaID %>">
</iframe>

<script>
function voltarVendas() {
    // Limpa histórico do relatório e volta pra tela de vendas
    window.location.replace("DetalheVenda.jsp");
}
</script>

</body>
</html>
