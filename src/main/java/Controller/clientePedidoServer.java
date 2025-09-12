package Controller;

import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.Message.RecipientType;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import DAO.ClientesPedidosDAO;
import DAO.UsuarioDAO;
import Model.Clientepedido;

@WebServlet(urlPatterns = {"/clientePedidoServer","/selecionacp","/cadClientePedido","/atualizaDadosCliente","/Recuperarsenhacliente","/alteraSenha"})
public class clientePedidoServer extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public clientePedidoServer() {
        super();
    }

    // Requisições GET
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        System.out.println("Ação GET: " + action);
        
        if(action.equals("/selecionacp")) {
            selecionarCliente(request, response);
        } else if(action.equals("/cadClientePedido")) {
        	cadastrarClientePedido(request,response);
        	
        }else if(action.equals("/atualizaDadosCliente")) {
        	alteraCliente(request,response);
        	
        }else if(action.equals("/Recuperarsenhacliente")) {
        	enviarEmailSenha(request,response);
        	
        }
        else if(action.equals("/alteraSenha")) {
        	alterarsenha(request,response);
        	
        }
        
        else {
            // Default - mostra a tela de login
            RequestDispatcher rd = request.getRequestDispatcher("LoginPedido.jsp");
            rd.forward(request, response);
        }
    }

    private void alterarsenha(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  {
        String novaSenha = request.getParameter("novaSenha");
        String email = request.getParameter("email");
        String empresa = request.getParameter("empresa");

        if (novaSenha == null || novaSenha.trim().isEmpty() || email == null || email.trim().isEmpty() || empresa == null || empresa.trim().isEmpty()) {
            request.setAttribute("erro", "Dados inválidos. Por favor, preencha todos os campos.");
            RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenhaAtualiza.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            ClientesPedidosDAO cliDAO = new ClientesPedidosDAO(empresa);
            
            // Chama o método do DAO e verifica o resultado
            boolean senhaAlteradaComSucesso = cliDAO.alteraSenha(novaSenha, email);
            
            if (senhaAlteradaComSucesso) {
                // Sucesso! Redireciona para a página de login.
                request.setAttribute("ok", "Sua senha foi alterada com sucesso! Você já pode fazer login.");
                response.sendRedirect("LoginPedido.jsp?sucesso=Sua senha foi alterada com sucesso! Você já pode fazer login.");
            } else {
                // Falha! O e-mail não foi encontrado na tabela ou houve outro problema.
                request.setAttribute("erro", "Não foi possível redefinir a senha. Verifique se o link está correto.");
                RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenhaAtualiza.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Erro genérico
            request.setAttribute("erro", "Ocorreu um erro ao redefinir a senha. Tente novamente mais tarde.");
            RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenhaAtualiza.jsp");
            rd.forward(request, response);
        }
    }

	private void enviarEmailSenha(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String email = request.getParameter("email");
		String empresa = request.getParameter("empresa");

		try {
			// **1. Verificação do e-mail no banco de dados**
			// A classe ClientesPedidosDAO deve ser configurada para se comunicar com o seu banco de dados
			// e ter um método para verificar a existência do e-mail.
			ClientesPedidosDAO cliDAO = new ClientesPedidosDAO(empresa);
			boolean emailExiste = cliDAO.enviarEmailCliente(email);

			if (emailExiste) {
				// **2. Configuração e envio do e-mail**
				// Onde você define a URL de redefinição de senha
				String resetLink = "http://localhost:8080/PDVVenda/RecuperarSenhaAtualiza.jsp?email=" + email + "&empresa=" + empresa;

				Properties props = new Properties();
				props.put("mail.smtp.host", "smtp.gmail.com");
				props.put("mail.smtp.port", "587");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.starttls.enable", "true");

				Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
					@Override
					protected PasswordAuthentication getPasswordAuthentication() {
						// Utilize sua senha de app do Gmail aqui
						return new PasswordAuthentication("wttech.tech@gmail.com", "mnpu lbua cxxm bgpk");
					}
				});

				try {
					MimeMessage message = new MimeMessage(session);
					message.setFrom(new InternetAddress("wttech.tech@gmail.com"));
					message.addRecipient(RecipientType.TO, new InternetAddress(email));
					message.setSubject("Recuperação de Senha");

					// Conteúdo do e-mail em HTML
					String htmlContent = "<html>"
										+ "<body>"
										+ "<div style='font-family: Arial, sans-serif; color: #333;'>"
										+ "<h2>Recuperação de Senha</h2>"
										+ "<p>Olá,</p>"
										+ "<p>Recebemos uma solicitação para redefinir sua senha. Para continuar com o processo, clique no botão abaixo:</p>"
										+ "<p style='margin: 20px 0;'>"
										+ "<a href='" + resetLink + "' style='background-color: #007bff; color: white; padding: 12px 24px; text-align: center; text-decoration: none; display: inline-block; border-radius: 5px; font-weight: bold;'>Redefinir Senha</a>"
										+ "</p>"
										+ "<p>Se você não solicitou a redefinição de senha, por favor, ignore este e-mail.</p>"
										+ "<p>Atenciosamente,<br>WTTECH</p>"
										+ "</div>"
										+ "</body>"
										+ "</html>";

					// Define o conteúdo da mensagem como HTML
					message.setContent(htmlContent, "text/html; charset=utf-8");

					Transport.send(message);
					System.out.println("E-mail enviado com sucesso para: " + email);

					// Define a mensagem de sucesso e redireciona
					request.setAttribute("ok", "Email enviado com sucesso! Confira sua caixa de entrada ou spam.");
					RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenhaCliente.jsp");
					rd.forward(request, response);

				} catch (MessagingException e) {
					e.printStackTrace();
					request.setAttribute("erro", "Falha ao enviar o e-mail. Tente novamente mais tarde.");
					RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenhaCliente.jsp");
					rd.forward(request, response);
				}

			} else {
				// **3. Erro: e-mail não encontrado**
				request.setAttribute("erro", "Email ou empresa incorretos. Por favor, verifique os dados.");
				RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenhaCliente.jsp");
				rd.forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("erro", "Ocorreu um erro interno ao processar a solicitação.");
			RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenhaCliente.jsp");
			rd.forward(request, response);
		}
	}
    
    
	private void alteraCliente(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");

		String nomecli = request.getParameter("nomeCliente");
		String enderecocli = request.getParameter("ruaCliente");
		String telefonecli = request.getParameter("telefoneCliente");
		String emailcli = request.getParameter("emailCliente");
		String numerocli = request.getParameter("numeroCliente");
		String bairrocli = request.getParameter("bairroCliente");
		String cidadecli = request.getParameter("cidadeCliente");
		String estadocli = request.getParameter("estadoCliente");
		String idcli = request.getParameter("idCliente");

		Clientepedido cliPed = new Clientepedido();

		try {
			if (nomecli != null && !nomecli.isEmpty()) {
				cliPed.setNome(nomecli);
			}
			if (enderecocli != null && !enderecocli.isEmpty()) {
				cliPed.setEndereco(enderecocli);
			}
			if (telefonecli != null && !telefonecli.isEmpty()) {
				cliPed.setCelular(telefonecli);
			}
			if (emailcli != null && !emailcli.isEmpty()) {
				cliPed.setEmail(emailcli);
			}
			if (numerocli != null && !numerocli.isEmpty()) {

				int cliNumero = Integer.parseInt(numerocli);
				cliPed.setNumero(cliNumero);

			}
			if (bairrocli != null && !bairrocli.isEmpty()) {
				cliPed.setBairro(bairrocli);
			}
			if (estadocli != null && !estadocli.isEmpty()) {
				request.setAttribute("estadoCliente", cliPed.getUf());
				cliPed.setUf(estadocli);
			}
			if (cidadecli != null && !cidadecli.isEmpty()) {
				cliPed.setCidade(cidadecli);
			}
			if (idcli != null && !idcli.isEmpty()) {

				int cliid = Integer.parseInt(idcli);
				cliPed.setId(cliid);
			}
			
			ClientesPedidosDAO daoped = new ClientesPedidosDAO(empresa);
			daoped.alteraClientePedido(cliPed);
			
			RequestDispatcher rd = request.getRequestDispatcher("ProdutosPedidos.jsp");
			rd.forward(request, response);
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		
		
	}

	private void cadastrarClientePedido(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String nome = request.getParameter("nome");

		String telefone = request.getParameter("fone");

		String endereco = request.getParameter("endereco");

		String numero = request.getParameter("numero");

		String bairro = request.getParameter("bairro");

		String cidade = request.getParameter("cidade");

		String estado = request.getParameter("estado");

		String email = request.getParameter("email");

		String senha = request.getParameter("senha");

		try {

			Clientepedido cpd = new Clientepedido();

			HttpSession session = request.getSession();

			String empresa = (String) session.getAttribute("empresa");

			ClientesPedidosDAO dao = new ClientesPedidosDAO(empresa);

			cpd.setNome(nome);

			cpd.setEndereco(endereco);

			cpd.setTelefone(telefone);

			cpd.setNumero(Integer.parseInt(numero));

			cpd.setBairro(bairro);

			cpd.setCidade(cidade);

			cpd.setUf(estado);

			cpd.setEmail(email);

			cpd.setSenha(senha);

			dao.Clientepedido(cpd);

			RequestDispatcher rd = request.getRequestDispatcher("LoginPedido.jsp");

			rd.forward(request, response);

		} catch (Exception e) {

			e.printStackTrace();

			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
					"Erro ao cadastrar cliente: " + e.getMessage());

		}

	}

	// Método para buscar cliente e retornar JSON para modal
    private void selecionarCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String idCli = request.getParameter("id");
        if (idCli != null) {
            try {
                int cliId = Integer.parseInt(idCli);
                HttpSession session = request.getSession();
                String empresa = (String) session.getAttribute("empresa");

                ClientesPedidosDAO cpDAO = new ClientesPedidosDAO(empresa);
                Clientepedido cp = cpDAO.selecionaClientePedido(cliId);

                // Coloca o objeto do cliente na requisição para que a JSP o utilize
                request.setAttribute("clienteParaModal", cp);
                request.setAttribute("estadoCliente", cp.getUf());
                session.setAttribute("clienteLogado", cp);
                
             

                // Faz o forward para a mesma página que contém o menu e o modal
                request.getRequestDispatcher("ProdutosPedidos.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                // Em caso de erro, redireciona de volta
                response.sendRedirect("ProdutosPedidos.jsp");
            }
        } else {
            response.sendRedirect("ProdutosPedidos.jsp");
        }
     }
    

    // Requisições POST (login)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        String email = request.getParameter("emailpedido");
        String senha = request.getParameter("senhapedido");
        String empresa = request.getParameter("empresa");
        
        // Pega empresa da sessão se não veio do formulário
        if (empresa == null) {
            empresa = (String) session.getAttribute("empresa");
        }
        
        // Validação simples dos campos
        if (email == null || email.isEmpty() || senha == null || senha.isEmpty() || empresa == null || empresa.isEmpty()) {
            request.setAttribute("erro", "Todos os campos devem ser preenchidos ou estabelecimento fora do horário.");
            RequestDispatcher rd = request.getRequestDispatcher("LoginPedido.jsp");
            rd.forward(request, response);
            return;
        }
        
        session.setAttribute("empresa", empresa); // para manter empresa na sessão
        
        try {
            UsuarioDAO dao = new UsuarioDAO(empresa);

            // Verifica login válido
            boolean loginValido = dao.efetuarLoginPedido(email, senha, empresa);
            if (!loginValido) {
                request.setAttribute("erro", "Usuário ou senha incorretos.");
                RequestDispatcher rd = request.getRequestDispatcher("LoginPedido.jsp");
                rd.forward(request, response);
                return;
            }

            // Buscar ID do usuário e objeto completo
            Clientepedido usuarioObj = new Clientepedido();
            usuarioObj.setEmail(email);
            usuarioObj.setSenha(senha);

            int usuarioID = dao.cidcliPedido(usuarioObj, empresa);
            Clientepedido clienteCompleto = dao.retornClipedido(usuarioObj, empresa, usuarioID);

            if (usuarioID > 0 && clienteCompleto != null) {
                // SALVAR NA SESSÃO O OBJETO CLIENTE COMPLETO e ID
                session.setAttribute("clienteLogado", clienteCompleto);
                session.setAttribute("usuarioID", usuarioID);

                System.out.println("Usuário logado ID: " + usuarioID);
                response.sendRedirect("ProdutosPedidos.jsp"); // página após login
            } else {
                request.setAttribute("erro", "Erro ao buscar dados do usuário.");
                RequestDispatcher rd = request.getRequestDispatcher("LoginPedido.jsp");
                rd.forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao processar a solicitação.");
            RequestDispatcher rd = request.getRequestDispatcher("LoginPedido.jsp");
            rd.forward(request, response);
        }
    }
}
