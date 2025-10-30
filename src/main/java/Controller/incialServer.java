package Controller;

import java.awt.Image;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.imageio.ImageIO;
import javax.naming.NamingException;

import com.google.gson.Gson;

import DAO.ConfigPagamentoDAO;
import DAO.EmpresaDAO;
import DAO.UsuarioDAO;
import DAO.VendasDAO;
import DAO.createData;
import DAO.itensVendaDAO;
import Model.ConfigPagamento;
import Model.Empresa;
import Model.HorarioFuncionamento;
import Model.ItensVenda;
import Model.Usuario;
import Model.Vendas;
import jakarta.mail.Message.RecipientType;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(urlPatterns = {
    "/selecionarVenda",
    "/totalVendas",
    "/CadastroUserEmpresa",
    "/RecuperaSenhaServlet",
    "/AtualizaçãoSenha",
    "/selecionarEmpresa",
    "/atualizaEmpresa",
    "/carregarCadastroPedido"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class incialServer extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Connection con;
    private Gson gson = new Gson();

    public incialServer() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        System.out.println("Ação recebida: " + action);

        if (action.equals("/selecionarVenda")) {
            itensPorvenda(request, response);
        } else if (action.equals("/CadastroUserEmpresa")) {
            try {
                createBase(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (action.equals("/RecuperaSenhaServlet")) {
            try {
                enviarEmail(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (action.equals("/selecionarEmpresa")) {
            try {
                selecionaEmpresa(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (action.equals("/carregarCadastroPedido")) {
            try {
                carregarDadosCadastroPedido(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.getRequestDispatcher("CadastroClientePedido.jsp").forward(request, response);
            }
        } else if (action.equals("/atualizaEmpresa")) {
            try {
                atualizaEmpresa(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (action.equals("/AtualizaçãoSenha")) {
            try {
                atualizaSenha(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void carregarDadosCadastroPedido(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException, NamingException {

        String empresaNomeSessao = request.getParameter("empresa");
        if (empresaNomeSessao == null || empresaNomeSessao.isEmpty()) {
            empresaNomeSessao = (String) request.getSession().getAttribute("empresa");
        }

        if (empresaNomeSessao == null || empresaNomeSessao.isEmpty()) {
            response.sendRedirect("LoginPedido.jsp");
            return;
        }

        int idEmpresa = 1; // Ajuste conforme sua lógica real
        List<HorarioFuncionamento> horarios;

        try {
            EmpresaDAO dao = new EmpresaDAO(empresaNomeSessao);
            horarios = dao.retornarHorariosPorEmpresa(idEmpresa);
        } catch (SQLException e) {
            System.err.println("Erro ao buscar horários de funcionamento: " + e.getMessage());
            horarios = new ArrayList<>();
        }

        Gson gson = new Gson();
        String horariosJson = gson.toJson(horarios);

        // 🔍 Detecta se a requisição veio via Fetch/AJAX
        String fetchHeader = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(fetchHeader) || "fetch".equals(request.getParameter("mode"))) {
            // ✅ Retorna apenas JSON se for uma requisição AJAX/fetch
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(horariosJson);
        } else {
            // ✅ Caso contrário, carrega a JSP normalmente
            request.setAttribute("horariosFuncionamento", horarios);
            request.setAttribute("horariosFuncionamentoJson", horariosJson);
            request.getRequestDispatcher("CadastroClientePedido.jsp").forward(request, response);
        }
    }




    private void selecionaEmpresa(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idEmpresa = Integer.parseInt(request.getParameter("id"));
            String empresaNomeSessao = (String) request.getSession().getAttribute("empresa");

            EmpresaDAO dao = new EmpresaDAO(empresaNomeSessao);
            ConfigPagamentoDAO daopag = new ConfigPagamentoDAO(empresaNomeSessao);

            Empresa empresa = dao.retornCompany(idEmpresa);
            ConfigPagamento config = daopag.buscarPorEmpresa(idEmpresa);

            List<HorarioFuncionamento> horarios = new ArrayList<>();
            if (empresa != null) {
                horarios = dao.retornarHorariosPorEmpresa(idEmpresa);
            }

            request.setAttribute("empresa", empresa);
            request.setAttribute("config", config);
            request.setAttribute("horariosFuncionamento", horarios);
            request.setAttribute("horariosEmpresa", horarios);

            request.getRequestDispatcher("Home.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da empresa inválido.");
            e.printStackTrace();
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro de banco de dados ao carregar empresa.");
            e.printStackTrace();
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro inesperado ao carregar empresa.");
            e.printStackTrace();
        }
    }

    public void atualizaEmpresa(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String empresaNomeSessao = (String) request.getSession().getAttribute("empresa");
            EmpresaDAO dao = new EmpresaDAO(empresaNomeSessao);

            int idEmpresa = Integer.parseInt(request.getParameter("idEmpresa"));
            String nomeEmpresa = request.getParameter("nomeEmpresa");
            String cnpjEmpresa = request.getParameter("empresaCnpj");
            String enderecoEmpresa = request.getParameter("empresaEndereco");

            byte[] logoBytes = null;
            Part filePart = request.getPart("logoEmpresa");

            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream fileContent = filePart.getInputStream();
                     ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fileContent.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                    logoBytes = outputStream.toByteArray();
                }
            } else {
                Empresa empresaExistente = dao.retornCompany(idEmpresa);
                if (empresaExistente != null) {
                    logoBytes = empresaExistente.getLogo();
                }
            }

            String gateway = request.getParameter("gateway");
            String pix = request.getParameter("chavePix");
            String clientid = request.getParameter("clientId");
            String clientsecret = request.getParameter("clientSecret");
            String acesstoken = request.getParameter("accessToken");
            String publickey = request.getParameter("publickey");

            ConfigPagamento confg = new ConfigPagamento();
            ConfigPagamentoDAO daopag = new ConfigPagamentoDAO(empresaNomeSessao);
            confg.setGateway(gateway);
            confg.setChavePix(pix);
            confg.setClientId(clientid);
            confg.setClientSecret(clientsecret);
            confg.setAccessToken(acesstoken);
            confg.setPublicKey(publickey);
            confg.setEmpresaId(idEmpresa);
            daopag.atualizar(confg);

            Empresa empresa = new Empresa();
            empresa.setId(idEmpresa);
            empresa.setNome(nomeEmpresa);
            empresa.setCnpj(cnpjEmpresa);
            empresa.setEndereco(enderecoEmpresa);
            empresa.setLogo(logoBytes);
            dao.atualizarEmpresa(empresa);

            List<HorarioFuncionamento> horarios = new ArrayList<>();
            String[] diasSemana = {"Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"};

            for (int i = 0; i < diasSemana.length; i++) {
                boolean aberto = request.getParameter("aberto_" + i) != null;
                String horaAbertura = request.getParameter("abertura_" + i);
                String horaFechamento = request.getParameter("fechamento_" + i);
                String observacao = request.getParameter("observacao_" + i);

                HorarioFuncionamento hf = new HorarioFuncionamento(
                    i,
                    aberto ? horaAbertura : null,
                    aberto ? horaFechamento : null,
                    aberto,
                    observacao
                );
                horarios.add(hf);
            }

            dao.atualizarHorariosFuncionamento(idEmpresa, horarios);

            RequestDispatcher rd = request.getRequestDispatcher("Home.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao salvar dados da empresa.");
        }
    }

    private void atualizaSenha(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException, NamingException {

        String senha = request.getParameter("senha");
        String senha2 = request.getParameter("senha2");
        String email = request.getParameter("email");
        String empresa = request.getParameter("empresa");

        if (senha != null && !senha.trim().isEmpty()) {
            if (senha.equals(senha2)) {
                UsuarioDAO dao = new UsuarioDAO(empresa);
                dao.recuperaSenha(senha, email, empresa);
                request.setAttribute("ok", "Senha alterada com sucesso");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            } else {
                request.setAttribute("erro", "Campo confirmação de senha diferente do campo nova senha. Verifique e tente novamente.");
                request.getRequestDispatcher("RedefinirSenha.jsp").forward(request, response);
            }
        }
    }

    private void enviarEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException, NamingException {

        String email = request.getParameter("email");
        String empresa = request.getParameter("empresa");
        UsuarioDAO usuarioDAO = new UsuarioDAO(empresa);
        boolean emailExiste = usuarioDAO.enviaEmail(email, empresa);

        try {
           

            if (emailExiste) {
                String to = email;
                String resetLink = "http://192.168.1.2:8080/PDV/RedefinirSenha.jsp";

                Properties props = new Properties();
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");

                Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication("walancristiano@gmail.com", "kjtd hzzx syze ysvo");
                    }
                });

                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress("walancristiano@gmail.com"));
                message.addRecipient(RecipientType.TO, new InternetAddress(to));
                message.setSubject("Recuperação de Senha");
                message.setText("Clique no link para redefinir sua senha: " + resetLink);
                Transport.send(message);

                request.setAttribute("ok", "E-mail enviado com sucesso.");
                request.getRequestDispatcher("RecuperarSenha.jsp").forward(request, response);
            } else {
                request.setAttribute("erro", "Email ou empresa incorretos.");
                request.getRequestDispatcher("RecuperarSenha.jsp").forward(request, response);
            }

        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("erro", "Falha ao enviar o e-mail.");
            request.getRequestDispatcher("RecuperarSenha.jsp").forward(request, response);
        }
    }

    protected void createBase(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String empresaBaseNome = request.getParameter("base");

        if (empresaBaseNome != null && !empresaBaseNome.trim().isEmpty()) {
            try {
                createData data = new createData(empresaBaseNome);

                String nomeUsuario = request.getParameter("nome");
                String usuarioTelefone = request.getParameter("telefone");
                String usuarioEmail = request.getParameter("email");
                String usuarioSenha = request.getParameter("senha");
                String empresaNomeFantasia = request.getParameter("nomeEmpresa");
                String empresaCnpj = request.getParameter("empresaCnpj");
                String empresaEndereco = request.getParameter("empresaEdereco");

                byte[] logoBytes = null;
                Part filePart = request.getPart("logo");

                if (filePart != null && filePart.getSize() > 0) {
                    InputStream inputStream = filePart.getInputStream();
                    logoBytes = inputStream.readAllBytes();
                }

                if (nomeUsuario == null || nomeUsuario.trim().isEmpty() ||
                    usuarioTelefone == null || usuarioTelefone.trim().isEmpty() ||
                    usuarioEmail == null || usuarioEmail.trim().isEmpty() ||
                    usuarioSenha == null || usuarioSenha.trim().isEmpty() ||
                    empresaNomeFantasia == null || empresaNomeFantasia.trim().isEmpty()) {

                    request.setAttribute("errorMessage", "Por favor, preencha todos os campos obrigatórios.");
                    request.getRequestDispatcher("cadastroUserEmpresa.jsp").forward(request, response);
                    return;
                }

                Usuario uso = new Usuario();
                uso.setNome(nomeUsuario);
                uso.setTelefone(usuarioTelefone);
                uso.setEmail(usuarioEmail);
                uso.setSenha(usuarioSenha);

                Empresa emp = new Empresa();
                emp.setNome(empresaNomeFantasia);
                emp.setCnpj(empresaCnpj);
                emp.setEndereco(empresaEndereco);
                emp.setLogo(logoBytes);

                List<HorarioFuncionamento> horarios = new ArrayList<>();
                for (int i = 0; i < 7; i++) {
                    boolean aberto = request.getParameter("aberto_" + i) != null;
                    String horaAbertura = request.getParameter("abertura_" + i);
                    String horaFechamento = request.getParameter("fechamento_" + i);
                    if (!aberto) {
                        horaAbertura = null;
                        horaFechamento = null;
                    }
                    HorarioFuncionamento horario = new HorarioFuncionamento(i, horaAbertura, horaFechamento, aberto, null);
                    horarios.add(horario);
                }

                data.inserirEmpresaUsuario(emp, uso, horarios);

                request.setAttribute("successMessage", "Cadastro realizado com sucesso! Faça seu login.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Erro ao realizar o cadastro: " + e.getMessage());
                request.getRequestDispatcher("cadastroUserEmpresa.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "O nome da base de dados não pode ser vazio.");
            request.getRequestDispatcher("cadastroUserEmpresa.jsp").forward(request, response);
        }
    }

    private Image converterImagem(byte[] imagemBytes) {
        try {
            ByteArrayInputStream is = new ByteArrayInputStream(imagemBytes);
            return ImageIO.read(is);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void Vendas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");

        if (empresa == null || empresa.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nome da empresa não fornecido.");
            return;
        }

        try {
            VendasDAO dao = new VendasDAO(empresa);
            ArrayList<Vendas> lista = (ArrayList<Vendas>) dao.listarVendasdoDia();
            request.setAttribute("Vendas", lista);
            RequestDispatcher rd = request.getRequestDispatcher("Home.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao processar a requisição.");
        }
    }

    private void itensPorvenda(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");
        String idVenda = request.getParameter("id");

        if (idVenda != null) {
            int vendaID = Integer.parseInt(idVenda);
            try {
                itensVendaDAO itdao = new itensVendaDAO(empresa);
                ArrayList<ItensVenda> lista_2 = (ArrayList<ItensVenda>) itdao.listarItensPorVendao(vendaID);
                request.setAttribute("tableRows", lista_2);
                RequestDispatcher rd = request.getRequestDispatcher("DetalheVenda.jsp");
                rd.forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
