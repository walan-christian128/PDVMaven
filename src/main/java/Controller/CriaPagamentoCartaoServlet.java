import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.common.IdentificationRequest;
import com.mercadopago.client.common.AddressRequest;
import com.mercadopago.client.common.PhoneRequest;
import com.mercadopago.client.preference.PreferenceClient;
import com.mercadopago.client.preference.PreferencePayerRequest;
import com.mercadopago.client.preference.PreferenceRequest;
import com.mercadopago.exceptions.MPApiException;
import com.mercadopago.exceptions.MPException;
import com.mercadopago.resources.preference.Preference;
import DAO.ConfigPagamentoDAO;
import DAO.VendasDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import javax.naming.NamingException;

@SuppressWarnings("serial")
@WebServlet("/criaPagamentoCartaoServlet")
public class CriaPagamentoCartaoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");

        if (empresa == null || empresa.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nome da empresa ausente.");
            return;
        }

        try {
            ConfigPagamentoDAO dbManager = new ConfigPagamentoDAO(empresa);
            String accessToken = dbManager.accessToken(1); // ID da empresa 1
            
            if (accessToken == null || accessToken.isEmpty()) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token de acesso não encontrado.");
                return;
            }

            MercadoPagoConfig.setAccessToken(accessToken);
            
            VendasDAO dao = new VendasDAO(empresa);
            BigDecimal totalVenda = dao.retornaVendaValor();
            String orderId = "Sua_Order_ID_Aqui"; // Obtenha a Order ID da sua sessão ou banco de dados

            if (totalVenda == null || totalVenda.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Valor da transação inválido.");
                return;
            }
            
            // ✅ Cria o objeto de preferência
            PreferenceClient client = new PreferenceClient();
            
            // Aqui você pode adicionar mais detalhes como itens, cliente, etc.
            // Para este exemplo, usamos o valor total da venda.
            PreferencePayerRequest payer = PreferencePayerRequest.builder()
                    .email("test_user@example.com")
                    .build();
            
            PreferenceRequest preferenceRequest = PreferenceRequest.builder()
                    .transactionAmount(totalVenda)
                    .description("Produto do Pedido")
                    .paymentMethods(null) // O Payment Brick cuida de qual tipo de cartão usar
                    .externalReference(orderId)
                    .payer(payer)
                    .build();

            // ✅ Cria a preferência no Mercado Pago
            Preference preference = client.create(preferenceRequest);
            
            // ✅ Adiciona a preferenceId e outros atributos na requisição
            request.setAttribute("preferenceId", preference.getId());
            request.setAttribute("publicKey", dbManager.publicKey(1)); // Obtenha a chave pública
            request.setAttribute("totalVenda", totalVenda.toString());
            request.setAttribute("orderId", orderId);
            
            // ✅ Redireciona para a página de checkout com os dados
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);

        } catch (MPApiException e) {
            System.err.println("Mercado Pago API Error: " + e.getApiResponse().toString());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro na API do Mercado Pago.");
        } catch (MPException | NamingException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao criar a preferência de pagamento.");
        }
    }
}