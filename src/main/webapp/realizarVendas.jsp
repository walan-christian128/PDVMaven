<%@ page import="org.json.JSONObject, org.json.JSONArray"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="Model.Clientes"%>
<%@ page import="Model.Produtos"%>
<%@ page import="DAO.ClientesDAO"%>
<%@ page import="DAO.VendasDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
Date dataAtual = new Date();
SimpleDateFormat formatoData = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); // Escolha o formato desejado
String  dataAtualFormatada = formatoData.format(dataAtual);

String empresa = (String) session.getAttribute("empresa");
if (empresa == null || empresa.isEmpty()) {
	RequestDispatcher rd = request.getRequestDispatcher("LoginExpirou.html");
	rd.forward(request, response);
	return; // Certifique-se de que o código pare de executar após o redirecionamento
}

if (session.getAttribute("empresaId") == null) {
    String empresaIdStr = request.getParameter("empresaId");
    if (empresaIdStr != null && !empresaIdStr.isEmpty()) {
        session.setAttribute("empresaId", Integer.parseInt(empresaIdStr));
    }
}
Integer empresaId = (Integer) session.getAttribute("empresaId");

%>
<%
Date agora = new Date();
SimpleDateFormat dataEUA = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String datamysql = dataEUA.format(agora);
%>
<%
Clientes clientes = new Clientes();
%>
<%
Produtos produtos = new Produtos();
%>
<%
HttpSession session_2 = request.getSession();
JSONArray itensArray = (JSONArray) session.getAttribute("itens");

String showModal = request.getParameter("showModal");
String vendaIDParam = request.getParameter("vendaID");

VendasDAO dao = new VendasDAO(empresa);

%>


<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>Venda</title>
<link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
	crossorigin="anonymous">

