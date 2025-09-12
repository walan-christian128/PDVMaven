<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.VendasDAO" %>

<%
    // Obtém o external_reference enviado pelo Mercado Pago
    String externalReference = request.getParameter("external_reference");

    String empresa = null;
    int vendaId = 0;
    String statusDaVenda = "unknown"; // padrão

    if (externalReference != null && !externalReference.isEmpty()) {
        try {
            // external_reference no formato "empresa_vendaId"
            String[] partes = externalReference.split("_");
            if (partes.length == 2) {
                empresa = partes[0];
                vendaId = Integer.parseInt(partes[1]);

                VendasDAO dao = new VendasDAO(empresa);
                statusDaVenda = dao.consultarStatusVenda(vendaId); // retorna approved/pending/rejected
            }
        } catch (Exception e) {
            e.printStackTrace();
            statusDaVenda = "error";
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Status do Pagamento</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --approved-color: #28a745;
            --pending-color: #ffc107;
            --rejected-color: #dc3545;
            --primary-bg-color: #f5f6f9;
            --card-bg-color: #ffffff;
            --text-color: #333333;
            --subtle-text-color: #666666;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Roboto', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: var(--primary-bg-color);
            margin: 0;
            text-align: center;
        }

        .container {
            padding: 50px;
            border-radius: 12px;
            background-color: var(--card-bg-color);
            box-shadow: var(--shadow);
            max-width: 500px;
            width: 90%;
            transition: all 0.3s ease-in-out;
        }

        h1 {
            font-size: 2.5em;
            font-weight: 700;
            margin-bottom: 10px;
        }

        p {
            font-size: 1.1em;
            color: var(--subtle-text-color);
            line-height: 1.6;
        }

        .status-icon {
            font-size: 5em;
            margin-bottom: 20px;
        }

        .icon-approved { color: var(--approved-color); }
        .icon-pending { color: var(--pending-color); }
        .icon-rejected { color: var(--rejected-color); }

        .progress-bar-container {
            width: 100%;
            background-color: #e0e0e0;
            border-radius: 50px;
            overflow: hidden;
            margin-top: 20px;
            height: 10px;
        }

        .progress-bar {
            height: 100%;
            background-color: var(--pending-color);
            width: 100%;
            animation: progress-animation 2s infinite linear;
        }
        
        @keyframes progress-animation {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        /* Classes de status */
        .status-approved { border-left: 5px solid var(--approved-color); }
        .status-pending { border-left: 5px solid var(--pending-color); }
        .status-rejected { border-left: 5px solid var(--rejected-color); }
    </style>
</head>
<body class="<%= "status-" + statusDaVenda.toLowerCase() %>">
    <div class="container">
        <% if ("approved".equalsIgnoreCase(statusDaVenda)) { %>
            <div class="status-icon icon-approved">&#10003;</div>
            <h1>Pagamento Aprovado!</h1>
            <p>Obrigado por sua compra. Seu pedido foi confirmado e será processado em breve.</p>
        <% } else if ("pending".equalsIgnoreCase(statusDaVenda)) { %>
            <div class="status-icon icon-pending">&#9203;</div>
            <h1>Seu Pagamento Está Pendente</h1>
            <p>Aguardando a confirmação do banco ou processamento da transação. Esta página será atualizada automaticamente.</p>
            <div class="progress-bar-container">
                <div class="progress-bar"></div>
            </div>
            <meta http-equiv="refresh" content="5" >
        <% } else { %>
            <div class="status-icon icon-rejected">&#10007;</div>
            <h1>Status do Pagamento: <%= statusDaVenda.toUpperCase() %></h1>
            <p>Não foi possível confirmar o seu pagamento. Por favor, tente novamente ou entre em contato com o suporte.</p>
        <% } %>
    </div>
</body>
</html>
