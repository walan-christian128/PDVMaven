<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
		<h1 class="text-center mb-4">Recuperação de Senha</h1>
	<form name="recuperarSenha" id="recuperarSenhaForm" action="RecuperaSenhaServlet" method="post">

			<c:if test="${not empty sucesso}">
				<div class="alert alert-success text-center" role="alert">
					<c:out value="${sucesso}" />
				</div>
			</c:if>

			<c:if test="${not empty erro}">
				<div class="alert alert-danger text-center" role="alert">
					<c:out value="${erro}" />
				</div>
			</c:if>

			<div class="form-floating mb-3">
				<input type="email" class="form-control" name="email" id="email"
					placeholder="nome@exemplo.com" required> <label for="email">Email</label>
			</div>

			<div class="form-floating mb-3">
				<input type="text" class="form-control" name="empresa" id="empresa"
					placeholder="Sua Empresa" required> <label for="empresa">Empresa</label>
			</div>

			<div class="d-grid gap-2">
				<button type="submit" class="btn btn-primary btn-lg"
					id="submitButton">Enviar</button>
			</div>

			
		</form>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>



</body>
</html>