<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="DAO.TokenServiceDAO" %>
<%@ page import="DAO.ProdutosDAO" %>
<%@ page import="Model.Produtos" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Locale" %>


<%
String empresa = (String) session.getAttribute("empresa");
%>

<%
List<Produtos> prodp; // Declara a lista
ProdutosDAO daop = new ProdutosDAO(empresa);
// Garante que o método listarProdutosPedido() está correto, ele deve tratar o caso de 'empresa' ser nulo.
prodp = (empresa != null) ? daop.listarProdutosPedido() : new ArrayList<>(); // Atribui o resultado da busca à lista exibida na tabela
%>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Produtos para pedidos</title>
<link rel="icon" href="img/pedido-online.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
    crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
td a {
    text-decoration: none;
    color: inherit;
    cursor: pointer;
}
 .modal-content {
        background-color: #1e1e1e;
        color: white;
    }

    .modal-header, .modal-footer {
        border-color: #444;
    }

    .btn-dark {
        background-color: #5c16c5;
        border: none;
    }

    .btn-dark:hover {
        background-color: #3e0e90;
    }
    
    #subtotalCarrinho {
        background-color: #212529;
        color: #fff;
        font-weight: bold;
        text-align: right;
    }
    .status-progress-bar img {
    max-width: 30px; /* Ajuste este valor conforme necessário */
    height: auto;
}
</style>

</head>


<body style="background-image: url('img/Gemini_Generated_Image_kysa9wkysa9wkysa.png'); background-size: cover; background-position: center; margin: 0; padding: 0; height: 100vh;">
<%@ include file="menuCliente.jsp"%>
	<div class="container mt-4 text-center">
		<button type="button" class="btn btn-danger btn-lg"
			onclick="verCarrinho()">
			Ver Carrinho
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
				fill="currentColor" class="bi bi-cart" viewBox="0 0 16 16">
            <path
					d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l1.313 7h8.17l1.313-7H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z" />
        </svg>
		</button>
		<button class="btn btn-info rounded-circle shadow" id="btnVerPedidosDoDia"
    style="position: fixed; bottom: 20px; right: 20px; width: 80px; height: 80px; font-size: 1.1rem; z-index: 1000; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; padding: 5px;"
    title="Ver Meus Pedidos do Dia">
    <i class="bi bi-basket mb-1" style="font-size: 1.5rem;"></i> <small>Pedidos</small> </button>

<div class="modal fade" id="meusPedidosModal" tabindex="-1" aria-labelledby="meusPedidosModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark text-white">
            <div class="modal-header">
                <h5 class="modal-title" id="meusPedidosModalLabel">Meus Pedidos do Dia</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="conteudoPedidos">
                <p>Carregando pedidos...</p>
            </div>
            <div class="modal-footer">
                <%-- O botão Cancelar Pedido será adicionado pela listagem do Servlet se o pedido for cancelável --%>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                 
            </div>
        </div>
    </div>
