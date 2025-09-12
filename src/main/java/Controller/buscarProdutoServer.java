package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;

import DAO.ProdutosDAO;
import Model.Produtos;

/**
 * Servlet implementation class buscaProdutoServer
 */
@WebServlet("/buscaProdutoServer")
public class buscarProdutoServer extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public buscarProdutoServer() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");

        try {
            String query = request.getParameter("query");

            ProdutosDAO dao = new ProdutosDAO(empresa);
            List<Produtos> produtos = dao.buscarPorDescricao(query);

            // Converte para JSON
            String json = new Gson().toJson(produtos);

            // Configura a resposta
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Envia a resposta
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

            // Debug no console
            System.out.println("JSON gerado: " + json);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao buscar produtos");
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
