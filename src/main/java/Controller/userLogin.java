package Controller;

import java.io.IOException;

import DAO.EmpresaDAO;
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

	/**
	 * @see HttpServlet#HttpServlet()
	 */

	public userLogin() {
		super();
		// TODO Auto-generated constructor stub
	}


	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
		rd.forward(request, response);
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	@SuppressWarnings("unused")
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

	    HttpSession session = request.getSession();
	    session.setAttribute("empresa", empresa);

	    try {
	        UsuarioDAO dao = new UsuarioDAO(empresa);

	        // 🔹 Primeiro verifica se o login é válido
	        boolean loginValido = dao.efetuarLogin(email, senha, empresa);
	        if (!loginValido) {
	            request.setAttribute("erro", "Usuário, senha ou empresa incorretos.");
	            RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
	            rd.forward(request, response);
	            return;
	        }

	        // 🔹 Depois busca o ID do usuário
	        Usuario usuarioObj = new Usuario();
	        usuarioObj.setEmail(email);
	        usuarioObj.setSenha(senha);

	        int usuarioID = dao.cidugoUsuario(usuarioObj, empresa);
	        Usuario nomeUser = dao.retornUser(usuarioObj, empresa, usuarioID);

	        // 🔹 Aqui entra a busca do ID da empresa
	        EmpresaDAO empresaDAO = new EmpresaDAO(empresa); // você precisa ter esse DAO
	        int empresaId = 1;

	        if (usuarioID > 0) {
	            session.setAttribute("usuarioID", usuarioID);
	            session.setAttribute("usuarioNome", nomeUser);
	            session.setAttribute("empresaId", empresaId); // <-- AGORA O ID FICA NA SESSÃO
	            System.out.println("Usuário logado: " + usuarioID + " | Empresa: " + empresaId);
	            response.sendRedirect("Home.jsp");
	        } else {
	            request.setAttribute("erro", "Erro ao buscar ID do usuário.");
	            RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
	            rd.forward(request, response);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        request.setAttribute("erro", "Ocorreu um erro ao processar a solicitação.");
	        RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
	        rd.forward(request, response);
	    }
	}


}