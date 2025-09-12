package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import DAO.ProdutosDAO;
import Model.Produtos;

/**
 * Servlet implementation class ExibirImagemProdutoServlet
 */

@WebServlet("/exibirImagemProduto")
public class ExibirImagemProdutoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");

        if (idParam != null && empresa != null) {
            try {
                int id = Integer.parseInt(idParam);
                ProdutosDAO dao = new ProdutosDAO(empresa);
                Produtos produto = dao.consultarPorCodigo(id);

                byte[] imagem = produto.getImagem();
                if (imagem != null) {
                    response.setContentType("image/jpeg");
                    response.setContentLength(imagem.length);
                    response.getOutputStream().write(imagem);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Imagem não encontrada.");
                }
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar imagem.");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido ou empresa não definida.");
        }
    }
}

