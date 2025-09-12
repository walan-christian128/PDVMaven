<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Model.Fornecedores"%>
<%@ page import="DAO.FornecedoresDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%
String empresa = (String) session.getAttribute("empresa");
if (empresa == null || empresa.isEmpty()) {
    RequestDispatcher rd = request.getRequestDispatcher("LoginExpirou.html");
    rd.forward(request, response);
    return; // Certifique-se de que o código pare de executar após o redirecionamento
}

List<Fornecedores> lista; // Declara a lista
FornecedoresDAO dao = new FornecedoresDAO(empresa);
lista = dao.listaFornecedores();
%>
<%
Fornecedores obj = new Fornecedores();
%>



<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fornecedores</title>
<link rel="icon"
	href="img/2992655_click_computer_currency_dollar_money_icon.png">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.css" />
<style>
/* Estilizando o link para remover a sublinhado e alterar a cor */
td a {
	text-decoration: none; /* Remove o sublinhado */
	color: inherit; /* Mantém a cor do texto padrão */
	cursor: pointer; /* Altera o cursor para indicar que é clicável */
}
</style>
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">
 
	<%@ include file="menu.jsp"%>
	<div id="container" class="d-flex container-fluid ">

		<!-- Formulário -->
		<div id="form-container" class="form-control form-control-sm m-0 text-dark">
			<h2>Cadastro/Edição de Fornecedores</h2>
			<form action="insertFornecedor" name="cadastroFornecedores"
				method="post" class="form-inline needs-validation" id="cadastroFornecedores">


				<div class="mb-3">
					<label for="id" class="form-label">Código</label> <input
						type="text" id="id" class="form-control " name="id" disabled>
				</div>
				
				
				


				<div class="mb-3">

					<label for="nome" class="form-label">Nome:</label> <input
						type="text" id="nome" class="form-control" name="nome" required>
						
						<div class="invalid-feedback">Campo Obrigatório</div>
				</div>
				

				<div class="mb-3">
					<label for="cnpj" class="form-label">Cnpj:</label> <input
						type="text" id="cnpj" class="form-control" name="cnpj" required>
				</div>
				<div class="mb-3">
					<label for="email" class="form-label">Email:</label> <input
						type="text" id="email" class="form-control" name="email" required>
				</div>
				<div class="mb-3">
					<label for="celular" class="form-label">Celular/Whats:</label> <input
						type="text" class="form-control cel-sp-mask"
						placeholder="Ex.: (00) 00000-0000" id="celular" name="celular">
				</div>
				<div class="mb-3">
					<label for="telefone" class="form-label">Telefone:</label> <input
						type="text" id="telefone" name="telefone"
						class="form-control cel-sp-mask"
						placeholder="Ex.: (00) 00000-0000">
				</div>
				<div class="mb-3">
					<label for="cep" class="form-label">CEP:</label> <input type="text"
						class="form-control"
						placeholder="Presione ENTER para pesquisar CEP automaticamente"
						id="cep" name="cep" required>
				</div>
				<div class="mb-3">
					<label for="endereco" class="form-label">Endereço:</label> <input
						type="text" class="form-control" id="endereco" name="endereco">
				</div>
				<div class="mb-3">
					<label for="numero" class="form-label">N°:</label> <input
						type="text" class="form-control" id="numero" name="numero">
				</div>
				<div class="mb-3">
					<label for="bairro" class="form-label">Bairro:</label> <input
						type="text" class="form-control" id="bairro" name="bairro">
				</div>
				<div class="mb-3">
					<label for="cidade" class="form-label">Cidade:</label> <input
						type="text" class="form-control" id="cidade" name="cidade">
				</div>
				<div class="mb-3">
					<label for="complemento" class="form-label">Complemento:</label> <input
						type="text" class="form-control" id="complemento"
						name="complemento" required>
				</div>
				<div class="mb-3">
					<label for="fornecedor" class="form-label">Estado:</label> <select
						name="estado" class="form-select" id="estado">
						<option value="">Selecione o Estado</option>
						<option value="AC">Acre</option>
						<option value="AL">Alagoas</option>
						<option value="AP">Amapá</option>
						<option value="AM">Amazonas</option>
						<option value="BA">Bahia</option>
						<option value="CE">Ceará</option>
						<option value="DF">Distrito Federal</option>
						<option value="ES">Espírito Santo</option>
						<option value="GO">Goiás</option>
						<option value="MA">Maranhão</option>
						<option value="MT">Mato Grosso</option>
						<option value="MS">Mato Grosso do Sul</option>
						<option value="MG">Minas Gerais</option>
						<option value="PA">Pará</option>
						<option value="PB">Paraíba</option>
						<option value="PR">Paraná</option>
						<option value="PE">Pernambuco</option>
						<option value="PI">Piauí</option>
						<option value="RJ">Rio de Janeiro</option>
						<option value="RN">Rio Grande do Norte</option>
						<option value="RS">Rio Grande do Sul</option>
						<option value="RO">Rondônia</option>
						<option value="RR">Roraima</option>
						<option value="SC">Santa Catarina</option>
						<option value="SP">São Paulo</option>
						<option value="SE">Sergipe</option>
						<option value="TO">Tocantins</option>
						<option value="EX">Estrangeiro</option>
					</select> <input class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#confirmacaoModal" type="button" value="Salvar">
                        <div class="modal fade" tabindex="-1" id="confirmacaoModal">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<h5 class="modal-title">Inserir Fornecedor</h5>
												<button type="button" class="btn-close"
													data-bs-dismiss="modal" aria-label="Close"></button>
											</div>
											<div class="modal-body">
												<p>Deseja Realmente Inserir Esse Fornecedor?</p>
											</div>
											<div class="modal-footer">
												<button type="button" class="btn btn-secondary"
													data-bs-dismiss="modal">Não</button>
												<input type="submit"
													class="btn btn-primary" value="Sim"
													>
											</div>
										</div>
									</div>
								</div>









				</div>



			</form>

		</div>
		<div class="container ">
			<div>
				<label for="pesquisa" class="form-label ">Pesquisa</label> <input
					type="text" class="col-md-3 d-flex align-items-center form-control"
					id="pesquisa" name="pesquisa"
					placeholder="Pesquisar fornecedor pelo nome">
				<div id="tables-container" class="container-sm">
					<div id="table-container" class="container-sm">
						<table id="tabela"class="table table-dark table-striped-columns table-hover">
							<thead>
								<h2>Fornecedores Cadastrados</h2>

								<tr>
									<th scope="col">Código</th>
									<th scope="col">Nome</th>
									<th scope="col">Cnpj</th>
									<th scope="col">CEP</th>
									<th scope="col">Email</th>
									<th scope="col">Cel/Whats</th>
									<th scope="col">Telefone</th>
									<th scope="col">Endereço</th>
									<th scope="col">N°</th>
									<th scope="col">Bairro</th>
									<th scope="col">Cidade</th>
									<th scope="col">Estado</th>
									<th scope="col">Complemento</th>
									<th scope="col">Opções</th>

								</tr>
							</thead>
							<tbody>
								<%
								for (int i = 0; i < lista.size(); i++) {
								%>
								<tr id="row<%=lista.get(i).getId()%>" class="linha-editar"
									data-id="<%=lista.get(i).getId()%>">
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getId()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>" ><%=lista.get(i).getNome()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getCnpj()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getCep()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getEmail()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getCelular()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getTelefone()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getEndereco()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getNumero()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getBairro()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getCidade()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getUf()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>"><%=lista.get(i).getComplemento()%></a></td>
									<td><a href="selectFornecedor?id=<%=lista.get(i).getId()%>" type="button" class="btn btn-success d-flex" name="btnEditar">Editar</a>
										<a type="button" class="btn btn-danger d-flex" data-bs-toggle="modal" data-bs-target="#exampleModal<%= i %>">Apagar</a></td>
									




								</tr>
								<div class="modal fade" tabindex="-1" id="exampleModal<%= i %>">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<h5 class="modal-title">Editar Fornecedor</h5>
												<button type="button" class="btn-close"
													data-bs-dismiss="modal" aria-label="Close"></button>
											</div>
											<div class="modal-body">
												<p>Deseja Realmente Apagar Esse Fornecedor?</p>
												<h6>"NOTA" : SE VOCÊ ESTA TENTANDO APAGAR UM FORNECEDOR NO QUAL JA ESTA VINCULADO UM PRODUTO NÃO SERA POSSIVEL "REALIZAR SUA EXCLUSÃO". REALIZE UM NOVO CADASTRO SE POSSIVEL</h6>
											</div>
											<div class="modal-footer">
												<button type="button" class="btn btn-secondary"
													data-bs-dismiss="modal">Não</button>
												<a href="apagar?id=<%=lista.get(i).getId()%>" type="button"
													class="btn btn-primary" name="btnCadastrar"
													id="btnCadastrar">Sim</a>
											</div>
										</div>
									</div>
								</div>
								<%
								}
								%>

							</tbody>
						</table>

					</div>

				</div>
			</div>
  </div>
  </div>





			<!-- Modal -->
			<div class="modal fade" id="exampleModal" tabindex="-1"
				aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered"></div>
			</div>
			<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
			<script
				src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
			<script
				src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
			<script
				src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
			<script
				src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>
			<script
				src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script>
				<script>
    $(document).ready(function(){
        // Event delegation para a tabela toda
        $('#tabela').on('click', '.btn-apagar', function(){
            var id = $(this).closest('tr').data('id');
            // Abre o modal de confirmação
            $('#exampleModal').modal('show');
            // Passa o ID para o botão de confirmar exclusão
            $('#confirmarApagar').data('id', id);
        });

        // Função para apagar a linha
        $('#confirmarApagar').click(function(){
            var id = $(this).data('id');
            // Remove a linha da tabela
            $('#row' + id).remove();
            // Fecha o modal
            $('#exampleModal').modal('hide');
        });
    });
