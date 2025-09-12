<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String empresa = request.getParameter("empresa");
if (empresa != null) {
    session.setAttribute("empresa", empresa);
} else {
    empresa = (String) session.getAttribute("empresa"); // recupera caso seja recarregada
}

%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Recuperação de Senha</title>
<link rel="icon"
	href="img/2992655_click_computer_currency_dollar_money_icon.png">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<style>
body {
	background-image:
		url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg');
	background-size: cover;
	background-position: center;
	background-repeat: no-repeat;
	margin: 0;
	padding: 0;
}

.form-container {
	max-width: 400px;
}

.card {
	border: none;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	background-color: rgba(255, 255, 255, 0.9);
}

/* Garante que o spinner esteja escondido por padrão */
#loadingSpinner {
	display: none;
}
</style>
</head>
<body class="d-flex justify-content-center align-items-center vh-100">

	<div class="card p-4 form-container">
		<h1 class="text-center mb-4">Redefinir Senha</h1>
		<form name="redefinirSenha" id="redefinirSenhaForm" action="alteraSenha" method="get">

			<%-- Mensagens de sucesso ou erro --%>
			<c:if test="${not empty ok}">
				<div class="alert alert-success text-center" role="alert">
					<c:out value="${ok}" />
				</div>
			</c:if>

			<c:if test="${not empty erro}">
				<div class="alert alert-danger text-center" role="alert">
					<c:out value="${erro}" />
				</div>
			</c:if>

			<%-- Campos ocultos para email e empresa --%>
			<input type="hidden" name="email" value="${param.email}">
			<input type="hidden" name="empresa" value="${param.empresa}">

			<div class="form-floating mb-3">
				<input type="password" class="form-control" name="novaSenha" id="novaSenha" required>
				<label for="novaSenha">Nova Senha</label>
			</div>

			<div class="form-floating mb-3">
				<input type="password" class="form-control" name="confirmarSenha" id="confirmarSenha" required>
				<label for="confirmarSenha">Confirmação da Senha</label>
			</div>

			<div class="d-grid gap-2">
				<button type="submit" class="btn btn-primary btn-lg" id="submitButton">Alterar Senha</button>
			</div>
		</form>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		// Script para validar se as senhas coincidem
		document.getElementById('redefinirSenhaForm').addEventListener('submit', function(event) {
			const novaSenha = document.getElementById('novaSenha').value;
			const confirmarSenha = document.getElementById('confirmarSenha').value;
			
			if (novaSenha !== confirmarSenha) {
				event.preventDefault(); // Impede o envio do formulário
				alert('As senhas não coincidem. Por favor, digite novamente.');
				document.getElementById('confirmarSenha').focus();
			}
		});
	</script>
</body>
</html>