</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">
     
	<%@ include file="menu.jsp"%>
	<main class="container d-flex h-auto d-inline-block d-flex">
		<div class="row col-md-9 mt-n3 d-flex">
			<!-- Formulário de Cliente -->
			<form id="buscarClienteForm" class="row g-3 needs-validation"
				novalidate action="selecionarClienteProdutos" method="POST">
				<div id="Cliente">
					<div class="col-md-8">
						<h2>Cliente</h2>
						<div class="row">
							<div class="col-md-6">
								<label for="cliId" class="form-label">Codigo: </label> <input
									type="text" class="form-control " id="cliId" name="cliId"
									required
									value="<%=request.getAttribute("cliId") != null ? request.getAttribute("cliId").toString() : ""%>"
									readonly>
								<div class="invalid-feedback">Código é obrigatório.</div>


							</div>
							<div class="col-md-6">
								<label for="dataProd" class="form-label d-flex">Data: </label> <input
									type="text" class="form-control d-flex "
									value="<%=dataAtualFormatada%>" disabled name="data">
							</div>
						</div>
						<div>
							<label for="cliNome" class="form-label">Nome: </label> <input
								type="text" class="form-control " id="cliNome" name="cliNome"
								required
								value="<%=request.getAttribute("cliNome") != null ? request.getAttribute("cliNome").toString() : ""%>"
								 placeholder="PESQUISA CLIENTE">
								
								<div id="sugestoescli" class="list-group position-absolute w-100" style="z-index: 500;"></div>
						</div>
						<div class="col-md-6">
							<label for="validationCustom01" class="form-label">CPF: </label>
							<input type="text" class="form-control" id="cliCpf" name="cliCpf"
								required
								value="<%=request.getAttribute("cliCpf") != null ? request.getAttribute("cliCpf").toString() : ""%><%clientes.getCpf();%>">
							<div class="invalid-feedback">CPF Obrigatorio</div>
						</div>
						<div class="col-md-6">
							<label for="cliEndereco" class="form-label">Endereço: </label> <input
								type="text" class="form-control " id="cliEndereco"
								name="cliEndereco" required
								value="<%=request.getAttribute("cliEndereco") != null ? request.getAttribute("cliEndereco").toString() : ""%>"
								readonly>
						</div>
						<div class="col-md-2">
							<label for="cliNumero" class="form-label">N°: </label> <input
								type="text" class="form-control" id="cliNumero" name="cliNumero"
								required
								value="<%=request.getAttribute("cliNumero") != null ? request.getAttribute("cliNumero").toString() : ""%>"
								readonly>
						</div>
						<div></div>
					</div>
					<div class="form-check mb-3">
						<input class="form-check-input" type="checkbox"
							id="semClienteCheckbox" onclick="toggleClienteFields(this)">
						<label class="form-check-label" for="semClienteCheckbox">
							Sem Cliente </label>
					</div>
				</div>
				<div id="Produtos">
					<div class="col-md-8">
						<h2>Produto</h2>
						<div class="col-md-6">
							<label for="validationCustom02" class="form-label">Codigo:
							</label> <input type="text" class="form-control " id="idProd"
								name="idProd" required
								value="<%=request.getAttribute("idProd") != null ? request.getAttribute("idProd").toString() : ""%><%produtos.getId();%>" readonly>
							<div class="invalid-feedback">Codigo do Produto é
								obrigatório.</div>
						</div>
						<div class="col-md-6 position-relative">
							<label for="desProd" class="form-label">Descrição:</label> <input
								type="text" class="form-control" id="desProd" name="desProd"
								required
								value="<%=request.getAttribute("desProd") != null ? request.getAttribute("desProd").toString() : ""%>" autocomplete="off" placeholder="PESQUISAR PRODUTO">
                                 
							<div id="sugestoes" class="list-group position-absolute w-100" style="z-index: 1000;"></div>
						</div>



						<div class="row">
							<div class="col-md-6">
								<label for="precoProd" class="form-label">Preço: </label> <input
									type="text" class="form-control " id="precoProd"
									name="precoProd" required
									value="<%=request.getAttribute("precoProd") != null ? request.getAttribute("precoProd").toString() : ""%>"
									readonly>
							</div>
							<div class="col-md-6">
								<label for="qtdProd" class="form-label">QTD: </label> <input
									type="number" class="form-control " id="qtdProd" name="qtdProd"
									value="<%=request.getAttribute("qtdProd") != null ? request.getAttribute("qtdProd").toString() : ""%>">

							</div>
						</div>
						<div class="col-md-6">


							<label for="compraProd" class="form-label">Meu Preço:</label> <input
								type="text" class="form-control " id="compraProd"
								name="compraProd" required
								value="<%=request.getAttribute("compraProd") != null ? request.getAttribute("compraProd").toString() : ""%>"
								readonly>

						</div>
						<div class="d-flex justify-content-between">
							<input class="btn btn-primary mt-3" type="submit"
								value="Pesquisar">
							<button type="submit" class="btn btn-danger mt-3" id="addItemBtn"
								value="<%=session.getAttribute("itens")%>">Adicionar
								item</button>

						</div>
						<div class="d-flex col-md-6"></div>
					</div>
				</div>

			</form>

		</div>

		<div class="row col-md-5 p-3 mb-2 bg-dark text-white ">

			<div class="p-3 bg-dark">



				<form action="inserirItens" method="post" name="carrinho">
					<h2 class="d-flex justify-content-center">Itens Da Venda</h2>
					<div>
						<table class="table table-danger table-hover table-bordered border-dark" id="carrinho">
							<thead>
								<tr>
									<th>Codigo</th>
									<th>Produto</th>
									<th>Quantidade</th>
									<th>Preço</th>
									<th>Subtotal</th>
								</tr>
							</thead>
							<tbody>
								<%
								// Obtendo a lista de itens da sessão

								if (itensArray != null) {
									for (int i = 0; i < itensArray.length(); i++) {
										JSONObject itemJson = itensArray.getJSONObject(i);
								%>
								<tr>
									<td><%=itemJson.getString("idProd")%></td>
									<td><%=itemJson.getString("desProd")%></td>
									<td><%=itemJson.getString("qtdProd")%></td>
									<td><%=itemJson.getString("precoProd")%></td>
									<td><%=itemJson.getString("subtotal")%></td>
								</tr>
								<%
								}
								}
								%>
							</tbody>
						</table>

					</div>
				</form>
				<div class="d-flex justify-content-between"></div>


			</div>

			<div>
				<a href="detroyLista.jsp" type="button" class="btn btn-danger">Limpar
					Lista</a>


			</div>


			<form action= "desconto"class ="d-flex" id="formDescont" method="post">
			<div class=" col-md-3">
				<label class="form-label">Total Venda:</label> <input
					id="totalVenda" type="text" class="form-control" name="totalVendaAtualizado"
					value="0.00">


			</div>
				

				<div class=" col-md-3">
				<label class="form-label">Desconto:</label> <input type="text"
					class="form-control" name="desconto"
					value="<%=request.getAttribute("desconto") != null ? request.getAttribute("desconto").toString() : "0.00"%>"
					id="desconto">
			</div>
				
			</form>
			  
			<div>
				<button type="button" class="btn btn-primary" data-bs-toggle="modal"
					data-bs-target="#confirmacaoModal">Pagamento</button>

				<input type="button" class="btn btn-danger" value="Desconto"
					id="descontoBtn"> <a type="button" class="btn btn-warning"
					href="#" data-bs-toggle="modal" data-bs-target="#CancelarVenda">Cancelar
					Venda</a>
			</div>

		</div>
