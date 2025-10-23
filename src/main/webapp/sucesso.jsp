<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
    <title>Pagamento Aprovado - Sucesso!</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: #333;
        }
        .container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
            border-top: 5px solid #28a745;
        }
        .icon-success {
            font-size: 72px;
            color: #28a745;
            margin-bottom: 20px;
        }
        h1 {
            color: #28a745;
            font-size: 2.2em;
            margin-bottom: 10px;
        }
        p {
            font-size: 1.1em;
            line-height: 1.6;
            color: #555;
            margin-bottom: 25px;
        }
        .transaction-details {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 8px;
            margin-top: 25px;
            text-align: left;
        }
        .transaction-details p {
            margin: 5px 0;
        }
        .transaction-details strong {
            color: #333;
        }
        .btn-return {
            background-color: #007bff;
            color: white;
            padding: 12px 25px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }
        .btn-return:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

    <%
        // Obtém o orderId da URL
        String orderId = request.getParameter("orderId");
        
        // Define uma URL de retorno, que pode ser a página inicial ou outra relevante
        String homeUrl = request.getContextPath() + "/realizarVendas.jsp";
    %>

    <div class="container">
        <div class="icon-success">
            <i class="fas fa-check-circle"></i>
        </div>
        <h1>Pagamento Aprovado!</h1>
        <p>
            Sua transação foi processada com sucesso. Agradecemos por sua compra!
        </p>

        <div class="transaction-details">
            <p><strong>Detalhes da Transação:</strong></p>
            <p><strong>ID do Pedido:</strong> <%= (orderId != null && !orderId.isEmpty()) ? orderId : "N/A" %></p>
        </div>

        <a href="<%= homeUrl %>" class="btn-return">
            Voltar para a Loja
        </a>
    </div>

</body>
</html>