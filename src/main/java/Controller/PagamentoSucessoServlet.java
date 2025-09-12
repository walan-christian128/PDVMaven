package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;



@WebServlet("/pagamento-sucesso")
public class PagamentoSucessoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // A URL de sucesso do Mercado Pago pode vir com o ID do pagamento.
        String paymentId = request.getParameter("payment_id");
        request.setAttribute("paymentId", paymentId);
        
        // Redireciona para a página JSP de sucesso
        request.getRequestDispatcher("/sucesso.jsp").forward(request, response);
    }
}