</script>
<script>
$(document).ready(function() {
    $("#cep").on("keypress", function(e) {
        if (e.which == 13) {  // Verifica se a tecla pressionada é Enter
            e.preventDefault(); // Previne o comportamento padrão de envio do formulário

            var numCep = $("#cep").val().replace(".", "").replace("-", ""); // Remover formatação do CEP
            var url = "https://viacep.com.br/ws/"+numCep+"/json";

            console.log("CEP digitado: " + numCep);

            $.ajax({
                url: url,
                type: "get",
                dataType: "json",
                success: function(dados) {
                    console.log("Resposta da API:", dados);
                    $("#estado").val(dados.uf);
                    $("#cidade").val(dados.localidade);
                    $("#endereco").val(dados.logradouro);
                    $("#bairro").val(dados.bairro);
                },
                error: function(xhr, status, error) {
                    console.log("Erro na solicitação AJAX:", error);
                }
            });
        }
    });
});
</script>
<script type="text/javascript">
    $(document).ready(function(){
      $('#telefone').mask('(00) - 0000-0000');
      $('#celular').mask('(00) - 00000-0000');
      $('#cep').mask('00.000-000');
      $('#cnpj').mask('00.000.000/0000-00');
      });
</script>
<script>
    // Verificar a validade do formulário ao enviar
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })();

    // Verificar validade dos campos no botão "Adicionar item"
    document.getElementById("addItemBtn").addEventListener("click", function (event) {
        var form = document.getElementById('cadastroFornecedores');
        if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
        }
        form.classList.add('was-validated');
    });
</script>
</body>
</html>
