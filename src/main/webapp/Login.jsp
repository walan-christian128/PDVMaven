<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    // Captura o parâmetro de erro (já existente)
    String erro = (String) request.getAttribute("erro");

    // NOVO: Captura o ID da empresa da URL (se existir)
    String idEmpresaCadastrada = request.getParameter("id_empresa_cadastrada");
    if (idEmpresaCadastrada == null || idEmpresaCadastrada.isEmpty()) {
        idEmpresaCadastrada = "0"; // Valor default para evitar erro no link
    }
    String nomeBaseCadastrada = request.getParameter("empresa");
    if (nomeBaseCadastrada == null || nomeBaseCadastrada.isEmpty()) {
        nomeBaseCadastrada = ""; // Valor default (vazio)
    }
    
    // Captura o parâmetro de status para o JavaScript
    String status = request.getParameter("status");

%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>Login de Usuário</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">
	
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet" href="style_login.css">
<link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">

<style>
/* Estilo personalizado para o tÃ­tulo */
.custom-title {
	font-family: 'SuaFontePersonalizada', sans-serif;
	color: black;
}

/* Removido o estilo .imagem (pois o fundo está no body) */

.userLogin, .userPassword, .userEmpresa {
	color: black;
}

.btn-primary {
	background-color: black;
	border-color: black;
}

/* REMOVER OU AJUSTAR: Isso força uma largura fixa e pode quebrar o layout responsivo */
.form-control {
	/* width: 400px; */ 
	width: 100%; /* Use 100% para ocupar a coluna e manter a responsividade */
}

/* REMOVER: Isso quebra o sistema de grid do Bootstrap e causa o reposicionamento incorreto */
.col-md-6 {
	/* position: relative;
	left: 0%;
	right: 12%;
	top: 0%;
	width: 400px;
	height: 400px;
    */
    /* Se você quer controlar o tamanho do formulário, use 'max-width' e centralize: */
    max-width: 450px; 
}

/* REMOVER: Isso é CSS quebrado ou desnecessário */
.container h-100 { 
	/* position: absolute; */
	/* display: white; */
}

.ls-login-forgot {
	color: white;
}

/* Estilo para o botão de fechar do modal (para ser branco) */
.modal-header .btn-close-white {
    filter: invert(1) grayscale(100%) brightness(200%);
}

/* Estilo para o cartão de login (manter, é bom) */
.well.custom-blue-bg.box-login {
    background-color: rgba(255, 255, 255, 0.9);
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}
</style>
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: cover; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

	<div class="imagem">
		<div class="container h-100">
			<div class="row h-100 justify-content-center align-items-center">
				<div class="col-md-6">
					<div class="well custom-blue-bg box-login text-center">
						<h1 class="ls-login-logo custom-title">Login</h1>

                       
                         <form action = "logar" method="post">

						<div class="form-group ls-login-user mb-3">
							<label for="userLogin" class="userLogin">Usuário (Email)</label> 
                            <input class="form-control form-control-lg" id="userLogin" type="email"
								aria-label="Usuáio" placeholder="Seu email de cadastro" name="email" required>
						</div>

						<div class="form-group ls-login-password mb-3">
							<label for="userPassword" class="userPassword">Senha</label> 
                            <input class="form-control form-control-lg" id="userPassword"
								type="password" aria-label="Senha" placeholder="Sua senha" name="senha" required>
						</div>

							
						<div class="form-group ls-login-enpressa mb-4">
							<label for="userEmpresa" class="userEmpresa">Empresa</label> 
                            <input class="form-control" id="userEmpresa"
								type="text"  placeholder= "Identificador da base de dados" name="empresa" required>
								
						</div>

						


							<div class= "mb-3">
                           <input type="submit" class="btn btn-primary btn-lg w-100" value="Entrar">
                           <p style="background-color: white; color: red;" class="mt-3">
                           <% 
                           if(erro !=null){
                           
                            out.print(erro);
                           }
                           %>
                           </p>
                           </div>
						   </form>

						</div>

						<a href="RecuperarSenha.jsp" class="ls-login-forgot">Esqueci minha senha</a>
						<br>
						<a href="cadastroUserEmpresa.jsp" class="ls-login-forgot">Não tem conta? Cadastre-se</a>

					</div>
				</div>
			</div>
		</div>

    
<div class="modal fade" id="sugestaoModal" tabindex="-1" aria-labelledby="sugestaoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="sugestaoModalLabel">🚀 Próximos Passos Essenciais!</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>O cadastro da sua empresa e usuário foi realizado com sucesso!</p>
                
                <h6 class="mt-4 text-primary">Recomendamos ativar:</h6>
                
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                        <i class="bi bi-whatsapp me-2 text-success"></i>
                        <strong>Integração com WhatsApp:</strong> Ative a sessão para enviar notificações automáticas de pedidos).
                    </li>
                    <li class="list-group-item">
                        <i class="bi bi-credit-card me-2 text-info"></i>
                        <strong>Pagamento Online:</strong> Configure sua API de pagamento para receber pedidos imediatamente.
                    </li>
                </ul>
            </div>
           <%
    // ... (Código JSP existente para capturar idEmpresaCadastrada) ...

    // Defina o número de telefone de suporte (ex: 5548999999999)
    String numeroSuporte = "5531991034754"; 
    // Mensagem pré-definida (URL encoded)
    String mensagemPadrao = "Olá, preciso de ajuda para configurar minha nova Empresa cadastrada: " + nomeBaseCadastrada + ".";
    String whatsappLink = "https://wa.me/" + numeroSuporte + "?text=" + java.net.URLEncoder.encode(mensagemPadrao, "UTF-8");
%>

<div class="modal-footer justify-content-center">
    <a href="<%= whatsappLink %>" target="_blank" class="btn btn-success">
        <i class="bi bi-whatsapp me-2"></i> Falar com Suporte
    </a> 
    
    <a href="<%= whatsappLink %>" class="btn btn-primary">Ir para Configurações</a>
</div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
        // 🔑 LÓGICA NOVO: Exibir o modal se o cadastro for bem-sucedido
        const status = "<%= status %>"; // Captura a variável JSP no JS
        
        // Verifica se o status é sucesso
        if (status === 'sucesso') {
            const sugestaoModal = new bootstrap.Modal(document.getElementById('sugestaoModal'));
            sugestaoModal.show();
            
            // Opcional, mas recomendado: Limpar a URL após a exibição do modal 
            // para que ele não apareça novamente se o usuário atualizar a página
            if (history.replaceState) {
                const cleanUrl = window.location.pathname;
                history.replaceState(null, null, cleanUrl);
            }
        }
    });
</script>

</body>
</html>