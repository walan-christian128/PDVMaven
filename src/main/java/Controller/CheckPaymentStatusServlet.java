package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import DAO.VendasDAO;

@WebServlet("/checkPaymentStatusServlet")
public class CheckPaymentStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CheckPaymentStatusServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");

        System.out.println(">>> CHECK PAYMENT STATUS SERVLET <<<");
        System.out.println("Order ID recebido: " + orderId);
        System.out.println("Empresa da sessão: " + empresa);

        response.setContentType("text/plain");

        if (orderId == null || orderId.isEmpty() || empresa == null || empresa.isEmpty()) {
            response.getWriter().write("error");
            return;
        }

        try {
            VendasDAO dao = new VendasDAO(empresa);
            String status = dao.getStatusVendaPorId(orderId); 

            System.out.println("Status retornado pelo DAO: " + status);
            
            if (status == null) {
                response.getWriter().write("pending");
            } else {
                // Converte a string do banco para minúsculas antes de enviar
                response.getWriter().write(status.toLowerCase());
            }

            // ... restante do seu código
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