<form action="InseirVendaEintens" id="modalVendas" method="get">
	<div class="modal fade" tabindex="-1" id="confirmacaoModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Pagamento</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div>

						<!-- O VALOR DA OPÇÃO 'PIX' FOI ALTERADO PARA 'MERCADOPAGO' -->
						<select class="form-select" name="formaPagamento" id="formaPagamento">
							<option value="">Selecione a Opçao de pagamento</option>
							<option value="Dinheiro">Dinheiro</option>
							<option value="Crédito">Crédito</option>
							<option value="Débito">Débito</option>
							<option value="MERCADOPAGO">Mercado Pago (Pix, Crédito, etc.)</option>
							<option value="Anotado">Anotado</option>
						</select>

								

								<div class="col-md-3">
							<label class="form-label">Valor: </label> <input type="text"
								class="form-control ml-1" id="pegardoTotal"
								value="0.00"
								name="iserirtotal">
						</div>
						
						
						<div class="col-md-3" id="dinheiroRecebidoDiv">
							<label class="form-label">Dinheiro recebido: </label> <input
								type="text" class="form-control ml-1" id="dinheiroRecebido">
						</div>
						
						<div class="col-md-3" id="trocoDiv">
							<label class="form-label"> Troco: </label> <input type="text"
								class="form-control" id="trocoVenda" value="0.00"> <input
								type="button" class="btn btn-success" value="Confimar Troco"
								style="margin-top: 10px;" id="btn-troco">
						</div>

						<div class="col-md-6" id="observacaoDiv">
							<label class="form-label"> Observação: </label> <input
								type="text" class="form-control" id="observacao"
								name="observacao">
						</div>
					</div>

				</div>
				<div class="modal-footer">
					<h4 class="display-7">Deseja finalizar a venda ?</h4>
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Não</button>
					
					<!-- O BOTÃO DE SUBMISSÃO FOI ALTERADO PARA UM TIPO "submit" ADEQUADO -->
					<button type="submit" class="btn btn-primary">Sim</button>
				</div>

			</div>
		</div>
	</div>
	
	<!-- CAMPOS OCULTOS FORAM ORGANIZADOS E DUPLICAÇÕES REMOVIDAS -->
	<input type="hidden" name="cliId" value="${cliente.id}">
	<input type="hidden" name="observacao" value="Observação da venda">
	
	<!-- CORRIGIDO: FORMATANDO A DATA PARA O PADRÃO YYYY-MM-DD HH:MM:SS -->
	<input type="hidden" name="data" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %>">
	
	<input type="hidden" name="desconto"
		value="<%=request.getAttribute("desconto") != null ? request.getAttribute("desconto").toString() : "0.00"%>"
		id="desconto">

	<!-- OS CAMPOS ABAIXO JÁ ESTÃO NO FORMULÁRIO. REMOVA AS DUPLICAÇÕES SE NECESSÁRIO -->
	<input type="hidden" name="usuarioID">
	<input type="hidden" name="empresaId" value="1">



	<%
	if (itensArray != null) {
		for (int i = 0; i < itensArray.length(); i++) {
			JSONObject itemJson_3 = itensArray.getJSONObject(i);
	%>
	<input type="hidden" name="idProd" id="idProd"
		value="<%=itemJson_3.getString("idProd")%>"> <input
		type="hidden" name="qtdProd" id="qtdProd"
		value="<%=itemJson_3.getString("qtdProd")%>"> <input
		type="hidden" name="subtotal" id="subtotal"
		value="<%=itemJson_3.getString("subtotal")%>">
	<%
	}
	}
	%>

