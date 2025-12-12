<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Model.Vendas"%>
<%@ page import="Model.Usuario"%> <%@ page import="DAO.VendasDAO"%>
<%@ page import="Model.Produtos"%>
<%@ page import="DAO.ProdutosDAO"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="jakarta.servlet.RequestDispatcher"%> <%
    // =========================================================
    // 🛑 1. GUARD DE LOGIN E DEFINIÇÕES DE ACESSO
    // =========================================================
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuario");
    String empresa = (String) session.getAttribute("empresa");
    
    // Se não houver objeto 'usuario' na sessão OU o nome da base estiver vazio
    if (usuarioLogado == null || empresa == null || empresa.isEmpty()) {
        // Redireciona para login (ou página de sessão expirada)
        RequestDispatcher rd = request.getRequestDispatcher("LoginExpirou.html");
        rd.forward(request, response);
        return; 
    }

    String nivel = usuarioLogado.getNivel();
    
    // Variáveis booleanas de controle para exibir funcionalidades:
    boolean isAdminOuSuperior = "ADMIN".equals(nivel) || "ROOT_MASTER".equals(nivel);
    boolean isRootMaster = "ROOT_MASTER".equals(nivel);

    // =========================================================
    // 🛑 2. LÓGICA DE NEGÓCIO E CORREÇÃO DO NULLPOINTEREXCEPTION
    // =========================================================
    List<Vendas> lista = new ArrayList<>(); // Inicializa para evitar NullPointer
    List<Produtos> prodp = new ArrayList<>(); // Inicializa para evitar NullPointer
    double totalVendasDia = 0;
    String daoErro = null; // Variável para armazenar erros do DAO
    
    try {
        // 🔑 CORREÇÃO AQUI: O DAO SÓ É CHAMADO SE A SESSÃO ESTIVER OK.
        // O erro (NullPointerException) ocorreu porque o DAO estava sendo criado
        // antes de você verificar se a sessão estava OK.
        
        // --- VendasDAO ---
        VendasDAO Vdao = new VendasDAO(empresa);
        lista = Vdao.listarVendasdoDia(); // Linha 24 original corrigida (agora dentro do try)
        
        // --- ProdutosDAO ---
        ProdutosDAO daop = new ProdutosDAO(empresa);
        prodp = daop.listarProdutos(); 
        
        // --- Total de Vendas ---
        SimpleDateFormat dataEUA = new SimpleDateFormat("yyyy-MM-dd");
        String datamysql = dataEUA.format(new Date());
        DateTimeFormatter formato = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate data_venda = LocalDate.parse(datamysql, formato);
        totalVendasDia = Vdao.retornaTotalVendaPorDia(data_venda);
        
    } catch (Exception e) {
        // Captura o erro do DAO (incluindo falha de conexão ou Query)
        System.err.println("Erro Crítico ao carregar dados da Home.jsp na base " + empresa + ": " + e.getMessage());
        daoErro = "Não foi possível carregar os dados (DB Error: " + e.getMessage() + ")";
        // As listas permanecerão vazias, e o erro será exibido.
    }

    // Definir o total de vendas como atributo da requisição
    request.setAttribute("totalVendido", totalVendasDia);

    // Limites de Alerta (os mesmos usados no JS)
    int limiteAlertaCritico = 3; 
    int limiteAlertaBaixo = 10;  
%>


<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>Home - <%= usuarioLogado.getNome() %>@<%= empresa %></title>
<link rel="icon"
	href="img/2992664_cart_dollar_mobile_shopping_smartphone_icon.png">
