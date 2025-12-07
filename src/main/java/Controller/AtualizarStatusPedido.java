package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.PedidosDAO;
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
        String empresa = (String) session.getAttribute("empresa");

        try {
            // 1. Recebe dados
            int pedidoId = Integer.parseInt(request.getParameter("idPedido"));
            String novoStatus = request.getParameter("status");

            // 2. DAO
            PedidosDAO dao = new PedidosDAO(empresa);

            // 3. Atualiza o status no banco
            dao.atualizarStatus(pedidoId, novoStatus);

            // 4. Busca os dados do cliente para envio de WhatsApp
            Pedidos ped = dao.getDadosParaWhatsApp(pedidoId);

            if (ped != null && ped.getClientepedido() != null) {

                String telefone = ped.getClientepedido().getTelefone();
                String nome = ped.getClientepedido().getNome();
                
                // Os dados do ID do Pedido e o Novo Status já estão disponíveis.
                
                // 5. Envia WhatsApp - AGORA USANDO O TEMPLATE PERSONALIZADO
                WhatsAppService.enviarStatusPedidoTemplate(
                    telefone, 
                    nome, 
                    ped.getIdPedido(), 
                    novoStatus // Use o status recém-definido
                );
            }

            // 6. Redireciona
            response.sendRedirect("Pedidos.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Erro ao atualizar status.");
        }
    }
}