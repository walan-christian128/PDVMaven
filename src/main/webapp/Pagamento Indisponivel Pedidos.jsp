<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pagamento Online Indisponível</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    
    <style>
        body {
            background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1;
        }
        .card-aviso {
            position: relative;
            z-index: 2;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            max-width: 500px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            border: none;
        }
        .icon-wrapper {
            font-size: 4rem;
            color: #f39c12; /* Cor de alerta (âmbar) */
            margin-bottom: 20px;
        }
        h2 { color: #2c3e50; font-weight: 700; }
        p { color: #7f8c8d; font-size: 1.1rem; line-height: 1.6; }
        .btn-voltar {
            background-color: #2c3e50;
            color: white;
            border-radius: 10px;
            padding: 12px 30px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        .btn-voltar:hover {
            background-color: #1a252f;
            transform: translateY(-2px);
            color: #fff;
        }
    </style>
</head>
<body>

    <div class="overlay"></div>

    <div class="card-aviso">
        <div class="icon-wrapper">
            <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" fill="currentColor" class="bi bi-credit-card-2-front-fill" viewBox="0 0 16 16">
                <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm2.5 1a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 2a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"/>
                <path d="M11.5 5.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5z" opacity=".5"/>
            </svg>
        </div>
        <h2>Pagamento Online Indisponível</h2>
        <p class="mt-3">
            No momento, esta empresa não está com o módulo de <strong>pagamentos online</strong> habilitado.
        </p>
        <p>
            Por favor, volte da pagina de pedidos cancele o pedido, faça um novo pedido selecionando outra forma de pagamento.
        </p>
        
        <a href="javascript:history.back()" class="btn-voltar">
            Voltar para o site
        </a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>