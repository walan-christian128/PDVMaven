<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.TokenServiceDAO" %> 
<%@ page import="Model.HorarioFuncionamento" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.google.gson.Gson" %>

<%
String erro = (String) request.getAttribute("erro");
String empresa = request.getParameter("empresa");

// 🔹 Garante que o nome da empresa esteja na sessão
if (empresa != null && !empresa.isEmpty() && !"null".equals(empresa)) {
    session.setAttribute("empresa", empresa);
} else {
    empresa = (String) session.getAttribute("empresa");
    if (empresa == null || empresa.isEmpty() || "null".equals(empresa)) {
        response.sendRedirect("LoginPedido.jsp");
        return;
    }
}

// 🔹 Carrega e converte os horários para JSON
List<HorarioFuncionamento> listaHorarios = (List<HorarioFuncionamento>) request.getAttribute("horariosFuncionamento");
if (listaHorarios == null) listaHorarios = java.util.Collections.emptyList();

Map<Integer, HorarioFuncionamento> horariosMap = new HashMap<>();
for (HorarioFuncionamento hf : listaHorarios) {
    horariosMap.put(hf.getDiaSemana(), hf);
}

Gson gson = new Gson();
String horariosJson = horariosMap.isEmpty() ? "{}" : gson.toJson(horariosMap);
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cadastro de Cliente</title>
<link rel="icon" href="img/pedido-online.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    background-image: url('img/Gemini_Generated_Image_kysa9wkysa9wkysa.png');
    background-size: cover;
    background-position: center;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}
.form-container {
    background-color: #fff;
    padding: 35px;
    border-radius: 12px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.25);
    max-width: 650px;
    width: 100%;
    animation: slideIn 0.8s ease-out;
}
@keyframes slideIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}
.invalid-feedback { display: none; }
.modal-footer-centered { justify-content: center; }
.text-info-small { font-size: 0.9em; margin-top: 15px; }
</style>
</head>

<body>

<!-- 🔹 Modal de boas-vindas -->
<div class="modal fade" id="welcomeModal" tabindex="-1" aria-labelledby="welcomeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Bem-vindo(a)!</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <p>Você já possui cadastro conosco?</p>
        <p>Se sim, clique em <strong>"Fazer Login"</strong>. Caso contrário, em <strong>"Realizar Cadastro"</strong>.</p>
        <hr>
        <p id="horarioFuncionamento" class="text-info-small"></p>
      </div>
      <div class="modal-footer modal-footer-centered">
        <a href="LoginPedido.jsp" class="btn btn-secondary btn-lg me-3">Fazer Login</a>
        <button type="button" class="btn btn-success btn-lg" data-bs-dismiss="modal">Realizar Cadastro</button>
      </div>
    </div>
  </div>
</div>

<!-- 🔹 Formulário principal -->
<div class="container form-container">
  <h2 class="text-center mb-5 text-primary">Seus Dados de Cadastro</h2>

  <form action="cadClientePedido" method="get" id="cadastroForm">
    <input type="hidden" name="empresapedido" value="<%= empresa %>">

    <div class="row">
      <div class="col-md-6 mb-3">
        <label class="form-label">Nome Completo:</label>
        <input type="text" class="form-control" id="nome" name="nome" required>
        <div class="invalid-feedback">Por favor, preencha seu nome.</div>
      </div>
      <div class="col-md-6 mb-3">
        <label class="form-label">Telefone:</label>
        <input type="text" class="form-control" id="fone" name="fone" placeholder="(XX) XXXXX-XXXX" required>
        <div class="invalid-feedback">Por favor, preencha um telefone válido.</div>
      </div>
    </div>

    <div class="mb-3">
      <label class="form-label">Endereço:</label>
      <input type="text" class="form-control" id="endereco" name="endereco" required>
    </div>

    <div class="row">
      <div class="col-md-4 mb-3">
        <label class="form-label">Número:</label>
        <input type="text" class="form-control" id="numero" name="numero" required>
      </div>
      <div class="col-md-4 mb-3">
        <label class="form-label">CEP:</label>
        <input type="text" class="form-control" id="cepPedido" name="cepPedido" placeholder="00000-000" required>
      </div>
      <div class="col-md-4 mb-3">
        <label class="form-label">Bairro:</label>
        <input type="text" class="form-control" id="bairro" name="bairro" required>
      </div>
    </div>

    <div class="row">
      <div class="col-md-6 mb-3">
        <label class="form-label">Cidade:</label>
        <input type="text" class="form-control" id="cidade" name="cidade" required>
      </div>
      <div class="col-md-6 mb-3">
        <label class="form-label">Estado:</label>
        <select name="estado" class="form-select" id="estado" required>
          <option value="">Selecione o Estado</option>
          <option value="MG">Minas Gerais</option>
          <option value="SP">São Paulo</option>
          <option value="RJ">Rio de Janeiro</option>
          <!-- ... demais estados -->
        </select>
      </div>
    </div>

    <div class="mb-3">
      <label class="form-label">Email:</label>
      <input type="email" class="form-control" id="email" name="email" required>
    </div>

    <div class="mb-4">
      <label class="form-label">Senha:</label>
      <input type="password" class="form-control" id="senha" name="senha" required>
    </div>

    <div class="text-center">
      <button type="button" class="btn btn-success btn-lg" data-bs-toggle="modal" data-bs-target="#confirmacaoModal">
        Cadastrar
      </button>
    </div>

    <!-- 🔹 Modal de confirmação -->
    <div class="modal fade" id="confirmacaoModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-success text-white">
            <h5 class="modal-title">Confirmar Cadastro</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body text-center">
            <p>Todos os dados estão corretos?</p>
          </div>
          <div class="modal-footer modal-footer-centered">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Revisar</button>
            <button type="submit" class="btn btn-primary">Sim, Cadastrar</button>
          </div>
        </div>
      </div>
    </div>
  </form>
