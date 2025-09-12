<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.VendasDAO" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.io.Serializable" %>

<%
    // Lógica para obter a empresa da sessão
    String empresa = (String) session.getAttribute("empresa");

    if (empresa == null) {
        empresa = "0"; // Defina um valor padrão ou trate o erro adequadamente
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finalizar Compra</title>
    <script src="https://sdk.mercadopago.com/js/v2"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #009ee3;
            --secondary-color: #3483fa;
            --background-color: #f5f6f9;
            --card-background: #ffffff;
            --text-color: #333333;
            --subtle-text-color: #666666;
            --border-color: #e0e0e0;
            --button-hover-color: #007bb6;
            --cancel-color: #ff4d4f;
            --cancel-hover-color: #cc3939;
            --approved-color: #28a745;
            --pending-color: #ffc107;
            --rejected-color: #dc3545;
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Roboto', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .container {
            width: 100%;
            max-width: 800px;
            background: var(--card-background);
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 25px;
            text-align: center;
        }
        
        h1 {
            font-size: 2.2em;
            margin-bottom: 10px;
        }
        
        .subtitle {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .content {
            padding: 30px;
        }
        
        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .payment-options button {
            padding: 15px;
            font-size: 1.1em;
            font-weight: 500;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .payment-options .pix-button {
            background-color: var(--primary-color);
        }
        
        .payment-options .pix-button:hover {
            background-color: var(--button-hover-color);
        }
        
        .payment-options .card-button {
            background-color: var(--secondary-color);
        }
        
        .payment-options .card-button:hover {
            background-color: #2b70d4;
        }
        
        .cancel-button {
            background: none;
            border: 1px solid var(--cancel-color);
            color: var(--cancel-color);
            padding: 12px 20px;
            font-size: 1em;
            font-weight: 500;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .cancel-button:hover {
            background-color: var(--cancel-color);
            color: #fff;
        }
        
        #paymentBrick_container {
            display: none;
            margin-bottom: 25px;
        }
        
        .hidden {
            display: none;
        }
        
        /* CSS para os modais - MELHORADO */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.7);
            padding: 20px;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 2% auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            max-width: 600px;
            width: 95%;
            position: relative;
        }

        .modal-close {
            color: #aaa;
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            z-index: 10;
        }

        .modal-close:hover,
        .modal-close:focus {
            color: black;
            text-decoration: none;
        }
        
        /* Layout de duas colunas para o modal PIX */
        .pix-container {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
            margin-top: 20px;
        }
        
        .pix-qr-section {
            flex: 1;
            min-width: 250px;
            text-align: center;
        }
        
        .pix-status-section {
            flex: 1;
            min-width: 250px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .pix-qr-container {
            margin: 15px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
            display: inline-block;
        }
        
        .pix-qr-container img {
            width: 220px;
            height: 220px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
        }
        
        .pix-code {
            word-break: break-all;
            padding: 15px;
            background-color: #f8f9fa;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            margin: 15px 0;
            font-family: monospace;
            font-size: 0.85em;
            line-height: 1.5;
            max-height: 120px;
            overflow-y: auto;
        }
        
        .copy-button {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s;
            margin-top: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .copy-button:hover {
            background-color: var(--button-hover-color);
        }
        
        .status-content {
            text-align: center;
            padding: 15px 0;
        }
        
        .status-icon {
            font-size: 3.5em;
            margin-bottom: 15px;
        }
        
        .icon-pending {
            color: var(--pending-color);
        }
        
        .icon-approved {
            color: var(--approved-color);
        }
        
        .icon-rejected {
            color: var(--rejected-color);
        }
        
        .status-message {
            font-size: 1.3em;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .status-description {
            color: var(--subtle-text-color);
            margin-bottom: 20px;
        }
        
        .progress-container {
            width: 100%;
            background-color: #e0e0e0;
            border-radius: 50px;
            overflow: hidden;
            margin: 20px 0;
            height: 10px;
        }
        
        .progress-bar {
            height: 100%;
            background-color: var(--pending-color);
            width: 100%;
            animation: progress-animation 2s infinite linear;
            transform-origin: left;
        }
        
        @keyframes progress-animation {
            0% { transform: scaleX(0); }
            50% { transform: scaleX(0.5); }
            100% { transform: scaleX(0); }
        }
        
        .payment-info {
            background-color: #e7f5ff;
            border-left: 4px solid var(--primary-color);
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            text-align: left;
        }
        
        .info-title {
            font-weight: 600;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        
        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 6px;
            text-align: center;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .btn-secondary {
            background-color: transparent;
            color: var(--subtle-text-color);
            border: 1px solid var(--border-color);
        }
        
        .btn-secondary:hover {
            background-color: #f8f9fa;
        }
        
        @media (max-width: 768px) {
            .pix-container {
                flex-direction: column;
            }
            
            .modal-content {
                padding: 20px;
                margin: 5% auto;
            }
            
            .pix-qr-container img {
                width: 180px;
                height: 180px;
            }
            
            h1 {
                font-size: 1.8em;
            }
        }
    </style>
</head>
<body>
    <div class="container" id="mainContainer">
        <header>
            <h1>Finalizar Compra</h1>
            <p class="subtitle">Seu pedido foi criado! Escolha a forma de pagamento.</p>
        </header>
        
        <div class="content">
            <div class="payment-options">
                <button id="pixPaymentButton" class="pix-button">
                    <i class="fas fa-qrcode"></i> Pagar com Pix
                </button>
                <button id="showCardPayment" class="card-button">
                    <i class="fas fa-credit-card"></i> Pagar com Cartão
                </button>
            </div>
            
            <div id="paymentBrick_container"></div>
            
            <button class="cancel-button" onclick="window.history.back()">
                <i class="fas fa-arrow-left"></i> Cancelar Pagamento
            </button>
        </div>
    </div>
    
    <!-- Modal PIX - MELHORADO -->
    <div id="pixModal" class="modal">
        <div class="modal-content">
            <span class="modal-close">&times;</span>
            
            <h2>Pagamento via PIX</h2>
            <p>Escaneie o QR Code ou copie o código para realizar o pagamento.</p>
            
            <div class="pix-container">
                <div class="pix-qr-section">
                    <div class="pix-qr-container">
                        <img id="qrCodeImage" src="" alt="QR Code Pix">
                    </div>
                    
                    <div class="pix-code" id="pixCodeText"></div>
                    
                    <button class="copy-button" onclick="copyPixCode()">
                        <i class="fas fa-copy"></i> Copiar Código
                    </button>
                </div>
                
                <div class="pix-status-section">
                    <div class="status-content">
                        <div class="status-icon icon-pending">
                            <i class="fas fa-clock"></i>
                        </div>
                        
                        <h3 class="status-message">Pagamento Pendente</h3>
                        
                        <p class="status-description">
                            Aguardando confirmação do pagamento. Esta tela será atualizada automaticamente.
                        </p>
                        
                        <div class="progress-container">
                            <div class="progress-bar"></div>
                        </div>
                    </div>
                    
                    <div class="payment-info">
                        <div class="info-title">
                            <i class="fas fa-info-circle"></i> Importante
                        </div>
                        <p>O pagamento pode levar alguns minutos para ser confirmado. Mantenha esta tela aberta.</p>
                    </div>
                </div>
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-secondary" onclick="closeModal('pixModal')">
                    <i class="fas fa-times"></i> Fechar
                </button>
                <button class="btn btn-primary" onclick="checkStatusManually()">
                    <i class="fas fa-sync-alt"></i> Verificar Status
                </button>
            </div>
        </div>
    </div>

    <!-- Modal de Status - MELHORADO -->
    <div id="statusModal" class="modal">
        <div class="modal-content">
            <span class="modal-close">&times;</span>
            <div id="modal-content-placeholder">
                <!-- Conteúdo será preenchido via JavaScript -->
            </div>
        </div>
    </div>
    
<script>
    // Elementos da interface
    const showCardButton = document.getElementById('showCardPayment');
    const paymentBrickContainer = document.getElementById('paymentBrick_container');
    const pixButton = document.getElementById('pixPaymentButton');
    const cancelButton = document.querySelector('.cancel-button');
    const statusModal = document.getElementById('statusModal');
    const pixModal = document.getElementById('pixModal');
    const modalContentPlaceholder = document.getElementById('modal-content-placeholder');
    const allModals = document.querySelectorAll('.modal');
    
    // Variáveis de controle
    let statusCheckInterval;
    let currentOrderId = null;
    
    // Função para fechar modais
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
        if (modalId === 'pixModal') {
            clearInterval(statusCheckInterval);
        }
    }
    
    // Fechar modal ao clicar no X ou fora dele
    allModals.forEach(modal => {
        modal.querySelector('.modal-close').addEventListener('click', () => {
            closeModal(modal.id);
        });
        
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                closeModal(modal.id);
            }
        });
    });

    // Lógica de inicialização do Brick para cartão
