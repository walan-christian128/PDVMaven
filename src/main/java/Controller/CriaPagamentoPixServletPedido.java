package Controller;

import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.payment.PaymentClient;
import com.mercadopago.client.payment.PaymentCreateRequest;
import com.mercadopago.client.payment.PaymentPayerRequest;
import com.mercadopago.exceptions.MPApiException;
import com.mercadopago.exceptions.MPException;
import com.mercadopago.resources.payment.Payment;
import com.google.gson.JsonObject;
import DAO.ConfigPagamentoDAO;
import DAO.VendasDAO;

import Model.Vendas;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.OffsetDateTime;
import java.util.UUID;
import javax.naming.NamingException;
import org.json.JSONArray;
import org.json.JSONObject;

@SuppressWarnings("serial")
@WebServlet("/criaPagamentoPixServletPedido")
public class CriaPagamentoPixServletPedido extends HttpServlet {

    @Override
    public void init() throws ServletException {
        // Nenhuma configuração estática aqui.
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");

        System.out.println("Servlet 'CriaPagamentoPixServlet' foi executado.");

        if (empresa == null || empresa.isEmpty()) {
            System.err.println("Erro: Nome da base da empresa não definido na sessão.");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nome da empresa ausente.");
            return;
        }

        String empresaIdStr = request.getParameter("idEmpresa");
        int idEmpresa = 1;

        if (empresaIdStr != null && !empresaIdStr.isEmpty()) {
            try {
                idEmpresa = Integer.parseInt(empresaIdStr);
            } catch (NumberFormatException e) {
                System.err.println("Erro: ID da empresa inválido.");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da empresa inválido.");
                return;
            }
        }

        try {
            ConfigPagamentoDAO dbManager = new ConfigPagamentoDAO(empresa);
            String accessToken = dbManager.accessToken(idEmpresa);

            if (accessToken == null || accessToken.isEmpty()) {
                System.err.println("Erro: Token de acesso não encontrado para a empresa.");
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token de acesso não encontrado para a empresa.");
                return;
            }

            // ✅ Configura o access token do Mercado Pago
            MercadoPagoConfig.setAccessToken(accessToken);

            VendasDAO dao = new VendasDAO(empresa);
            BigDecimal amount = dao.retornaVendaValor();

            if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
                System.err.println("Erro: Valor da transação é inválido.");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "O valor da transação deve ser positivo.");
                return;
            }

            String ngrokBaseUrl = getNgrokTunnelUrl();
            if (ngrokBaseUrl == null) {
                System.err.println("Erro: Não foi possível obter a URL do Ngrok. Verifique se o Ngrok está rodando.");
                response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Erro ao obter a URL do Ngrok.");
                return;
            }
            
            // ✅ Gera externalReference e cria a requisição de pagamento
            String externalReference = empresa + "_" + UUID.randomUUID().toString();
            String notificationUrl = ngrokBaseUrl + "/PDVVenda/mercadopago-webhook";
            
            System.out.println("URL de notificação para o Pix: " + notificationUrl);
            
            PaymentPayerRequest payerRequest = PaymentPayerRequest.builder()
                    .email("test_user@example.com")
                    .build();

            PaymentClient client = new PaymentClient();
            PaymentCreateRequest paymentCreateRequest = PaymentCreateRequest.builder()
                    .transactionAmount(amount)
                    .description("Produto do Pedido")
                    .paymentMethodId("pix")
                    .externalReference(externalReference)
                    .notificationUrl(notificationUrl)
                    .dateOfExpiration(OffsetDateTime.now().plusMinutes(30))
                    .payer(payerRequest)
                    .build();

            Payment payment = client.create(paymentCreateRequest);

            String qrCode = null;
            String qrCodeBase64 = null;

            if (payment.getPointOfInteraction() != null && payment.getPointOfInteraction().getTransactionData() != null) {
                qrCode = payment.getPointOfInteraction().getTransactionData().getQrCode();
                qrCodeBase64 = payment.getPointOfInteraction().getTransactionData().getQrCodeBase64();
            }

            // ✅ Aqui atualizamos a última venda cadastrada com os dados do pagamento online
            int idVendaExistente = dao.retornaVenda(); // método precisa existir no seu DAO

            Vendas vendaParaAtualizar = new Vendas();
            vendaParaAtualizar.setExternalReference(externalReference);
            vendaParaAtualizar.setPgTotalOnline(amount);
            vendaParaAtualizar.setSetStatusVenda("PENDENTE"); // Corrigido: não usar setSetStatusVenda

            boolean atualizado = dao.atualizarVendaOnline(idVendaExistente, vendaParaAtualizar);

            if (atualizado) {
                System.out.println("Venda " + idVendaExistente + " atualizada com externalReference " + externalReference);
            } else {
                System.err.println("Falha ao atualizar a venda " + idVendaExistente + ". Verifique se ela existe.");
            }

            // ✅ Retorna os dados do pagamento em JSON para o frontend
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            JsonObject json = new JsonObject();
            json.addProperty("qr_code", qrCode);
            json.addProperty("qr_code_base64", qrCodeBase64);
            json.addProperty("id", externalReference);

            response.getWriter().write(json.toString());

        } catch (MPApiException e) {
            System.err.println("Mercado Pago API Error:");
            System.err.println("HTTP Status: " + e.getApiResponse().getStatusCode());
            System.err.println("Response Body: " + e.getApiResponse().toString());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro na API do Mercado Pago. Verifique o console para mais detalhes.");
        } catch (MPException | NamingException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao criar a preferência de pagamento.");
        }
    }

    private String getNgrokTunnelUrl() {
        try {
            URL url = new URL("http://127.0.0.1:4040/api/tunnels");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            if (conn.getResponseCode() != 200) {
                System.err.println("Erro ao conectar na API do Ngrok: " + conn.getResponseCode());
                return null;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            String output;
            StringBuilder response = new StringBuilder();
            while ((output = br.readLine()) != null) {
                response.append(output);
            }
            conn.disconnect();

            JSONObject json = new JSONObject(response.toString());
            JSONArray tunnels = json.getJSONArray("tunnels");

            for (int i = 0; i < tunnels.length(); i++) {
                JSONObject tunnel = tunnels.getJSONObject(i);
                if (tunnel.getString("proto").equals("https")) {
                    return tunnel.getString("public_url");
                }
            }

        } catch (IOException e) {
            System.err.println("Erro de I/O ao tentar conectar na API do Ngrok: " + e.getMessage());
        }
        return null;
    }
}