</form>
		      <!-- Modal para o relatório -->
		<div class="modal fade" tabindex="-1" id="comprovanteVenda"
			data-bs-backdrop="static" data-bs-keyboard="false">
			<div class="modal-dialog"
				style="min-width: 90%; min-height: 90%; height: 90%;">
				<div class="modal-content">
					<div class="modal-body">
						<!-- iframe aponta para a página JSP que carrega o relatório -->
						<iframe id="iframeRelatorio" src="relatorioVenda.jsp" width="100%"
							height="100%" style="border: none;"></iframe>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Fechar</button>
						<a type="button" class="btn btn-primary"
							onclick="document.getElementById('iframeRelatorio').contentWindow.print();">Imprimir</a>
					</div>
				</div>
			</div>
		</div>


		<div class="modal fade" tabindex="-1" id="CancelarVenda">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Deseja Cancelar a Venda ?</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body"></div>
					<div class="modal-footer">

						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Não</button>
						<a type="submit" class="btn btn-primary" href="detroyLista.jsp">Sim</a>

					</div>

				</div>
			</div>
		</div>
		
	</main>




	<!-- Bootstrap JavaScript Bundle com Popper -->
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
	<script>
		var totalValue = 0;
		var lucroValue = 0;
		var pegarTotal = 0;

		document
				.getElementById("addItemBtn")
				.addEventListener(
						"click",
						function() {
							// Obter os valores dos campos
							var idProd = document.getElementById("idProd").value;
							var desProd = document.getElementById("desProd").value;
							var qtdProd = document.getElementById("qtdProd").value;
							var precoProd = document
									.getElementById("precoProd").value;
							var meuPreco = document
									.getElementById("compraProd").value;
							var desconto = document
							.getElementById("desconto").value;
							

							// Verificar se os campos de entrada não estão vazios
							if (idProd && desProd && qtdProd && precoProd
									&& meuPreco) {
								// Converter os valores para números
								var quantidade = parseInt(qtdProd);
								var preco = parseFloat(precoProd);
								var precoCompra = parseFloat(meuPreco);

								// Verificar se os valores são números válidos
								if (!isNaN(quantidade) && !isNaN(preco)
										&& !isNaN(precoCompra) && !isNaN(desconto)) {
									// Calcular o subtotal
									var subtotalValue = quantidade * preco;
									var lucroUnitario = preco - precoCompra; // Calcular o lucro unitário
									var lucroCalculo = lucroUnitario
											* quantidade; // Calcular o lucro total

									// Criar um objeto com os dados do item
									var item = {
										idProd : idProd,
										desProd : desProd,
										qtdProd : qtdProd,
										precoProd : precoProd,
										compraProd: meuPreco,
										subtotal : subtotalValue,
										desconto : desconto
									};

									// Enviar os dados para o Servlet usando AJAX
									var xhr = new XMLHttpRequest();
									xhr.open("POST", "inserirItens", true);
									xhr.setRequestHeader("Content-Type",
											"application/json");
									xhr.onreadystatechange = function() {
										if (xhr.readyState == 4
												&& xhr.status == 200) {
											// Adicionar a nova linha à tabela após a resposta do Servlet
											var newRow = xhr.responseText;
											var tableBody = document
													.getElementById("carrinho")
													.getElementsByTagName(
															"tbody")[0];
											tableBody.insertAdjacentHTML(
													"beforeend", newRow);

											// Limpar os campos após adicionar o item
											document.getElementById("idProd").value = "";
											document.getElementById("desProd").value = "";
											document.getElementById("qtdProd").value = "";
											document
													.getElementById("precoProd").value = "";
											document
													.getElementById("compraProd").value = ""; // Limpar o campo de preço de compra

											// Atualizar o valor total da venda e o lucro
											var totalVendaInput = document
													.getElementById("totalVenda");
											totalVendaInput.value = parseFloat(totalVendaInput.value)
													+ subtotalValue;

											var lucroInput = document
													.getElementById("lucro");
											var lucroAtual = parseFloat(lucroInput.value);
											if (!isNaN(lucroAtual)) {
												lucroInput.value = lucroAtual
														+ lucroCalculo;
											}
										}
									};
									xhr.send(JSON.stringify(item));
								} else {
									alert("Por favor, insira valores numéricos válidos para quantidade, preço e preço de compra.");
								}
							} else {
								alert("Por favor, preencha todos os campos.");
							}
						});

		// Função para calcular o total da venda e o lucro
	
		// Função para calcular o total da venda e o lucro
		

		// Função para calcular o total da venda e o lucro
		function updateTotal(subtotalValue, lucroCalculo) {
			var totalValue = parseFloat(document.getElementById("totalVenda").value);
			var lucroValue = parseFloat(document.getElementById("lucro").value);

			totalValue += subtotalValue; // Adicionar o subtotal ao total
			lucroValue += lucroCalculo; // Adicionar o lucro ao total de lucro

			document.getElementById("totalVenda").value = totalValue.toFixed(2);
			document.getElementById("lucro").value = lucroValue.toFixed(2); // Exibir o lucro com duas casas decimais
		}

		
		
		// Função para mostrar ou ocultar os campos com base na opção selecionada
		function mostrarCampos() {
			var select = document.getElementById("formaPagamento");
			var dinheiroRecebidoDiv = document
					.getElementById("dinheiroRecebidoDiv");
			var trocoDiv = document.getElementById("trocoDiv");

			// Verifica se a opção selecionada é "Dinheiro"
			if (select.value === "Dinheiro") {
				dinheiroRecebidoDiv.style.display = "block"; // Mostra o campo "Dinheiro recebido"
				trocoDiv.style.display = "block"; // Mostra o campo "Troco"
			} else {
				dinheiroRecebidoDiv.style.display = "none"; // Oculta o campo "Dinheiro recebido"
				trocoDiv.style.display = "none"; // Oculta o campo "Troco"
			}
		}

		// Chama a função ao carregar a página e quando o valor do select mudar
		window.onload = mostrarCampos;
		document.getElementById("formaPagamento").addEventListener("change",
				mostrarCampos);

		function mostrarObservacao() {
			var select = document.getElementById("formaPagamento");
			var observacao = document.getElementById("observacaoDiv");

			// Verifica se a opção selecionada é "Dinheiro"
			if (select.value === "Anotado") {
				observacao.style.display = "block"; // Mostra o campo "observacao"
				// Mostra o campo "Troco"
			} else {
				observacao.style.display = "none";// Oculta o campo "observacao"
			}
		}

		// Chama a função ao carregar a página e quando o valor do select mudar
		window.onload = mostrarObservacao;
		document.getElementById("formaPagamento").addEventListener("change",
				mostrarObservacao);
	</script>

	<script>
		document.getElementById("addItemBtn").addEventListener("click",
				function() {
					// Fazer uma requisição AJAX para o servlet
					var xhr = new XMLHttpRequest();
					xhr.open("POST", "inserirItens", true);
					xhr.setRequestHeader("Content-Type", "application/json");
					xhr.onreadystatechange = function() {
						if (xhr.readyState === 4 && xhr.status === 200) {
							// A requisição foi bem-sucedida, você pode executar ações adicionais aqui se necessário
							console.log("Sessão atualizada com sucesso!");

						}
					};
					xhr.send();
				});
	</script>
	<script>
	document.getElementById("descontoBtn").addEventListener("click", function() {
	    var desconto = parseFloat(document.getElementById("desconto").value);
	    var totalValue = parseFloat(document.getElementById("totalVenda").value);
	    
	    if (!isNaN(desconto)) {
	        totalValue -= desconto;
	        document.getElementById("totalVenda").value = totalValue.toFixed(2);
	    } else {
	        alert("Por favor, insira um valor válido para o desconto.");
	    }
	});
	
	
	</script>
	<script>
     document.getElementById("desconto").addEventListener("input", function() {
     document.getElementById("vdesconto").value = this.value;
});
     document.getElementById("totalVenda").addEventListener("input", function() {
         document.getElementById("pegardoTotal").value = this.value;
    });
