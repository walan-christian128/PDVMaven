<%@ page import="Model.Empresa" %>
<%@ page import="Model.ConfigPagamento" %>
<%@ page import="Model.HorarioFuncionamento" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Base64" %> <%-- Necessário para exibir a imagem da logo --%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="Model.Vendas"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Model.ItensVenda"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%

Vendas vendasDia = new Vendas();
String totalVenda = request.getAttribute("totalVenda2") != null ? request.getAttribute("totalVenda2").toString() : "";
String data = request.getAttribute("data") != null ? request.getAttribute("data").toString() : "";
%>
<%
String empresa4 = (String) session.getAttribute("empresa");
if (empresa4 == null || empresa4.isEmpty()) {
    RequestDispatcher rd = request.getRequestDispatcher("LoginExpirou.html");
    rd.forward(request, response);
    return; // Certifique-se de que o código pare de executar após o redirecionamento
}

ConfigPagamento pagamentoModal = (ConfigPagamento) request.getAttribute("config");

Empresa empresaModal = (Empresa) request.getAttribute("empresa");
List<HorarioFuncionamento> horariosEmpresaModal = (List<HorarioFuncionamento>) request.getAttribute("horariosEmpresa");

// Garante que a lista de horários não é nula para evitar NullPointerException e facilita o acesso
if (horariosEmpresaModal == null) {
    horariosEmpresaModal = new ArrayList<>();
}
// Cria um mapa para facilitar o acesso aos horários pelo dia da semana (0=Domingo, 1=Segunda, etc.)
java.util.Map<Integer, HorarioFuncionamento> horariosMap = new java.util.HashMap<>();
for (HorarioFuncionamento hf : horariosEmpresaModal) {
    horariosMap.put(hf.getDiaSemana(), hf);
}

%>

<!doctype html>
<html lang="pt-br">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Menu Principal</title>
<link rel="icon" href="img/2992655_click_computer_currency_dollar_money_icon.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.css" />
<%-- Link para seu CSS personalizado, se houver --%>
<%-- <link rel="stylesheet" href="css/style.css"> --%>

<style>
    /* Estilos para a imagem de fundo otimizada */
    body {
        background-image: url('img/background-menu.webp'); /* Imagem otimizada (ex: WebP) */
        background-size: cover; /* Melhor para cobrir toda a área */
        background-position: center center;
        background-repeat: no-repeat;
        margin: 0;
        padding: 0;
        min-height: 100vh; /* Garante que o fundo cubra a tela toda mesmo com pouco conteúdo */
        width: 100vw;
    }

    /* Ajustes para os links do menu para melhor legibilidade */
    .offcanvas-body .nav-link {
        font-size: 1.5rem; /* Um pouco menor para melhor ajuste em telas menores, mas ainda grande */
        padding: 0.75rem 1rem; /* Aumenta o padding para melhor área de clique */
        display: flex; /* Para alinhar ícone e texto */
        align-items: center;
        gap: 10px; /* Espaçamento entre ícone e texto */
        color: inherit; /* Garante que a cor seja a padrão do nav-link */
        text-decoration: none; /* Remove sublinhado padrão */
    }

    .offcanvas-body .nav-link .icon {
        font-size: 1.8rem; /* Tamanho do ícone */
    }

    /* Estilo para dropdowns (agora collapse) no menu lateral */
    .offcanvas-body .collapse .nav-link {
        font-size: 1.3rem; /* Tamanho do texto dos itens do submenu colapsável */
        padding: 0.5rem 1rem;
    }

    /* Estilo para a seta de expansão/colapso */
    .nav-link.collapsed .bi-chevron-down {
        transform: rotate(0deg);
        transition: transform 0.2s ease-in-out;
    }

    .nav-link:not(.collapsed) .bi-chevron-down {
        transform: rotate(180deg);
        transition: transform 0.2s ease-in-out;
    }
