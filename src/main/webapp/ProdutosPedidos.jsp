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
prodp = daop.listarProdutosPedido(); // Atribui o resultado da busca à lista exibida na tabela


%>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
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
                    <p class="card-text text-muted">R$ <%=String.format("%.2f", produto.getPreco_de_venda())%></p>

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
                   <input class="form-control-plaintext text-white text-end fw-bold" type="text" id="subtotalCarrinho" value="R$ XX,XX" readonly style="width: auto;">
                   
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
                            <option value="Cartao Crédito">Cartão de Crédito(no ato da entrega)</option>
                            <option value="Cartao Debito">Cartão de Débito(no ato da entrega)</option>  
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
<div class="modal fade" id="modalMeusPedidos" tabindex="-1" aria-labelledby="modalMeusPedidosLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content bg-dark text-white">
            <div class="modal-header">
                <h5 class="modal-title" id="modalMeusPedidosLabel">Meus Pedidos</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="conteudoMeusPedidos">
                    <p class="text-white">Carregando seus pedidos...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
            </div>
        </div>
    </div>
</div>
		</body>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script>
<script>
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
function adicionarProduto(id) {
    const quantidade = document.getElementById("quantidade_" + id).value;

    $.ajax({
        url: "selecionarVendaCarrinho",
        method: "GET",
        data: { id: id, qtd: quantidade, acao: "adicionar" }, // Adicionado acao: "adicionar"
        success: function(data) {
           
            $("#conteudoCarrinho").html(data);
            $("#carrinho").modal("show");

            // A função atualizarSubtotal() não está no código, mas se existir, ela seria chamada aqui.
            // Se o subtotal já vem no 'data' (como no seu servlet), você não precisa de uma função separada.
            // O script dentro do 'data' já atualiza o campo #subtotalCarrinho
        },
        error: function(xhr, status, error) { // Adicionado tratamento de erro mais detalhado
            console.error("Erro ao adicionar produto ao carrinho:", status, error);
            alert("Erro ao adicionar produto ao carrinho. Detalhes: " + xhr.responseText);
        }
    });
}
</script>


<script>
function removerProduto(id) {
    if (confirm("Tem certeza que deseja remover este item do carrinho?")) {
        $.ajax({
            url: "selecionarVendaCarrinho",
            method: "GET",
            data: { id: id, acao: "remover" }, // 'acao' para indicar remoção
            success: function(data) {
                // Atualiza o conteúdo do modal com o carrinho atualizado
                $("#conteudoCarrinho").html(data);
                // A função atualizarSubtotal() não está no código, mas se existir, ela seria chamada aqui.
                // O script dentro do 'data' já atualiza o campo #subtotalCarrinho
            },
            error: function(xhr, status, error) { // Adicionado tratamento de erro mais detalhado
                console.error("Erro ao remover produto do carrinho:", status, error);
                alert("Erro ao remover produto do carrinho. Detalhes: " + xhr.responseText);
            }
        });
    }
}
</script>
<script>
    function verCarrinho() {
        $.ajax({
            url: "selecionarVendaCarrinho",
            method: "GET",
            data: { acao: "ver" }, // 'acao' para indicar que queremos apenas ver o carrinho
            success: function(data) {
                $("#conteudoCarrinho").html(data); // Atualiza o conteúdo do modal com os itens do carrinho
                $("#carrinho").modal("show");      // Abre o modal do carrinho
            },
            error: function(xhr, status, error) { // Adicionado tratamento de erro mais detalhado
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
                // *** NOVO DEBUG: O QUE O JAVASCRIPT ESTÁ LENDO DO HTML? ***
                let subtotalText = subtotalCarrinhoDisplay.value; 
                console.log("DEBUG (JS) ANTES DA MANIPULAÇÃO: subtotalCarrinhoDisplay.value = '" + subtotalText + "'");

                // 2. Pré-limpeza: Remover "R$" e espaços
                subtotalText = subtotalText.replace('R$', '').trim(); 
                console.log("DEBUG (JS) APÓS REMOVER 'R$': '" + subtotalText + "'");

                // --- Lógica de normalização ---

                let decimalSeparator = '';
                // Simplificação: Se houver vírgula, use-a como separador decimal. Caso contrário, use ponto.
                if (subtotalText.includes(',')) {
                    decimalSeparator = ',';
                } else if (subtotalText.includes('.')) {
                    // Cuidado: pode ser um separador de milhar ou decimal.
                    // Para strings como '1.260.00', precisamos ser mais específicos.
                    // Se a string contiver mais de um '.', assumimos que todos, exceto o último, são milhares.
                    if ((subtotalText.match(/\./g) || []).length > 1) { // Conta o número de pontos
                         // Ex: '1.260.00'
                         let parts = subtotalText.split('.');
                         let lastPart = parts.pop(); // Remove a última parte (assumido decimal)
                         subtotalText = parts.join('') + '.' + lastPart; // Junta o resto e adiciona o decimal
                         console.log("DEBUG (JS) CORREÇÃO MÚLTIPLOS PONTOS: '" + subtotalText + "'");
                    }
                    decimalSeparator = '.'; // Último ponto é o decimal
                } else {
                    // Sem ponto ou vírgula, assume que é um número inteiro
                    decimalSeparator = '';
                }


                if (decimalSeparator === ',') {
                    // Se o separador decimal é vírgula (formato BR), remove pontos e troca vírgula por ponto
                    subtotalText = subtotalText.replace(/\./g, ''); // Remove separadores de milhar (pontos)
                    subtotalText = subtotalText.replace(',', '.');   // Troca vírgula decimal por ponto
                    console.log("DEBUG (JS) PÓS TRATAMENTO (VÍRGULA): '" + subtotalText + "'");
                } else if (decimalSeparator === '.') {
                    // Se já é ponto ou já foi tratado para ter um único ponto
                    // Não há mais nada a fazer, a string já deve estar no formato 'XXXX.YY'
                    console.log("DEBUG (JS) PÓS TRATAMENTO (PONTO): '" + subtotalText + "'");
                }
                
                // Fallback final para garantir que o resultado seja numérico e tenha um formato consistente.
                // Isso é essencial se a string ainda for inválida para BigDecimal.
                // `replace(',', '.')` no `parseFloat` é uma segurança extra caso o decimalSeparator seja vazio ou mal inferido.
                let parsedValue = parseFloat(subtotalText); // Tenta parsear
                if (isNaN(parsedValue)) {
                    subtotalText = "0.00"; 
                    console.error("ERRO (JS): Valor do subtotal não pôde ser normalizado para um número válido. Usando 0.00. String original para parseFloat: '" + subtotalText + "'");
                } else {
                    // Opcional: formatar para garantir 2 casas decimais, mesmo após o parseFloat
                    // Isso é bom para consistência, mas BigDecimal no Java lida com precisão
                    // subtotalText = parsedValue.toFixed(2);
                }


                // 3. Atribuir o valor limpo e formatado para o input hidden
                hiddenSubtotalInput.value = subtotalText;

                // Para depuração no console do navegador:
                console.log("DEBUG (JS): Valor FINAL do hiddenSubtotal enviado para o Servlet:", hiddenSubtotalInput.value);

                // 4. Submeter o formulário
                formFinalizarPedido.submit();
            });
        }
    });