</script>
	<script>
document.getElementById("carrinho").addEventListener("click", function(event) {
    var row = event.target.parentNode.parentNode;
    var idProd = row.cells[0].innerText;
 
    var qtdProd = row.cells[2].innerText;
    
    var subtotal = row.cells[4].innerText;

    document.getElementById("idProd").value = idProd;
   
    document.getElementById("qtdProd").value = qtdProd;
   
    document.getElementById("subtotal").value = subtotal;

    // Adicione este trecho para enviar os valores qtdProd e subtotal para o servidor
    document.getElementById("qtdProdHidden").value = qtdProd;
    document.getElementById("subtotalHidden").value = subtotal;
});

});

</script>
	<script>
    document.getElementById("btn-troco").addEventListener("click", function() {
        var pegarTotal = parseFloat(document.getElementById("pegardoTotal").value);
        var dinheiroRecebido = parseFloat(document.getElementById("dinheiroRecebido").value);
        
        if (!isNaN(pegarTotal) && !isNaN(dinheiroRecebido)) {
            var troco = dinheiroRecebido - pegarTotal;
            document.getElementById("trocoVenda").value = troco.toFixed(2);
        } else {
            alert("Por favor, insira valores válidos.");
        }
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
        var form = document.getElementById('buscarClienteForm');
        if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
        }
        form.classList.add('was-validated');
    });