</style>
</head>
<body>

    <i class="bi bi-list d-flex ms-3 mt-3" data-bs-toggle="offcanvas" href="#offcanvasMenu" role="button" aria-controls="offcanvasMenu" style="font-size: 3rem; cursor: pointer; color: white;"></i>
    
    <div class="offcanvas offcanvas-start bg-light" tabindex="-1" id="offcanvasMenu" aria-labelledby="offcanvasMenuLabel">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="offcanvasMenuLabel">Menu de Navegação</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body">
            <div class="mb-3">
                <p class="h5 text-primary">Empresa: <c:out value="${empresa}"/></p>
            </div>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" href="Home.jsp">
                        <span class="icon"><i class="bi bi-house-door-fill"></i></span> <span class="txt-link">Página Inicial</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="Produtos.jsp">
                        <span class="icon"><i class="bi bi-box-seam-fill"></i></span> <span class="txt-link">Estoque</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="Pedidos.jsp">
                        <span class="icon"><i class="bi bi-card-checklist"></i></span> <span class="txt-link">Pedidos</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="LinkCadastroPedido.jsp">
                        <span class="icon"><i class="bi bi-person-plus-fill"></i></span> <span class="txt-link">Cadastro de Clientes</span>
                    </a>
                </li>
                
                <%-- ACORDEÃO para Histórico de Vendas --%>
              
                <li class="nav-item">
                    <a class="nav-link active" href="Clientes.jsp">
                        <span class="icon"><i class="bi bi-person-fill"></i></span> <span class="txt-link">Clientes</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="Fornecedores.jsp">
                        <span class="icon"><i class="bi bi-building-fill-up"></i></span> <span class="txt-link">Fornecedores</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="#">
                        <span class="icon"><i class="bi bi-person-badge-fill"></i></span> <span class="txt-link">Funcionários</span>
                    </a>
                </li>
                
                <%-- ACORDEÃO para Resumos Financeiros --%>
                <li class="nav-item">
                    <a class="nav-link active collapsed" data-bs-toggle="collapse" href="#collapseResumos" role="button" aria-expanded="false" aria-controls="collapseResumos">
                        <span class="icon"><i class="bi bi-journal-check"></i></span> <span class="txt-link">Resumos Financeiros</span>
                        <i class="bi bi-chevron-down ms-auto"></i> 
                    </a>
                    <div class="collapse" id="collapseResumos" data-bs-parent="#offcanvasMenu .navbar-nav">
                        <ul class="navbar-nav ms-4"> 
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#modalLucroPorVenda">Lucro por Venda</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#modalLucroPeriodo">Lucro por Período</a>
                            </li>
                           
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#modalVendasPeriodo">Vendas por Período</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#modalVendasDia">Vendas por Dia</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#modalMaisVendidos">Produtos Mais Vendidos</a>
                            </li>
                    
                        </ul>
                    </div>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link active collapsed" data-bs-toggle="collapse" href="#collapseCadastros" role="button" aria-expanded="false" aria-controls="collapseCadastros">
                        <span class="icon"><i class="bi bi-person-gear"></i></span> <span class="txt-link">Cadastros</span>
                        <i class="bi bi-chevron-down ms-auto"></i>
                    </a>
                     <div class="collapse" id="collapseCadastros" data-bs-parent="#offcanvasMenu .navbar-nav">
                        <ul class="navbar-nav ms-4"> 
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#">Usuário</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" id="linkAbrirModalEmpresa">Empresa</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" id="linkAbrirModalPagamento" data-bs-toggle="modal" data-bs-target="#modalCadastropagamento">Configuração de pagamento </a>
                            </li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="realizarVendas.jsp">
                        <span class="icon"><i class="bi bi-receipt-cutoff"></i></span> <span class="txt-link">Realizar Vendas</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="destroyLogautadm.jsp">
                        <span class="icon"><i class="bi bi-box-arrow-right"></i></span> <span class="txt-link">Sair</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    
    <%-- MODAL: Lucro por Período --%>
    <div class="modal fade" id="modalLucroPeriodo" tabindex="-1" aria-labelledby="modalLucroPeriodoLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalLucroPeriodoLabel">Lucro por Período</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formLucroPeriodo" action="lucroPeriodo" method="post">
                        <div class="mb-3">
                            <label for="dataInicialLucro" class="form-label">Data Inicial:</label>
                            <input type="text" id="dataInicialLucro" class="form-control" name="dataIniciallucro" required placeholder="DD/MM/AAAA">
                        </div>
                        <div class="mb-3">
                            <label for="dataFinalLucro" class="form-label">Data Final:</label>
                            <input type="text" id="dataFinalLucro" class="form-control" name="dataFinallucro" required placeholder="DD/MM/AAAA">
                        </div>
                        <div class="table-responsive mt-4">
                                      <table class="table table-dark table-striped">
                                <thead>
                                    <tr>
                                        <th>Total de Lucro no Período:</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Double lucroperiodo = (Double) request.getAttribute("totalLucro");
                                        if (lucroperiodo != null) {
                                            String lucroStr = String.format("%.2f", lucroperiodo); // Formata para 2 casas decimais
                                            if (!lucroStr.isEmpty()) {
                                    %>
                                    <tr>
                                        <td>R$ <%=lucroStr%></td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="1">Nenhum dado encontrado.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                            <button type="submit" class="btn btn-primary">Buscar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <%-- MODAL: Lucro por Venda --%>
    <div class="modal fade" id="modalLucroPorVenda" tabindex="-1" aria-labelledby="modalLucroPorVendaLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalLucroPorVendaLabel">Lucro por Venda</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formLucroVenda" action="lucroVenda" method="post">
                        <div class="mb-3">
                            <label for="codigoVendaInput" class="form-label">Código da Venda:</label>
                            <input type="text" id="codigoVendaInput" class="form-control" name="CodigoVenda" required placeholder="Digite o código da venda">
                        </div>
                        <div class="table-responsive mt-4">
                            <table class="table table-dark table-striped">
                                <thead>
                                    <tr>
                                        <th>Código:</th>
                                        <th>Lucro:</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Double lucro = (Double) request.getAttribute("lucro");
                                        if (lucro != null) {
                                            String lucroStr = String.format("%.2f", lucro); // Formata para 2 casas decimais
                                            if (!lucroStr.isEmpty()) {
                                    %>
                                    <tr>
                                        <td><%=request.getAttribute("vendaCodigo")%></td>
                                        <td>R$ <%=lucroStr%></td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="2">Nenhum dado encontrado.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                            <button type="submit" class="btn btn-primary">Buscar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%-- MODAL: Vendas por Dia --%>
    <div class="modal fade" id="modalVendasDia" tabindex="-1" aria-labelledby="modalVendasDiaLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalVendasDiaLabel">Vendas por Dia</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formVendasDia" action="dia" method="post">
                        <div class="mb-3">
                            <label for="dataInputDia" class="form-label">Data:</label>
                            <input type="text" id="dataInputDia" class="form-control" name="data" required placeholder="DD/MM/AAAA" value="<%=data%>">
                        </div>
						<div class="mb-3">
							<label for="totalVendaInput" class="form-label">Total:</label>
							<%
							double total = 0.0;
							if (totalVenda != null && !totalVenda.trim().isEmpty()) {
								total = Double.parseDouble(totalVenda);
							}
							%>
							<input type="text" id="totalVendaInput" class="form-control"
								name="totalVenda"
								value="R$ <%=String.format("%.2f", total).replace('.', ',')%>"
								readonly>

						</div>
						<div class="d-flex justify-content-end gap-2 mt-3">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                            <button type="submit" class="btn btn-primary">Buscar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    
<div class="modal fade" id="modalCadastroempresa" tabindex="-1" aria-labelledby="modalCadastroempresa" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modalEmpresaLabel">Dados da Empresa</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="container form-card">
                    <form name="cadastroForm" action="atualizaEmpresa" method="post" enctype="multipart/form-data">
                        <input type="hidden" id="idEmpresa" name="idEmpresa" value="<%= empresaModal != null ? empresaModal.getId() : "" %>">

                        <!-- ================= Informações Gerais ================= -->
                        <h4 class="text-secondary mb-4">Informações Gerais</h4>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nomeEmpresa" class="form-label">Nome Fantasia da Empresa:</label>
                                <input type="text" class="form-control" id="nomeEmpresa" name="nomeEmpresa" placeholder="Nome da sua empresa" required
                                       value="<%= empresaModal != null ? empresaModal.getNome() : "" %>">
                                <div class="invalid-feedback">Por favor, insira o nome fantasia da empresa.</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="empresaCnpj" class="form-label">CNPJ:</label>
                                <input type="text" class="form-control" id="empresaCnpj" name="empresaCnpj" placeholder="00.000.000/0000-00"
                                       value="<%= empresaModal != null ? empresaModal.getCnpj() : "" %>">
                                <div class="invalid-feedback">Por favor, insira um CNPJ válido.</div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label for="empresaEndereco" class="form-label">Endereço da Empresa:</label>
                                <input type="text" class="form-control" id="empresaEndereco" name="empresaEndereco" placeholder="Endereço completo da empresa"
                                       value="<%= empresaModal != null ? empresaModal.getEndereco() : "" %>">
                                <div class="invalid-feedback">Por favor, insira o endereço da empresa.</div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label for="logoEmpresa" class="form-label">Logo da Empresa:</label>
                                <input type="file" class="form-control" id="logoEmpresa" name="logoEmpresa">
                                <% if (empresaModal != null && empresaModal.getLogo() != null && empresaModal.getLogo().length > 0) { %>
                                    <div class="mt-2 text-center">
                                        <p>Logo atual:</p>
                                        <img src="data:image/jpeg;base64,<%= Base64.getEncoder().encodeToString(empresaModal.getLogo()) %>"
                                             alt="Logo da Empresa" style="max-width: 200px; height: auto; border: 1px solid #ddd; padding: 5px;">
                                    </div>
                                <% } else { %>
                                    <small class="form-text text-muted">Nenhuma logo cadastrada ou logo não disponível.</small>
                                <% } %>
                            </div>
                        </div>

                        <!-- ================= Configuração do Gateway ================= -->
							<hr class="my-4">
							<h4 class="text-secondary mb-3">Configuração de Pagamento</h4>
							<div class="row">
								<div class="col-md-6 mb-3">
									<label for="gateway" class="form-label">Gateway:</label> <select
										class="form-select" id="gateway" name="gateway" required>
										<option value="">Selecione</option>
										<option value="mercadopago"
											<%=(pagamentoModal != null && "mercadopago".equals(pagamentoModal.getGateway())) ? "selected" : ""%>>
											Mercado Pago</option>
										<option value="paypal"
											<%=(pagamentoModal != null && "paypal".equals(pagamentoModal.getGateway())) ? "selected" : ""%>>
											PayPal</option>
									</select>
								</div>

			

                    <!-- Chave Pix -->
                    <div class="col-12">
                        <label for="chavePix" class="form-label">Chave Pix</label>
                        <input type="text" id="chavePix" name="chavePix" class="form-control" placeholder="Sua chave Pix" value="<%= pagamentoModal != null ? pagamentoModal.getChavePix() : " " %>">
                    </div>

                    <!-- Client ID -->
                    <div class="col-12">
                        <label for="clientId" class="form-label">Client ID</label>
                        <input type="text" id="clientId" name="clientId" class="form-control" placeholder="Insira o Client ID do seu gateway" required value="<%= pagamentoModal != null ? pagamentoModal.getClientId() : "" %>">
                    </div>

                    <!-- Client Secret -->
                    <div class="col-12">
                        <label for="clientSecret" class="form-label">Client Secret</label>
                        <input type="password" id="clientSecret" name="clientSecret" class="form-control" placeholder="Insira o Client Secret do seu gateway" required value="<%= pagamentoModal != null ? pagamentoModal.getClientSecret() : "" %>">
                    </div>

                    <!-- Access Token -->
                    <div class="col-12">
                        <label for="accessToken" class="form-label">Access Token</label>
                        <input type="text" id="accessToken" name="accessToken" class="form-control" placeholder="Insira o Access Token do seu gateway" required value="<%= pagamentoModal != null ? pagamentoModal.getAccessToken() : "" %>">
                    </div>
                    <div class="col-12">
                        <label for="publickey" class="form-label">Public Key</label>
                        <input type="text" id="publickey" name="publickey" class="form-control" placeholder="Insira o Access Token do sua publickey" required value="<%= pagamentoModal != null ? pagamentoModal.getPublicKey() : "" %>">
                    </div>
							</div>

							<!-- ================= Horários de Funcionamento ================= -->
                        <hr class="my-4">
                        <h4 class="text-secondary mb-3">Horários de Funcionamento</h4>
                        <%-- (mantém exatamente o loop existente dos dias da semana) --%>
                        <% String[] diasSemana = {"Domingo","Segunda-feira","Terça-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sábado"}; %>
                        <% for (int i = 0; i < diasSemana.length; i++) { 
                            HorarioFuncionamento hfAtual = horariosMap.get(i);
                            boolean isAberto = (hfAtual != null && hfAtual.isAberto());
                            String horaAbertura = (hfAtual != null && hfAtual.getHoraAbertura() != null) ? hfAtual.getHoraAbertura() : "";
                            String horaFechamento = (hfAtual != null && hfAtual.getHoraFechamento() != null) ? hfAtual.getHoraFechamento() : "";
                        %>
                            <div class="mb-3 p-3 border rounded">
                                <div class="day-header d-flex justify-content-between align-items-center mb-2">
                                    <strong class="text-primary"><%= diasSemana[i] %></strong>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input dia-aberto-switch" type="checkbox" id="aberto_<%= i %>" name="aberto_<%= i %>" value="true" <%= isAberto ? "checked" : "" %>>
                                        <label class="form-check-label" for="aberto_<%= i %>">Aberto</label>
                                    </div>
                                </div>
                                <div class="row horario-inputs" id="horario_inputs_<%= i %>" style="<%= isAberto ? "" : "display: none;" %>">
                                    <div class="col-md-6 mb-3">
                                        <label for="abertura_<%= i %>" class="form-label">Abertura:</label>
                                        <input type="time" class="form-control" id="abertura_<%= i %>" name="abertura_<%= i %>" value="<%= horaAbertura %>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="fechamento_<%= i %>" class="form-label">Fechamento:</label>
                                        <input type="time" class="form-control" id="fechamento_<%= i %>" name="fechamento_<%= i %>" value="<%= horaFechamento %>">
                                    </div>
                                    <div class="col-12 mb-3">
                                        <label for="observacao_<%= i %>" class="form-label">Observação (opcional):</label>
                                        <input type="text" class="form-control" id="observacao_<%= i %>" name="observacao_<%= i %>"
                                               value="<%= (hfAtual != null && hfAtual.getObservacao() != null) ? hfAtual.getObservacao() : "" %>">
                                    </div>
                                </div>
                            </div>
                        <% } %>

                        <div class="text-center mt-5">
                            <button type="submit" class="btn btn-primary">Salvar Alterações</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

          
    
    <%-- MODAL: Produtos Mais Vendidos por Período --%>
    <div class="modal fade" id="modalMaisVendidos" tabindex="-1" aria-labelledby="modalMaisVendidosLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalMaisVendidosLabel">Produtos Mais Vendidos por Período</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formMaisVendidos" action="maisVendidos" method="post">
                        <div class="mb-3">
                            <label for="dataVendaInicio" class="form-label">Data Inicial:</label>
                            <input type="text" id="dataVendaInicio" class="form-control" name="dataVendainicio" required placeholder="DD/MM/AAAA">
                        </div>
                        <div class="mb-3">
                            <label for="dataVendaFim" class="form-label">Data Final:</label>
                            <input type="text" id="dataVendaFim" class="form-control" name="dataVendafim" required placeholder="DD/MM/AAAA">
                        </div>
                        <div class="table-responsive mt-4">
                           <table class="table table-dark table-striped">
                                <thead>
                                    <tr>
                                        <th>Quantidade:</th>
                                        <th>Descrição:</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<ItensVenda> maisVendidos = (List<ItensVenda>) request.getAttribute("maisVendidos");
                                        if (maisVendidos != null && !maisVendidos.isEmpty()) {
                                            for (ItensVenda produtosVendidos : maisVendidos) {
                                    %>
                                    <tr>
                                        <td><%=produtosVendidos.getQtd()%></td>
                                        <td><%=produtosVendidos.getProduto().getDescricao()%></td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="2">Nenhum dado encontrado.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                            <button type="submit" class="btn btn-primary">Buscar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%-- MODAL: Vendas por Período --%>
    <div class="modal fade" id="modalVendasPeriodo" tabindex="-1" aria-labelledby="modalVendasPeriodoLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalVendasPeriodoLabel">Vendas por Período</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formVendasPeriodo" action="PeriodoVenda" method="post">
                        <div class="mb-3">
                            <label for="dataInicialPeriodo" class="form-label">Data Inicial:</label>
                            <input type="text" id="dataInicialPeriodo" class="form-control" name="dataInicial" required placeholder="DD/MM/AAAA">
                        </div>
                        <div class="mb-3">
                            <label for="dataFinalPeriodo" class="form-label">Data Final:</label>
                            <input type="text" id="dataFinalPeriodo" class="form-control" name="dataFinal" required placeholder="DD/MM/AAAA">
                        </div>
                        <div class="table-responsive mt-4">
                            <table class="table table-dark table-striped">
                                <thead>
                                    <tr>
                                        <th>Data:</th>
                                        <th>Total:</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Vendas> periodoVenda = (List<Vendas>) request.getAttribute("periodo");
                                        if (periodoVenda != null && !periodoVenda.isEmpty()) {
                                            for (Vendas vendas : periodoVenda) {
                                    %>
                                    <tr>
                                        <td><%=vendas.getData_venda()%></td>
                                        <td>R$ <%=String.format("%.2f", vendas.getTotal_venda())%></td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="2">Nenhum dado encontrado.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                            <button type="submit" class="btn btn-primary">Buscar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
   <div class="modal fade" id="modalCadastropagamento" tabindex="-1" aria-labelledby="modalCadastropagamentoLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalCadastropagamentoLabel">Configurações de Pagamento</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Fechar"></button>
            </div>
            <div class="modal-body">
                <p class="text-center text-muted mb-4">
                    Configure as credenciais para o seu gateway de pagamento.
                </p>

                <form action="configpagamento" method="post" class="row g-3">

                    <!-- Gateway de Pagamento -->
                    <div class="col-12">
                        <label for="gateway" class="form-label">Gateway de Pagamento</label>
                        <select id="gateway" name="gateway" class="form-select" required>
                            <option value="MercadoPago">Mercado Pago</option>
                            <option value="PayPal">PayPal</option>
                        </select>
                    </div>

                    <!-- Chave Pix -->
                    <div class="col-12">
                        <label for="chavePix" class="form-label">Chave Pix</label>
                        <input type="text" id="chavePix" name="chavePix" class="form-control" placeholder="Sua chave Pix">
                    </div>

                    <!-- Client ID -->
                    <div class="col-12">
                        <label for="clientId" class="form-label">Client ID</label>
                        <input type="text" id="clientId" name="clientId" class="form-control" placeholder="Insira o Client ID do seu gateway" required>
                    </div>

                    <!-- Client Secret -->
                    <div class="col-12">
                        <label for="clientSecret" class="form-label">Client Secret</label>
                        <input type="password" id="clientSecret" name="clientSecret" class="form-control" placeholder="Insira o Client Secret do seu gateway" required>
                    </div>

                    <!-- Access Token -->
                    <div class="col-12">
                        <label for="accessToken" class="form-label">Access Token</label>
                        <input type="text" id="accessToken" name="accessToken" class="form-control" placeholder="Insira o Access Token do seu gateway" required>
                    </div>
                    <div class="col-12">
                        <label for="publickey" class="form-label">Public Key</label>
                        <input type="text" id="publickey" name="publickey" class="form-control" placeholder="Insira o Access Token do sua publickey" required>
                    </div>

                    <!-- Botão de Envio -->
                    <div class="col-12 d-grid mt-3">
                        <button type="submit" class="btn btn-primary btn-lg">Salvar Configurações</button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>


    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>

 <script type="text/javascript">
	
		
		$(document).ready(function() {
			// Aplica as máscaras de input
			$('#dataInicialPeriodo').mask('00/00/0000');
			$('#dataFinalPeriodo').mask('00/00/0000');
			$('#dataInicialLucro').mask('00/00/0000'); // Corrigido
			$('#dataFinalLucro').mask('00/00/0000');   // Corrigido
			$('#dataVendaInicio').mask('00/00/0000');
			$('#dataVendaFim').mask('00/00/0000');
			$('#dataInputDia').mask('00/00/0000'); // Corrigido
			

			// Lógica para reabrir os modais com base nos atributos da requisição
            <% if (request.getAttribute("totalLucro") != null) { %>
                $('#modalLucroPeriodo').modal('show');
                // Expande o acordeão "Resumos Financeiros" se o modal for aberto
                $('#collapseResumos').collapse('show');
            <% } %>

            <% if (request.getAttribute("lucro") != null) { %>
                $('#modalLucroPorVenda').modal('show');
                // Expande o acordeão "Resumos Financeiros" se o modal for aberto
                $('#collapseResumos').collapse('show');
            <% } %>

            <% if (!totalVenda.isEmpty()) { %>
                $('#modalVendasDia').modal('show');
                // Expande o acordeão "Histórico de Vendas" se o modal for aberto
                $('#collapseHistorico').collapse('show');
            <% } %>

            <% if (request.getAttribute("maisVendidos") != null && ((List<ItensVenda>) request.getAttribute("maisVendidos")).size() > 0) { %>
                $('#modalMaisVendidos').modal('show');
                // Expande o acordeão "Histórico de Vendas" se o modal for aberto
                $('#collapseHistorico').collapse('show');
            <% } %>

            <% if (request.getAttribute("periodo") != null && ((List<Vendas>) request.getAttribute("periodo")).size() > 0) { %>
                $('#modalVendasPeriodo').modal('show');
                // Expande o acordeão "Histórico de Vendas" se o modal for aberto
                $('#collapseHistorico').collapse('show');
            <% } %>
		});
	</script>
	<script>
	// A lógica para os links do menu que expandem/colapsam
	$(document).ready(function() {
		// Não precisamos mais desses handlers específicos se estamos usando data-bs-toggle="collapse"
		// diretamente nos links do acordeão, pois o Bootstrap já cuida disso.
		// Apenas para garantir que o acordeão "Resumos Financeiros" seja expandido se um de seus modais for aberto
	});
	
	</script>
	<script type="text/javascript">
    // Garante que o script só execute depois que o DOM estiver completamente carregado
    $(document).ready(function() {
        // Aplica as máscaras de input
        $('#dataInicialPeriodo').mask('00/00/0000');
        $('#dataFinalPeriodo').mask('00/00/0000');
        $('#dataInicialLucro').mask('00/00/0000');
        $('#dataFinalLucro').mask('00/00/0000');
        $('#dataVendaInicio').mask('00/00/0000');
        $('#dataVendaFim').mask('00/00/0000');
        $('#dataInputDia').mask('00/00/0000');

        // Lógica para reabrir os modais com base nos atributos da requisição (se houver)
        // Certifique-se de que estas seções JSP não estejam cortadas no seu Home.jsp
        <% if (request.getAttribute("totalLucro") != null) { %>
            $('#modalLucroPeriodo').modal('show');
            $('#collapseResumos').collapse('show');
        <% } %>

        <% if (request.getAttribute("lucro") != null) { %>
            $('#modalLucroPorVenda').modal('show');
            $('#collapseResumos').collapse('show');
        <% } %>

        <%-- A partir daqui, seu código da empresa ajustado --%>

       
            });
        }
    }); // Fecha o $(document).ready()
</script>
<script>
//Adicione este bloco DEPOIS de todos os seus imports de bibliotecas JS e suas máscaras

//Lógica para reabrir os modais com base nos atributos da requisição (Mantenha seu código existente)
//...
//Exemplo:
//<% if (!totalVenda.isEmpty()) { %>
//  $('#modalVendasDia').modal('show');
//<% } %>

$(document).ready(function() {
 // ... (Suas máscaras de input existentes e outras lógicas de $(document).ready) ...

 // ** Lógica Específica para o Modal da Empresa **

 // 1. Controlar a visibilidade dos campos de horário com base no switch "Aberto"
 // Isso aplica-se tanto ao carregar a página (com base nos valores do banco) quanto ao mudar o switch
 $('.dia-aberto-switch').each(function() {
     let diaIndex = this.id.split('_')[1];
     let horarioInputs = $('#horario_inputs_' + diaIndex);
     if (!$(this).is(':checked')) {
         horarioInputs.hide(); // Esconde se não estiver marcado inicialmente
     }
 }).on('change', function() {
     let diaIndex = this.id.split('_')[1];
     let horarioInputs = $('#horario_inputs_' + diaIndex);
     if ($(this).is(':checked')) {
         horarioInputs.slideDown(); // Mostra com animação
     } else {
         horarioInputs.slideUp();   // Esconde com animação
         // Opcional: Limpar os campos de hora quando o dia é desmarcado como 'Aberto'
         $('#abertura_' + diaIndex).val('');
         $('#fechamento_' + diaIndex).val('');
         $('#observacao_' + diaIndex).val(''); // Limpa a observação também
     }
 });

 // 2. Disparar a abertura do modal da empresa ao carregar a página, se os dados foram enviados
 // Este scriptlet verifica se o objeto 'empresaModal' foi populado pelo Servlet.
 // Se sim, significa que o Servlet "selecionaEmpresa" foi chamado, e o modal deve abrir.
 <% if (empresaModal != null) { %>
     $('#modalCadastroempresa').modal('show');
    
     // Opcional: expandir o acordeão "Cadastros" no menu lateral
     $('#collapseCadastros').collapse('show');
     
     
 <% } %>
 
 

 // 3. Lógica para o link "Empresa" no menu lateral
 // Ao invés de um AJAX que requer manipulação complexa do DOM,
 // faremos com que o link chame o Servlet diretamente.
 // O Servlet então faz o forward para menu.jsp, que é carregado com os dados e abre o modal.
 $('#linkAbrirModalEmpresa').on('click', function(e) {
     e.preventDefault(); // Previne o comportamento padrão do link

     // ** Importante: Defina qual ID de empresa você quer carregar. **
     // Se for um sistema com apenas UMA empresa principal, pode ser um ID fixo (ex: 1).
     // Se o usuário logado pertence a uma empresa específica, você precisaria ter o ID da empresa do usuário na sessão.
     let idDaEmpresaParaCarregar = 1; // ** AJUSTE AQUI: Use o ID da empresa relevante para o seu sistema **

     // Redireciona para o Servlet. O Servlet fará o processamento e o forward para este JSP novamente.
     window.location.href = 'selecionarEmpresa?id=' + idDaEmpresaParaCarregar;
 });
 


 // ... (Mantenha o resto do seu $(document).ready) ...
});

</script>
</body>
</html>
	
