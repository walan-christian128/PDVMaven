<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Usuario"%>
<%@ page import="Model.ApiConfig"%>
<%@ page import="DAO.ApiConfigDAO"%>

<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuario");
    String nomeBase = request.getParameter("base"); 
    String mensagem = request.getParameter("msg");

    if (usuarioLogado == null) {
        response.sendRedirect("Login.jsp?erro=Sessao_expirada"); 
        return;
    }

    String nivel = usuarioLogado.getNivel();
    if (!"ROOT_MASTER".equals(nivel) || nomeBase == null || nomeBase.isEmpty()) {
        response.sendRedirect("Home.jsp?erro=Acesso_negado");
        return;
    }
    
    Model.ApiConfig apiConfig = null; 
    String apiStatus = "DISCONNECTED"; 
    boolean tokenConfigurado = false;
    
    try {
        ApiConfigDAO dao = new ApiConfigDAO(nomeBase);
        apiConfig = dao.buscarConfigPorBase(nomeBase);
        if (apiConfig != null && apiConfig.getAccessToken() != null && !apiConfig.getAccessToken().isEmpty()) {
            tokenConfigurado = true;
            apiStatus = apiConfig.getSessionStatus() != null ? apiConfig.getSessionStatus() : "DISCONNECTED";
        }
    } catch (Exception e) {
        apiStatus = "ERRO_CONEXAO";
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Ativação API - <%= nomeBase %></title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    
    <style>
        .qr-code-area {
            border: 2px dashed #007bff;
            min-height: 350px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin-top: 20px;
            padding: 20px;
        }
        #imagemQRCode { 
            max-width: 90%; 
            border: 8px solid white; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.2); 
            border-radius: 5px;
        }
        .badge { font-size: 0.9rem; padding: 0.6em 1em; }
    </style>
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: cover; background-position: center; min-height: 100vh;">

    <%@ include file="menu.jsp"%> 

    <div class="container mt-5 pb-5">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h3 class="mb-0"><i class="fab fa-whatsapp"></i> Ativação WhatsApp</h3>
                <span class="badge bg-light text-primary"><%= nomeBase %></span>
            </div>
            <div class="card-body">
                
                <% if (tokenConfigurado) { %>
                    <div class="alert alert-info py-2">
                        <small><strong>Token Ativo:</strong> <%= apiConfig.getAccessToken() %></small>
                    </div>
                <% } %>

                <div class="row">
                    <div class="col-md-5 border-end">
                        <div class="p-3">
                            <h4>Status: <span id="apiStatus" class="badge bg-secondary"><%= apiStatus %></span></h4>
                            <div class="d-grid gap-3 mt-4">
                                <button id="btnPrincipal" class="btn btn-success btn-lg shadow-sm">
                                    <i class="fas fa-play-circle me-2"></i> Iniciar e Gerar QR
                                </button>
                                <button id="btnDesconectar" class="btn btn-danger shadow-sm">
                                    <i class="fas fa-power-off me-2"></i> Desconectar
                                </button>
                                <button id="btnAtualizarStatus" class="btn btn-outline-primary btn-sm mt-2">
                                    <i class="fas fa-sync-alt me-2"></i> Verificar Conexão
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-7 text-center">
                        <div class="qr-code-area" id="qrCodeArea">
                            <div id="placeholderArea">
                                <i class="fas fa-qrcode fa-5x text-muted opacity-50 mb-3"></i>
                                <p class="text-muted">Clique em "Iniciar" para gerar o código</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"></script>
    <script src="bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const NOME_BASE = '<%= nomeBase %>';
        const BTN_PRINCIPAL = $('#btnPrincipal');
        const BTN_DESCONECTAR = $('#btnDesconectar');
        const QR_CODE_AREA = $('#qrCodeArea');
        const API_STATUS_BADGE = $('#apiStatus');
        
        let qrTimer = null;

        function atualizarUI(status) {
            API_STATUS_BADGE.text(status);
            API_STATUS_BADGE.removeClass('bg-success bg-warning bg-danger bg-info bg-secondary');
            
            if (status === 'CONNECTED') API_STATUS_BADGE.addClass('bg-success');
            else if (status === 'QRCODE' || status === 'STARTING') API_STATUS_BADGE.addClass('bg-warning');
            else if (status === 'DISCONNECTED') API_STATUS_BADGE.addClass('bg-danger');
            else API_STATUS_BADGE.addClass('bg-secondary');

            BTN_PRINCIPAL.prop('disabled', (status === 'CONNECTED' || status === 'QRCODE' || status === 'STARTING'));
        }

        function iniciarSessao() {
            atualizarUI('STARTING');
            QR_CODE_AREA.html('<div class="spinner-border text-primary" style="width: 3rem; height: 3rem;"></div><p class="mt-3 fw-bold text-primary">Gerando QR Code no Servidor...</p>');
            
            $.post('GerarQRCodeServlet', { nomeBase: NOME_BASE, acao: 'iniciar' }, function(response) {
                console.log("Resposta API:", response); // DEPURAÇÃO NO F12
                
                // Mapeia diferentes possíveis retornos do WPPConnect
                let qrData = response.qrcode || response.base64 || (response.response ? response.response.qrcode : null);
                
                if (qrData) {
                    atualizarUI('QRCODE');
                    QR_CODE_AREA.html('<img id="imagemQRCode" src="' + qrData + '"><div class="alert alert-warning mt-3 py-1"><small>Leia o código acima com seu WhatsApp</small></div>');
                    
                    if (qrTimer) clearInterval(qrTimer);
                    qrTimer = setInterval(monitorarStatus, 5000);
                } else if (response.status === 'CONNECTED' || response.connected === true) {
                    marcarComoConectado();
                } else {
                    QR_CODE_AREA.html('<p class="text-danger"><i class="fas fa-exclamation-triangle"></i> Erro: O servidor não enviou a imagem.</p>');
                    atualizarUI('DISCONNECTED');
                }
            }).fail(function(err) {
                console.error("Erro Ajax:", err);
                QR_CODE_AREA.html('<p class="text-danger">Erro técnico: Verifique se o Servlet e o Node estão ativos.</p>');
                atualizarUI('ERRO_CONEXAO');
            });
        }

        function monitorarStatus() {
            $.post('GerarQRCodeServlet', { nomeBase: NOME_BASE, acao: 'status' }, function(response) {
                let status = response.status || (response.response ? response.response.status : null);
                if (status === 'CONNECTED' || response.connected === true) {
                    marcarComoConectado();
                }
            });
        }

        function marcarComoConectado() {
            if (qrTimer) clearInterval(qrTimer);
            atualizarUI('CONNECTED');
            QR_CODE_AREA.html('<div class="animate__animated animate__zoomIn"><i class="fas fa-check-circle text-success fa-5x"></i><h4 class="mt-3">Conexão Estabelecida!</h4><p class="text-muted">Seu sistema está pronto para enviar mensagens.</p></div>');
        }

        function desconectar() {
            if (!confirm("Deseja realmente encerrar a sessão do WhatsApp?")) return;
            atualizarUI('STARTING');
            $.post('GerarQRCodeServlet', { nomeBase: NOME_BASE, acao: 'desconectar' }, function() {
                window.location.reload();
            });
        }

        $(document).ready(function() {
            // Removemos qualquer erro de máscara que possa travar o JS
            try {
                // Se houver campos de máscara no menu.jsp, eles continuam funcionando, 
                // mas não chamamos nada aqui para não dar conflito.
            } catch(e) { console.warn("Erro de máscara ignorado."); }

            atualizarUI('<%= apiStatus %>');
            
            BTN_PRINCIPAL.on('click', iniciarSessao);
            BTN_DESCONECTAR.on('click', desconectar);
            $('#btnAtualizarStatus').on('click', monitorarStatus);

            if ('<%= apiStatus %>' === 'QRCODE') {
                qrTimer = setInterval(monitorarStatus, 5000);
            }
        });
    </script>
</body>
</html>