</script>
	<script>
    function toggleClienteFields() {
        var checkbox = document.getElementById('semClienteCheckbox');
        var clienteFields = [
            'cliId',
            'cliNome',
            'cliCpf',
            'cliEndereco',
            'cliNumero'
        ];

        clienteFields.forEach(function(fieldId) {
            var field = document.getElementById(fieldId);
            if (field) {
                field.disabled = checkbox.checked;
                if (checkbox.checked) {
                    field.value = ""; // Limpa o valor do campo
                    if (field.id === 'cliId') {
                        field.removeAttribute('name'); // Remove o name para evitar envio
                    }
                } else {
                    if (field.id === 'cliId') {
                        field.setAttribute('name', 'cliId'); // Reatribui o name
                    }
                }
            }
        });

        // Salva o estado do checkbox no localStorage
        localStorage.setItem('semClienteChecked', checkbox.checked);
    }

    // Função para restaurar o estado ao carregar a página
    window.onload = function() {
        var checkbox = document.getElementById('semClienteCheckbox');
        var semClienteChecked = localStorage.getItem('semClienteChecked');

        if (semClienteChecked !== null) {
            checkbox.checked = semClienteChecked === 'true';
            toggleClienteFields();
        }
    };
</script>

>

  
    <script>
    document.getElementById("confirmarPagamento").addEventListener("click", function() {
        // Submete o formulário manualmente
        document.getElementById("modalVendas").submit();
       
    });
  
    
    </script>
    <script >
    document.getElementById('comprovanteVenda').addEventListener('hidden.bs.modal', function () {
        document.getElementById('iframeRelatorio').src = '';
    });

    
    
    </script>
    <script>
    function submitFormAndShowModal() {
        // Seleciona o formulário de vendas
        const form = document.getElementById("modalVendas");
        const formData = new FormData(form);

        // Envia o formulário via AJAX
        fetch(form.action, {
            method: 'POST',
            body: formData,
        })
        .then(response => response.json()) // Supondo que o servlet retorna um JSON de confirmação
        .then(data => {
            if (data.success) { // Confirmação do backend
                // Chama o modal para exibir o relatório
                $('#confirmacaoModal').modal('hide'); // Biblioteca Bootstrap para modais
            } else {
                alert("Erro ao inserir a venda.");
            }
        })
        .catch(error => console.error("Erro na solicitação:", error));
    }

    
    </script>
   


	<script>
	document.getElementById("rel").addEventListener("click", function() {
	    // Abre o relatório em uma nova aba
	    window.open("relatorioVenda.jsp", "_blank");

	    // Fecha o modal e remove o backdrop manualmente
	    let modalElement = document.getElementById("confirmacaoModal");
	    let modalInstance = bootstrap.Modal.getInstance(modalElement);

	    if (modalInstance) {
	        modalInstance.hide();

	        // Aguardar um curto período para garantir que o modal seja fechado antes de remover o backdrop
	        setTimeout(() => {
	            document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
	            document.body.classList.remove('modal-open');
	            document.body.style.paddingRight = '';
	            window.location.href = "realizarVendas.jsp";
	            
	        }, 200); // Delay de 200ms para garantir o fechamento do modal
	    }
	});

	
	
	</script>

	<script>
	(() => {
	    'use strict';
	    const forms = document.querySelectorAll('.needs-validation');
	    Array.from(forms).forEach(form => {
	        form.addEventListener('submit', event => {
	            const qtdProd = form.querySelector('#qtdProd'); // Campo a ignorar
	            if (qtdProd) {
	                qtdProd.setCustomValidity(''); // Limpa qualquer estado inválido
	            }

	            if (!form.checkValidity()) {
	                event.preventDefault();
	                event.stopPropagation();
	            }
	            form.classList.add('was-validated');
	        }, false);
	    });
	})();

 
 </script>
  <script>
    // JavaScript para desconto
        document.getElementById('descontoBtn').addEventListener('click', function () {
        document.getElementById('formDescont').submit();
    });
