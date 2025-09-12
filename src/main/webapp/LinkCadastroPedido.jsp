<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Link de envio</title>
<link rel="icon"
	href="img/2992655_click_computer_currency_dollar_money_icon.png">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

  <%@ include file="menu.jsp"%>
	<div class="container mt-4">
		<h1 class="">Link</h1>
		<form name="link" action="linkPedido" class="container mb-3">
			<h2>Link de acesso temporário:</h2>
			<div class="mb-1">
				<label for="id" class="form-label">Link:</label> 
				<input type="text" class="form-control" name="token" id="token" 
					value="<%out.print(request.getAttribute("token") != null ? request.getAttribute("token") : "");%>" readonly>
			</div>

			<div>
				<input type="submit" class="btn btn-primary" value="Gerar">
			</div>
		</form>
		
		<div class="d-flex">
			<button class="btn btn-warning" onclick="copiarLink()">Copiar Link</button>
		</div>
	</div>

	<script>
		function copiarLink() {
			let campoToken = document.getElementById("token"); // Pega o campo do input
			let link = campoToken.value; // Obtém o valor do input
			if (link) {
				navigator.clipboard.writeText(link).then(() => {
					alert("Link copiado!");
				}).catch(err => {
					alert("Erro ao copiar o link: " + err);
				});
			} else {
				alert("Nenhum link disponível para copiar!");
			}
		}
	</script>

</body>
</html>
