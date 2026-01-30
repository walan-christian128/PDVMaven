/*package Controller;

import java.io.IOException;

import org.json.JSONObject;

import DAO.ApiConfigDAO;
import Model.ApiConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GerarQRCodeServlet")
public class GerarQRCodeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JSONObject json = new JSONObject();

        String nomeBase = request.getParameter("nomeBase");
        String acao = request.getParameter("acao");

        try {

            // 🔒 Validação básica
            if (nomeBase == null || nomeBase.trim().isEmpty()) {
                json.put("status", "ERRO");
                json.put("mensagem", "Nome da base não informado.");
                response.getWriter().print(json.toString());
                return;
            }

            ApiConfigDAO dao = new ApiConfigDAO(nomeBase);
            
            int idEmpresa = (int) request.getSession().getAttribute("empresa");
            ApiConfig config = dao.buscarConfigPorEmpresa(idEmpresa);

            // 🔒 Validação CRÍTICA (era isso que estava faltando)
            if (config == null || config.getSessionName() == null) {
                json.put("status", "ERRO");
                json.put("mensagem", "SessionName não configurado para esta empresa.");
                response.getWriter().print(json.toString());
                return;
            }

            // 🔥 AÇÕES
            if ("iniciar".equalsIgnoreCase(acao)) {

                String resposta = WhatsAppService.iniciarSessao(
                        config.getSessionName()
                );

                json.put("status", "STARTING");
                json.put("response", resposta);
            }

            else if ("status".equalsIgnoreCase(acao)) {

                String status = WhatsAppService.obterStatusSessao(
                        config.getSessionName()
                );

                json.put("status", status);
            }

            else if ("desconectar".equalsIgnoreCase(acao)) {
                // opcional — mantém estrutura
                json.put("status", "DISCONNECTED");
            }

            else {
                json.put("status", "ERRO");
                json.put("mensagem", "Ação inválida.");
            }

        } catch (Exception e) {
            json.put("status", "ERRO");
            json.put("mensagem", e.getMessage());
        }

        response.getWriter().print(json.toString());
    }
}*/
