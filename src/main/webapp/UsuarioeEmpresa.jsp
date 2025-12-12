<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.TokenServiceDAO" %>
<%
    // Validação de token - Mantido como no seu código original
    String tokenRecebido = request.getParameter("token");
    if (tokenRecebido == null || !TokenServiceDAO.validarToken(tokenRecebido)) {
        response.sendRedirect("LinkExpirado.html"); // Certifique-se de ter esta página
        return;
    }
    
    // Captura o ID da empresa para usar no link de configuração do modal
    String idEmpresaCadastrada = request.getParameter("id_empresa_cadastrada");
    if (idEmpresaCadastrada == null) {
        idEmpresaCadastrada = "0"; // Valor default para evitar erro no link
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Cadastro de Empresa / Usuário</title>
    <link rel="icon" href="img/2992655_click_computer_currency_dollar_money_icon.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
          crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body {
            background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg');
            background-size: cover; 
            background-position: center;
            background-attachment: fixed; 
            margin: 0;
            padding: 20px 0; 
            min-height: 100vh; 
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column; 
        }
        .form-card {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 800px; 
            margin-top: 20px;
            margin-bottom: 20px;
            animation: fadeIn 0.8s ease-out; 
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .form-label {
            font-weight: 500;
            color: #333;
        }
        h1, h2, h3, h4, h5 {
            color: #0d6efd; 
            margin-bottom: 25px;
            text-align: center;
        }
        hr {
            margin-top: 30px;
            margin-bottom: 30px;
            border-top: 2px solid rgba(0, 0, 0, 0.1);
        }
        .btn-primary {
            padding: 12px 30px;
            font-size: 1.1em;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .form-check-label {
            margin-left: 10px;
            color: #555;
        }
        .day-header {
            background-color: #e9ecef;
            padding: 8px 15px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-weight: bold;
            color: #495057;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .invalid-feedback {
            display: none; 
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
        .form-control.is-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
        }
        /* Estilo para o botão de fechar do modal (para ser branco) */
        .modal-header .btn-close-white {
            filter: invert(1) grayscale(100%) brightness(200%);
        }
    </style>
</head>
<body>

<div class="container form-card">
    <h1>Cadastro de Usuário e Empresa</h1>

    <form name="cadastroForm" action="CadastroUserEmpresa" method="post" enctype="multipart/form-data">

        <h4 class="text-secondary mb-4">Dados do Usuário</h4>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="nome" class="form-label">Nome Completo:</label>
                <input type="text" class="form-control" name="nome" id="nome" placeholder="Seu nome" required>
                <div class="invalid-feedback">Por favor, insira seu nome completo.</div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="telefone" class="form-label">Telefone:</label>
                <input type="text" class="form-control" id="telefone" name="telefone" placeholder="(XX) XXXX-XXXX" required>
                <div class="invalid-feedback">Por favor, insira seu telefone.</div>
            </div>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email:</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="seu@email.com" required>
            <div class="invalid-feedback">Por favor, insira um email válido.</div>
        </div>
        <div class="mb-3">
            <label for="senha" class="form-label">Senha:</label>
            <input type="password" class="form-control" id="senha" name="senha" placeholder="Crie uma senha forte" required>
            <div class="invalid-feedback">Por favor, crie uma senha.</div>
        </div>

        <hr>

        <h4 class="text-secondary mb-4">Dados da Empresa</h4>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="base" class="form-label">Nome da Base de Dados (Identificador):</label>
                <input type="text" class="form-control" id="base" name="base" placeholder="nome_da_base_sem_espacos"
                       required pattern="[a-zA-Z0-9_]+" title="Somente letras, números e underscores, sem espaços">
                <div class="invalid-feedback">Por favor, insira um nome de base sem espaços ou caracteres especiais.</div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="nomeEmpresa" class="form-label">Nome Fantasia da Empresa:</label>
                <input type="text" class="form-control" id="nomeEmpresa" name="nomeEmpresa" placeholder="Nome da sua empresa" required>
                <div class="invalid-feedback">Por favor, insira o nome fantasia da empresa.</div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="empresaCnpj" class="form-label">CNPJ:</label>
                <input type="text" class="form-control" id="empresaCnpj" name="empresaCnpj" placeholder="00.000.000/0000-00">
                <div class="invalid-feedback">Por favor, insira um CNPJ válido.</div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="empresaEndereco" class="form-label">Endereço da Empresa:</label>
                <input type="text" class="form-control" id="empresaEndereco" name="empresaEndereco" placeholder="Endereço completo da empresa">
                <div class="invalid-feedback">Por favor, insira o endereço da empresa.</div>
            </div>
        </div>
        <div class="mb-3">
            <label for="logo" class="form-label">Logo da Empresa:</label>
            <input type="file" class="form-control" id="logo" name="logo" accept="image/*">
            <div class="invalid-feedback">Por favor, selecione uma imagem de logo.</div>
        </div>

        <hr>

        <h4 class="text-secondary mb-4">Horários de Funcionamento Padrão</h4>
        <p class="text-muted small mb-4">Defina os horários que sua empresa estará aberta. Se estiver fechada em um dia, desmarque a opção "Aberto" para o dia.</p>

        <%
            String[] diasSemana = {"Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"};
        %>

        <% for (int i = 0; i < diasSemana.length; i++) { %>
            <div class="mb-3 p-3 border rounded">
                <div class="day-header">
                    <span><%= diasSemana[i] %></span>
                    <div class="form-check form-switch">
                        <input class="form-check-input dia-aberto-switch" type="checkbox" id="aberto_<%= i %>" name="aberto_<%= i %>" <%= (i >= 1 && i <= 6) ? "checked" : "" %>> 
                        <label class="form-check-label" for="aberto_<%= i %>">Aberto</label>
                    </div>
                </div>
                <div class="row horario-inputs" id="horario_inputs_<%= i %>" style="<%= (i >= 1 && i <= 6) ? "" : "display: none;" %>">
                    <div class="col-md-6 mb-3">
                        <label for="abertura_<%= i %>" class="form-label">Abertura:</label>
                        <input type="time" class="form-control" id="abertura_<%= i %>" name="abertura_<%= i %>" value="<%= (i >= 1 && i <= 6) ? "08:00" : "" %>">
                        <div class="invalid-feedback">Informe um horário de abertura.</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="fechamento_<%= i %>" class="form-label">Fechamento:</label>
                        <input type="time" class="form-control" id="fechamento_<%= i %>" name="fechamento_<%= i %>" value="<%= (i >= 1 && i <= 6) ? "23:00" : "" %>">
                        <div class="invalid-feedback">Informe um horário de fechamento e que seja após a abertura.</div>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="text-center mt-5">
            <button type="submit" class="btn btn-primary">Salvar Cadastro</button>
        </div>
    </form>
</div>

<div class="modal fade" id="sugestaoModal" tabindex="-1" aria-labelledby="sugestaoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="sugestaoModalLabel">🚀 Próximos Passos Essenciais!</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>O cadastro da sua empresa e usuário foi realizado com sucesso!</p>
                
                <h6 class="mt-4 text-primary">Recomendamos ativar:</h6>
                
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                        <i class="bi bi-whatsapp me-2 text-success"></i>
                        <strong>Integração com WhatsApp:</strong> Ative a sessão para enviar notificações automáticas de pedidos.
                    </li>
                    <li class="list-group-item">
                        <i class="bi bi-credit-card me-2 text-info"></i>
                        <strong>Pagamento Online:</strong> Configure sua API de pagamento para receber pedidos imediatamente.
                    </li>
                </ul>
            </div>
            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Configurar Depois</button>
                <a href="ConfiguracoesEmpresa.jsp?id=<%= idEmpresaCadastrada %>" class="btn btn-primary">Ir para Configurações</a>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
        // Aplica máscaras
        $('#empresaCnpj').mask('00.000.000/0000-00');
        $('#telefone').mask('(00) 00000-0000'); 

        // Lógica para mostrar/esconder campos de horário baseados no switch "Aberto"
        $('.dia-aberto-switch').change(function() {
            const dayIndex = $(this).attr('id').split('_')[1];
            const horarioInputs = $('#horario_inputs_' + dayIndex);
            if ($(this).is(':checked')) {
                horarioInputs.slideDown();
                horarioInputs.find('input[type="time"]').attr('required', true);
            } else {
                horarioInputs.slideUp();
                horarioInputs.find('input[type="time"]').removeAttr('required').val('');
                horarioInputs.find('input[type="time"]').removeClass('is-invalid');
                horarioInputs.find('.invalid-feedback').hide();
            }
        });

        // Simula o clique para garantir o estado inicial correto ao carregar a página
        $('.dia-aberto-switch').each(function() {
            if (!$(this).is(':checked')) {
                const dayIndex = $(this).attr('id').split('_')[1];
                const horarioInputs = $('#horario_inputs_' + dayIndex);
                horarioInputs.hide();
                horarioInputs.find('input[type="time"]').removeAttr('required');
            }
        });


        // Validação do formulário antes do submit
        $('form[name="cadastroForm"]').on('submit', function(event) {
            let formValido = true;

            // Validação de campos de texto/email/senha/file
            $(this).find('input[required], select[required]').each(function() {
                if ($(this).is(':visible') && !$(this).val()) { 
                    formValido = false;
                    $(this).addClass('is-invalid');
                    $(this).next('.invalid-feedback').css('display', 'block');
                } else {
                    $(this).removeClass('is-invalid');
                    $(this).next('.invalid-feedback').css('display', 'none');
                }
            });

            // Validação dos horários de funcionamento
            for (let i = 0; i < 7; i++) {
                const switchAberto = $('#aberto_' + i);
                const aberturaInput = $('#abertura_' + i);
                const fechamentoInput = $('#fechamento_' + i);

                if (switchAberto.is(':checked')) { 
                    const horaAbertura = aberturaInput.val();
                    const horaFechamento = fechamentoInput.val();

                    if (!horaAbertura) {
                        formValido = false;
                        aberturaInput.addClass('is-invalid');
                        aberturaInput.next('.invalid-feedback').text('Informe um horário de abertura.').css('display', 'block');
                    } else {
                        aberturaInput.removeClass('is-invalid');
                        aberturaInput.next('.invalid-feedback').css('display', 'none');
                    }

                    if (!horaFechamento) {
                        formValido = false;
                        fechamentoInput.addClass('is-invalid');
                        fechamentoInput.next('.invalid-feedback').text('Informe um horário de fechamento.').css('display', 'block');
                    } else {
                        fechamentoInput.removeClass('is-invalid');
                        fechamentoInput.next('.invalid-feedback').css('display', 'none');
                    }

                    // Se ambos os horários estiverem preenchidos, valida a ordem
                    if (horaAbertura && horaFechamento && horaAbertura >= horaFechamento) {
                        formValido = false;
                        fechamentoInput.addClass('is-invalid');
                        fechamentoInput.next('.invalid-feedback').text('O horário de fechamento deve ser após o de abertura.').css('display', 'block');
                    }
                } else {
                    // Se o dia não estiver marcado como aberto, remove classes de validação
                    aberturaInput.removeClass('is-invalid');
                    fechamentoInput.removeClass('is-invalid');
                    aberturaInput.next('.invalid-feedback').css('display', 'none');
                    fechamentoInput.next('.invalid-feedback').css('display', 'none');
                }
            }


            if (!formValido) {
                event.preventDefault(); 
                $('html, body').animate({
                    scrollTop: $('.is-invalid').first().offset().top - 100 
                }, 500);
            }
        });

        // Oculta as mensagens de feedback ao digitar (melhora UX)
        $(this).find('input, select, textarea').on('input change', function() {
            if ($(this).hasClass('is-invalid')) {
                $(this).removeClass('is-invalid');
                $(this).next('.invalid-feedback').hide();
            }
        });
        
        // 🔑 LÓGICA NOVO: Exibir o modal se o cadastro for bem-sucedido
        const urlParams = new URLSearchParams(window.location.search);
        
        // Verifica se a URL contém ?status=sucesso
        if (urlParams.get('status') === 'sucesso') {
            const sugestaoModal = new bootstrap.Modal(document.getElementById('sugestaoModal'));
            sugestaoModal.show();
        }
    });
</script>

</body>
</html>