<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Model.Pedidos" %>
<%@ page import="Model.ItensPedidos" %>
<%@ page import="Model.Produtos" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="DAO.PedidosDAO" %>
<%@ page import="java.text.NumberFormat, java.util.Locale" %>

<%
String empresa = (String) session.getAttribute("empresa");
if (empresa == null || empresa.isEmpty()) {
    // Se a sessão expirou, redireciona sem fazer forward para evitar erros de renderização
    response.sendRedirect("LoginExpirou.html");
    return;
}

List<Pedidos> pedidos = new ArrayList<>(); // Inicializa para garantir que não seja nulo
try {
	PedidosDAO daop = new PedidosDAO(empresa);
	pedidos = daop.listaTodosPedidosDoDia(); // Carrega os pedidos para a renderização inicial
} catch (Exception e) {
	e.printStackTrace(); // Loga qualquer erro na conexão ou consulta
	// Opcional: Adicionar uma mensagem de erro ao usuário na tela
}

List<Pedidos> todosPedidos = new ArrayList<>();
try {
	PedidosDAO daoTodos = new PedidosDAO(empresa);
	todosPedidos = daoTodos.pedidoEntregue();

} catch (Exception e) {

}

List<Pedidos> Pedidostodos = new ArrayList<>();
try {
	PedidosDAO Todosdao = new PedidosDAO(empresa);
	Pedidostodos = Todosdao.todosEntregue();

} catch (Exception e) {

}

List<Pedidos> PedidosPendentes = new ArrayList<>();
try {
	PedidosDAO Pendentedao = new PedidosDAO(empresa);
	PedidosPendentes = Pendentedao.pedidoPendentes();

} catch (Exception e) {

}
List<Pedidos> PedidosrotaEntrega = new ArrayList<>();
try {
	PedidosDAO entregadao = new PedidosDAO(empresa);
	PedidosrotaEntrega = entregadao.pedidoEmRota();

} catch (Exception e) {

}

List<Pedidos> pedidosReprovados = new ArrayList<>();
try {
	PedidosDAO reprovadosDAO = new PedidosDAO(empresa);
	pedidosReprovados = reprovadosDAO.pedidoReprovados();

} catch (Exception e) {

}

List<Pedidos> pedidosdiaCancelados = new ArrayList<>();
try {
	PedidosDAO canceladosDAO = new PedidosDAO(empresa);
	pedidosdiaCancelados = canceladosDAO.listaTodosPedidosDoDiaCancelados();

} catch (Exception e) {

}

List<Pedidos> pedidosPreparacao = new ArrayList<>();
try {
	PedidosDAO preparacaoDAO = new PedidosDAO(empresa);
	pedidosPreparacao = preparacaoDAO.pedidoPreparacao();

} catch (Exception e) {

}
NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));




%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="refresh" content="30">

<link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="bootstrap/js/bootstrap.bundle.min.js"></script>
<title>Pedidos</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
    /* Estilo para a tabela dentro de um container rolável */
    .table-container {
        max-height: 500px; /* Altura máxima para a tabela */
        overflow-y: auto; /* Adiciona scroll vertical quando necessário */
        border-radius: 0.5rem; /* Bordas arredondadas */
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /* Sombra */
    }
    .table-container table {
        margin-bottom: 0; /* Remove margem inferior da tabela dentro do container */
    }
    /* Para garantir que o cabeçalho fique fixo ao rolar */
    .table-container thead th {
        position: sticky;
        top: 0;
        background-color: #343a40; /* Cor de fundo do cabeçalho da tabela escura */
        color: white;
        z-index: 10;
    }
    #modalItensTableBody td {
  color: black !important;
  height: auto !important;
  visibility: visible !important;
  display: table-cell !important;
}

