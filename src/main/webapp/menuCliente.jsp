<%@ page import="Model.Clientepedido" %>
<%@ page import="Model.ItensPedidos" %>
<%@ page import="DAO.ClientesPedidosDAO" %>
<%@ page import="DAO.PedidosDAO" %>
<%@ page import="DAO.ItensPedidoDAO" %>
<%@ page import="Model.Pedidos" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.text.NumberFormat, java.util.Locale" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    
    Clientepedido clienteSessao = (Clientepedido) session.getAttribute("clienteLogado");
    String nomeCliente = (clienteSessao != null && clienteSessao.getNome() != null) ? clienteSessao.getNome() : "Cliente";
    Clientepedido clienteModal = (Clientepedido) request.getAttribute("clienteParaModal");

    if (clienteSessao == null) {
        response.sendRedirect("LoginPedido.jsp");
        return;
    }
    String empresaCliente = (String) session.getAttribute("empresa");
    List<Pedidos> PedidosCliente = new ArrayList<>();
    try {
    	ClientesPedidosDAO clienteDAO = new ClientesPedidosDAO(empresaCliente);
    	PedidosCliente = clienteDAO.pedidosCliente(clienteSessao.getId());

    } catch (Exception e) {

    }
    
   
   
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

%>


<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menu do Cliente</title>
    <link rel="icon" href="img/2992655_click_computer_currency_dollar_money_icon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.css" />

    <style>
        body {
            background-image: url('img/background-menu.webp');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            width: 100vw;
        }

        .offcanvas-body .nav-link {
            font-size: 1.5rem;
            padding: 0.75rem 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
            color: inherit;
            text-decoration: none;
        }

        .offcanvas-body .nav-link .icon {
            font-size: 1.8rem;
        }
    </style>
</head>
<body>

    <i class="bi bi-list d-flex ms-3 mt-3" data-bs-toggle="offcanvas" href="#offcanvasMenu" role="button" aria-controls="offcanvasMenu" style="font-size: 3rem; cursor: pointer; color: white;"></i>

    <div class="offcanvas offcanvas-start bg-light" tabindex="-1" id="offcanvasMenu" aria-labelledby="offcanvasMenuLabel">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="offcanvasMenuLabel">Menu do Cliente</h5>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body">
            <div class="mb-3">
                <p class="h5 text-primary">Bem-vindo, <%= nomeCliente %></p>
            </div>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
             
				<li class="nav-item"><a class="nav-link active"
					href="selecionacp?id=<%=clienteSessao.getId()%>"> <span
						class="icon"><i class="bi bi-person-circle"></i></span> <span
						class="txt-link">Meus Dados</span>
				</a></li>
				<li class="nav-item">
                    <a class="nav-link active" href="#" data-bs-toggle="modal" data-bs-target="#modalPedidos">
                        <span class="icon"><i class="bi bi-card-checklist"></i></span> <span class="txt-link">Meus pedidos</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="detroyLogaut.jsp">
                        <span class="icon"><i class="bi bi-box-arrow-right"></i></span> <span class="txt-link">Sair</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>

    

