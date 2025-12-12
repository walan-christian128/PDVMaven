package Controller;

import java.io.IOException;

import DAO.UsuarioDAO;
import Model.Empresa;
import Model.Usuario;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class userLogin
 */
@WebServlet(name = "Login.jsp", urlPatterns = { "/logar" })
public class userLogin extends HttpServlet {

	private static final long serialVersionUID = 1L;

	// --- VARIÁVEIS FIXAS DO MASTER DO SISTEMA ---
	private static final String MASTER_EMAIL_FIXO = "dbawttech@gmail.com";
	private static final String MASTER_SENHA_FIXA = "dbawttech@!"; // Substitua pela senha real
	private static final String MASTER_NIVEL = "ROOT_MASTER";
	// ---------------------------------------------

	public userLogin() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
		rd.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");
		String empresa = request.getParameter("empresa");

		if (email == null || email.isEmpty() || senha == null || senha.isEmpty() || empresa == null || empresa.isEmpty()) {
			request.setAttribute("erro", "Todos os campos devem ser preenchidos.");
			RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
			rd.forward(request, response);
			return;
		}

		String nomeBase = empresa.trim().toLowerCase();
		HttpSession session = request.getSession();

		// --- 1. TENTATIVA DE LOGIN DO MASTER FIXO ---
		if (email.equals(MASTER_EMAIL_FIXO) && senha.equals(MASTER_SENHA_FIXA)) {
			
			try {
				// Simplesmente tenta instanciar o DAO para verificar se a conexão/base existe
				new UsuarioDAO(nomeBase); 
				
				// Se a conexão foi bem-sucedida (não lançou exceção)
				
				// Cria o objeto Usuário Master
				Usuario master = new Usuario();
				master.setEmail(MASTER_EMAIL_FIXO);
				master.setNome("Master do Sistema");
				master.setNivel(MASTER_NIVEL);
				
				// Cria o objeto Empresa que o Master está gerenciando
				Empresa empMaster = new Empresa();
				empMaster.setNome(nomeBase);
				master.setEmpresa(empMaster);

				// Armazena na sessão
				session.setAttribute("usuario", master);
				session.setAttribute("empresa", nomeBase); 
				
				System.out.println("Master logado na base: " + nomeBase);
				response.sendRedirect("Home.jsp");
				return;
				
			} catch (Exception e) {
				// Base não existe ou erro de conexão
				request.setAttribute("erro", "Master: A base de dados '" + nomeBase + "' não existe ou ocorreu um erro de conexão.");
				RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
				rd.forward(request, response);
				return;
			}
		} 
		// FIM DA CHECAGEM DO MASTER FIXO
		
		// --- 2. LÓGICA DE LOGIN COMUM DO CLIENTE (MÉTODOS ORIGINAIS) ---
		else {
			UsuarioDAO dao;
			try {
				dao = new UsuarioDAO(nomeBase);
				
				// 🔹 Primeiro verifica se o login é válido
				boolean loginValido = dao.efetuarLogin(email, senha, nomeBase);
				if (!loginValido) {
					request.setAttribute("erro", "Usuário, senha ou empresa incorretos.");
					RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
					rd.forward(request, response);
					return;
				}

				// 🔹 Depois busca o ID do usuário (Método 1)
				Usuario usuarioCredenciais = new Usuario();
				usuarioCredenciais.setEmail(email);
				usuarioCredenciais.setSenha(senha);

				int usuarioID = dao.cidugoUsuario(usuarioCredenciais, nomeBase);
				
				if (usuarioID > 0) {
					// 🔹 Busca o objeto Usuario COMPLETO (Método 2)
					// *** CRÍTICO: Este método deve retornar o nível de acesso! ***
					Usuario usuarioLogado = dao.retornUser(usuarioCredenciais, nomeBase, usuarioID); 

					if (usuarioLogado != null) {
						
						// SUBSTITUÍMOS as sessões parciais pela sessão do objeto completo
						session.setAttribute("usuario", usuarioLogado);
						session.setAttribute("empresa", nomeBase); 
						
						System.out.println("Usuário logado: " + usuarioLogado.getId() + " | Nível: " + usuarioLogado.getNivel());
						
						// Redireciona para a Home.jsp
						response.sendRedirect("Home.jsp");
						return;
					} else {
						request.setAttribute("erro", "Erro ao buscar dados completos do usuário.");
						RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
						rd.forward(request, response);
					}
					
				} else {
					request.setAttribute("erro", "Erro ao buscar ID do usuário.");
					RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
					rd.forward(request, response);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("erro", "Ocorreu um erro ao processar a solicitação (Verifique se a base existe).");
				RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
				rd.forward(request, response);
			}
		}
	}
}