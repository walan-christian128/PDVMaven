<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Model.Usuario"%>
<%@ page import="Model.ApiConfig"%>
<%@ page import="DAO.ApiConfigDAO"%>
<%@ page import="jakarta.servlet.RequestDispatcher"%>

<%
    // =========================================================
    // 🛑 1. GUARD DE ACESSO (APENAS ROOT_MASTER)
    // =========================================================
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuario");
    String nomeBase = request.getParameter("base"); 
    
    // Capturar a mensagem de retorno (ex: após gerar token)
    String mensagem = request.getParameter("msg");

    if (usuarioLogado == null) {
        response.sendRedirect("Login.jsp?erro=Sessão expirada ou acesso negado."); 
        return;
    }

    String nivel = usuarioLogado.getNivel();
    if (!"ROOT_MASTER".equals(nivel) || nomeBase == null || nomeBase.isEmpty()) {
        response.sendRedirect("Home.jsp?erro=Acesso_negado_Root_Master");
        return;
    }
    
    // =========================================================
    // 🔑 2. BUSCA DO TOKEN E STATUS
    // =========================================================
    // Usando Model.ApiConfig apiConfig para evitar conflito com ServletConfig
    Model.ApiConfig apiConfig = null; 
    ApiConfigDAO dao = null; // Inicializar fora do try para o finally
    String apiStatus = "Não Configurado"; 
    boolean tokenConfigurado = false;
    
    try {
        dao = new ApiConfigDAO(nomeBase);
        apiConfig = dao.buscarConfigPorBase(nomeBase);
        
        if (apiConfig != null && apiConfig.getAccessToken() != null && !apiConfig.getAccessToken().isEmpty()) {
            tokenConfigurado = true;
            apiStatus = apiConfig.getSessionStatus();
        }
        
    } catch (Exception e) {
        // Erro de conexão com o banco ou DAO
        apiStatus = "ERRO DAO: " + e.getMessage();
        System.err.println("Erro ao carregar ApiConfigDAO: " + e.getMessage());
    }

%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
<script src="path/to/jquery-3.6.4.min.js"></script>

