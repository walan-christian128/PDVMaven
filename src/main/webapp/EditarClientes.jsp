<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Editar Clientes</title>
<link rel="icon"
	href="img/2992655_click_computer_currency_dollar_money_icon.png">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.css" />
</head>
<h1>Editar Clientes</h1>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">
	<%@ include file="menu.jsp"%>
<div id="form-container"
	class="form-control form-control-sm m-0 d-flex ">

	<div class="modal-header"></div>
	<div class="modal-body">
		<div id="form-container" class="form-control form-control-sm m-0 ">

			<form action="atualizarClientes" method="post">


				<div class="mb-3">
					<label for="id" class="form-label">Código</label> <input
						type="text" id="id" class="form-control" name="id" required
						value="<%out.print(request.getAttribute("id"));%>" disabled>
				</div>
				<input type="hidden" name="id" value="<%out.print(request.getAttribute("id"));%>">
				


				<div class="mb-3">

					<label for="nome" class="form-label">Nome:</label> <input
						type="text" id="nome" class="form-control" name="nome" required
						value="<%out.print(request.getAttribute("nome"));%>">
				</div>

				<div class="mb-3">
					<label for="cpf" class="form-label">Cpf:</label> <input type="text"
						id="cpf" class="form-control" name="cpf" required
						value="<%out.print(request.getAttribute("cpf"));%>">
				</div>
				<div class="mb-3">
					<label for="email" class="form-label">Email:</label> <input
						type="text" id="email" class="form-control" name="email" required
						value="<%out.print(request.getAttribute("email"));%>">
				</div>
				<div class="mb-3">
					<label for="celular" class="form-label">Celular/Whats:</label> <input
						type="text" class="form-control cel-sp-mask"
						placeholder="Ex.: (00) 00000-0000" id="celular" name="celular"
						value="<%out.print(request.getAttribute("celular"));%>">
				</div>
				<div class="mb-3">
					<label for="telefone" class="form-label">Telefone:</label> <input
						type="text" id="telefone" name="telefone"
						class="form-control cel-sp-mask"
						placeholder="Ex.: (00) 0000-0000"
						value="<%out.print(request.getAttribute("telefone"));%>">
				</div>
				<div class="mb-3">
					<label for="cep" class="form-label">CEP:</label> <input type="text"
						class="form-control"
						placeholder="Presione ENTER para pesquisar CEP automaticamente"
						id="cep" name="cep" required
						value="<%out.print(request.getAttribute("cep"));%>">
				</div>
				<div class="mb-3">
					<label for="endereco" class="form-label">Endereço:</label> <input
						type="text" class="form-control" id="endereco" name="endereco"
						value="<%out.print(request.getAttribute("endereco"));%>">
				</div>
				<div class="mb-3">
					<label for="numero" class="form-label">N°:</label> <input
						type="text" class="form-control" id="numero" name="numero"
						value="<%out.print(request.getAttribute("numero"));%>">
				</div>
				<div class="mb-3">
					<label for="bairro" class="form-label">Bairro:</label> <input
						type="text" class="form-control" id="bairro" name="bairro"
						value="<%out.print(request.getAttribute("bairro"));%>">
				</div>
				<div class="mb-3">
					<label for="cidade" class="form-label">Cidade:</label> <input
						type="text" class="form-control" id="cidade" name="cidade"
						value="<%out.print(request.getAttribute("cidade"));%>">
				</div>
				<div class="mb-3">
					<label for="complemento" class="form-label">Complemento:</label> <input
						type="text" class="form-control" id="complemento"
						name="complemento"
						value="<%out.print(request.getAttribute("complemento"));%>"
						required>
				</div>
				<div class="mb-3">
					<label for="fornecedor" class="form-label">Estado:</label> <select
						name="estado" class="form-select" id="estado">
						<option value="">Selecione o Estado</option>
						<option value="AC"
							<%if ("AC".equals(request.getAttribute("estado")))
	out.print("selected");%>>Acre</option>
						<option value="AL"
							<%if ("AL".equals(request.getAttribute("estado")))
	out.print("selected");%>>Alagoas</option>
						<option value="AP"
							<%if ("AP".equals(request.getAttribute("estado")))
	out.print("selected");%>>Amapá</option>
						<option value="AM"
							<%if ("AM".equals(request.getAttribute("estado")))
	out.print("selected");%>>Amazonas</option>
						<option value="BA"
							<%if ("BA".equals(request.getAttribute("estado")))
	out.print("selected");%>>Bahia</option>
						<option value="CE"
							<%if ("CE".equals(request.getAttribute("estado")))
	out.print("selected");%>>Ceará</option>
						<option value="DF"
							<%if ("DF".equals(request.getAttribute("estado")))
	out.print("selected");%>>Distrito
							Federal</option>
						<option value="ES"
							<%if ("ES".equals(request.getAttribute("estado")))
	out.print("selected");%>>Espírito
							Santo</option>
						<option value="GO"
							<%if ("GO".equals(request.getAttribute("estado")))
	out.print("selected");%>>Goiás</option>
						<option value="MA"
							<%if ("MA".equals(request.getAttribute("estado")))
	out.print("selected");%>>Maranhão</option>
						<option value="MT"
							<%if ("MT".equals(request.getAttribute("estado")))
	out.print("selected");%>>Mato
							Grosso</option>
						<option value="MS"
							<%if ("MS".equals(request.getAttribute("estado")))
	out.print("selected");%>>Mato
							Grosso do Sul</option>
						<option value="MG"
							<%if ("MG".equals(request.getAttribute("estado")))
	out.print("selected");%>>Minas
							Gerais</option>
						<option value="PA"
							<%if ("PA".equals(request.getAttribute("estado")))
	out.print("selected");%>>Pará</option>
						<option value="PB"
							<%if ("PB".equals(request.getAttribute("estado")))
	out.print("selected");%>>Paraíba</option>
						<option value="PR"
							<%if ("PR".equals(request.getAttribute("estado")))
	out.print("selected");%>>Paraná</option>
						<option value="PE"
							<%if ("PE".equals(request.getAttribute("estado")))
	out.print("selected");%>>Pernambuco</option>
						<option value="PI"
							<%if ("PI".equals(request.getAttribute("estado")))
	out.print("selected");%>>Piauí</option>
						<option value="RJ"
							<%if ("RJ".equals(request.getAttribute("estado")))
	out.print("selected");%>>Rio
							de Janeiro</option>
						<option value="RN"
							<%if ("RN".equals(request.getAttribute("estado")))
	out.print("selected");%>>Rio
							Grande do Norte</option>
						<option value="RS"
							<%if ("RS".equals(request.getAttribute("estado")))
	out.print("selected");%>>Rio
							Grande do Sul</option>
						<option value="RO"
							<%if ("RO".equals(request.getAttribute("estado")))
	out.print("selected");%>>Rondônia</option>
						<option value="RR"
							<%if ("RR".equals(request.getAttribute("estado")))
	out.print("selected");%>>Roraima</option>
						<option value="SC"
							<%if ("SC".equals(request.getAttribute("estado")))
	out.print("selected");%>>Santa
							Catarina</option>
						<option value="SP"
							<%if ("SP".equals(request.getAttribute("estado")))
	out.print("selected");%>>São
							Paulo</option>
						<option value="SE"
							<%if ("SE".equals(request.getAttribute("estado")))
	out.print("selected");%>>Sergipe</option>
						<option value="TO"
							<%if ("TO".equals(request.getAttribute("estado")))
	out.print("selected");%>>Tocantins</option>
						<option value="EX"
							<%if ("EX".equals(request.getAttribute("estado")))
	out.print("selected");%>>Estrangeiro</option>
					</select>


					<button type="button" class="btn btn-primary"
						data-bs-toggle="modal" data-bs-target="#exampleModal">
						Salvar</button>
				</div>
				<div class="modal fade" tabindex="-1" id="exampleModal">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title">Editar Cliente</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<p>Deseja Realmente Editar Esse Cliente?</p>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary"
									data-bs-dismiss="modal">Não</button>
								<button type="submit" class="btn btn-primary">Sim</button>
							</div>
						</div>
					</div>
				</div>




			</form>


		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
	<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script>

</div>
</body>

<script type="text/javascript">
	$(document).ready(function() {
		$('#telefone').mask('(00) - 0000-0000');
		$('#celular').mask('(00) - 00000-0000');
		$('#cep').mask('00.000-000');
		$('#cpf').mask('000.000.000-00');
	});
</script>
<script>
	$(document).ready(function() {
		$("#cep").on("keypress", function(e) {
			if (e.which == 13) { // Verifica se a tecla pressionada é Enter
				e.preventDefault(); // Previne o comportamento padrão de envio do formulário

				var numCep = $("#cep").val().replace(".", "").replace("-", ""); // Remover formatação do CEP
				var url = "https://viacep.com.br/ws/" + numCep + "/json";

				console.log("CEP digitado: " + numCep);

				$.ajax({
					url : url,
					type : "get",
					dataType : "json",
					success : function(dados) {
						console.log("Resposta da API:", dados);
						$("#estado").val(dados.uf);
						$("#cidade").val(dados.localidade);
						$("#endereco").val(dados.logradouro);
						$("#bairro").val(dados.bairro);
					},
					error : function(xhr, status, error) {
						console.log("Erro na solicitação AJAX:", error);
					}
				});
			}
		});
	});
</script>