</style>
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: cover; background-position: center; margin: 0; padding: 0; min-height: 100vh; width: 100vw; display: flex; flex-direction: column;">

	<%@ include file="menu.jsp"%>

	<div class="container-fluid flex-grow-1 py-4">
		<h3 class="mb-4 text-dark">Pedidos</h3>

		<div class="row g-3 mb-4">
			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-white bg-primary bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="totalPedidosEfetuados">0</h2>
							<p class="card-text mb-0">PEDIDOS EFETUADOS</p>
						</div>
						<i class="bi bi-cart fs-1 opacity-75"></i>
					</div>
				</div>
			</div>

			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-white bg-warning bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="totalPedidosPendentes">0</h2>
							<p class="card-text mb-0">PEDIDOS PENDENTES</p>
						</div>
						<i class="bi bi-cart fs-1 opacity-75"></i>
					</div>
				</div>
			</div>

			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-white bg-info bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="totalPedidosEmPreparacao">0</h2>
							<p class="card-text mb-0">PEDIDOS EM PREPARAÇÃO</p>
						</div>
						<i class="bi bi-cart fs-1 opacity-75"></i>
					</div>
				</div>
			</div>

			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-white bg-success bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="totalPedidosEmEntrega">0</h2>
							<p class="card-text mb-0">PEDIDOS EM ROTA DE ENTREGA</p>
						</div>
						<i class="bi bi-cart fs-1 opacity-75"></i>
					</div>
				</div>
			</div>

			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-white bg-danger bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="totalPedidosReprovados">0</h2>
							<p class="card-text mb-0">PEDIDOS REPROVADOS</p>
						</div>
						<i class="bi bi-cart fs-1 opacity-75"></i>
					</div>
				</div>
			</div>

			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-white bg-secondary bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="totalClientesPedidos">0</h2>
							<p class="card-text mb-0">CLIENTES COM PEDIDOS</p>
						</div>
						<i class="bi bi-person fs-1 opacity-75"></i>
					</div>
				</div>
			</div>
			
			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-dark bg-light bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="totalEntregue">0</h2>
							<p class="card-text mb-0">PEDIDOS ENTREGUE</p>
						</div>
						<i class="bi bi-cart fs-1 opacity-75"></i>
					</div>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-md-4 col-lg-2">
				<div
					class="card text-dark bg-light bg-gradient shadow-sm rounded-3">
					<div
						class="card-body d-flex justify-content-between align-items-center">
						<div>
							<h2 class="card-title mb-0" id="CanceladosDia">0</h2>
							<p class="card-text mb-0">PEDIDOS CANCELADOS DO DIA</p>
						</div>
						<i class="bi bi-cart fs-1 opacity-75"></i>
					</div>
				</div>
			</div>
		</div>
		<ul class="nav nav-tabs" id="myTab" role="tablist">
		
		<div class="d-flex flex-wrap align-items-center gap-2">
		
			<label class="form-control mb-0" style="width: auto;">filtros:</label>
			 <li class="nav-item" role="presentation">
			<button class="btn btn-warning" type="button" data-bs-toggle="tab" data-bs-target="#PedidosPendentes" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="false">PEDIDOS
				PENDENTES</button> </li>
			<li class="nav-item" role="presentation">
			<button class="btn btn-light" type="button" id="btnPedidosEntregues" data-bs-toggle="tab" data-bs-target="#pedidosEntregues" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="false">PEDIDOS ENTREGUES</button>
			 </li>
			<li class="nav-item" role="presentation">
			<button class="btn btn-primary" type="button" id="home-tab" data-bs-toggle="tab" data-bs-target="#todosPedidos" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="true">TODOS PEDIDOS</button>
			</li>
				<li class="nav-item" role="presentation">
			<button class="btn btn-success" type="button" data-bs-toggle="tab" data-bs-target="#rotaEntrega" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="true">PEDIDOS EM
				ROTA DE ENTREGA</button>
				</li>
				<li class="nav-item" role="presentation">
			<button class="btn btn-danger" type="button" data-bs-toggle="tab" data-bs-target="#pedidosReprovados" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="true">PEDIDOS
				REPROVADOS</button>
				</li>
				<li class="nav-item" role="presentation">
			<button class="btn btn-info" type="button" data-bs-toggle="tab" data-bs-target="#pedidosPreparacao" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="true">PEDIDOS EM
				PREPARAÇÃO</button>
				</li>
				<li class="nav-item" role="presentation">
			<button class="btn btn-dark" type="button" data-bs-toggle="tab" data-bs-target="#pedidosCancelado" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="true">PEDIDOS EM
				CANCELADOS DO DIA </button>
				</li>
		</div>
		</ul>
			<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Pedidos do dia</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Pagamento Online</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (pedidos != null && !pedidos.isEmpty()) {
										for (int i = 0; i < pedidos.size(); i++) {
									%>
									<tr>
										<td><%=pedidos.get(i).getIdPedido()%></td>
										<td><%=pedidos.get(i).getClientepedido().getNome()%></td>
										<td><%=pedidos.get(i).getDataPeedido()%></td>
										<td><%=pedidos.get(i).getStatus()%></td>
										<td><%= currencyFormat.format(pedidos.get(i).getTotalPedido()) %></td>
										<td><%=pedidos.get(i).getObservacoes() != null && !pedidos.get(i).getObservacoes().isEmpty()
		? pedidos.get(i).getObservacoes()
		: "-"%></td>
										<td><%=pedidos.get(i).getFormapagamento() != null && !pedidos.get(i).getFormapagamento().isEmpty()
		? pedidos.get(i).getFormapagamento()
		: "-"%></td>                    
		                                <td><%=pedidos.get(i).getPagamentoPedido() != null && !pedidos.get(i).getPagamentoPedido().isEmpty()
		? pedidos.get(i).getPagamentoPedido()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=pedidos.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=pedidos.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
		
		<div class="tab-content" id="myTabContent">
		
		<div class="tab-pane fade" id="pedidosPreparacao" role="tabpanel"
				aria-labelledby="home-tab" tabindex="0">
			<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Pedidos Reprovados</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (pedidosPreparacao != null && !pedidosPreparacao.isEmpty()) {
										for (int i = 0; i < pedidosPreparacao.size(); i++) {
									%>
									<tr>
										<td><%=pedidosPreparacao.get(i).getIdPedido()%></td>
										<td><%=pedidosPreparacao.get(i).getClientepedido().getNome()%></td>
										<td><%=pedidosPreparacao.get(i).getDataPeedido()%></td>
										<td><%=pedidosPreparacao.get(i).getStatus()%></td>
										<td>R$ <%=String.format("%.2f", pedidosPreparacao.get(i).getTotalPedido())%></td>
										<td><%=pedidosPreparacao.get(i).getObservacoes() != null && !pedidosPreparacao.get(i).getObservacoes().isEmpty()
		? pedidosPreparacao.get(i).getObservacoes()
		: "-"%></td>
										<td><%=pedidosPreparacao.get(i).getFormapagamento() != null && !pedidosPreparacao.get(i).getFormapagamento().isEmpty()
		? pedidosPreparacao.get(i).getFormapagamento()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=pedidosPreparacao.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=pedidosPreparacao.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		
			<div class="tab-pane fade" id="pedidosReprovados" role="tabpanel"
				aria-labelledby="home-tab" tabindex="0">
			<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Pedidos Reprovados</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (pedidosReprovados != null && !pedidosReprovados.isEmpty()) {
										for (int i = 0; i < pedidosReprovados.size(); i++) {
									%>
									<tr>
										<td><%=pedidosReprovados.get(i).getIdPedido()%></td>
										<td><%=pedidosReprovados.get(i).getClientepedido().getNome()%></td>
										<td><%=pedidosReprovados.get(i).getDataPeedido()%></td>
										<td><%=pedidosReprovados.get(i).getStatus()%></td>
										<td>R$ <%=String.format("%.2f", pedidosReprovados.get(i).getTotalPedido())%></td>
										<td><%=pedidosReprovados.get(i).getObservacoes() != null && !pedidosReprovados.get(i).getObservacoes().isEmpty()
		? pedidosReprovados.get(i).getObservacoes()
		: "-"%></td>
										<td><%=pedidosReprovados.get(i).getFormapagamento() != null && !pedidosReprovados.get(i).getFormapagamento().isEmpty()
		? pedidosReprovados.get(i).getFormapagamento()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=pedidosReprovados.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=pedidosReprovados.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		
			<div class="tab-pane fade" id="rotaEntrega" role="tabpanel"
				aria-labelledby="home-tab" tabindex="0">
			<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Pedidos em rota de entrega</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (PedidosrotaEntrega != null && !PedidosrotaEntrega.isEmpty()) {
										for (int i = 0; i < PedidosrotaEntrega.size(); i++) {
									%>
									<tr>
										<td><%=PedidosrotaEntrega.get(i).getIdPedido()%></td>
										<td><%=PedidosrotaEntrega.get(i).getClientepedido().getNome()%></td>
										<td><%=PedidosrotaEntrega.get(i).getDataPeedido()%></td>
										<td><%=PedidosrotaEntrega.get(i).getStatus()%></td>
										<td>R$ <%=String.format("%.2f", PedidosrotaEntrega.get(i).getTotalPedido())%></td>
										<td><%=PedidosrotaEntrega.get(i).getObservacoes() != null && !PedidosrotaEntrega.get(i).getObservacoes().isEmpty()
		? PedidosrotaEntrega.get(i).getObservacoes()
		: "-"%></td>
										<td><%=PedidosrotaEntrega.get(i).getFormapagamento() != null && !PedidosrotaEntrega.get(i).getFormapagamento().isEmpty()
		? PedidosrotaEntrega.get(i).getFormapagamento()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=PedidosrotaEntrega.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=PedidosrotaEntrega.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="tab-pane fade" id="todosPedidos" role="tabpanel"
				aria-labelledby="home-tab" tabindex="0">
			<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Todos Pedidos</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Pagamento Online</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (Pedidostodos != null && !Pedidostodos.isEmpty()) {
										for (int i = 0; i < Pedidostodos.size(); i++) {
									%>
									<tr>
										<td><%=Pedidostodos.get(i).getIdPedido()%></td>
										<td><%=Pedidostodos.get(i).getClientepedido().getNome()%></td>
										<td><%=Pedidostodos.get(i).getDataPeedido()%></td>
										<td><%=Pedidostodos.get(i).getStatus()%></td>
										<td>R$ <%=String.format("%.2f", Pedidostodos.get(i).getTotalPedido())%></td>
										<td><%=Pedidostodos.get(i).getObservacoes() != null && !Pedidostodos.get(i).getObservacoes().isEmpty()
		? Pedidostodos.get(i).getObservacoes()
		: "-"%></td>
										<td><%=Pedidostodos.get(i).getFormapagamento() != null && !Pedidostodos.get(i).getFormapagamento().isEmpty()
		? Pedidostodos.get(i).getFormapagamento()
		: "-"%></td>
		                             <td><%=Pedidostodos.get(i).getPagamentoPedido() != null && !Pedidostodos.get(i).getPagamentoPedido().isEmpty()
		? Pedidostodos.get(i).getPagamentoPedido()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=Pedidostodos.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=Pedidostodos.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
						<div class="tab-pane fade" id="PedidosPendentes" role="tabpanel"
				aria-labelledby="profile-tab" tabindex="0">
			<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Pedidos Pendentes</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (PedidosPendentes != null && !PedidosPendentes.isEmpty()) {
										for (int i = 0; i < PedidosPendentes.size(); i++) {
									%>
									<tr>
										<td><%=PedidosPendentes.get(i).getIdPedido()%></td>
										<td><%=PedidosPendentes.get(i).getClientepedido().getNome()%></td>
										<td><%=PedidosPendentes.get(i).getDataPeedido()%></td>
										<td><%=PedidosPendentes.get(i).getStatus()%></td>
										<td>R$ <%=String.format("%.2f", PedidosPendentes.get(i).getTotalPedido())%></td>
										<td><%=PedidosPendentes.get(i).getObservacoes() != null && !PedidosPendentes.get(i).getObservacoes().isEmpty()
		? PedidosPendentes.get(i).getObservacoes()
		: "-"%></td>
										<td><%=PedidosPendentes.get(i).getFormapagamento() != null && !PedidosPendentes.get(i).getFormapagamento().isEmpty()
		? PedidosPendentes.get(i).getFormapagamento()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=PedidosPendentes.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=PedidosPendentes.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="tab-pane fade" id="pedidosEntregues" role="tabpanel"
				aria-labelledby="profile-tab" tabindex="0">
				<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Pedidos Entregues</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (todosPedidos != null && !todosPedidos.isEmpty()) {
										for (int i = 0; i < todosPedidos.size(); i++) {
									%>
									<tr>
										<td><%=todosPedidos.get(i).getIdPedido()%></td>
										<td><%=todosPedidos.get(i).getClientepedido().getNome()%></td>
										<td><%=todosPedidos.get(i).getDataPeedido()%></td>
										<td><%=todosPedidos.get(i).getStatus()%></td>
										<td>R$ <%=String.format("%.2f", todosPedidos.get(i).getTotalPedido())%></td>
										<td><%=todosPedidos.get(i).getObservacoes() != null && !todosPedidos.get(i).getObservacoes().isEmpty()
		? todosPedidos.get(i).getObservacoes()
		: "-"%></td>
										<td><%=todosPedidos.get(i).getFormapagamento() != null && !todosPedidos.get(i).getFormapagamento().isEmpty()
		? todosPedidos.get(i).getFormapagamento()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=todosPedidos.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=todosPedidos.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<div class="tab-pane fade" id="pedidosCancelado" role="tabpanel"
				aria-labelledby="profile-tab" tabindex="0">
				<div class="row">
					<div class="col-md-12">
						<div class="table-container">
							<h1 class="card-title mb-0">Pedidos Entregues</h1>
							<table id="pedidosDiario"
								class="table table-dark table-striped table-hover">
								<thead>
									<tr>
										<th>Codigo do pedido</th>
										<th>Nome</th>
										<th>Data</th>
										<th>Status</th>
										<th>Total Pedido</th>
										<th>Observação</th>
										<th>Forma de pagamento</th>
										<th>Ações</th>
									</tr>
								</thead>
								<tbody id="pedidosTableBody">

									<%
									if (pedidosdiaCancelados != null && !pedidosdiaCancelados.isEmpty()) {
										for (int i = 0; i < pedidosdiaCancelados.size(); i++) {
									%>
									<tr>
										<td><%=pedidosdiaCancelados.get(i).getIdPedido()%></td>
										<td><%=pedidosdiaCancelados.get(i).getClientepedido().getNome()%></td>
										<td><%=pedidosdiaCancelados.get(i).getDataPeedido()%></td>
										<td><%=pedidosdiaCancelados.get(i).getStatus()%></td>
										<td>R$ <%=String.format("%.2f", pedidosdiaCancelados.get(i).getTotalPedido())%></td>
										<td><%=pedidosdiaCancelados.get(i).getObservacoes() != null && !pedidosdiaCancelados.get(i).getObservacoes().isEmpty()
		? pedidosdiaCancelados.get(i).getObservacoes()
		: "-"%></td>
										<td><%=pedidosdiaCancelados.get(i).getFormapagamento() != null && !pedidosdiaCancelados.get(i).getFormapagamento().isEmpty()
		? pedidosdiaCancelados.get(i).getFormapagamento()
		: "-"%></td>
										<td>
											<button type="button"
												class="btn btn-sm btn-info visualizar-pedido"
												data-id-pedido="<%=todosPedidos.get(i).getIdPedido()%>"
												data-bs-toggle="modal" data-bs-target="#gereciarPedido">
												<i class="bi bi-eye"></i> Detalhes
											</button> <a type="button"
											class="btn btn-sm btn-success btn-atualizar-status"
											data-id-pedido="<%=todosPedidos.get(i).getIdPedido()%>"
											data-novo-status="Em Preparo" data-bs-toggle="modal"
											data-bs-target="#atualizarStatus"> <i
												class="bi bi-arrow-up-circle"></i> Atualizar Status
										</a>
										</td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="8" class="text-center">Nenhum pedido
											encontrado para hoje.</td>
									</tr>
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

<div class="modal fade" id="gereciarPedido" data-bs-backdrop="static"
	data-bs-keyboard="false" tabindex="-1"
	aria-labelledby="staticBackdropLabel" aria-hidden="true">
	<div
		class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="staticBackdropLabel">
					Detalhes do Pedido <span id="modalPedidoId"></span>
				</h1>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<div class="bg-light p-4 rounded shadow mb-4">
					<h5 class="text-center mb-3">Informações do Pedido e Cliente</h5>
					<div class="row">
						<div class="col-md-6">
							<p>
								<strong>Codigo:</strong> <span id="modalIdPedido"></span>
							</p>
							<p>
								<strong>Data Pedido:</strong> <span id="modalDataPedido"></span>
							</p>
							<p>
								<strong>Status:</strong> <span id="modalStatusPedido"></span>
							</p>
							<p>
								<strong>Total Pedido:</strong> <span id="modalTotalPedido"></span>
							</p>
							<p>
								<strong>Forma Pagamento:</strong> <span
									id="modalFormaPagamento"></span>
							</p>
							<p>
								<strong>Observações:</strong> <span id="modalObservacoes"></span>
							</p>
						</div>
						<div class="col-md-6">
							<p>
								<strong>Cliente:</strong> <span id="modalNomeCliente"></span>
							</p>
							<p>
								<strong>Endereço:</strong> <span id="modalEnderecoCliente"></span>
							</p>
							<p>
								<strong>Número:</strong> <span id="modalNumeroCliente"></span>
							</p>
							<p>
								<strong>CEP:</strong> <span id="modalCepCliente"></span>
							</p>
							<p>
								<strong>Estado:</strong> <span id="modalEstadoCliente"></span>
							</p>
							<p>
								<strong>Telefone:</strong> <span id="modalTelefoneCliente"></span>
							</p>
							<p>
								<strong>Email:</strong> <span id="modalEmailCliente"></span>
							</p>
						</div>
					</div>
				</div>

				<div class="bg-white p-4 rounded shadow">
					<h5 class="text-center mb-3">Itens do Pedido</h5>
					<div class="table-responsive">
						<table class="table table-striped table-hover">
							<thead>
								<tr>
									<th>Item</th>
									<th>Quantidade</th>
									<th>Preço Unitário</th>
									<th>Subtotal</th>
								</tr>
							</thead>
							<tbody id="modalItensTableBody">
								<tr>
									<td colspan="4" class="text-center text-muted">Carregando
										itens...</td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<th colspan="3" class="text-end">Total Itens:</th>
									<th id="modalTotalItens">R$ 0,00</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>

			<form action="AtualizarStatusPedido" method="post">
				<div class="modal-footer">
					<input type="hidden" name="acao" value="pedido">
					<input type="hidden" name="idPedido" id="formIdPedido">

					<div class="d-flex align-items-center flex-grow-1 me-3">
						<label for="formStatus" class="form-label mb-0 me-2 text-nowrap">Novo
							Status:</label>
						<select class="form-select me-2" name="status"
							id="formStatus">
							<option value="Pendente">Pendente</option>
							<option value="Em Preparo">Em Preparo</option>
							<option value="Em Rota de Entrega">Em Rota de Entrega</option>
							<option value="Entregue">Entregue</option>
							<option value="Reprovado">Reprovado</option>
							<option value="Cancelado">Cancelado</option>
						</select>
						<label for="formObservacoes"
							class="form-label mb-0 me-2 text-nowrap">Observações:</label>
						<textarea class="form-control me-2" name="observacoes"
							id="formObservacoes" rows="1"
							placeholder="Adicionar observações"></textarea>
					</div>

					<button type="button" class="btn btn-warning" id="btnImprimirPedido">Imprimir Pedido</button>

					<button type="submit" class="btn btn-success me-2">
						Atualizar Pedido
					</button>
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">
						Fechar
					</button>
				</div>
			</form>
		</div>
	</div>
</div>

<div class="modal fade" tabindex="-1" id="atualizarStatus">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="atualizaPedido" method="post">
        <div class="modal-header">
          <h5 class="modal-title">Atualizar pedido</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body">
          <p>Deseja passar o seu pedido para uma próxima etapa?</p>

          <input type="hidden" name="acao" value="status">
          <input type="hidden" name="idPedido" id="statusModalIdPedido">

          <label for="statusModalStatus" class="form-label mb-0 me-2 text-nowrap">Novo Status:</label>
          <select class="form-select me-2" name="status" id="statusModalStatus">
              <option value="Pendente">Pendente</option>
              <option value="Em Preparo">Em Preparo</option>
              <option value="Em Rota de Entrega">Em Rota de Entrega</option>
              <option value="Entregue">Entregue</option>
              <option value="Reprovado">Reprovado</option>
          </select>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Não</button>
          <button type="submit" class="btn btn-primary">Sim</button>
        </div>
      </form>
    </div>
  </div>
</div>
</div>



<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Obtenha referências aos elementos do DOM que serão usados.
        // O modal gereciarPedido é gerenciado internamente pela handleDetalhesClick.
        // Já pegamos as referências dos campos do formulário aqui para reuso.
        const formIdPedido = document.getElementById("formIdPedido");
        const formStatus = document.getElementById("formStatus");
        const formObservacoes = document.getElementById("formObservacoes");

        // --- SUA FUNÇÃO handleDetalhesClick() COM AS ADIÇÕES NECESSÁRIAS ---
        function handleDetalhesClick() {
            const idDoPedidoParaRequisicao = this.getAttribute('data-id-pedido');
            const modalItensTableBody = document.getElementById("modalItensTableBody");
            const modalElement = document.getElementById('gereciarPedido');

            // --- Sua lógica original de Gerenciamento do Modal ---
            let gereciarPedidoModal = bootstrap.Modal.getInstance(modalElement);

            if (!gereciarPedidoModal) {
                gereciarPedidoModal = new bootstrap.Modal(modalElement);
            }
            // ------------------------------------------

            // Exibe mensagem de carregando
            modalItensTableBody.innerHTML = `<tr><td colspan="4" class="text-center text-muted">Carregando itens...</td></tr>`;
            document.getElementById("modalTotalItens").innerText = "R$ 0,00";

            // Mostra o modal (utiliza a instância existente ou a recém-criada)
            gereciarPedidoModal.show();

            const urlDeRequisicao = "selecionarPedido?id=" + encodeURIComponent(idDoPedidoParaRequisicao);

            fetch(urlDeRequisicao)
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 401) {
                            window.location.href = 'LoginExpirou.html';
                            return Promise.reject('Sessão expirada.');
                        }
                        return response.text().then(text => {
                            throw new Error(text || `Erro HTTP ${response.status}: ${response.statusText}`);
                        });
                    }
                    return response.json();
                })
                .then(itensPedido => {
                    console.log("Detalhes do pedido recebidos com sucesso:", itensPedido);

                    if (itensPedido && itensPedido.length > 0) {
                        const primeiroItem = itensPedido[0];
                        const pedidoInfo = primeiroItem.pedido || {};
                        const clienteInfo = pedidoInfo.clientepedido || {};

                        // Preenchimento de informações gerais do pedido e cliente
                        document.getElementById("modalIdPedido").innerText = pedidoInfo.idPedido || '-';
                        document.getElementById("modalDataPedido").innerText = pedidoInfo.dataPeedido || '-';
                        document.getElementById("modalStatusPedido").innerText = pedidoInfo.status || '-';

                        const totalPedidoValue = pedidoInfo.totalPedido || 0;
                        const totalPedidoFormatado = typeof totalPedidoValue === 'number'
                            ? totalPedidoValue.toFixed(2).replace('.', ',')
                            : '0,00';
                        document.getElementById("modalTotalPedido").innerText = 'R$ ' + totalPedidoFormatado;

                        document.getElementById("modalFormaPagamento").innerText = pedidoInfo.formapagamento || "-";
                        document.getElementById("modalObservacoes").innerText = pedidoInfo.observacoes || "-";

                        document.getElementById("modalNomeCliente").innerText = clienteInfo.nome || '-';
                        document.getElementById("modalEnderecoCliente").innerText = clienteInfo.endereco || '-';
                        document.getElementById("modalNumeroCliente").innerText = clienteInfo.numero || "-";
                        document.getElementById("modalEstadoCliente").innerText = clienteInfo.uf || "-";
                        document.getElementById("modalTelefoneCliente").innerText = clienteInfo.telefone || "-";
                        document.getElementById("modalEmailCliente").innerText = clienteInfo.email || "-";

                        // Limpa a tabela antes de inserir (SUA LÓGICA FUNCIONAL AQUI!)
                        modalItensTableBody.innerHTML = "";
                        let totalItens = 0;

                        // Loop para preencher a tabela de itens (SUA LÓGICA FUNCIONAL AQUI!)
                        itensPedido.forEach(item => {
                            const descricao = item.produto?.descricao || '-';

                            const quantidade = parseFloat(item.quantidade) || 0;
                            const precoUnitario = parseFloat(item.precoUnitario) || 0;

                            const subtotal = quantidade * precoUnitario;
                            totalItens += subtotal;

                            const precoFormatado = precoUnitario.toFixed(2).replace('.', ',');
                            const subtotalFormatado = subtotal.toFixed(2).replace('.', ',');

                            // Criação dos elementos da linha da tabela (SUA LÓGICA FUNCIONAL AQUI!)
                            const tr = document.createElement('tr');

                            const tdDescricao = document.createElement('td');
                            tdDescricao.textContent = descricao;

                            const tdQtd = document.createElement('td');
                            tdQtd.textContent = quantidade;

                            const tdPreco = document.createElement('td');
                            tdPreco.textContent = "R$ " + precoFormatado;

                            const tdSubtotal = document.createElement('td');
                            tdSubtotal.textContent = "R$ " + subtotalFormatado;

                            tr.appendChild(tdDescricao);
                            tr.appendChild(tdQtd);
                            tr.appendChild(tdPreco);
                            tr.appendChild(tdSubtotal);

                            modalItensTableBody.appendChild(tr);
                        });

                        // Atualiza o total de itens no rodapé da tabela
                        document.getElementById("modalTotalItens").innerText = "R$ " + totalItens.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

                        // *** LINHAS ADICIONADAS PARA PREENCHER OS CAMPOS DO FORMULÁRIO ***
                        // Isso garante que os valores de status e observações sejam os mais atualizados do banco de dados
                        // E o idPedido é fundamental para a submissão do formulário.
                        if (formIdPedido) {
                            formIdPedido.value = pedidoInfo.idPedido || ''; // Garante o ID no campo hidden do form
                        }
                        if (formStatus) {
                            formStatus.value = pedidoInfo.status || ''; // Define o status atual no select
                        }
                        if (formObservacoes) {
                            formObservacoes.value = pedidoInfo.observacoes || ''; // Define as observações atuais na textarea
                        }
                        // *******************************************************************

                    } else {
                        // Caso não haja itens
                        modalItensTableBody.innerHTML = `<tr><td colspan="4" class="text-center text-muted">Nenhum item encontrado para este pedido.</td></tr>`;
                        document.getElementById("modalTotalItens").innerText = "R$ 0,00";
                    }
                })
                .catch(error => {
                    console.error('Erro ao carregar detalhes do pedido:', error);
                    modalItensTableBody.innerHTML = `<tr><td colspan="4" class="text-center text-danger">Erro ao carregar detalhes: ${error.message || 'Erro desconhecido'}</td></tr>`;
                    document.getElementById("modalTotalItens").innerText = "R$ 0,00";
                    alert("Ocorreu um erro ao carregar os detalhes do pedido. Verifique o console.");
                });
        }
        // --- FIM DA FUNÇÃO handleDetalhesClick() ---


        // --- OUTRAS FUNÇÕES AUXILIARES (Consolidadas e sem duplicação) ---

        /**
         * Função que garante que todos os botões de detalhes tenham o listener
         * É chamada no DOMContentLoaded e após cada atualização da tabela via AJAX.
         */
        function adicionarListenersAosBotoesDetalhes() {
            document.querySelectorAll('.visualizar-pedido').forEach(button => {
                button.removeEventListener('click', handleDetalhesClick); // Remove para evitar listeners duplicados
                button.addEventListener('click', handleDetalhesClick);
            });
        }

        /**
         * Função para atualizar os cartões de resumo com base na lista de pedidos.
         */
        function atualizarCartoes(pedidos) {
            let totalPedidosEfetuados = 0;
            let totalPedidosPendentes = 0;
            let totalPedidosEmPreparacao = 0;
            let totalPedidosEmEntrega = 0;
            let totalPedidosReprovados = 0;
            let totalPedidosEntregue = 0;
            const clientesComPedidos = new Set();

            if (pedidos && pedidos.length > 0) {
                pedidos.forEach(pedido => {
                    totalPedidosEfetuados++;
                    const statusUpper = pedido.status ? pedido.status.toUpperCase() : '';

                    if (statusUpper === 'PENDENTE') {
                        totalPedidosPendentes++;
                    } else if (statusUpper === 'EM PREPARO' || statusUpper === 'EM PREPARAÇÃO') {
                        totalPedidosEmPreparacao++;
                    } else if (statusUpper === 'EM ROTA DE ENTREGA') {
                        totalPedidosEmEntrega++;
                    } else if (statusUpper === 'REPROVADO') {
                        totalPedidosReprovados++;
                    } else if (statusUpper === 'ENTREGUE') {
                    	totalPedidosEntregue++;
                    }
                    if (pedido.clientepedido && pedido.clientepedido.nome) {
                        clientesComPedidos.add(pedido.clientepedido.nome);
                    }
                });
            }

            document.getElementById('totalPedidosEfetuados').textContent = totalPedidosEfetuados;
            document.getElementById('totalPedidosPendentes').textContent = totalPedidosPendentes;
            document.getElementById('totalPedidosEmPreparacao').textContent = totalPedidosEmPreparacao;
            document.getElementById('totalPedidosEmEntrega').textContent = totalPedidosEmEntrega;
            document.getElementById('totalPedidosReprovados').textContent = totalPedidosReprovados;
            document.getElementById('totalClientesPedidos').textContent = clientesComPedidos.size;
            document.getElementById('totalEntregue').textContent = totalPedidosEntregue;
        }

        /**
         * Função para carregar e atualizar a tabela e os cartões via AJAX.
         * É executada periodicamente e no carregamento inicial.
         */
        function carregarEAtualizarPedidosViaAjax() {
            console.log("Atualizando pedidos via AJAX...");
            fetch('getPedidosJson.jsp')
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 401) {
                            window.location.href = 'LoginExpirou.html';
                            return Promise.reject('Sessão expirada. Redirecionando...');
                        }
                        throw new Error('Erro ao carregar os pedidos: ' + response.statusText);
                    }
                    return response.json();
                })
                .then(pedidos => {
                    console.log("Pedidos recebidos via AJAX:", pedidos);
                    const tbody = document.getElementById('pedidosTableBody');
                    tbody.innerHTML = ''; // Limpa a tabela antes de adicionar os novos dados

                    if (pedidos && pedidos.length > 0) {
                        pedidos.forEach(pedido => {
                            const row = tbody.insertRow();
                            row.insertCell().textContent = pedido.idPedido;
                            row.insertCell().textContent = pedido.clientepedido ? pedido.clientepedido.nome : '-';
                            row.insertCell().textContent = pedido.dataPeedido;
                            row.insertCell().textContent = pedido.status;
                            row.insertCell().textContent = 'R$ ' + (pedido.totalPedido ? pedido.totalPedido.toFixed(2).replace('.', ',') : '0,00');
                            row.insertCell().textContent = pedido.observacoes && pedido.observacoes !== "" ? pedido.observacoes : '-';
                            row.insertCell().textContent = pedido.formapagamento && pedido.formapagamento !== "" ? pedido.formapagamento : '-';

                            const acoesCell = row.insertCell();
                            const detalhesButton = document.createElement('button');
                            detalhesButton.type = 'button';
                            detalhesButton.className = 'btn btn-sm btn-info visualizar-pedido me-1';
                            detalhesButton.setAttribute('data-id-pedido', pedido.idPedido);
                            detalhesButton.setAttribute('data-bs-toggle', 'modal');
                            detalhesButton.setAttribute('data-bs-target', '#gereciarPedido');
                            detalhesButton.innerHTML = '<i class="bi bi-eye"></i> Detalhes';
                            acoesCell.appendChild(detalhesButton);

                            const atualizarStatusButton = document.createElement('button');
                            atualizarStatusButton.type = 'button';
                            atualizarStatusButton.className = 'btn btn-sm btn-success btn-atualizar-status';
                            atualizarStatusButton.setAttribute('data-id-pedido', pedido.idPedido);
                            atualizarStatusButton.setAttribute('data-novo-status', 'Em Preparo');
                            atualizarStatusButton.setAttribute('data-bs-toggle', 'modal');
                            atualizarStatusButton.setAttribute('data-bs-target', '#atualizarStatus');
                            atualizarStatusButton.innerHTML = '<i class="bi bi-arrow-up-circle"></i> Atualizar Status';
                            acoesCell.appendChild(atualizarStatusButton);
                        });
                    } else {
                        const row = tbody.insertRow();
                        const cell = row.insertCell();
                        cell.colSpan = 8;
                        cell.classList.add('text-center');
                        cell.textContent = 'Nenhum pedido encontrado para hoje.';
                    }

                    atualizarCartoes(pedidos);
                    // Re-adiciona listeners para os novos botões gerados dinamicamente!
                    adicionarListenersAosBotoesDetalhes();
                    // Adiciona listeners para os botões de atualização de status também
                    adicionarListenersAosBotoesAtualizarStatus();
                })
                .catch(error => {
                    console.error('Erro ao buscar pedidos via AJAX:', error);
                });
        }

        // --- Listener para o modal "atualizarStatus" ---
        function adicionarListenersAosBotoesAtualizarStatus() {
            document.querySelectorAll('.btn-atualizar-status').forEach(btn => {
                btn.removeEventListener('click', handleAtualizarStatusClick);
                btn.addEventListener('click', handleAtualizarStatusClick);
            });
        }

        function handleAtualizarStatusClick() {
            const idPedido = this.dataset.idPedido;
            // O novoStatus aqui é um valor padrão do botão, você pode querer preencher com o status atual do pedido
            const novoStatusDoBotao = this.dataset.novoStatus;

            document.getElementById('statusModalIdPedido').value = idPedido;

            // Opcional: preencher o select de status do modal de atualização com o status atual do pedido
            const statusAtualDaLinha = this.closest('tr')?.querySelector('td:nth-child(4)')?.textContent;
            if (document.getElementById('statusModalStatus')) {
                 document.getElementById('statusModalStatus').value = statusAtualDaLinha || '';
            }
        }


        // --- Lógica de Inicialização no DOMContentLoaded ---

        // 1. Carrega os cartões com os dados que já estão na tabela (se houver)
        const initialPedidosData = [];
        const tbodyInitial = document.getElementById('pedidosTableBody');
        if (tbodyInitial && tbodyInitial.rows.length > 0 && tbodyInitial.rows[0].cells[0].colSpan !== 8) {
            for (let i = 0; i < tbodyInitial.rows.length; i++) {
                const row = tbodyInitial.rows[i];
                initialPedidosData.push({
                    idPedido: row.cells[0].textContent,
                    clientepedido: { nome: row.cells[1].textContent },
                    dataPeedido: row.cells[2].textContent,
                    status: row.cells[3].textContent,
                    totalPedido: parseFloat(row.cells[4].textContent.replace('R$ ', '').replace(',', '.')),
                    observacoes: row.cells[5].textContent === '-' ? '' : row.cells[5].textContent,
                    formapagamento: row.cells[6].textContent === '-' ? '' : row.cells[6].textContent
                });
            }
        }
        atualizarCartoes(initialPedidosData);

        // 2. Adiciona listeners aos botões de detalhes e status que já existem na página (se renderizados inicialmente pelo JSP)
        adicionarListenersAosBotoesDetalhes();
        adicionarListenersAosBotoesAtualizarStatus();

        // 3. Ativa a atualização periódica via AJAX para a tabela e cartões
        setInterval(carregarEAtualizarPedidosViaAjax, 10000); // Atualiza a cada 10 segundos
    });
</script>
 <script>
        document.addEventListener("DOMContentLoaded", function() {
            const botao = document.getElementById("btnPedidosEntregues");
            if (botao) {
                botao.addEventListener("click", function() {
                    console.log("Botão clicado! Chamando o Servlet...");

                    // --- ESTA É A "NOTACÃO JAVASCRIPT" PARA EXECUTAR SEU SERVLET ---
                    fetch('getPedidosEntreguesJson')
                        .then(response => {
                            if (!response.ok) {
                                if (response.status === 401) {
                                    window.location.href = 'LoginExpirou.html';
                                    return Promise.reject('Sessão expirada.');
                                }
                                return response.text().then(text => {
                                    throw new Error(`Erro HTTP ${response.status}: ${response.statusText}. Detalhes: ${text}`);
                                });
                            }
                            return response.json();
                        })
                        .then(data => {
                            console.log("Dados de pedidos entregues recebidos:", data);
                            // Exemplo: Limpar o contêiner e mostrar os dados
                            const container = document.getElementById("aondeACarregarTabelaVai");
                            if (container) {
                                if (data && data.length > 0) {
                                    container.innerHTML = "<h3>Pedidos Entregues Carregados:</h3>";
                                    data.forEach(pedido => {
                                        container.innerHTML += `<p>ID: ${pedido.idPedido}, Cliente: ${pedido.clientepedido ? pedido.clientepedido.nome : '-'}, Status: ${pedido.status}</p>`;
                                    });
                                } else {
                                    container.innerHTML = "<p>Nenhum pedido entregue encontrado.</p>";
                                }
                            }
                        })
                        .catch(error => {
                            console.error("Erro ao carregar pedidos entregues:", error);
                            const container = document.getElementById("aondeACarregarTabelaVai");
                            if (container) {
                                container.innerHTML = `<p style="color: red;">Erro ao carregar os dados: ${error.message}</p>`;
                            }
                            alert("Não foi possível carregar os pedidos. Verifique o console.");
                        });
                });
            }
        });
    </script>
  <script>
//Função que abre o relatório, já corrigida
 // Função que abre o relatório, já corrigida
function abrirRelatorio(id) {
    if (id) {
        window.open('comprovantePedido.jsp?id_pedido=' + id, '_blank');
    } else {
        alert("ID do pedido não encontrado para imprimir.");
    }
}

// Evento que escuta a abertura do modal 'gereciarPedido'
const gerenciarPedidoModal = document.getElementById('gereciarPedido');

gerenciarPedidoModal.addEventListener('show.bs.modal', event => {
    // Pega o elemento que abriu o modal (botão ou linha da tabela)
    const trigger = event.relatedTarget;
    
    // Pega o ID do pedido do atributo 'data-id-pedido' do elemento que abriu o modal
    const idPedido = trigger.getAttribute('data-id-pedido');

    // Seleciona o botão de imprimir e o dropdown de status dentro do modal
    const btnImprimir = gerenciarPedidoModal.querySelector('#btnImprimirPedido');
    const formStatus = gerenciarPedidoModal.querySelector('#formStatus');
    const formIdPedido = gerenciarPedidoModal.querySelector('#formIdPedido');

    // 1. Atualiza o hidden input do formulário com o ID do pedido
    formIdPedido.value = idPedido;

    // 2. Atualiza o texto do botão de impressão
    btnImprimir.innerText = `Imprimir Pedido #${idPedido}`;
    
    // 3. Define a função de click do botão de impressão com o ID correto
    // Por padrão, o botão está desabilitado, então a função de click não será executada se ele estiver disabled
    btnImprimir.onclick = () => abrirRelatorio(idPedido);

    // 4. LÓGICA DA CONDIÇÃO: Verifica o status inicial e define o estado do botão
    function verificarStatusEBotao() {
        if (formStatus.value === 'Em Preparo') {
            btnImprimir.disabled = false; // Habilita o botão
        } else {
            btnImprimir.disabled = true; // Desabilita o botão
        }
    }
    
    // Define o estado inicial do botão quando o modal é aberto
    verificarStatusEBotao();

    // 5. Adiciona um ouvinte de evento para quando o valor do dropdown de status mudar
    formStatus.addEventListener('change', verificarStatusEBotao);
});
    </script>

</body>
</html>