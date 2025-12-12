package Controller;

import java.io.IOException;

import DAO.ApiConfigDAO;
import Model.ApiConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ConfigurarApiServlet")
public class ConfigurarApiServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nomeBase = request.getParameter("empresa");
        String accessToken = request.getParameter("accessToken");
        
        if (nomeBase == null || nomeBase.isEmpty() || accessToken == null || accessToken.isEmpty()) {
            response.sendRedirect("PainelAtivacaoAPI.jsp?base=" + nomeBase + "&msg=erro_dados_invalidos");
            return;
        }

        try {
            ApiConfig config = new ApiConfig(nomeBase, accessToken);
            ApiConfigDAO dao = new ApiConfigDAO(nomeBase);
            
            // O DAO salva ou atualiza o registro no banco
            dao.salvarOuAtualizarConfig(config);
            
            // Redireciona de volta para o painel com sucesso
            response.sendRedirect("PainelAtivacaoAPI.jsp?base=" + nomeBase + "&msg=config_salva_sucesso");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PainelAtivacaoAPI.jsp?base=" + nomeBase + "&msg=erro_dao&detail=" + e.getMessage());
        }
	}
}