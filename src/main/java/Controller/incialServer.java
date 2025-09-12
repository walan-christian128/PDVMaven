package Controller;

import java.awt.Image;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.imageio.ImageIO;
import javax.naming.NamingException;

import java.io.ByteArrayOutputStream;


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

@WebServlet(urlPatterns = { "/selecionarVenda", "/totalVendas", "/CadastroUserEmpresa", "/RecuperaSenhaServlet",
		"/AtualizaçãoSenha","/selecionarEmpresa","/atualizaEmpresa" })
@MultipartConfig(
		fileSizeThreshold = 1024 * 1024 * 2, // 2MB - Tamanho do arquivo na memória antes de gravar no disco
	    maxFileSize = 1024 * 1024 * 5, // 5MB - Tamanho máximo do arquivo permitido
	    maxRequestSize = 1024 * 1024 * 10 // 10MB - Tamanho máximo da requisição (arquivo + outros dados)
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
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} else if (action.equals("/RecuperaSenhaServlet")) {
			try {
				enviarEmail(request, response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}else if (action.equals("/selecionarEmpresa") || action.equals("/selecionarEmpresa")) { // Adicionado '|| action.equals("/empresa")'
		    try {
		        selecionaEmpresa(request, response);
		    } catch (ServletException e) {
		        e.printStackTrace();
		    } catch (IOException e) {
		        e.printStackTrace();
		    }
		}
		else if (action.equals("/atualizaEmpresa")) { // Adicionado '|| action.equals("/empresa")'
		    try {
		    	atualizaEmpresa(request, response);
		    } catch (ServletException e) {
		        e.printStackTrace();
		    } catch (IOException e) {
		        e.printStackTrace();
		    }
		}
		else if (action.equals("/AtualizaçãoSenha")) {
			try {
				try {
					atualizaSenha(request, response);
				} catch (NamingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}

	private void selecionaEmpresa(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    try {
	        // Pega o parâmetro do id da empresa
	        int idEmpresa = Integer.parseInt(request.getParameter("id"));

	        // Cria o DAO (ajuste conforme seu construtor e onde a conexão é estabelecida)
	        // **Verifique se 'empresaNomeSessao' é realmente o que o DAO precisa para a conexão**
	        String empresaNomeSessao = (String) request.getSession().getAttribute("empresa");
	        EmpresaDAO dao = new EmpresaDAO(empresaNomeSessao);
	        ConfigPagamentoDAO daopag = new ConfigPagamentoDAO(empresaNomeSessao);
	        
	        

	        // 1. Busca APENAS os dados básicos da empresa
	        Empresa empresa = dao.retornCompany(idEmpresa);
	        ConfigPagamento config = daopag.buscarPorEmpresa(idEmpresa);
	        

	        // 2. Busca os horários de funcionamento SEPARADAMENTE
	        List<HorarioFuncionamento> horarios = new ArrayList<>(); // Inicializa uma lista vazia
	        if (empresa != null) { // Apenas se a empresa foi encontrada, busca os horários
	            horarios = dao.retornarHorariosPorEmpresa(idEmpresa); // Usando o novo método que discutimos
	        }

	        // Passa a empresa para o JSP
	        request.setAttribute("empresa", empresa);
	        request.setAttribute("config", config);

	        // Passa a lista de horários para o JSP
	        request.setAttribute("horariosEmpresa", horarios); // Um novo atributo para os horários

	        // Encaminha para o JSP que contém o modal
	        request.getRequestDispatcher("Home.jsp").forward(request, response);

	    } catch (NumberFormatException e) {
	        // Lida com erro se 'id' não for um número válido
	        e.printStackTrace();
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da empresa inválido.");
	    } catch (SQLException e) {
	        // Lida com erros de banco de dados
	        e.printStackTrace();
	        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro de banco de dados ao carregar empresa.");
	    } catch (Exception e) {
	        // Lida com outras exceções inesperadas
	        e.printStackTrace();
	        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro inesperado ao carregar empresa.");
	    }
	}
	
	

	public void atualizaEmpresa(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        EmpresaDAO dao = null;
        try {
            String empresaNomeSessao = (String) request.getSession().getAttribute("empresa");
            dao = new EmpresaDAO(empresaNomeSessao);

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
                // Lógica para manter a logo existente se nenhuma nova for enviada
                // Primeiro, obtenha a empresa atual do banco para pegar a logo existente
                Empresa empresaExistente = dao.retornCompany(idEmpresa);
                if (empresaExistente != null) {
                    logoBytes = empresaExistente.getLogo();
                }
                // Se empresaExistente for null (empresa não encontrada) ou não tiver logo, logoBytes permanecerá null
            }
            
            //atualizar forma de pagamento//
            
            String gateway =request.getParameter("gateway");
            String pix = request.getParameter("chavePix");
            String clientid = request.getParameter("clientId");
            String clientsecret = request.getParameter("clientSecret");
            String acesstoken = request.getParameter("accessToken");
            String publickey = request.getParameter("publickey");
            
            ConfigPagamento confg = new ConfigPagamento();
            
            if(confg !=null) {
            ConfigPagamentoDAO daopag = new ConfigPagamentoDAO(empresaNomeSessao);
            confg.setGateway(gateway);
            confg.setChavePix(pix);
            confg.setClientId(clientid);
            confg.setClientSecret(clientsecret);
            confg.setAccessToken(acesstoken);
            confg.setPublicKey(publickey);
            confg.setEmpresaId(idEmpresa);
            
            daopag.atualizar(confg);
            }

            Empresa empresa = new Empresa();
            empresa.setId(idEmpresa);
            empresa.setNome(nomeEmpresa);
            empresa.setCnpj(cnpjEmpresa);
            empresa.setEndereco(enderecoEmpresa);
            empresa.setLogo(logoBytes);

            dao.atualizarEmpresa(empresa);

            // 2. Coleta os dados dos Horários de Funcionamento para TODOS os 7 dias
            List<HorarioFuncionamento> horarios = new ArrayList<>();
            String[] diasSemana = {"Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"};

            for (int i = 0; i < diasSemana.length; i++) {
                boolean aberto = request.getParameter("aberto_" + i) != null; // True se marcado, False se desmarcado
                String horaAbertura = request.getParameter("abertura_" + i);
                String horaFechamento = request.getParameter("fechamento_" + i);
                String observacao = request.getParameter("observacao_" + i);

                // *** MUDANÇA AQUI: SEMPRE ADICIONE O HORARIOFUNCIONAMENTO À LISTA ***
                // Se o dia não estiver aberto, as horas podem ser null ou vazias,
                // mas o status 'aberto' será false.
                HorarioFuncionamento hf = new HorarioFuncionamento(
                    i,
                    aberto ? horaAbertura : null, // Passa null se não estiver aberto
                    aberto ? horaFechamento : null, // Passa null se não estiver aberto
                    aberto, // Este é o boolean que queremos salvar!
                    observacao
                );
                horarios.add(hf);

                System.out.println("Dia " + i + ": Aberto=" + aberto + ", Abertura=" + horaAbertura + ", Fechamento=" + horaFechamento + ", Observacao=" + observacao);
            }

            dao.atualizarHorariosFuncionamento(idEmpresa, horarios);

            // Redireciona de volta para o menu.jsp e reabre o modal com os dados atualizados
            RequestDispatcher rd = request.getRequestDispatcher("Home.jsp");

            rd.forward(request, response);// Redireciona para o Servlet que carrega e abre o modal

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da empresa inválido.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Erro de banco de dados ao salvar dados da empresa: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro de banco de dados ao salvar dados da empresa: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Erro inesperado ao salvar dados da empresa: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro inesperado ao salvar dados da empresa: " + e.getMessage());
        } finally {
            // Lógica para fechar a conexão se necessário (se não for gerenciada por um pool)
            // if (dao != null && dao.con != null) {
            //     try { dao.con.close(); } catch (SQLException e) { e.printStackTrace(); }
            // }
        }
    }
	


	private void atualizaSenha(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException, ClassNotFoundException, NamingException {
		String senha = request.getParameter("senha");
		String senha2 = request.getParameter("senha2");
		String email = request.getParameter("email");
		String empresa = request.getParameter("empresa");

		if (senha != null && !senha.trim().isEmpty()) {
			Usuario uso = new Usuario();

			uso.setSenha(senha);
			uso.setEmail(email);

			if (senha .equals(senha2) ) {
				UsuarioDAO dao = new UsuarioDAO(empresa);
				dao.recuperaSenha(senha, email, empresa);
				request.setAttribute("ok", "senha alterada com sucesso");
				RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
				rd.forward(request, response);

			} else if (senha != senha2) {

				request.setAttribute("erro","Campo confirmação de senha diferente do campo nova senha verifique o valor e digite novamente");
				RequestDispatcher rd = request.getRequestDispatcher("RedefinirSenha.jsp");
				rd.forward(request, response);
			}
		}

	}

	private void enviarEmail(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException, ClassNotFoundException {
		String email = request.getParameter("email");
		String empresa = request.getParameter("empresa");

		try {
			// Verifica se o email existe no banco de dados
			UsuarioDAO usuarioDAO = new UsuarioDAO(empresa);
			boolean emailExiste = usuarioDAO.enviaEmail(email, empresa);

			if (emailExiste) {
				// Enviar OTP por e-mail
				String to = email;
				String resetLink = "http://192.168.1.2:8080/PDV/RedefinirSenha.jsp"; // Gera o
																												// OTP
																												// aqui

				// Configurações do servidor de e-mail
				Properties props = new Properties();
				props.put("mail.smtp.host", "smtp.gmail.com");
				props.put("mail.smtp.port", "587");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.starttls.enable", "true");

				// Autenticação para envio de e-mail
				Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
					@Override
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication("walancristiano@gmail.com", "kjtd hzzx syze ysvo"); // Use o
																												// seu
																												// e-mail
																												// e
																												// senha
					}
				});

				try {
					// Criando a mensagem de e-mail
					MimeMessage message = new MimeMessage(session);
					message.setFrom(new InternetAddress("walancristiano@gmail.com")); // E-mail do remetente
					message.addRecipient(RecipientType.TO, new InternetAddress(to)); // E-mail do
																									// destinatário
					message.setSubject("Recuperação de Senha");
					message.setText("Click no link para redefinição de senha: " + resetLink);

					// Enviando o e-mail
					Transport.send(message);
					System.out.println("E-mail enviado com sucesso");

					// Define a mensagem de sucesso na requisição
					request.setAttribute("ok", "Email enviado com sucesso.");

					// Encaminha a requisição para o JSP
					RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenha.jsp");
					rd.forward(request, response);

				} catch (MessagingException e) {
					e.printStackTrace();
					request.setAttribute("erro", "Falha ao enviar o e-mail.");
					RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenha.jsp");
					rd.forward(request, response);
				}

			} else {
				// Caso o e-mail ou a empresa estejam incorretos
				request.setAttribute("erro", "Email ou empresa incorretos.");
				RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenha.jsp");
				rd.forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("erro", "Ocorreu um erro ao processar a solicitação.");
			RequestDispatcher rd = request.getRequestDispatcher("RecuperarSenha.jsp");
			rd.forward(request, response);
		}
	}

	@SuppressWarnings("static-access")
	 protected void createBase(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

        String empresaBaseNome = request.getParameter("base"); // Corrigido para "base" do JSP

        if (empresaBaseNome != null && !empresaBaseNome.trim().isEmpty()) {
            try {
                // Instancia seu DAO principal, que agora precisa de uma conexão
                // createData data = new createData(empresaBaseNome); // Isso deve criar a conexão e, opcionalmente, o BD/tabelas

                // **Importante:** Assumindo que `createData` lida com a conexão.
                // Se `createData` for o seu DAO principal, você passaria a conexão para ele.
                // Ex: SeuDaoPrincipal dao = new SeuDaoPrincipal(ConexaoBD.getConnection());
                // Ou, se `createData` já encapsula a criação da conexão e do DAO
                createData data = new createData(empresaBaseNome); // Instancia seu objeto DAO/serviço

                // Coletar dados do usuário
                String nomeUsuario = request.getParameter("nome");
                String usuarioTelefone = request.getParameter("telefone");
                String usuarioEmail = request.getParameter("email");
                String usuarioSenha = request.getParameter("senha");

                // Coletar dados da empresa
                String empresaNomeFantasia = request.getParameter("nomeEmpresa"); // Corrigido para "nomeEmpresa"
                String empresaCnpj = request.getParameter("empresaCnpj");
                String empresaEndereco = request.getParameter("empresaEdereco"); // Corrigido para "empresaEdereco"

                byte[] logoBytes = null;
                Image logoImage = null; // Para JasperReports, se ainda for usar

                // Processar upload da logo
                Part filePart = request.getPart("logo"); // 'logo' é o 'name' do input type="file" no JSP

                if (filePart != null && filePart.getSize() > 0) {
                    InputStream inputStream = filePart.getInputStream();
                    logoBytes = inputStream.readAllBytes();
                    logoImage = converterImagem(logoBytes); // Converte para java.awt.Image se necessário
                }

                // Validar dados básicos antes de criar objetos
                if (nomeUsuario == null || nomeUsuario.trim().isEmpty() ||
                    usuarioTelefone == null || usuarioTelefone.trim().isEmpty() ||
                    usuarioEmail == null || usuarioEmail.trim().isEmpty() ||
                    usuarioSenha == null || usuarioSenha.trim().isEmpty() ||
                    empresaNomeFantasia == null || empresaNomeFantasia.trim().isEmpty()) {

                    request.setAttribute("errorMessage", "Por favor, preencha todos os campos obrigatórios de Usuário e Empresa.");
                    request.getRequestDispatcher("cadastroUserEmpresa.jsp").forward(request, response);
                    return;
                }

                // Criar objetos Empresa e Usuário
                Usuario uso = new Usuario();
                Empresa emp = new Empresa();

                uso.setNome(nomeUsuario);
                uso.setTelefone(usuarioTelefone);
                uso.setEmail(usuarioEmail);
                uso.setSenha(usuarioSenha); // A senha será hashed no DAO

                emp.setNome(empresaNomeFantasia); // Nome fantasia para a coluna 'nome' da tb_empresa
                emp.setCnpj(empresaCnpj);
                emp.setEndereco(empresaEndereco);
                emp.setLogo(logoBytes);

                // --- Coleta dos Horários de Funcionamento ---
                List<HorarioFuncionamento> horarios = new ArrayList<>();
                // O loop no JSP vai de 0 a 6 (Domingo a Sábado)
                for (int i = 0; i < 7; i++) {
                    boolean aberto = request.getParameter("aberto_" + i) != null; // 'on' se marcado, null se não
                    String horaAbertura = request.getParameter("abertura_" + i);
                    String horaFechamento = request.getParameter("fechamento_" + i);

                    // Se o dia não estiver marcado como aberto, garantimos que horários sejam nulos no objeto
                    if (!aberto) {
                        horaAbertura = null;
                        horaFechamento = null;
                    }

                    // Observação (se você tiver um campo para isso, senão pode ser null)
                    String observacao = null; // Ex: request.getParameter("observacao_" + i);

                    // Cria o objeto HorarioFuncionamento e adiciona à lista
                    HorarioFuncionamento horario = new HorarioFuncionamento(i, horaAbertura, horaFechamento, aberto, observacao);
                    horarios.add(horario);
                }

                // Inserir empresa, usuário e horários no banco
                // Modificado para passar a lista de horários
                data.inserirEmpresaUsuario(emp, uso, horarios);

                // Passar imagem para JasperReports se necessário (se 'logoImage' ainda for usado)
                // HashMap<String, Object> parametros = new HashMap<>();
                // parametros.put("logo", logoImage); // Isso geralmente é feito em um servlet de relatório

                // Redireciona para a página de login ou de sucesso
                request.setAttribute("successMessage", "Cadastro realizado com sucesso! Faça seu login.");
                request.getRequestDispatcher("Login.jsp").forward(request, response); // Ou uma página de sucesso

            } catch (Exception e) {
                e.printStackTrace(); // Log completo do erro no console do servidor
                // Define uma mensagem de erro mais amigável para o usuário
                request.setAttribute("errorMessage", "Ocorreu um erro ao realizar o cadastro: " + e.getMessage());
                // Redireciona de volta para o próprio formulário ou para uma página de erro dedicada
                request.getRequestDispatcher("cadastroUserEmpresa.jsp").forward(request, response); // Melhor voltar para o formulário
            }
        } else {
            request.setAttribute("errorMessage", "O nome da base de dados (identificador da empresa) não pode ser vazio.");
            request.getRequestDispatcher("cadastroUserEmpresa.jsp").forward(request, response); // Volta para o formulário
        }
	    }

	    /**
	     * Converte um array de bytes em um objeto java.awt.Image
	     */
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
			// Passe o nome da empresa para o DAO
			VendasDAO dao = new VendasDAO(empresa);
			ArrayList<Vendas> lista = (ArrayList<Vendas>) dao.listarVendasdoDia();
			request.setAttribute("Vendas", lista);
			RequestDispatcher rd = request.getRequestDispatcher("Home.jsp");
			rd.forward(request, response);
		} catch (Exception e) {
			e.printStackTrace(); // Imprimir a pilha de erros para depuração
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao processar a requisição.");
		}
	}

	private void itensPorvenda(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String empresa = (String) session.getAttribute("empresa");
		String idVenda = request.getParameter("id");
		int vendaID = Integer.parseInt(idVenda);
		if (idVenda != null) {

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