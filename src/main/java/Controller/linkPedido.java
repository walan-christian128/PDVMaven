package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import DAO.TokenServiceDAO;

/**
 * Servlet implementation class linkPedido
 */
@WebServlet("/linkPedido")
public class linkPedido extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public linkPedido() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	   try {
		   String token = TokenServiceDAO.gerarToken(); // Gera o token

           // Recupera o nome da empresa da sessão ou do request
           HttpSession session = request.getSession();
           String empresa = (String) session.getAttribute("empresa");

           // Monta o link com token e empresa como parâmetros
           String link = "http://localhost:8080/PDVVenda/CadastroClientePedido.jsp?token=" + token + "&empresa=" + empresa;

           // Armazena o link na requisição para ser exibido na JSP
           request.setAttribute("token", link);

           // Encaminha para a JSP
           request.getRequestDispatcher("LinkCadastroPedido.jsp").forward(request, response);
	} catch (Exception e) {
		e.printStackTrace();
	}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