</div>
	</div>
	<div class="container mt-4">
    <div class="row justify-content-center">
        <%
        if (prodp != null && !prodp.isEmpty()) {
            for (int i = 0; i < prodp.size(); i++) {
                Produtos produto = prodp.get(i);
        %>
        <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-4">
            <div class="card h-100 shadow-sm text-center">
                <img src="exibirImagemProduto?id=<%=produto.getId()%>" class="card-img-top" alt="Imagem"
                     style="height: 180px; object-fit: cover;" onerror="this.src='img/padrao.png';">
                <div class="card-body d-flex flex-column justify-content-between">
                    <h5 class="card-title"><%=produto.getDescricao()%></h5>
                    <p class="card-text text-muted">R$ <%=String.format(Locale.of("pt", "BR"), "%.2f", produto.getPreco_de_venda())%></p>

                    <div class="d-flex justify-content-center align-items-center gap-2 mb-2">
                        <button class="btn btn-outline-secondary btn-sm" type="button"
                                onclick="diminuirQuantidade(<%=produto.getId()%>)">-</button>
                        <input type="text" id="quantidade_<%=produto.getId()%>" value="1"
                               class="form-control form-control-sm text-center" style="width: 50px;" readonly>
                        <button class="btn btn-outline-secondary btn-sm" type="button"
                                onclick="aumentarQuantidade(<%=produto.getId()%>)">+</button>
                    </div>

						<button class="btn btn-dark btn-sm"
							onclick="adicionarProduto(<%=produto.getId()%>)">
							Adicionar</button>

					</div>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div class="col-12 text-center">
            <p class="text-muted">Nenhum produto encontrado.</p>
        </div>
        <%
        }
        %>
    </div>
</div>
       
 

   
		<div class="modal fade" id="carrinho" tabindex="-1" aria-labelledby="carrinhoLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg"> <div class="modal-content bg-dark text-white">
            <div class="modal-header">
                <h5 class="modal-title" id="carrinhoLabel">Itens no carrinho</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <div id="conteudoCarrinho" class="mb-3" style="max-height: 300px; overflow-y: auto;">
                    </div>

                <div class="d-flex justify-content-between align-items-center mt-3 p-2 bg-secondary rounded">
                    <h5 class="mb-0">Subtotal:</h5>
                   <input class="form-control-plaintext text-white text-end fw-bold" type="text" id="subtotalCarrinho" value="R$ 0,00" readonly style="width: auto;">
                   
                </div>

                <form id="formFinalizarPedido" action="finalizarPedidoServlet" method="post" class="mt-4">
                    <input type="hidden" name="clienteId" value="<%= (session.getAttribute("usuarioID") != null) ? session.getAttribute("usuarioID") : "" %>">
                     <input type="hidden" name="subtotal" id="hiddenSubtotal">
                    <div class="mb-3">
                        <label for="observacoesPedido" class="form-label">Observações:</label>
                        <textarea class="form-control bg-dark text-white" id="observacoesPedido" name="observacoes" rows="2" placeholder="Adicione observações sobre o pedido..."></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="formaPagamento" class="form-label">Forma de pagamento :</label>
                        <select class="form-select bg-dark text-white" id="formaPagamento" name="formaPagamento" required>
                            <option value="" selected disabled>Selecione a Opção de pagamento</option>
                            <option value="Dinheiro">Dinheiro</option>
                            <option value="Cartao Crédito">Cartão de Crédito (no ato da entrega)</option>
                            <option value="Cartao Debito">Cartão de Débito (no ato da entrega)</option>  
                            <option value="MERCADOPAGOPAY">Pagamento Online</option>
                            <option value="Pix">Pix (no ato da entrega)</option>
                        </select>
                    </div>
                </form> </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Voltar a Produtos</button>
                <button type="button" class="btn btn-primary" id="btnFinalizarPedido">Finalizar Pedido</button>
            </div>
        </div>
    </div>
</div>

<%-- 1. NOVO MODAL DE CONFIRMAÇÃO/ESTORNO INSERIDO AQUI --%>
<div class="modal fade" id="modalConfirmacaoCancelamento" tabindex="-1" aria-labelledby="modalConfirmacaoCancelamentoLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content bg-dark text-white">
            <div class="modal-header">
                <h5 class="modal-title" id="modalConfirmacaoCancelamentoLabel">Confirmação de Cancelamento</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="mensagemCancelamento"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Voltar</button>
                <button type="button" class="btn btn-danger" id="btnConfirmarCancelamento">Sim, Cancelar Pedido</button>
            </div>
        </div>
    </div>
</div>
<%-- FIM DO NOVO MODAL (O outro modal de pedidos foi removido para evitar duplicação, usando apenas 'meusPedidosModal') --%>


		</body>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script>

<script>
    // Funções de ajuste de quantidade (mantidas)
    function aumentarQuantidade(id) {
        const campo = document.getElementById("quantidade_" + id);
        let valor = parseInt(campo.value);
        campo.value = valor + 1;
    }

    function diminuirQuantidade(id) {
        const campo = document.getElementById("quantidade_" + id);
        let valor = parseInt(campo.value);
        if (valor > 1) {
            campo.value = valor - 1;
        }
    }
</script>

<script>
// Função para adicionar produto ao carrinho (mantida)
function adicionarProduto(id) {
    const quantidade = document.getElementById("quantidade_" + id).value;

    $.ajax({
        url: "selecionarVendaCarrinho",
        method: "GET",
        data: { id: id, qtd: quantidade, acao: "adicionar" }, 
        success: function(data) {
           
            $("#conteudoCarrinho").html(data);
            $("#carrinho").modal("show");

        },
        error: function(xhr, status, error) { 
            console.error("Erro ao adicionar produto ao carrinho:", status, error);
            alert("Erro ao adicionar produto ao carrinho. Detalhes: " + xhr.responseText);
        }
    });
}

// Função para remover produto do carrinho (mantida)
function removerProduto(id) {
    if (confirm("Tem certeza que deseja remover este item do carrinho?")) {
        $.ajax({
            url: "selecionarVendaCarrinho",
            method: "GET",
            data: { id: id, acao: "remover" }, 
            success: function(data) {
                $("#conteudoCarrinho").html(data);
            },
            error: function(xhr, status, error) { 
                console.error("Erro ao remover produto do carrinho:", status, error);
                alert("Erro ao remover produto do carrinho. Detalhes: " + xhr.responseText);
            }
        });
    }
}

// Função para ver o carrinho (mantida)
function verCarrinho() {
    $.ajax({
        url: "selecionarVendaCarrinho",
        method: "GET",
        data: { acao: "ver" }, 
        success: function(data) {
            $("#conteudoCarrinho").html(data); 
            $("#carrinho").modal("show");      
        },
        error: function(xhr, status, error) { 
            console.error("Erro ao carregar o carrinho:", status, error);
            alert("Erro ao carregar o carrinho. Detalhes: " + xhr.responseText);
        }
    });
}
</script>


<script>
    document.addEventListener('DOMContentLoaded', function() {
        const btnFinalizarPedido = document.getElementById('btnFinalizarPedido');
        const formFinalizarPedido = document.getElementById('formFinalizarPedido');
        const subtotalCarrinhoDisplay = document.getElementById('subtotalCarrinho');
        const hiddenSubtotalInput = document.getElementById('hiddenSubtotal');

        if (btnFinalizarPedido && formFinalizarPedido && subtotalCarrinhoDisplay && hiddenSubtotalInput) {
            btnFinalizarPedido.addEventListener('click', function() {
                // --- Lógica de sanitização e formatação do Subtotal para envio ao Servlet ---
                let subtotalText = subtotalCarrinhoDisplay.value; 

                // 1. Pré-limpeza: Remover "R$" e espaços
                subtotalText = subtotalText.replace('R$', '').trim(); 

                // 2. Normalização: Tratar formato brasileiro (ponto como milhar, vírgula como decimal)
                // Remove pontos de milhar e troca vírgula decimal por ponto
                subtotalText = subtotalText.replace(/\./g, ''); 
                subtotalText = subtotalText.replace(',', '.');   

                // 3. Validação e formatação final
                let parsedValue = parseFloat(subtotalText);
                if (isNaN(parsedValue)) {
                    subtotalText = "0.00"; 
                    console.error("ERRO (JS): Valor do subtotal não pôde ser normalizado. Usando 0.00.");
                } else {
                    subtotalText = parsedValue.toFixed(2); // Garante 2 casas decimais
                }

                // 4. Atribuir o valor limpo e formatado para o input hidden
                hiddenSubtotalInput.value = subtotalText;

                // 5. Submeter o formulário
                formFinalizarPedido.submit();
            });
        }
    });
</script>

<%-- 2. NOVO JAVASCRIPT PARA CANCELAMENTO COM AVISO DE ESTORNO --%>
<script>
    let pedidoIDParaCancelar = null; // Variável global para armazenar o ID do pedido que será cancelado

    /**
     * Inicia o processo de cancelamento, verificando a forma de pagamento para exibir o aviso de estorno.
     * Esta função é chamada pelo botão "Cancelar Pedido" que é renderizado pelo 'pedidoServer'.
     */
    function iniciarCancelamento(pedidoId, formaPagamento) {
        pedidoIDParaCancelar = pedidoId; // Armazena o ID do pedido

        const mensagemElement = document.getElementById('mensagemCancelamento');
        let mensagem = `Tem certeza que deseja cancelar o **Pedido #${pedidoId}**?`;
        
        // Formas de pagamento que implicam estorno
        // Usei "Cartao Crédito" conforme definido no seu <select> do modal de carrinho
        const formasComEstorno = ['MERCADOPAGOPAY', 'Cartao Crédito']; 

        if (formasComEstorno.includes(formaPagamento)) {
            // Usa <strong class="text-warning"> para destacar o aviso
            mensagem += `<br><br><strong class="text-warning">ATENÇÃO:</strong> Como a forma de pagamento foi **${formaPagamento}** (pagamento online/cartão), o estorno será processado e o valor deverá ser creditado na sua conta/fatura no prazo de **3 dias úteis**.`;
        } else {
            mensagem += `<br><br>O cancelamento será processado imediatamente.`;
        }
        
        mensagemElement.innerHTML = mensagem;
        
        // Abre o modal de confirmação
        const modalConfirmacao = new bootstrap.Modal(document.getElementById('modalConfirmacaoCancelamento'));
        modalConfirmacao.show();

        // Oculta o modal de pedidos do dia
        const modalPedidosEl = document.getElementById('meusPedidosModal');
        const modalPedidos = bootstrap.Modal.getInstance(modalPedidosEl);
        if(modalPedidos) modalPedidos.hide();
    }

    // Evento de clique para o botão "Sim, Cancelar Pedido" dentro do modal de Confirmação
    document.addEventListener('DOMContentLoaded', function() {
        const btnConfirmarCancelamento = document.getElementById('btnConfirmarCancelamento');
        if (btnConfirmarCancelamento) {
            btnConfirmarCancelamento.addEventListener('click', function() {
                if (pedidoIDParaCancelar !== null) {
                    
                    // Chamada AJAX para o Servlet (/cancelarPedidoServlet)
                    $.ajax({
                        url: "cancelarPedidoServlet", 
                        method: "POST", 
                        data: { id: pedidoIDParaCancelar, status: "Cancelado" },
                        success: function(response) {
                            alert("Pedido " + pedidoIDParaCancelar + " cancelado com sucesso!");
                            
                            // Fecha o modal de confirmação
                            const modalConfirmacaoEl = document.getElementById('modalConfirmacaoCancelamento');
                            const modalConfirmacao = bootstrap.Modal.getInstance(modalConfirmacaoEl);
                            modalConfirmacao.hide();
                            
                            // Reabre e recarrega a lista de pedidos para refletir a mudança
                            carregarPedidosDoDia(true); // O 'true' indica para forçar a abertura após o carregamento
                        },
                        error: function(xhr, status, error) {
                            alert("Erro ao tentar cancelar o pedido: " + xhr.responseText);
                            // Se der erro, pode reabrir o modal de pedidos se desejar
                            carregarPedidosDoDia(true); 
                        }
                    });

                } else {
                    alert("Erro: ID do pedido não encontrado para cancelamento.");
                }
            });
        }
    });
</script>
<%-- FIM NOVO JAVASCRIPT CANCELAMENTO --%>

<script>
    /**
     * Função para carregar os pedidos via AJAX e exibir no modal.
     * @param {boolean} [forceOpen=false] - Se true, força a abertura do modal após o carregamento.
     */
    function carregarPedidosDoDia(forceOpen = false) {
        const conteudoPedidos = document.getElementById('conteudoPedidos');
        if (conteudoPedidos) {
            // Certifique-se de que o modal está preparado para abrir
            const meusPedidosModalEl = document.getElementById('meusPedidosModal');
            let meusPedidosModal = bootstrap.Modal.getInstance(meusPedidosModalEl);
            if (!meusPedidosModal) {
                 meusPedidosModal = new bootstrap.Modal(meusPedidosModalEl);
            }
            if (forceOpen) {
                meusPedidosModal.show(); // Abre imediatamente para mostrar "Carregando"
            }
            
            conteudoPedidos.innerHTML = '<p class="text-white text-center">Carregando seus pedidos...</p>'; 

            fetch('listarPedidosCliente') // Chama o servlet mapeado para /listarPedidosCliente
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 403) { 
                            return response.text().then(text => Promise.reject(text));
                        }
                        throw new Error('Erro na rede ou no servidor: ' + response.statusText);
                    }
                    return response.text();
                })
                .then(data => {
                    conteudoPedidos.innerHTML = data; // Insere o HTML retornado pelo servlet
                    if (forceOpen) meusPedidosModal.show();
                })
                .catch(error => {
                    console.error('Erro ao carregar pedidos:', error);
                    let errorMessage = 'Não foi possível carregar os pedidos. Tente novamente mais tarde.';
                    if (typeof error === 'string') {
                         errorMessage = error;
                    }
                    conteudoPedidos.innerHTML = '<p class="text-danger text-center">' + errorMessage + '</p>';
                    if (forceOpen) meusPedidosModal.show();
                });
        }
    }

    // Adiciona o evento de clique ao botão
    document.addEventListener('DOMContentLoaded', function() {
        const btnVerPedidos = document.getElementById('btnVerPedidosDoDia');
        if (btnVerPedidos) {
            btnVerPedidos.addEventListener('click', () => carregarPedidosDoDia(true)); // Passa true para forçar a abertura
        }

        // Se a página foi recarregada com o parâmetro 'abrirModalPedidos=true'
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('abrirModalPedidos') && urlParams.get('abrirModalPedidos') === 'true') {
            carregarPedidosDoDia(true); // Chama a função para carregar e abrir o modal
            history.replaceState({}, document.title, window.location.pathname); // Limpa a URL
        }
    });
</script>

</html>