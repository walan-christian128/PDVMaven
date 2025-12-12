package Controller;

import java.io.IOException;
import java.io.PrintWriter;

import DAO.ApiConfigDAO;
import Model.ApiConfig;
import Util.TokenGenerator; // Importar a nova classe
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GerarTokenEIniciarApiServlet")
public class GerarTokenEIniciarApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String nomeBase = request.getParameter("empresa");
        
        if (nomeBase == null || nomeBase.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Nome da base inválido.\"}");
            return;
        }

        try {
            // 1. GERAR TOKEN DE ACESSO
            String novoAccessToken = TokenGenerator.generateSecureToken(); 
            
            // 2. SALVAR/ATUALIZAR CONFIGURAÇÃO NO BANCO (com status inicial DISCONNECTED)
            ApiConfig config = new ApiConfig(nomeBase, novoAccessToken);
            ApiConfigDAO dao = new ApiConfigDAO(nomeBase);
            dao.salvarOuAtualizarConfig(config);
            
            // O nome da instância AGORA É O NOME DA BASE
            String instanceName = nomeBase; 
            
            // 3. CHAMAR A API PARA INICIAR A SESSÃO
            // O WhatsAppService.iniciarSessao já retorna o JSON com o QR Code
            String resultadoJson = WhatsAppService.iniciarSessao(instanceName, novoAccessToken); 
            
            // O JSON de resposta da API (que contém o QR Code) é repassado diretamente
            out.print(resultadoJson);

        } catch (Exception e) {
            System.err.println("Erro ao gerar token, salvar ou iniciar API para base " + nomeBase + ": " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Erro interno ao gerar Token/Iniciar API. Detalhe: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}