<div class="modal fade" id="modalDadosCadastrais" tabindex="-1" aria-labelledby="modalDadosCadastraisLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modalDadosCadastraisLabel">Alterar Dados Cadastrais</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="atualizaDadosCliente" method="get" class="needs-validation" novalidate>
                    <%-- Input para o ID do cliente, usado para identificar qual cliente atualizar --%>
                    <input type="hidden" name="idCliente" id="idClienteInput" value="<%= clienteModal != null ? clienteModal.getId() : "" %>">

                    <div class="mb-3">
                        <label for="nomeCliente" class="form-label">Nome Completo:</label>
                        <input type="text" class="form-control" id="nomeCliente" name="nomeCliente" required
                               value="<%= clienteModal != null ? clienteModal.getNome() : "" %>">
                        <div class="invalid-feedback">Por favor, insira seu nome.</div>
                    </div>
                    <div class="mb-3">
                        <label for="telefoneCliente" class="form-label">Telefone:</label>
                        <input type="text" class="form-control" id="telefoneCliente" name="telefoneCliente" placeholder="(99) 9999-9999"
                               value="<%= clienteModal != null ? clienteModal.getCelular() : "" %>">
                    </div>
                    <div class="mb-3">
                        <label for="emailCliente" class="form-label">E-mail:</label>
                        <input type="email" class="form-control" id="emailCliente" name="emailCliente" required
                               value="<%= clienteModal != null ? clienteModal.getEmail() : "" %>">
                        <div class="invalid-feedback">Por favor, insira um e-mail válido.</div>
                    </div>

                    <h5 class="text-secondary mt-4 mb-3">Endereço</h5>
                    <div class="row">
                        <div class="col-md-9 mb-3">
                            <label for="ruaCliente" class="form-label">Rua:</label>
                            <input type="text" class="form-control" id="ruaCliente" name="ruaCliente"
                                   value="<%= clienteModal != null ? clienteModal.getEndereco() : "" %>">
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="numeroCliente" class="form-label">Número:</label>
                            <input type="text" class="form-control" id="numeroCliente" name="numeroCliente"
                                   value="<%= clienteModal != null ? clienteModal.getNumero() : "" %>">
                        </div>
                             <div class="col-md-3 mb-3">
                            <label for="cepPedido" class="form-label">Cep:</label>
                            <input type="text" class="form-control" id="cepPedido" name="cepPedido"
                                   value="<%= clienteModal != null ? clienteModal.getCep() : "" %>">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="bairroCliente" class="form-label">Bairro:</label>
                            <input type="text" class="form-control" id="bairroCliente" name="bairroCliente"
                                   value="<%= clienteModal != null ? clienteModal.getBairro() : "" %>">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="cidadeCliente" class="form-label">Cidade:</label>
                            <input type="text" class="form-control" id="cidadeCliente" name="cidadeCliente"
                                   value="<%= clienteModal != null ? clienteModal.getCidade() : "" %>">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="estadoCliente" class="form-label">Estado:</label>
                      <select
						name="estadoCliente" class="form-select" id="estadoCliente">
						<option value="">Selecione o Estado</option>
						<option value="AC"
							<%if ("AC".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Acre</option>
						<option value="AL"
							<%if ("AL".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Alagoas</option>
						<option value="AP"
							<%if ("AP".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Amapá</option>
						<option value="AM"
							<%if ("AM".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Amazonas</option>
						<option value="BA"
							<%if ("BA".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Bahia</option>
						<option value="CE"
							<%if ("CE".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Ceará</option>
						<option value="DF"
							<%if ("DF".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Distrito
							Federal</option>
						<option value="ES"
							<%if ("ES".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Espírito
							Santo</option>
						<option value="GO"
							<%if ("GO".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Goiás</option>
						<option value="MA"
							<%if ("MA".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Maranhão</option>
						<option value="MT"
							<%if ("MT".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Mato
							Grosso</option>
						<option value="MS"
							<%if ("MS".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Mato
							Grosso do Sul</option>
						<option value="MG"
							<%if ("MG".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Minas
							Gerais</option>
						<option value="PA"
							<%if ("PA".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Pará</option>
						<option value="PB"
							<%if ("PB".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Paraíba</option>
						<option value="PR"
							<%if ("PR".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Paraná</option>
						<option value="PE"
							<%if ("PE".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Pernambuco</option>
						<option value="PI"
							<%if ("PI".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Piauí</option>
						<option value="RJ"
							<%if ("RJ".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Rio
							de Janeiro</option>
						<option value="RN"
							<%if ("RN".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Rio
							Grande do Norte</option>
						<option value="RS"
							<%if ("RS".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Rio
							Grande do Sul</option>
						<option value="RO"
							<%if ("RO".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Rondônia</option>
						<option value="RR"
							<%if ("RR".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Roraima</option>
						<option value="SC"
							<%if ("SC".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Santa
							Catarina</option>
						<option value="SP"
							<%if ("SP".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>São
							Paulo</option>
						<option value="SE"
							<%if ("SE".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Sergipe</option>
						<option value="TO"
							<%if ("TO".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Tocantins</option>
						<option value="EX"
							<%if ("EX".equals(clienteModal != null ? clienteModal.getUf() : ""))
	out.print("selected");%>>Estrangeiro</option>
					</select>

                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-3">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                        <button type="submit" class="btn btn-primary">Salvar Alterações</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

    <div class="modal fade" id="modalPedidos" tabindex="-1" aria-labelledby="modalAlterarSenhaLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalAlterarSenhaLabel">Meus Pedidos</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
 <div class="col-md-12">
    <div class="table-container">
        <table class="table table-dark table-striped table-hover">
            <thead>
                <tr>
               
                    <th>Data</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Observação</th>
                    <th>Pagamento</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <%if(PedidosCliente != null && ! PedidosCliente.isEmpty()){ 
                    for(int i = 0 ; i< PedidosCliente.size();i++ ){
                        String status = PedidosCliente.get(i).getStatus();
                        String badgeClass = "";
                        switch(status.toLowerCase()) {
                            case "entregue":
                                badgeClass = "bg-success";
                                break;
                            case "reprovado":
                                badgeClass = "bg-danger";
                                break;
                            case "pendente":
                                badgeClass = "bg-warning text-dark";
                                break;
                            default:
                                badgeClass = "bg-secondary";
                                break;
                        }
                %>
                <tr>
                 
                    <td><%=PedidosCliente.get(i).getDataPeedido() %></td>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    <td><%= currencyFormat.format(PedidosCliente.get(i).getTotalPedido()) %></td>
                    <td class="text-truncate" style="max-width: 150px;"><%= PedidosCliente.get(i).getObservacoes() %></td>
                   <td><%=PedidosCliente.get(i).getFormapagamento() != null && !PedidosCliente.get(i).getFormapagamento().isEmpty()
		? PedidosCliente.get(i).getFormapagamento()
		: "-"%></td>
                    <td>
    <div class="d-flex flex-column flex-md-row gap-1">
        <a type="button" class="btn btn-sm btn-info visualize-pedido"
            data-id-pedido="<%=PedidosCliente.get(i).getIdPedido()%>"
            data-bs-toggle="modal" data-bs-target="#modaldetlhesPedidos">
            <i class="bi bi-eye"></i>
        </a>
    </div>
</td>
                </tr>
                <%
                    }
                } else{
                %>
                <tr>
                    <td colspan="8" class="text-center">Nenhum pedido realizado ainda.</td>
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
        </div>
        
<div class="modal fade" id="modaldetlhesPedidos" tabindex="-1" aria-labelledby="modalAlterarSenhaLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modalAlterarSenhaLabel">Detalhes Pedido</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="col-md-12">
                    <div class="table-container">
                        <table class="table table-dark table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Quantidade</th>
                                    <th>Preço Unitário</th>
                                    <th>Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"></script>
    
    <script>
    $(document).ready(function() {
        
        // =======================================================
        // 🚀 Aplicação das Máscaras (jQuery Mask Plugin)
        // =======================================================
        
        // 1. Máscara de Telefone/Celular (Flexível: 8 ou 9 dígitos + DDD)
        var SPMaskBehavior = function (val) {
          return val.replace(/\D/g, '').length === 11 ? '(00) 00000-0000' : '(00) 0000-00009';
        },
        spOptions = {
          onKeyPress: function(val, e, field, options) {
              field.mask(SPMaskBehavior.apply({}, arguments), options);
            }
        };
        $('#telefoneCliente').mask(SPMaskBehavior, spOptions);

        // 2. Máscara de CEP
        $('#cepPedido').mask('00000-000');
        
        // 3. Máscara para Número do Endereço (Opcional: aceita até 5 dígitos)
        $('#numeroCliente').mask('0#'); 


        // =======================================================
        // 📝 Scripts de Validação e Abertura de Modal (Existente)
        // =======================================================
        
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });

            // Reativa o scriptlet que abre o modal 'modalDadosCadastrais' 
            // se o atributo 'clienteParaModal' estiver na requisição
            <%if (request.getAttribute("clienteParaModal") != null) {%>
                var modal = new bootstrap.Modal(document.getElementById('modalDadosCadastrais'));
                modal.show();
            <%}%>
        })();
        
        // =======================================================
        // 🛒 Script para Visualização de Detalhes do Pedido (Existente)
        // =======================================================

        $('#modalPedidos').on('click', '.visualize-pedido', function(e) {
            e.preventDefault();
            
            var idPedido = $(this).data('id-pedido');
            
            $.ajax({
                url: 'selecionarPedidoCliente',
                type: 'GET',
                data: { id: idPedido },
                dataType: 'json', 
                success: function(itensPedido) {
                    var tableBody = $('#modaldetlhesPedidos .modal-body tbody');
                    tableBody.empty();
                    
                    if (itensPedido && itensPedido.length > 0) {
                        $.each(itensPedido, function(index, item) {
                            // Formatação para moeda (R$) com 2 casas decimais e vírgula
                            var precoUnitarioFormatado = parseFloat(item.precoUnitario).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
                            var subtotal = item.quantidade * item.precoUnitario;
                            var subtotalFormatado = subtotal.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
                            
                            var row = '<tr>' +
                                '<td>' + item.produto.descricao + '</td>' +
                                '<td>' + item.quantidade + '</td>' +
                                '<td>' + precoUnitarioFormatado + '</td>' +
                                '<td>' + subtotalFormatado + '</td>' +
                            '</tr>';
                            tableBody.append(row);
                        });
                    } else {
                        var noDataRow = '<tr>' +
                            '<td colspan="4" class="text-center">Nenhum detalhe de pedido encontrado.</td>' +
                        '</tr>';
                        tableBody.append(noDataRow);
                    }
                    
                    $('#modalPedidos').modal('hide');
                    setTimeout(function() {
                        $('#modaldetlhesPedidos').modal('show');
                    }, 400);
                },
                error: function(xhr) {
                    var errorMessage = 'Erro ao carregar os detalhes do pedido.';
                    // Adicionei uma verificação de erro mais robusta
                    try {
                        var jsonError = JSON.parse(xhr.responseText);
                        errorMessage = jsonError.error || jsonError.message || errorMessage;
                    } catch (e) {
                        // Se não for JSON, usa o texto ou a mensagem padrão
                        errorMessage = xhr.responseText.substring(0, 100) + '...' || errorMessage;
                    }
                    alert("Erro (" + xhr.status + "): " + errorMessage);
                }
                
            });
        });
    });
    </script>
    <script>
$(document).ready(function() {
    $("#cepPedido").on("keypress", function(e) {
        if (e.which == 13) {  // Verifica se a tecla pressionada é Enter
            e.preventDefault(); // Previne o comportamento padrão de envio do formulário

            var numCep = $("#cepPedido").val().replace(".", "").replace("-", ""); // Remover formatação do CEP
            var url = "https://viacep.com.br/ws/"+numCep+"/json";

            console.log("CEP digitado: " + numCep);

            $.ajax({
                url: url,
                type: "get",
                dataType: "json",
                success: function(dados) {
                    console.log("Resposta da API:", dados);
                    $("#estadoCliente").val(dados.uf);
                    $("#cidadeCliente").val(dados.localidade);
                    $("#ruaCliente").val(dados.logradouro);
                    $("#bairroCliente").val(dados.bairro);
                },
                error: function(xhr, status, error) {
                    console.log("Erro na solicitação AJAX:", error);
                }
            });
        }
    });
});
</script>
</body>
</html>