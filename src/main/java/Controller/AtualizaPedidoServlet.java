package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import DAO.PedidosDAO;
import Model.Pedidos;

@WebServlet("/atualizaPedido")
public class AtualizaPedidoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");

        String acao = request.getParameter("acao"); // "status" ou "pedido"
        String idPedidoStr = request.getParameter("idPedido");

        if (idPedidoStr == null || idPedidoStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do pedido está ausente ou inválido.");
            return;
        }

        int idPedido;
        try {
            idPedido = Integer.parseInt(idPedidoStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do pedido não é um número válido.");
            return;
        }

        String status = request.getParameter("status");

        try {
            PedidosDAO dao = new PedidosDAO(empresa);
            Pedidos ped = new Pedidos();
            ped.setIdPedido(idPedido);
            ped.setStatus(status);

            if ("status".equals(acao)) {
                dao.atualizaPedidoStatus(ped);
            } else if ("pedido".equals(acao)) {
                String observacoes = request.getParameter("observacoes");
                ped.setObservacoes(observacoes);
                dao.atualizaPedido(ped);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao atualizar o pedido.");
            return;
        }

        // Redirecionar para a página de pedidos
        response.sendRedirect("Pedidos.jsp");
    }

}