<script src="path/to/jquery.mask.min.js"></script>
    <meta charset="UTF-8">
    <title>Ativação API - <%= nomeBase %></title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <style>
        .qr-code-area {
            border: 2px dashed #007bff;
            min-height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin-top: 20px;
        }
        .text-break-all {
            word-break: break-all;
        }
    </style>
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: cover; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

    <%@ include file="menu.jsp"%> 

    <div class="container mt-5">
        
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0"><i class="fab fa-whatsapp"></i> Ativação da API de Mensagens</h3>
            </div>
            <div class="card-body">
                
                <h5 class="text-danger">Base de Cliente Ativa: <strong><%= nomeBase %></strong></h5>
                <hr>

                <% if ("config_salva_sucesso".equals(mensagem)) { %>
                    <div class="alert alert-success text-center">
                        Token gerado e salvo com sucesso!
                    </div>
                <% } %>
                
                <% if (tokenConfigurado) { %>
                    <div class="alert alert-secondary text-break-all">
                        <strong>Token de Acesso (Salvo):</strong> <%= apiConfig.getAccessToken() %>
                    </div>
                <% } %>

                <div class="row">
                    <div class="col-md-6">
                        <h4>Status da Conexão: <span id="apiStatus" class="badge bg-<%= apiStatus.equals("CONNECTED") ? "success" : apiStatus.equals("QRCODE") ? "warning" : "danger" %>"><%= apiStatus %></span></h4>
                        
                        <div class="d-grid gap-2 mb-4">
                            
                            <button id="btnPrincipal" class="btn btn-success btn-lg" 
                                <%= apiStatus.equals("CONNECTED") || apiStatus.equals("QRCODE") ? "disabled" : "" %>>
                                <i class="fas fa-play-circle me-2"></i> 
                                <%= tokenConfigurado ? "Iniciar Conexão e Gerar QR Code" : "Gerar Token de Acesso e Iniciar API" %>
                            </button>
                            
                            <button id="btnDesconectar" class="btn btn-warning btn-lg" 
                                <%= !apiStatus.equals("CONNECTED") && !apiStatus.equals("QRCODE") ? "disabled" : "" %>>
                                <i class="fas fa-stop-circle me-2"></i> Desconectar Sessão
                            </button>
                            <button id="btnAtualizarStatus" class="btn btn-info btn-lg">
                                <i class="fas fa-sync-alt me-2"></i> Atualizar Status
                            </button>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <h4 class="text-center">QR Code para Leitura</h4>
                        <div class="qr-code-area" id="qrCodeArea">
                            <p class="text-muted" id="qrMessage">Status atual: <%= apiStatus %></p>
                            <% if ("QRCODE".equals(apiStatus)) { %>
                                <p class="text-warning">Aguardando leitura. Clique em "Atualizar Status" se o QR não aparecer.</p>
                            <% } else if ("CONNECTED".equals(apiStatus)) { %>
                                <i class="fas fa-check-circle text-success" style="font-size: 5rem;"></i><p class="mt-3">Sessão Ativa!</p>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer text-muted">
                Usuário Master: <%= usuarioLogado.getNome() %> | Nível: <%= nivel %>
            </div>
        </div>
        
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const NOME_BASE = '<%= nomeBase %>';
        const TOKEN_CONFIGURADO = <%= tokenConfigurado %>;
        const QR_CODE_AREA = $('#qrCodeArea');
        const API_STATUS_BADGE = $('#apiStatus');
        const BTN_PRINCIPAL = $('#btnPrincipal');
        const BTN_DESCONECTAR = $('#btnDesconectar');
        
        let qrTimer = null; 
        const QR_TIMEOUT_MS = 10000; // 10 segundos para monitorar

        function atualizarStatus(novoStatus) {
            API_STATUS_BADGE.text(novoStatus);
            
            // Habilita/Desabilita botões
            const isConnectedOrQr = (novoStatus === 'CONNECTED' || novoStatus === 'QRCODE' || novoStatus === 'STARTING');
            BTN_PRINCIPAL.prop('disabled', isConnectedOrQr);
            BTN_DESCONECTAR.prop('disabled', novoStatus !== 'CONNECTED' && novoStatus !== 'QRCODE');

            // Atualiza a cor do badge
            API_STATUS_BADGE.removeClass('bg-success bg-warning bg-danger bg-info').addClass(
                novoStatus === 'CONNECTED' ? 'bg-success' : 
                (novoStatus === 'QRCODE' || novoStatus === 'STARTING' || novoStatus === 'DISCONNECTING') ? 'bg-warning' : 'bg-danger'
            );
            
            // Persiste o status no banco (Requer a implementação do AtualizarStatusApiServlet)
            $.post('AtualizarStatusApiServlet', { nomeBase: NOME_BASE, status: novoStatus });
        }


        // =========================================================
        // FUNÇÃO 1: INICIAR SESSÃO (Chama GerarQRCodeServlet)
        // Usada quando o Token JÁ EXISTE no banco.
        // =========================================================
        function iniciarSessao() {
            atualizarStatus('STARTING');
            BTN_PRINCIPAL.text('Conectando...');
            QR_CODE_AREA.empty().html('<p class="text-info">Iniciando a sessão WPPConnect...</p>');
            
            $.ajax({
                url: 'GerarQRCodeServlet', 
                type: 'POST',
                data: { nomeBase: NOME_BASE, acao: 'iniciar' },
                success: function(response) {
                    if (response.success && response.qrcode) { 
                        atualizarStatus('QRCODE');
                        QR_CODE_AREA.html(`<img src="${response.qrcode}" alt="QR Code" style="max-width: 80%;">`);
                        
                        // Inicia o timer para monitorar o status
                        if (qrTimer) clearInterval(qrTimer);
                        qrTimer = setInterval(monitorarStatus, QR_TIMEOUT_MS); 
                        
                    } else {
                        atualizarStatus('ERRO_API');
                        QR_CODE_AREA.html('<p class="text-danger">Falha ao iniciar: ' + (response.message || 'Erro desconhecido.') + '</p>');
                    }
                },
                error: function(xhr) {
                    atualizarStatus('ERRO_COMUNICAÇÃO');
                    QR_CODE_AREA.html('<p class="text-danger">Erro de comunicação com a API: ' + (xhr.statusText) + '</p>');
                },
                complete: function() {
                    BTN_PRINCIPAL.text('Iniciar Conexão e Gerar QR Code');
                }
            });
        }
        
        // =========================================================
        // FUNÇÃO 2: GERAR TOKEN E INICIAR SESSÃO (Chama GerarTokenEIniciarApiServlet)
        // Usada quando o Token NÃO EXISTE no banco.
        // =========================================================
        function gerarTokenEIniciar() {
             atualizarStatus('STARTING_TOKEN');
            BTN_PRINCIPAL.text('Gerando Token e Conectando...');
            QR_CODE_AREA.empty().html('<p class="text-info">Gerando token de segurança e iniciando instância...</p>');

            $.ajax({
                url: 'GerarTokenEIniciarApiServlet', 
                type: 'POST',
                data: { nomeBase: NOME_BASE },
                success: function(response) {
                    if (response.success && response.qrcode) {
                        // Se for sucesso, o token foi salvo e a sessão iniciada. Recarrega a página.
                        window.location.href = "PainelAtivacaoAPI.jsp?base=" + NOME_BASE + "&msg=config_salva_sucesso";
                    } else {
                        // Trata erro na geração/início
                        atualizarStatus('ERRO_API');
                        QR_CODE_AREA.html('<p class="text-danger">Falha: ' + (response.message || 'Erro desconhecido ao gerar Token.') + '</p>');
                    }
                },
                error: function(xhr) {
                    atualizarStatus('ERRO_COMUNICAÇÃO');
                    QR_CODE_AREA.html('<p class="text-danger">Erro de comunicação com o servidor. Status: ' + (xhr.statusText) + '</p>');
                }
            });
        }


        // =========================================================
        // FUNÇÃO 3: MONITORAR STATUS (Chama GerarQRCodeServlet?acao=status)
        // =========================================================
        function monitorarStatus() {
            $.ajax({
                url: 'GerarQRCodeServlet',
                type: 'POST',
                data: { nomeBase: NOME_BASE, acao: 'status' },
                success: function(response) {
                    if (response.status) { 
                        atualizarStatus(response.status);
                        
                        if (response.status === 'CONNECTED') {
                            if (qrTimer) clearInterval(qrTimer);
                            QR_CODE_AREA.html('<i class="fas fa-check-circle text-success" style="font-size: 5rem;"></i><p class="mt-3">Sessão Ativa!</p>');
                        } else if (response.status === 'DISCONNECTED') {
                            if (qrTimer) clearInterval(qrTimer);
                            QR_CODE_AREA.html('<p class="text-danger">Desconectado. Inicie nova sessão.</p>');
                        } else if (response.status === 'QRCODE' && response.qrcode) {
                             QR_CODE_AREA.html(`<img src="${response.qrcode}" alt="QR Code" style="max-width: 80%;">`);
                        } else if (response.status === 'QRCODE') {
                            QR_CODE_AREA.html('<p class="text-warning">QR Code válido, mas não foi retornado na última consulta. Aguarde ou clique em Iniciar novamente.</p>');
                        }
                    }
                },
                error: function() {
                    console.log("Erro ao monitorar status.");
                }
            });
        }
        
        // =========================================================
        // FUNÇÃO 4: DESCONECTAR
        // =========================================================
        BTN_DESCONECTAR.on('click', function() {
            if (!confirm("Tem certeza que deseja desconectar a sessão do WhatsApp?")) return;
            
            atualizarStatus('DISCONNECTING');
            
            $.ajax({
                url: 'GerarQRCodeServlet',
                type: 'POST',
                data: { nomeBase: NOME_BASE, acao: 'desconectar' },
                success: function() {
                    atualizarStatus('DISCONNECTED');
                    if (qrTimer) clearInterval(qrTimer);
                    QR_CODE_AREA.empty().html('<p class="text-danger">Sessão encerrada.</p>');
                }
            });
        });

        // =========================================================
        // INICIALIZAÇÃO DE EVENTOS
        // =========================================================
        $(document).ready(function() {
            // Ligar o botão principal ao fluxo correto (Gerar ou Iniciar)
            if (TOKEN_CONFIGURADO) {
                BTN_PRINCIPAL.on('click', iniciarSessao);
            } else {
                BTN_PRINCIPAL.on('click', gerarTokenEIniciar);
            }
            
            // Ligar o botão de atualização
            $('#btnAtualizarStatus').on('click', monitorarStatus);

            // Se o status no banco for QRCODE na carga da página, iniciar monitoramento
            if ('<%= apiStatus %>' === 'QRCODE') {
                if (qrTimer) clearInterval(qrTimer); // Garante que não há timer antigo
                qrTimer = setInterval(monitorarStatus, QR_TIMEOUT_MS); 
            }
        });

    </script>
</body>
</html>