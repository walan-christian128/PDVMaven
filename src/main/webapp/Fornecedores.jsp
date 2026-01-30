<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Fornecedores, DAO.FornecedoresDAO, java.util.List"%>

<%
    String empresa = (String) session.getAttribute("empresa");
    if (empresa == null || empresa.isEmpty()) {
        response.sendRedirect("LoginExpirou.html");
        return;
    }

    FornecedoresDAO dao = new FornecedoresDAO(empresa);
    List<Fornecedores> lista = dao.listaFornecedores();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciamento de Fornecedores</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.css" />
    
    <style>
        body {
            background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg');
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
            color: #fff;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            color: #333;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        .table-container {
            background: rgba(33, 37, 41, 0.85);
            border-radius: 15px;
            padding: 20px;
        }
        .form-label { font-weight: bold; margin-bottom: 2px; font-size: 0.85rem; color: #444; }
        .modal-label { font-weight: bold; color: #333; }
    </style>
</head>
<body style="background-image: url('img/Gemini_Generated_Image_97a36f97a36f97a3.jpg'); background-size: auto auto; background-position: center; margin: 0; padding: 0; height: 100vh; width: 100vw;">

    <%@ include file="menu.jsp"%>

    <div class="container-fluid mt-4">
        <div class="row px-2">
            
          <div class="col-lg-3 mb-4">
                <div class="glass-card">
                    <h4 class="text-center mb-4">Cadastro / Edição</h4>
                    <form action="insertFornecedor" method="post" id="formFornecedor" class="needs-validation" novalidate>
                        
                        <div class="row">
                            <div class="col-4 mb-2">
                                <label class="form-label">Cód.</label>
                                <input type="text" class="form-control" name="id" id="id" disabled placeholder="Novo">
                            </div>
                            <div class="col-8 mb-2">
                                <label class="form-label">CNPJ</label>
                                <input type="text" class="form-control" name="cnpj" id="cnpj" required>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Razão Social / Nome</label>
                            <input type="text" class="form-control" name="nome" id="nome" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">E-mail</label>
                            <input type="email" class="form-control" name="email" id="email" required>
                        </div>

                        <div class="row">
                            <div class="col-6 mb-2">
                                <label class="form-label">WhatsApp</label>
                                <input type="text" class="form-control" name="celular" id="celular">
                            </div>
                            <div class="col-6 mb-2">
                                <label class="form-label">Telefone</label>
                                <input type="text" class="form-control" name="telefone" id="telefone">
                            </div>
                        </div>

                        <hr>

                        <div class="row">
                            <div class="col-6 mb-2">
                                <label class="form-label">CEP</label>
                                <input type="text" class="form-control" name="cep" id="cep" placeholder="Pressione Enter" required>
                            </div>
                            <div class="col-6 mb-2">
                                <label class="form-label">Estado (UF)</label>
                                <input type="text" class="form-control" name="estado" id="estado" readonly>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Endereço</label>
                            <input type="text" class="form-control" name="endereco" id="endereco">
                        </div>

                        <div class="row">
                            <div class="col-4 mb-2">
                                <label class="form-label">Nº</label>
                                <input type="text" class="form-control" name="numero" id="numero">
                            </div>
                            <div class="col-8 mb-2">
                                <label class="form-label">Bairro</label>
                                <input type="text" class="form-control" name="bairro" id="bairro">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Cidade</label>
                            <input type="text" class="form-control" name="cidade" id="cidade">
                        </div>

                        <button type="button" class="btn btn-primary w-100 py-2" data-bs-toggle="modal" data-bs-target="#modalConfirm">
                            Salvar Fornecedor
                        </button>
                    </form>
                </div>
            </div>

            <div class="col-lg-9">
                <div class="table-container shadow">
                    <h3 class="mb-4 text-center">Fornecedores Cadastrados</h3>
                    <div class="table-responsive">
                        <table id="tabelaFornecedores" class="table table-dark table-hover align-middle w-100">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nome</th>
                                    <th>CNPJ</th>
                                    <th>Contato</th>
                                    <th>Cidade/UF</th>
                                    <th class="text-center">Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Fornecedores f : lista) { %>
                                <tr>
                                    <td><%= f.getId() %></td>
                                    <td><strong><%= f.getNome() %></strong></td>
                                    <td><%= f.getCnpj() %></td>
                                    <td><%= f.getCelular() %></td>
                                    <td><%= f.getCidade() %>-<%= f.getUf() %></td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-success btn-editar" 
                                            data-id="<%= f.getId() %>"
                                            data-nome="<%= f.getNome() %>"
                                            data-cnpj="<%= f.getCnpj() %>"
                                            data-email="<%= f.getEmail() %>"
                                            data-celular="<%= f.getCelular() %>"
                                            data-telefone="<%= f.getTelefone() %>"
                                            data-cep="<%= f.getCep() %>"
                                            data-endereco="<%= f.getEndereco() %>"
                                            data-numero="<%= f.getNumero() %>"
                                            data-bairro="<%= f.getBairro() %>"
                                            data-cidade="<%= f.getCidade() %>"
                                            data-uf="<%= f.getUf() %>"
                                            data-complemento="<%= f.getComplemento() %>">
                                            Editar
                                        </button>
                                        <a href="apagar?id=<%= f.getId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Deseja excluir?')">Apagar</a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade text-dark" id="modalEditar" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title">Editar Fornecedor</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="updateFornecedor" method="post">
                    <div class="modal-body bg-light">
                        <div class="row">
                            <div class="col-md-2 mb-3">
                                <label class="modal-label">ID</label>
                                <input type="text" class="form-control bg-secondary-subtle" name="id" id="edit_id" readonly>
                            </div>
                            <div class="col-md-5 mb-3">
                                <label class="modal-label">Nome</label>
                                <input type="text" class="form-control" name="nome" id="edit_nome" required>
                            </div>
                            <div class="col-md-5 mb-3">
                                <label class="modal-label">CNPJ</label>
                                <input type="text" class="form-control cnpj" name="cnpj" id="edit_cnpj" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="modal-label">E-mail</label>
                                <input type="email" class="form-control" name="email" id="edit_email">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="modal-label">Celular</label>
                                <input type="text" class="form-control celular" name="celular" id="edit_celular">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="modal-label">CEP</label>
                                <input type="text" class="form-control cep" name="cep" id="edit_cep">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="modal-label">Endereço</label>
                                <input type="text" class="form-control" name="endereco" id="edit_endereco">
                            </div>
                            <div class="col-md-2 mb-3">
                                <label class="modal-label">Nº</label>
                                <input type="text" class="form-control" name="numero" id="edit_numero">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="modal-label">Bairro</label>
                                <input type="text" class="form-control" name="bairro" id="edit_bairro">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5 mb-3">
                                <label class="modal-label">Cidade</label>
                                <input type="text" class="form-control" name="cidade" id="edit_cidade">
                            </div>
                            <div class="col-md-2 mb-3">
                                <label class="modal-label">UF</label>
                                <input type="text" class="form-control" name="estado" id="edit_uf">
                            </div>
                            <div class="col-md-5 mb-3">
                                <label class="modal-label">Complemento</label>
                                <input type="text" class="form-control" name="complemento" id="edit_complemento">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success px-4">Salvar Alterações</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.11/jquery.mask.min.js"></script>

    <script>
        $(document).ready(function() {
            // DataTables
            $('#tabelaFornecedores').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/pt-BR.json' }
            });

            // Máscaras Dinâmicas
           $('#cnpj').mask('00.000.000/0000-00');
            $('#cep').mask('00.000-000');
            $('#celular, #telefone').mask('(00) 00000-0000');

            // Lógica do Botão Editar (Preencher Modal)
            $('.btn-editar').on('click', function() {
                $('#edit_id').val($(this).data('id'));
                $('#edit_nome').val($(this).data('nome'));
                $('#edit_cnpj').val($(this).data('cnpj'));
                $('#edit_email').val($(this).data('email'));
                $('#edit_celular').val($(this).data('celular'));
                $('#edit_cep').val($(this).data('cep'));
                $('#edit_endereco').val($(this).data('endereco'));
                $('#edit_numero').val($(this).data('numero'));
                $('#edit_bairro').val($(this).data('bairro'));
                $('#edit_cidade').val($(this).data('cidade'));
                $('#edit_uf').val($(this).data('uf'));
                $('#edit_complemento').val($(this).data('complemento'));
                
                $('#modalEditar').modal('show');
            });

            // Busca CEP (Cadastro)
            $('#cep').on('keypress', function(e) {
                if (e.which == 13) {
                    e.preventDefault();
                    let cep = $(this).val().replace(/\D/g, '');
                    if (cep !== "") {
                        $.getJSON("https://viacep.com.br/ws/"+ cep +"/json/", function(dados) {
                            if (!("erro" in dados)) {
                                $("#estado").val(dados.uf);
                                $("#cidade").val(dados.localidade);
                                $("#endereco").val(dados.logradouro);
                                $("#bairro").val(dados.bairro);
                                $("#numero").focus();
                            }
                        });
                    }
                }
            });
        });
    </script>

</body>
</html>