</script>

<script>
    // Função para carregar e exibir os pedidos no modal
    function carregarMeusPedidos() {
        $.ajax({
            url: "listarPedidosCliente", // Chama o novo servlet
            method: "GET",
            success: function(data) {
                $("#conteudoMeusPedidos").html(data); // Preenche o conteúdo do modal
                // O modal será aberto pela função que chamou carregarMeusPedidos
            },
            error: function(xhr, status, error) {
                console.error("Erro ao carregar meus pedidos:", status, error);
                $("#conteudoMeusPedidos").html("<p class=\"text-danger\">Não foi possível carregar seus pedidos. Tente novamente mais tarde.</p>");
                alert("Erro ao carregar seus pedidos. Detalhes: " + xhr.responseText);
            }
        });
    }

    // Verifica se o modal de pedidos deve ser aberto ao carregar a página
    $(document).ready(function() {
        const urlParams = new URLSearchParams(window.location.search);
        const abrirModalPedidos = urlParams.get('abrirModalPedidos');

        if (abrirModalPedidos === 'true') {
            carregarMeusPedidos(); // Carrega os dados primeiro
            $('#modalMeusPedidos').modal('show'); // Abre o modal
            // Opcional: Remover o parâmetro da URL para que não reabra se a página for recarregada
            history.replaceState({}, document.title, window.location.pathname);
        }
    });

    // Você pode adicionar um botão para o cliente ver os pedidos manualmente também
    // Por exemplo, um botão "Meus Pedidos" no menu ou na página
    // Adicionar um botão no seu HTML:
    // <button type="button" class="btn btn-info" onclick="carregarMeusPedidos(); $('#modalMeusPedidos').modal('show');">Meus Pedidos</button>
</script>
<script>
    // Função para carregar os pedidos via AJAX e exibir no modal
    function carregarPedidosDoDia() {
        const conteudoPedidos = document.getElementById('conteudoPedidos');
        if (conteudoPedidos) {
            conteudoPedidos.innerHTML = '<p class="text-white text-center">Carregando seus pedidos...</p>'; // Mensagem de carregamento

            fetch('listarPedidosCliente') // Chama o servlet mapeado para /listarPedidosCliente
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 403) { // SC_FORBIDDEN
                            return response.text().then(text => Promise.reject(text));
                        }
                        throw new Error('Erro na rede ou no servidor: ' + response.statusText);
                    }
                    return response.text();
                })
                .then(data => {
                    conteudoPedidos.innerHTML = data; // Insere o HTML retornado pelo servlet
                    // Se o modal não estiver aberto, abra-o
                    var meusPedidosModal = new bootstrap.Modal(document.getElementById('meusPedidosModal'));
                    meusPedidosModal.show();
                })
                .catch(error => {
                    console.error('Erro ao carregar pedidos:', error);
                    let errorMessage = 'Não foi possível carregar os pedidos. Tente novamente mais tarde.';
                    if (typeof error === 'string') { // Se o erro for a mensagem do servidor (403)
                         errorMessage = error;
                    }
                    conteudoPedidos.innerHTML = '<p class="text-danger text-center">' + errorMessage + '</p>';
                    var meusPedidosModal = new bootstrap.Modal(document.getElementById('meusPedidosModal'));
                    meusPedidosModal.show(); // Abre o modal para mostrar o erro
                });
        }
    }

    // Adiciona o evento de clique ao botão
    document.addEventListener('DOMContentLoaded', function() {
        const btnVerPedidos = document.getElementById('btnVerPedidosDoDia');
        if (btnVerPedidos) {
            btnVerPedidos.addEventListener('click', carregarPedidosDoDia);
        }

        // Se a página foi recarregada com o parâmetro 'abrirModalPedidos=true' (do finalizarPedidoServlet)
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('abrirModalPedidos') && urlParams.get('abrirModalPedidos') === 'true') {
            carregarPedidosDoDia(); // Chama a função para carregar e abrir o modal
            // Opcional: Remover o parâmetro da URL para não reabrir o modal em futuros recarregamentos manuais
            // history.replaceState({}, document.title, window.location.pathname);
        }
    });
</script>

</html>