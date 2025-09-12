// Package e imports mantidos do código original
package Controller;

import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.payment.PaymentClient;
import com.mercadopago.exceptions.MPApiException;

import com.mercadopago.resources.payment.Payment;

import com.mercadopago.client.merchantorder.MerchantOrderClient;
import com.mercadopago.resources.merchantorder.MerchantOrder;
import com.mercadopago.resources.merchantorder.MerchantOrderPayment;
import DAO.ConfigPagamentoDAO;
import DAO.VendasDAO;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;


@WebServlet("/mercadopago-webhook")
public class MercadoPagoWebhookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("\n✅ Requisição POST recebida em /mercadopago-webhook");

        // Log dos headers da requisição
        System.out.println("URL completa: " + request.getRequestURL().toString());
        System.out.println("Headers: ");
        request.getHeaderNames().asIterator().forEachRemaining(headerName -> {
            System.out.println(" - " + headerName + ": " + request.getHeader(headerName));
        });

        // Lê o corpo da requisição
        StringBuilder bodyBuilder = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                bodyBuilder.append(line);
            }
        }

        String body = bodyBuilder.toString();
        System.out.println("\n--- Webhook Recebido ---");
        System.out.println("Body: " + body);

        if (body.isEmpty()) {
            System.err.println("Erro: Corpo da requisição vazio.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            JSONObject jsonBody = new JSONObject(body);
            String tipoNotificacao = jsonBody.has("type") ? jsonBody.getString("type") :
                                     jsonBody.has("topic") ? jsonBody.getString("topic") : null;
            String resourceId = jsonBody.has("resource") ? jsonBody.getString("resource") :
                                jsonBody.has("data") && jsonBody.getJSONObject("data").has("id") ?
                                jsonBody.getJSONObject("data").getString("id") : null;

            System.out.println("Tipo de notificação: " + tipoNotificacao);
            System.out.println("Resource ID: " + resourceId);

            // Ignora notificações de teste
            if ("test".equals(jsonBody.optString("live_mode"))) {
                System.out.println("⚠️ Notificação de TESTE recebida. Não será processada.");
                response.setStatus(HttpServletResponse.SC_OK);
                System.out.println("--- Webhook Finalizado ---\n");
                return;
            }

            if (tipoNotificacao != null && tipoNotificacao.startsWith("payment") && resourceId != null) {

                Long paymentId;
                try {
                    paymentId = Long.parseLong(resourceId);
                } catch (NumberFormatException e) {
                    System.err.println("Erro: ID do recurso não é um número. Tentando ID do corpo.");
                    paymentId = jsonBody.has("data") ? jsonBody.getJSONObject("data").optLong("id") : null;
                }

                if (paymentId != null) {
                    System.out.println("Payment ID: " + paymentId);
                    System.out.println("Buscando detalhes do pagamento...");

                    PaymentClient client = new PaymentClient();
                    Payment payment = client.get(paymentId);

                    String externalReference = payment.getExternalReference();
                    if (externalReference == null || externalReference.isEmpty()) {
                        System.err.println("Erro: external_reference vazio ou nulo. Ignorando notificação.");
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }

                    // Extrai apenas a empresa para criar DAO
                    String empresa = externalReference.contains("_") ? externalReference.substring(0, externalReference.indexOf("_")) : externalReference;

                    processPayment(payment, empresa, externalReference);

                } else {
                    System.err.println("⚠️ Payment ID inválido. Notificação ignorada.");
                }
            } else {
                System.out.println("⚠️ Notificação ignorada. Tipo ou ID inválido.");
            }

            response.setStatus(HttpServletResponse.SC_OK);
            System.out.println("--- Webhook Finalizado ---\n");

        } catch (Exception e) {
            System.err.println("Erro ao processar webhook: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    private void processPayment(Payment payment, String empresa, String referenciaVenda) throws Exception {
        String status = payment.getStatus();
        System.out.println("Iniciando o processamento do pagamento...");
        System.out.println("Status do pagamento consultado: " + status);
        System.out.println("External Reference: " + payment.getExternalReference());

        // ⚡ Busca o access_token no banco via DAO da empresa correta
        System.out.println("Buscando access token para a empresa: " + empresa);
        ConfigPagamentoDAO configDAO = new ConfigPagamentoDAO(empresa);
        String token = configDAO.accessToken(1);

        if (token == null || token.isEmpty()) {
            System.err.println("Nenhum access token encontrado para a empresa " + empresa);
            return;
        }

        MercadoPagoConfig.setAccessToken(token);
        System.out.println("Access token da empresa " + empresa + " configurado com sucesso!");

        VendasDAO dao = new VendasDAO(empresa);

        // Tenta converter a referenciaVenda para um número. Se não for, assume que é string/UUID
        Integer vendaIdNumerico = null;
        try {
            vendaIdNumerico = Integer.parseInt(referenciaVenda);
        } catch (NumberFormatException e) {
            System.err.println("A referência da venda não é um número. Prosseguindo com a referência como string.");
        }

        // Determina o status final a ser atualizado
        String statusVenda = switch (status) {
            case "approved" -> "APROVADA";
            case "pending" -> "PENDENTE";
            case "rejected" -> "REJEITADA";
            case "cancelled" -> "CANCELADA";
            default -> null;
        };

        if (statusVenda != null) {
            boolean atualizado;
            if (vendaIdNumerico != null) {
                atualizado = dao.atualizarStatusVenda(vendaIdNumerico, statusVenda);
            } else {
                atualizado = dao.atualizarStatusVenda(referenciaVenda, statusVenda);
            }

            if (atualizado) {
                System.out.println("✅ Venda " + referenciaVenda + " atualizada para " + statusVenda);
            } else {
                System.err.println("⚠️ Nenhuma venda encontrada com referência " + referenciaVenda);
            }
        } else {
            System.out.println("Status do pagamento não reconhecido: " + status);
        }
    }

}