showCardButton.addEventListener('click', () => {
        document.querySelector('.payment-options').classList.add('hidden');
        cancelButton.classList.add('hidden');
        paymentBrickContainer.style.display = 'block';

        const preferenceId = "<%= request.getAttribute("preferenceId") %>";
        const publicKey = "<%= request.getAttribute("publicKey") %>";
        const totalAmount = "<%= request.getAttribute("totalVenda") %>";
        const orderId = "<%= request.getAttribute("orderId") %>";

        const mp = new MercadoPago(publicKey, { locale: 'pt-BR' });
        const bricksBuilder = mp.bricks();

        bricksBuilder.create("payment", "paymentBrick_container", {
            initialization: {
                // CORREÇÃO: Passe a preferenceId para linkar a transação
                preferenceId: preferenceId,
                amount: parseFloat(totalAmount),
            },
            customization: {
                visual: {
                    hideFormTitle: true,
                },
                paymentMethods: {
                    creditCard: 'all',
                    debitCard: 'all',
                },
            },
            callbacks: {
                onReady: () => {
                    console.log("Payment Brick para cartões pronto.");
                },
                onError: (error) => {
                    console.error("Erro no Payment Brick:", error);
                    alert("Ocorreu um erro ao carregar o formulário de pagamento. Tente novamente.");
                    window.history.back();
                },
                onPaymentSuccess: (result) => {
                    console.log("Pagamento com cartão aprovado!", result);
                    window.location.href = 'sucesso.jsp?orderId=' + orderId;
                },
                onPaymentError: (error) => {
                    console.error("Pagamento com cartão recusado!", error);
                    alert("Pagamento não aprovado. Verifique os dados e tente novamente.");
                    window.location.href = 'erro.jsp?orderId=' + orderId;
                },
            },
        });
    });
    
    // Lógica de pagamento com Pix (AJAX)
    pixButton.addEventListener('click', async () => {
        document.querySelector('.payment-options').classList.add('hidden');
        cancelButton.classList.add('hidden');

        try {
            const response = await fetch('criaPagamentoPixServlet?idEmpresa=1');
            const data = await response.json(); 
            
            if (data.qr_code && data.qr_code_base64 && data.id) {
                document.getElementById('qrCodeImage').src = 'data:image/jpeg;base64,' + data.qr_code_base64;
                document.getElementById('pixCodeText').innerText = data.qr_code;
                pixModal.style.display = 'block';
                currentOrderId = data.id;

                // Inicia a verificação de status no background
                startStatusCheck(data.id); 
            } else {
                alert('Erro ao gerar o Pix. Tente novamente.');
                document.querySelector('.payment-options').classList.remove('hidden');
                cancelButton.classList.remove('hidden');
            }
        } catch (error) {
            console.error('Erro:', error);
            alert('Ocorreu um erro inesperado.');
            document.querySelector('.payment-options').classList.remove('hidden');
            cancelButton.classList.remove('hidden');
        }
    });

    // Função para copiar o código Pix
    function copyPixCode() {
        const pixCode = document.getElementById('pixCodeText').innerText;
        navigator.clipboard.writeText(pixCode).then(() => {
            alert('Código Pix copiado com sucesso!');
        }).catch(err => {
            console.error('Erro ao copiar o código:', err);
            alert('Erro ao copiar o código. Tente novamente.');
        });
    }

    // Função para iniciar a verificação de status do pagamento (Lógica de Polling)
    function startStatusCheck(orderId) {
        clearInterval(statusCheckInterval);

        statusCheckInterval = setInterval(async () => {
            try {
                const response = await fetch(
                    'checkPaymentStatusServlet?orderId=' + orderId + '&empresa=1'
                );
                const status = (await response.text()).trim();

                console.log("Status recebido:", status);

                if (status === 'aprovada') {
                    clearInterval(statusCheckInterval);
                    window.location.href = 'sucesso.jsp?orderId=' + orderId;
                } else if (status === 'rejeitada') {
                    clearInterval(statusCheckInterval);
                    window.location.href = 'erro.jsp?orderId=' + orderId;
                }
            } catch (error) {
                console.error("Erro ao verificar o status:", error);
            }
        }, 5000);
    }
    
    // Verificação manual de status
    function checkStatusManually() {
        if (currentOrderId) {
            fetch('checkPaymentStatusServlet?orderId=' + currentOrderId)
                .then(response => response.text())
                .then(status => {
                    if (status.trim() === 'aprovada' || status.trim() === 'rejeitada') {
                        clearInterval(statusCheckInterval);
                        if(status.trim() === 'aprovada') {
                             window.location.href = 'sucesso.jsp?orderId=' + currentOrderId;
                        } else {
                             window.location.href = 'erro.jsp?orderId=' + currentOrderId;
                        }
                    } else {
                        alert('Pagamento ainda está pendente.');
                    }
                })
                .catch(error => {
                    console.error("Erro ao verificar o status:", error);
                    alert('Erro ao verificar status. Tente novamente.');
                });
        }
    }
    
    // Tecla ESC para fechar modais
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            allModals.forEach(modal => {
                if (modal.style.display === 'block') {
                    closeModal(modal.id);
                }
            });
        }
    });
</script>
</body>
</html>