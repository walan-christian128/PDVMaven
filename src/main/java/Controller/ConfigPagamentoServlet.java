package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.ConfigPagamentoDAO;
import Model.ConfigPagamento;

/**
 * Servlet para gerenciar as configurações de pagamento da empresa.
 */
@WebServlet("/configpagamento")
public class ConfigPagamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Método POST - usado para salvar/atualizar configurações de pagamento.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String empresaNome = (String) session.getAttribute("empresa");
        Integer empresaId = 1;

        if (empresaNome == null || empresaId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?erro=empresa-nao-encontrada");
            return;
        }

        // Captura os parâmetros do formulário
        String gateway = request.getParameter("gateway");
        String chavePix = request.getParameter("chavePix");
        String clientId = request.getParameter("clientId");
        String clientSecret = request.getParameter("clientSecret");
        String accessToken = request.getParameter("accessToken");
        String publickey = request.getParameter("publickey");

        // Cria objeto ConfigPagamento
        ConfigPagamento config = new ConfigPagamento(
                empresaId, gateway, chavePix, clientId, clientSecret, accessToken,
                publickey
                
        );

        try {
            ConfigPagamentoDAO dao = new ConfigPagamentoDAO(empresaNome);
            ConfigPagamento configExistente = dao.buscarPorEmpresa(1);

            if (configExistente != null) {
                dao.atualizar(config);
                request.setAttribute("mensagem", "Configuração de pagamento atualizada com sucesso!");
            } else {
                dao.salvar(config);
                request.setAttribute("mensagem", "Configuração de pagamento salva com sucesso!");
            }

            // Redireciona para página inicial
            response.sendRedirect("Home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao salvar configuração: " + e.getMessage());
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }

    /**
     * Método GET - usado para buscar e exibir configurações de pagamento.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String empresaNome = (String) session.getAttribute("empresa");
        Integer empresaId = (Integer) session.getAttribute("empresaId");

        if (empresaNome == null || empresaId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?erro=empresa-nao-encontrada");
            return;
        }

        try {
            ConfigPagamentoDAO dao = new ConfigPagamentoDAO(empresaNome);
            ConfigPagamento config = dao.buscarPorEmpresa(empresaId);

            request.setAttribute("configPagamento", config);
            request.getRequestDispatcher("Home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagemErro", "Erro ao carregar configuração: " + e.getMessage());
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }
}