<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="bootstrap/js/bootstrap.bundle.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLMD/CDpYkRSl7Lq+d+bO08bH9n1h3kP3jDk+S7hE007a/uB4P9/1yA6k9d1G89S5+w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body
	style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; min-height: 100vh; width: 100vw;">
   
	<%@ include file="menu.jsp"%>

	<div class="container mt-4">
	
	    <% if (daoErro != null) { %>
            <div class="alert alert-danger text-center shadow-lg" role="alert">
                <strong>Erro de Conexão:</strong> <%= daoErro %>
            </div>
        <% } %>
		
		<% if (isRootMaster) { %>
            <div class="alert alert-danger shadow-lg mb-4 text-center" role="alert">
                <i class="fas fa-hammer me-2"></i> 
                <strong>ACESSO ROOT:</strong> Você está na base **<%= empresa %>**. 
                Use esta seção para gerenciar ativações críticas.
                <a href="PainelAtivacaoAPI.jsp?base=<%= empresa %>" class="btn btn-warning btn-sm ms-3">
                    <i class="fab fa-whatsapp me-1"></i> Ativação API
                </a>
            </div>
        <% } %>
		<div class="row mb-4">
            <div class="col-md-4">
                <div class="card bg-success text-white shadow">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-shopping-cart"></i> Total Vendido Hoje</h5>
                        <p class="card-text fs-2">R$ <%= String.format("%.2f", totalVendasDia) %></p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card bg-dark text-white shadow">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-box"></i> Produtos Disponivel em estoque</h5>
                        <p class="card-text fs-2"><%= prodp != null ? prodp.size() : 0 %></p>
                    </div>
                </div>
            </div>
            
             <div class="col-md-4 d-flex align-items-center justify-content-end">
                <a href="realizarVendas.jsp" class="btn btn-lg btn-danger shadow-lg">
                    <i class="fas fa-cash-register"></i> NOVA VENDA
                </a>
            </div>
        </div>
        <div class="row">
			<div class="col-md-6">
				<h2>Vendas do Dia</h2>
				<input type="text" id="filtroVendas" class="form-control mb-2 bg-dark text-white" placeholder="Buscar venda por Código ou Cliente..." data-table="tabelaVendas">

				<table id="tabelaVendas" class="table table-dark table-striped table-hover">
					<thead>
						<tr>
							<th>Código</th>
							<th>Nome</th>
							<th>Data</th>
							<th>Total</th>
							<th>Obs</th> <th>Desconto</th>
							<th>Pagamento</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (lista != null && !lista.isEmpty()) {
							for (int i = 0; i < lista.size(); i++) {
						%>
						<tr id="<%=lista.get(i).getId()%>" class="linha-editar"
							data-id="<%=lista.get(i).getId()%>">
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getId()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getCliente() != null && lista.get(i).getCliente().getNome() != null ? lista.get(i).getCliente().getNome() : "" %></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getData_venda()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getTotal_venda()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none" title="<%=lista.get(i).getObs()%>">...</a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getDesconto()%></a></td>
							<td><a href="selecionarVenda?id=<%=lista.get(i).getId()%>" class="text-white text-decoration-none"><%=lista.get(i).getformaPagamento()%></a></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="7">Não há vendas disponíveis na data de hoje.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				
				<div class="mb-3 p-3">
					<label class="form-label">Usuário Logado: </label> <input
						type="text" class="form-control bg-dark text-white"
						name="Usuarionome"
						value="Usuario: <%= usuarioLogado.getNome() %> (Nível: <%= nivel %>)"
						aria-label="Sizing example input"
						aria-describedby="inputGroup-sizing-sm" readonly>
				</div>
			</div>
			

			<div class="col-md-6">
				<h2>Produtos em Estoque</h2>
				<input type="text" id="filtroProdutos" class="form-control mb-2 bg-dark text-white" placeholder="Buscar produto por Código ou Descrição..." data-table="tabelaProdutos">

				<table id="tabelaProdutos" class="table table-dark table-striped table-hover">
					<thead>
						<tr>
							<th>Código</th>
							<th>Descrição</th>
							<th class="sortable" data-sort-by="2">Quantidade <i class="fas fa-sort-numeric-down text-secondary"></i></th>
						</tr>
					</thead>
					<tbody>
						<%
						if (prodp != null && !prodp.isEmpty()) {
							for (int i = 0; i < prodp.size(); i++) {
								int quantidade = prodp.get(i).getQtd_estoque();
								String classeAlerta = "";
								String iconeStatus = "";

								if (quantidade <= limiteAlertaCritico) {
							        // ALERTA CRÍTICO (Pisca-Pisca)
							        classeAlerta = "alerta-estoque-critico";
							        iconeStatus = "<i class='fas fa-exclamation-triangle text-danger pisca'></i> ";
								} else if (quantidade <= limiteAlertaBaixo) {
							        // ALERTA BAIXO (Amarelo Sólido)
							        classeAlerta = "alerta-estoque-baixo";
							        iconeStatus = "<i class='fas fa-exclamation-circle text-warning'></i> ";
								} else {
							        // ESTOQUE NORMAL
							        iconeStatus = "<i class='fas fa-check-circle text-success'></i> ";
								}
						%>
						<tr id="<%=prodp.get(i).getId()%>"
							class="linha-editar <%=classeAlerta%>"
							data-id="<%=prodp.get(i).getId()%>"
							data-qtd="<%=quantidade%>"> <td><a href="select?id=<%=prodp.get(i).getId()%>"
								class="text-white text-decoration-none"><%=prodp.get(i).getId()%></a></td>
							<td><a href="select?id=<%=prodp.get(i).getId()%>"
								class="text-white text-decoration-none"><%=prodp.get(i).getDescricao()%></a></td>
							<td><a href="select?id=<%=prodp.get(i).getId()%>"
								class="text-white text-decoration-none">
								<%=iconeStatus%> <%=quantidade%></a></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="3">Não há produtos disponíveis no estoque.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawR3GWtYfFMi/xa6I6dZ5p6vS+I623T4w15Q=" crossorigin="anonymous"></script>
    
	<style>
/* -------------------------------------- */
/* ESTILOS CSS PARA ALERTAS E USABILIDADE */
/* -------------------------------------- */
/* ... (Seus estilos CSS originais) ... */
.alerta-estoque-critico {
    background-color: #dc3545 !important;
    color: white !important;
}
.alerta-estoque-critico a, .alerta-estoque-critico .fas {
    color: white !important; 
}
.blink-ativo {
    background-color: #ffc107 !important;
    color: #343a40 !important;
}
.blink-ativo a, .blink-ativo .fas {
    color: #343a40 !important; 
}
.alerta-estoque-baixo {
    background-color: #ffc107 !important;
    color: #343a40 !important; 
}
.alerta-estoque-baixo a, .alerta-estoque-baixo .fas {
    color: #343a40 !important;
}
.pisca {
    animation: blinker 0.8s linear infinite;
}
@keyframes blinker {
    50% { opacity: 0.0; }
}
#tabelaVendas tbody tr td:nth-child(5) {
    max-width: 50px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
	</style>
</body>
<script>
    // ... (Seu código JavaScript original) ...
    // ... (Mantido sem alterações, pois o foco foi o JSP) ...
    function piscarAlertaEstoque() {
        $('.alerta-estoque-critico').each(function() {
            $(this).toggleClass('blink-ativo');
        });
    }

    function setupTableFilter(inputId, tableId) {
        $(inputId).on("keyup", function() {
            var value = $(this).val().toLowerCase();
            $(tableId + " tbody tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
    }
    
    function setupTableSorting(tableId) {
        $(tableId + ' th[data-sort-by]').on('click', function() {
            var table = $(this).parents('table').eq(0);
            var rows = table.find('tbody > tr').toArray().sort(comparer($(this).index()));
            this.asc = !this.asc;
            if (!this.asc) {
                rows = rows.reverse();
            }
            for (var i = 0; i < rows.length; i++) {
                table.append(rows[i]);
            }
            
            var icon = $(this).find('i');
            table.find('th i').removeClass('fa-sort-up fa-sort-down').addClass('fa-sort-numeric-down');
            if (this.asc) {
                icon.removeClass('fa-sort-numeric-down').addClass('fa-sort-up');
            } else {
                icon.removeClass('fa-sort-numeric-down').addClass('fa-sort-down');
            }
        });

        function comparer(index) {
            return function(a, b) {
                var valA = parseFloat($(a).data('qtd'));
                var valB = parseFloat($(b).data('qtd'));
                
                if (valA < valB) return -1;
                if (valA > valB) return 1;
                return 0;
            }
        }
    }

    $(document).ready(function() {
        setInterval(piscarAlertaEstoque, 800); 
        setupTableFilter('#filtroVendas', '#tabelaVendas');
        setupTableFilter('#filtroProdutos', '#tabelaProdutos');
        setupTableSorting('#tabelaProdutos');
        $('[title]').tooltip();
    });
</script>
</html>