</div>

<!-- 🔹 Scripts -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"></script>

<script>
function verificarHorarioFuncionamento(horarios) {
  const now = new Date();
  const day = now.getDay();
  const configDia = horarios[day];
  let mensagem, classe;

  if (!configDia || !configDia.aberto) {
    mensagem = "😴 Estamos fechados no momento. Consulte nossos horários de atendimento.";
    classe = "text-danger";
  } else {
    const abrir = configDia.horaAbertura.substring(0,5);
    const fechar = configDia.horaFechamento.substring(0,5);
    const [ha, ma] = abrir.split(':').map(Number);
    const [hf, mf] = fechar.split(':').map(Number);
    const minutosAgora = now.getHours()*60 + now.getMinutes();
    const minutosAbertura = ha*60 + ma;
    const minutosFechamento = hf*60 + mf;

    if (minutosAgora >= minutosAbertura && minutosAgora < minutosFechamento) {
      mensagem = "🥳 Estamos abertos para pedidos agora!";
      classe = "text-success";
    } else {
      mensagem = `😴 Fechados agora. Hoje atendemos das ${abrir} às ${fechar}.`;
      classe = "text-danger";
    }
  }

  $('#horarioFuncionamento').text(mensagem).removeClass().addClass(classe);
  console.log(horarios);
}

function carregarCadastroPedido() {
	  return fetch('carregarCadastroPedido', {
	    headers: { 'X-Requested-With': 'XMLHttpRequest' } // <- essencial
	  })
	    .then(response => {
	      if (!response.ok) throw new Error('Erro ao chamar o servlet');
	      return response.json();
	    })
	    .then(data => {
	      console.log("📅 Horários retornados:", data);
	      return data;
	    })
	    .catch(error => {
	      console.error('Erro ao carregar horários:', error);
	      return [];
	    });
	}


$(function() {
  const modal = new bootstrap.Modal('#welcomeModal', { backdrop: 'static', keyboard: false });
  modal.show();

  // Chama o servlet e só depois verifica o horário
  carregarCadastroPedido().then(horarios => {
    verificarHorarioFuncionamento(horarios);
  });

  // Máscaras
  const SPMaskBehavior = val => val.replace(/\D/g, '').length === 11 ? '(00) 00000-0000' : '(00) 0000-00009';
  $('#fone').mask(SPMaskBehavior, {
    onKeyPress: (val, e, field, options) =>
      field.mask(SPMaskBehavior.apply({}, arguments), options)
  });
  $('#cepPedido').mask('00000-000');

  // ViaCEP
  $('#cepPedido').on('blur', function() {
    const cep = $(this).val().replace(/\D/g, '');
    if (cep.length !== 8) return;
    $.getJSON(`https://viacep.com.br/ws/${cep}/json/`, dados => {
      if (!dados.erro) {
        $('#estado').val(dados.uf);
        $('#cidade').val(dados.localidade);
        $('#endereco').val(dados.logradouro);
        $('#bairro').val(dados.bairro);
      }
    });
  });

  // Validação
  $('#cadastroForm').on('submit', function(e) {
    let valido = true;
    $(this).find(':input[required]').each(function() {
      if (!$(this).val()) {
        valido = false;
        $(this).addClass('is-invalid').next('.invalid-feedback').show();
      } else {
        $(this).removeClass('is-invalid').next('.invalid-feedback').hide();
      }
    });
    if (!valido) e.preventDefault();
  });
});
</script>


</body>
</html>