</script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const input = document.getElementById("desProd");
    const sugestoes = document.getElementById("sugestoes");
    let timeout;

    input.addEventListener("input", function () {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            const query = this.value.trim();

            if (query.length < 2) {
                sugestoes.innerHTML = "";
                return;
            }

            fetch("buscaProdutoServer?query=" + encodeURIComponent(query))
                .then(response => {
                    if (!response.ok) throw new Error("Erro na requisição");
                    return response.json();
                })
                .then(data => {
                    // Aqui está o ponto principal:
                    const produtos = data|| [];

                    sugestoes.innerHTML = "";

                    if (produtos.length === 0) {
                        console.log("Produtos recebidos (vazio):", produtos);
                        sugestoes.innerHTML = `
                            <button type="button" class="list-group-item list-group-item-action disabled">
                                Nenhum produto encontrado
                            </button>`;
                        return;
                    }

                    console.log("Produtos recebidos:", produtos);

                    produtos.forEach(produto => {
                        const descricao = produto.descricao || "Sem descrição";
                        const codigo = produto.id || "N/A";
                        const meuPreco = produto.preco_de_compra || "0.00";
                        const precoVenda = produto.preco_de_venda || "0.00";
                        
                        const item = document.createElement("button");
                        
                        item.type = "button";
                        item.className = "list-group-item list-group-item-action";
                        item.textContent = descricao;
                        
                        item.addEventListener("click", function () {
                            document.getElementById("idProd").value = codigo;
                            document.getElementById("desProd").value = descricao;
                            document.getElementById("precoProd").value = precoVenda;
                            document.getElementById("compraProd").value = meuPreco;
                            sugestoes.innerHTML = "";
                        });
                        sugestoes.appendChild(item);
                    });
                })
                .catch(error => {
                    console.error("Erro ao buscar produtos:", error);
                    sugestoes.innerHTML = `
                        <button type="button" class="list-group-item list-group-item-action disabled">
                            Erro ao buscar produtos
                        </button>`;
                });
        }, 300); // Pequeno delay
    });
});
</script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const input = document.getElementById("cliNome");
    const sugestoes = document.getElementById("sugestoescli");
    let timeout;

    input.addEventListener("input", function () {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            const cliNome = this.value.trim();

            if (cliNome.length < 2) {
                sugestoes.innerHTML = "";
                return;
            }

            fetch("buscaClienteServer?cliNome=" + encodeURIComponent(cliNome))
                .then(response => {
                    if (!response.ok) throw new Error("Erro na requisição");
                    return response.json();
                })
                .then(data => {
                    // Aqui está o ponto principal:
                    const cliente = data|| [];

                    cliente.innerHTML = "";

                    if (cliente.length === 0) {
                        console.log("Cliente recebidos (vazio):", cliente);
                        sugestoes.innerHTML = `
                            <button type="button" class="list-group-item list-group-item-action disabled">
                                Nenhum cliente encontrado
                            </button>`;
                        return;
                    }

                    console.log("Clientes recebidos:", cliente);

                    cliente.forEach(cliente => {
              
                        const nome = cliente.nome || "Sem descrição";
                        const codigo = cliente.id || "N/A";
                        const cpf = cliente.cpf || " ";
                        const endereco = cliente.endereco || " ";
                        const numero = cliente.numero || " ";
                        
                        const item = document.createElement("button");
                        
                        item.type = "button";
                        item.className = "list-group-item list-group-item-action";
                        item.textContent = nome;
                        
                        item.addEventListener("click", function () {
                            document.getElementById("cliId").value = codigo;
                            document.getElementById("cliNome").value = nome;
                            document.getElementById("cliCpf").value = cpf;
                            document.getElementById("cliEndereco").value = endereco;
                            document.getElementById("cliNumero").value = numero;
                            sugestoes.innerHTML = "";
                        });
                        sugestoes.appendChild(item);
                    });
                })
                .catch(error => {
                    console.error("Erro ao buscar cliente:", error);
                    sugestoes.innerHTML = `
                        <button type="button" class="list-group-item list-group-item-action disabled">
                            Erro ao buscar cliente
                        </button>`;
                });
        }, 300); // Pequeno delay
    });
});
</script>

	<script>
function recalcularTotal() {
    let total = 0;
    document.querySelectorAll("#carrinho tbody tr").forEach(row => {
        let subtotal = parseFloat(row.cells[4].innerText.replace(",", "."));
        if (!isNaN(subtotal)) total += subtotal;
    });
    document.getElementById("totalVenda").value = total.toFixed(2);
}

window.onload = recalcularTotal;
</script>

	<script>
var confirmacaoModal = document.getElementById('confirmacaoModal');

confirmacaoModal.addEventListener('show.bs.modal', function () {
    let totalTela = document.getElementById("totalVenda").value;
    document.getElementById("pegardoTotal").value = totalTela;
});
</script>




</body>
</html>