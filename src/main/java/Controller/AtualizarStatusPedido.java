package Controller;

import java.io.IOException;
import java.sql.SQLException; // Importado para tratamento de erro de DB
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.PedidosDAO;
import DAO.ApiConfigDAO; 
import Model.Pedidos;

@WebServlet("/AtualizarStatusPedido")
public class AtualizarStatusPedido extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AtualizarStatusPedido() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String instanceName = (String) session.getAttribute("empresa");

        if (instanceName == null || instanceName.isEmpty()) {
            response.getWriter().write("Erro: Sessão de empresa não definida.");
            return;
        }

        String mensagemErro = null;
        PedidosDAO pedidoDao = null;
        ApiConfigDAO apiDao = null;

        try {
            // 1. Recebe dados
            int pedidoId = Integer.parseInt(request.getParameter("idPedido"));
            String novoStatus = request.getParameter("status");

            // 2. DAO (Atualização do Pedido)
            pedidoDao = new PedidosDAO(instanceName);

            // 3. Atualiza o status no banco
            pedidoDao.atualizarStatus(pedidoId, novoStatus);

            // 4. Busca os dados do cliente para envio de WhatsApp
            Pedidos ped = pedidoDao.getDadosParaWhatsApp(pedidoId);

            if (ped != null && ped.getClientepedido() != null) {

                String telefone = ped.getClientepedido().getTelefone();
                String nome = ped.getClientepedido().getNome();

                // =========================================================
                // 🔑 PASSO CRÍTICO: BUSCAR O TOKEN DA API
                // =========================================================
                // Instancia o DAO de API
                apiDao = new ApiConfigDAO(instanceName);
                String accessToken = apiDao.obterApiAccessToken(instanceName); 

                // Fechamento da conexão do ApiConfigDAO aqui é seguro.
                // Não há problema em fechar o DAO e reabri-lo se for necessário.
                apiDao.close(); 
                apiDao = null; // Zera a referência

                if (accessToken == null || accessToken.isEmpty()) {
                    System.err.println("Aviso: Token da API não configurado para a base " + instanceName + ". Mensagem WPP não enviada.");
                    mensagemErro = "Status atualizado. Aviso WPP não enviado: Token não configurado.";
                } else {
                    // =========================================================
                    // 5. CHAMADA ATUALIZADA DO WHATSAPP SERVICE
                    // =========================================================
                    WhatsAppService.enviarStatusPedidoTemplate(
                        instanceName, 
                        accessToken,  
                        telefone,
                        nome,
                        ped.getIdPedido(),
                        novoStatus
                    );
                    mensagemErro = "Status atualizado e aviso WPP enviado com sucesso.";
                }

            } else {
                mensagemErro = "Status atualizado. Dados do cliente não encontrados para envio do aviso WPP.";
            }

            // 6. Redireciona com uma mensagem 
            session.setAttribute("mensagemStatus", mensagemErro);
            response.sendRedirect("Pedidos.jsp");

        } catch (NumberFormatException e) {
             e.printStackTrace();
             response.getWriter().write("Erro: ID do Pedido ou Status inválido.");
        } catch (SQLException e) {
            e.printStackTrace();
            // Erro na comunicação com o DB
            session.setAttribute("mensagemStatus", "Erro no banco de dados ao atualizar status: " + e.getMessage());
            response.sendRedirect("Pedidos.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            // Erro na comunicação com a API (WhatsAppService) ou outra exceção genérica
            session.setAttribute("mensagemStatus", "Erro grave ao atualizar status: " + e.getMessage());
            response.sendRedirect("Pedidos.jsp");
        } finally {
            // GARANTE O FECHAMENTO DAS CONEXÕES DO BANCO (CRÍTICO!)
            if (pedidoDao != null) {
                
            }
            // OBS: O apiDao já foi fechado mais acima, mas o try-finally garante que se ele
            // falhar antes do close explícito, ele será fechado aqui, se não for null.
            if (apiDao != null) {
                apiDao.close();
            }
        }
    }
}