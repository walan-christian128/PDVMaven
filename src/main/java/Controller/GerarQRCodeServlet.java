package Controller;

import java.io.IOException;
import java.io.PrintWriter;

import DAO.ApiConfigDAO; // CORREÇÃO: Usar o DAO correto para configurações da API
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet responsável por gerenciar as ações da API de Mensagens
 * (Início/QR Code, Desconexão, Status), utilizando Token e Instância (nome da Base) Dinâmicos.
 * Requer: WhatsAppService, ApiConfigDAO, e a classe de Conexão.
 */
@WebServlet("/GerarQRCodeServlet")
public class GerarQRCodeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // CORREÇÃO: No PainelAtivacaoAPI.jsp passamos o parâmetro como 'nomeBase', 
        // mas se você manteve 'empresa' no seu JS ou está lendo 'empresa' do seu login,
        // garantimos que o nome da base/instância é lido corretamente aqui.
        String nomeBase = request.getParameter("nomeBase"); // O JS usa 'nomeBase'
        if (nomeBase == null || nomeBase.isEmpty()) {
            nomeBase = request.getParameter("empresa"); // Tentativa de fallback
        }
        if (nomeBase == null || nomeBase.isEmpty()) {
            nomeBase = request.getParameter("base");
        }
        
        String acao = request.getParameter("acao");         

        if (nomeBase == null || nomeBase.isEmpty() || acao == null || acao.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Parâmetros de base/ação inválidos.\"}");
            return;
        }

        String resultadoJson;
        
        try {
            // 1. BUSCAR O TOKEN DE ACESSO DA BASE ESPECÍFICA (CRÍTICO!)
            // CORREÇÃO: Instancia o ApiConfigDAO (assumindo que ele está no pacote DAO)
            ApiConfigDAO dao = new ApiConfigDAO(nomeBase); 
            
            // CORREÇÃO: Chama o método do DAO correto
            String accessToken = dao.obterApiAccessToken(nomeBase); 
            
            if (accessToken == null || accessToken.isEmpty()) {
                 response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                 out.print("{\"success\": false, \"message\": \"Token de acesso da API não configurado para esta base.\"}");
                 return;
            }

            // O nome da instância AGORA É O NOME DA BASE
            String instanceName = nomeBase; 
            
            switch (acao.toLowerCase()) {
                
                case "iniciar":
                    // Chamada DINÂMICA
                    resultadoJson = WhatsAppService.iniciarSessao(instanceName, accessToken); 
                    break;
                    
                case "desconectar":
                    // Chamada DINÂMICA
                    resultadoJson = WhatsAppService.desconectarSessao(instanceName, accessToken);
                    break;
                    
                case "status":
                    // Chamada DINÂMICA
                    resultadoJson = WhatsAppService.obterStatusSessao(instanceName, accessToken);
                    break;
                    
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\": false, \"message\": \"Ação desconhecida.\"}");
                    return;
            }
            
            out.print(resultadoJson);

        } catch (Exception e) {
            // Se houver erro de DAO (conexão) ou na chamada à API externa
            System.err.println("Erro ao buscar Token ou chamar API para base " + nomeBase + ": " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Erro interno no servidor ao processar a API: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}