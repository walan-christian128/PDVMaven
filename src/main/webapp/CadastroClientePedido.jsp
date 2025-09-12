<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.TokenServiceDAO" %> <%-- Mantenha se você realmente usar TokenServiceDAO aqui --%>
<%
String erro = (String) request.getAttribute("erro");

//⚠️ CORREÇÃO: Recuperar o valor do parâmetro "empresapedido"
String empresa = request.getParameter("empresa");

if (empresa != null && !empresa.isEmpty() && !"null".equals(empresa)) {
 // Se a empresa foi passada por parâmetro, salve na sessão
 session.setAttribute("empresa", empresa);
} else {
 // Se não foi passada, tente recuperar da sessão
 empresa = (String) session.getAttribute("empresa");
 
 // Se a empresa ainda for nula, redirecione o usuário para a página de login
 if (empresa == null || empresa.isEmpty() || "null".equals(empresa)) {
     // Redireciona para a página de login.
     response.sendRedirect("LoginPedido.jsp");
     return; // É crucial parar a execução da JSP
 }
}
%>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro de Cliente</title>
    <link rel="icon" href="img/pedido-online.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
        crossorigin="anonymous">
    <style>
        body {
            background-image: url('img/Gemini_Generated_Image_kysa9wkysa9wkysa.png');
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .form-container {
            background-color: #ffffff;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
            width: 100%;
            max-width: 650px;
            animation: slideIn 0.8s ease-out;
            /* O formulário pode estar ligeiramente opaco até o modal ser fechado, se desejar */
            /* opacity: 0.7; pointer-events: none; */
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .btn-success, .btn-primary {
            transition: all 0.3s ease;
        }
        .btn-success:hover, .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        .form-control.is-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
        }
        .invalid-feedback {
            display: none; /* Inicia oculto, será mostrado via JS */
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
        .modal-footer-centered {
            justify-content: center;
        }
        .text-info-small {
            font-size: 0.9em;
            margin-top: 15px;
        }
    </style>
</head>
<body>

    <div class="modal fade" id="welcomeModal" tabindex="-1" aria-labelledby="welcomeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="welcomeModalLabel">Bem-vindo(a)!</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-3">Você já possui cadastro conosco?</p>
                    <p class="mb-4">Se sim, clique em **"Fazer Login"**. Se não, clique em **"Realizar Cadastro"** para continuar neste formulário!</p>
                    <hr>
                    <p id="horarioFuncionamento" class="text-info-small"></p>
                </div>
                <div class="modal-footer modal-footer-centered">
                    <a href="LoginPedido.jsp" class="btn btn-secondary btn-lg me-3">Fazer Login</a>
                    <button type="button" class="btn btn-success btn-lg" data-bs-dismiss="modal">Realizar Cadastro</button> <%-- Fecha o modal e permite o uso do form --%>
                </div>
            </div>
        </div>
    </div>

    <div class="container form-container">
        <h2 class="text-center mb-5 text-primary">Seus Dados de Cadastro</h2>

        <form action="cadClientePedido" method="get" id="cadastroForm"> <%-- Alterado para method="post" para segurança --%>
            <h5 class="text-center mb-4 text-secondary">Preencha com suas informações</h5>
            <input type="hidden" name="empresapedido" value="<%= empresa %>">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="nome" class="form-label">Nome Completo:</label>
                    <input type="text" class="form-control" id="nome" name="nome" placeholder="Ex: João Silva" required>
                    <div class="invalid-feedback">Por favor, preencha seu nome.</div>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="fone" class="form-label">Telefone:</label>
                    <input type="text" class="form-control" id="fone" name="fone" placeholder="(XX) XXXXX-XXXX" required>
                    <div class="invalid-feedback">Por favor, preencha um telefone válido.</div>
                </div>
            </div>

            <div class="mb-3">
                <label for="endereco" class="form-label">Endereço:</label>
                <input type="text" class="form-control" id="endereco" name="endereco" placeholder="Ex: Rua das Flores, 123" required>
                <div class="invalid-feedback">Por favor, preencha seu endereço.</div>
            </div>

            <div class="row">
                <div class="col-md-4 mb-3">
                    <label for="numero" class="form-label">Número:</label>
                    <input type="text" class="form-control" id="numero" name="numero" placeholder="N°" required>
                    <div class="invalid-feedback">Por favor, preencha o número.</div>
                </div>
                <div class="col-md-8 mb-3">
                    <label for="bairro" class="form-label">Bairro:</label>
                    <input type="text" class="form-control" id="bairro" name="bairro" placeholder="Ex: Centro" required>
                    <div class="invalid-feedback">Por favor, preencha seu bairro.</div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="cidade" class="form-label">Cidade:</label>
                    <input type="text" class="form-control" id="cidade" name="cidade" placeholder="Ex: Betim" required>
                    <div class="invalid-feedback">Por favor, preencha sua cidade.</div>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="estado" class="form-label">Estado:</label>
                    <select name="estado" class="form-select" id="estado" required>
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
                    </select>
                    <div class="invalid-feedback">Por favor, selecione seu estado.</div>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" class="form-control" id="email" name="email" placeholder="seu@email.com" required>
                <div class="invalid-feedback">Por favor, preencha um email válido.</div>
            </div>

            <div class="mb-4">
                <label for="senha" class="form-label">Senha:</label>
                <input type="password" class="form-control" id="senha" name="senha" placeholder="Crie sua senha" required>
                <div class="invalid-feedback">Por favor, crie uma senha.</div>
            </div>

            <div class="text-center">
                <button type="button" class="btn btn-success btn-lg" data-bs-toggle="modal" data-bs-target="#confirmacaoModal">
                    Cadastrar
                </button>

                <div class="modal fade" tabindex="-1" id="confirmacaoModal">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header bg-success text-white">
                                <h5 class="modal-title">Confirmar Cadastro</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body text-center">
                                <p>Todos os dados inseridos estão corretos e prontos para serem salvos?</p>
                            </div>
                            <div class="modal-footer modal-footer-centered">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Revisar</button>
                                <button type="submit" class="btn btn-primary" id="btnConfirmarCadastro">Sim, Cadastrar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="modal fade" id="editarClienteModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
        aria-labelledby="editarClienteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h1 class="modal-title fs-5" id="editarClienteModalLabel">Editar Cliente</h1>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="atualizaCliente" method="post" id="formEdicaoCliente">
                        <h5 class="text-center mb-3 text-secondary">Dados do Cliente</h5>

                        <div class="mb-3">
                            <label class="form-label">Código do Cliente:</label>
                            <input type="text" class="form-control" name="idCli" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nome:</label>
                            <input type="text" class="form-control" name="nomemodal" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Endereço:</label>
                            <input type="text" class="form-control" name="enderecomodal" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">N°:</label>
                            <input type="text" class="form-control" name="numeromodal" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">CEP:</label>
                            <input type="text" class="form-control" name="cepmodal" id="cepmodal" placeholder="XXXXX-XXX" required>
                        </div>
                        <div class="mb-3">
                            <label for="estadomodal" class="form-label">Estado:</label>
                            <select name="estadomodal" class="form-select" id="estadomodal" required>
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
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Telefone:</label>
                            <input type="text" class="form-control" name="fonemodal" id="fonemodal" placeholder="(XX) XXXXX-XXXX" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email:</label>
                            <input type="email" class="form-control" name="emailmodal" required>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                            <button type="submit" class="btn btn-success">Atualizar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


</body>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>

<script>
    $(document).ready(function() {
        // Exibe o modal de boas-vindas automaticamente ao carregar a página
        var welcomeModal = new bootstrap.Modal(document.getElementById('welcomeModal'), {
            backdrop: 'static', // Impede o fechamento ao clicar fora
            keyboard: false     // Impede o fechamento ao pressionar ESC
        });
        welcomeModal.show();

        // Lógica para verificar o horário de funcionamento (mantida do anterior)
        function verificarHorarioFuncionamento() {
            const now = new Date();
            const day = now.getDay(); // 0 = Domingo, 1 = Segunda, ..., 6 = Sábado
            const hour = now.getHours();
            const currentMinute = now.getMinutes();

            // Lembre-se: Estamos em Betim, MG. Horário atual: 8:42 AM
            // Horário de funcionamento: Segunda a Sábado, das 8h às 23h.
            const horaAbertura = 8;
            const horaFechamento = 23;

            let mensagem = "";
            let classColor = "";

            if (day >= 1 && day <= 6 && hour >= horaAbertura && hour < horaFechamento) {
                mensagem = "🥳 Ótima notícia! Estamos **abertos** para pedidos agora!";
                classColor = 'text-success';
            } else if (day === 0) { // Domingo
                 mensagem = "😴 Hoje é **Domingo**! Estamos fechados. Nosso horário de atendimento é de Segunda a Sábado, das " + horaAbertura + "h às " + horaFechamento + "h.";
                 classColor = 'text-danger';
            }
            else { // Fora do horário de funcionamento nos dias de semana
                mensagem = `😴 No momento, estamos **fechados**. Nosso horário de atendimento é de Segunda a Sábado, das ${horaAbertura}h às ${horaFechamento}h.`;
                classColor = 'text-danger';
            }

            $('#horarioFuncionamento').html(mensagem).removeClass('text-success text-danger').addClass(classColor);
        }

        // Chama a função ao carregar a página
        verificarHorarioFuncionamento();

        // Aplica máscaras aos campos (telefones e CEP)
        $('#fone').mask('(00) 00000-0000');
        $('#fonemodal').mask('(00) 00000-0000');
        $('#cepmodal').mask('00000-000');

        // Validação aprimorada do formulário de cadastro antes de abrir o modal de confirmação
        $('#cadastroForm').on('submit', function(event) {
            let formValido = true;
            $(this).find(':input[required]').each(function() {
                if (!$(this).val()) {
                    formValido = false;
                    $(this).addClass('is-invalid');
                    $(this).next('.invalid-feedback').css('display', 'block'); // Show feedback
                } else {
                    $(this).removeClass('is-invalid');
                    $(this).next('.invalid-feedback').css('display', 'none'); // Hide feedback
                }
            });

            if (!formValido) {
                event.preventDefault(); // Impede o envio do formulário
                $('#confirmacaoModal').modal('hide'); // Garante que o modal de confirmação não abra
            }
        });
    });
</script>
</html>