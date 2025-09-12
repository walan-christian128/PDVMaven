<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
String erro = (String) request.getAttribute("erro");

String empresa = request.getParameter("empresa");

if (empresa != null && !empresa.isEmpty()) {
    // Se a empresa foi passada por parâmetro, salve na sessão
    session.setAttribute("empresa", empresa);
} else {
    // Se não foi passada, tente recuperar da sessão
    empresa = (String) session.getAttribute("empresa");
    
    // Se a empresa ainda for nula, redirecione o usuário para uma página de erro ou de escolha de empresa
    if (empresa == null) {
        // Redirecionamento para evitar erros.
        // Substitua "pagina_inicial_de_login.jsp" pela sua página inicial.
        response.sendRedirect("ProdutosPedidos.jsp");
        return; // É crucial parar a execução da JSP
    }
}


%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<head>
<meta charset="UTF-8">
<!-- Adicione as folhas de estilo do Bootstrap 4 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">
<link rel="stylesheet" href="style_login.css">
<link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">

<style>
/* Estilo personalizado para o tÃ­tulo */
.custom-title {
	font-family: 'SuaFontePersonalizada', sans-serif;
	color: black;
}

.imagem {
	/* Substitua pelo caminho da sua imagem de fundo */
	background-size: cover; /* Ajusta a imagem para cobrir toda a tela */
	background-position: center;
	/* Centraliza a imagem horizontalmente e verticalmente */
	width: 100%;
	height: 100vh;
	/* Define a altura da imagem para preencher a tela inteira */
}

.userLogin {
	color: black;
}

.btn-primary {
	background-color: black;
	border-color: black;
}

.userPassword {
	color: black;
}

.form-control {
	width: 400px;
}

.col-md-6 {
	position: relative;
	left: 0%;
	right: 12%;
	top: 0%;
	width: 400px;
	height: 400px;
}

.container h-100 {
	position: absolute;
	display: white;
}

.ls-login-forgot {
	color: white;
}
</style>
</head>
<body style="background-image: url('img/Gemini_Generated_Image_kysa9wkysa9wkysa.png'); background-size: cover; background-position: center; margin: 0; padding: 0; height: 100vh;">
	<div class="imagem">
		<div class="container h-100">
			<div class="row h-100 justify-content-center align-items-center">
				<div class="col-md-6">
					<div class="well custom-blue-bg box-login text-center">
						<h1 class="ls-login-logo custom-title text-dark">Login Pedido</h1>
						<!-- Adicione a classe custom-title ao tÃ­tulo -->

                       
                         <form action = "clientePedidoServer" method="post">

						<div class="form-group ls-login-user">
							<label for="userLogin" class="userLogin">Email</label> <input
								class="form-control form-control-lg" id="userLogin" type="text"
								aria-label="Usuáio" placeholder="Email" name="emailpedido">
						</div>

						<div class="form-group ls-login-password texte-white">
							<label for="userPassword" class="userPassword">Senha</label> <input
								class="form-control form-control-lg" id="userPassword"
								type="password" aria-label="Senha" placeholder="Senha" name="senhapedido">
						</div>
                         
                         <input type="hidden" name="empresa" value="<%= empresa %>">
                         
					
						


							<div class= "mb-3">
                           <input type="submit" class="btn btn-primary" value="Entrar">
                           <p style="background-color: white;">
                           <% 
                           if(erro !=null){
                           
                            out.print(erro);
                           }
                           %>
                           </p>
                           
                           
                           </div>
						   </form>

						</div>

						<a href="RecuperarSenhaCliente.jsp?empresapedido=<%= empresa %>" class="ls-login-forgot">Esqueci minha senha</a>

                       


					</div>
				</div>
			</div>
		</div>
	

	
</body>
</html>