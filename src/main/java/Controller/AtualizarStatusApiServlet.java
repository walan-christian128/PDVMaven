package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import DAO.ApiConfigDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet responsável por atualizar o 'session_status' da API no banco de dados.
 * É chamado via AJAX pelo PainelAtivacaoAPI.jsp
 */
@WebServlet("/AtualizarStatusApiServlet") // Mapeamento corrigido para 404
public class AtualizarStatusApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Parâmetros esperados do AJAX
        String nomeBase = request.getParameter("nomeBase");
        String novoStatus = request.getParameter("status");
        
        if (nomeBase == null || nomeBase.isEmpty() || novoStatus == null || novoStatus.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Parâmetros nomeBase ou status não fornecidos.\"}");
            return;
        }

        ApiConfigDAO dao = null;
        try {
            // 1. Conexão ao DAO usando o nome da base
            dao = new ApiConfigDAO(nomeBase);
            
            // 2. Chama o método do DAO para atualizar o status na tabela funcition_wpp
            dao.atualizarStatus(nomeBase, novoStatus);
            
            // 3. Sucesso
            out.print("{\"success\": true, \"message\": \"Status atualizado para " + novoStatus + "\"}");

        } catch (Exception e) {
            System.err.println("Erro ao atualizar status da API para base " + nomeBase + ": " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Erro interno ao salvar status: " + e.getMessage() + "\"}");
        } finally {
            if (dao != null) {
                dao.close();
            }
        }
    }
}