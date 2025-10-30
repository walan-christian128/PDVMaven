<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
    <title>Pagamento Não Aprovado</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --error-color: #dc3545;
            --button-color: #007bff;
            --button-hover-color: #0056b3;
            --background-color: #f8f9fa;
            --card-background: #ffffff;
            --text-color: #333333;
            --subtle-text-color: #6c757d;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            text-align: center;
        }

        .container {
            width: 100%;
            max-width: 500px;
            background-color: var(--card-background);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .icon-box {
            font-size: 6rem;
            color: var(--error-color);
            margin-bottom: 20px;
        }

        h1 {
            font-size: 2.2rem;
            color: var(--error-color);
            margin-bottom: 15px;
        }

        p {
            font-size: 1.1rem;
            color: var(--subtle-text-color);
            line-height: 1.6;
            margin-bottom: 25px;
        }

        .error-details {
            font-size: 0.9rem;
            color: var(--subtle-text-color);
            margin-top: 20px;
        }

        .buttons-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 25px;
            font-size: 1rem;
            font-weight: bold;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }

        .btn-primary {
            background-color: var(--button-color);
            color: #ffffff;
            border: none;
        }

        .btn-primary:hover {
            background-color: var(--button-hover-color);
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--button-color);
            border: 2px solid var(--button-color);
        }

        .btn-secondary:hover {
            background-color: var(--button-color);
            color: #ffffff;
        }
    </style>
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

<div class="container">
    <div class="icon-box">
        <i class="fas fa-times-circle"></i>
    </div>
    
    <h1>Pagamento Não Aprovado</h1>
    
    <p>
        O seu pagamento não foi aprovado. Isso pode ter ocorrido por alguns motivos, como dados incorretos do cartão, falta de saldo ou recusa do banco.
    </p>

    <div class="error-details">
        <p>Por favor, verifique seus dados ou tente novamente com outra forma de pagamento.</p>
        <p>Se o problema persistir, entre em contato com seu banco para mais informações.</p>
    </div>

    <div class="buttons-container">
        <a href="checkout.jsp" class="btn btn-primary">
            Tentar Novamente
        </a>
        
        <a href="contato.jsp" class="btn btn-secondary">
            Entrar em Contato
        </a>
          <a href="realizarVendas.jsp" class="btn btn-secondary">
            Voltar a Vendas
        </a>
    </div>
</div>

</body>
</html>