package Controller;

import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.payment.PaymentClient;
import com.mercadopago.exceptions.MPApiException;
import com.mercadopago.resources.payment.Payment;
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

import javax.naming.NamingException;


@WebServlet("/mercadopago-webhook")
public class MercadoPagoWebhookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("\n✅ Requisição POST recebida em /mercadopago-webhook");

        // ... (Log dos headers)

        // Lê o corpo da requisição
        StringBuilder bodyBuilder = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream()))) {
            // ... (leitura do body)
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
            if ("test".equals(jsonBody.optString("live_mode")) || "test".equals(request.getHeader("X-Custom-Test"))) {
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
                    
                    PaymentClient client = new PaymentClient();
                    
                    // ATENÇÃO: É necessário obter o Access Token AQUI, antes de chamar client.get(paymentId)
                    // Como você só tem o external_reference APÓS a consulta, isso é um dilema.

                    // SOLUÇÃO: Você DEVE ter uma forma de obter o Access Token GLOBAL ou tentar com um token padrão.
                    // Para o ambiente de teste, vamos assumir que você tem um token padrão no DB para o ID 1
                    
                    // **PROBLEMA DE ACCESS TOKEN:**
                    // O MP exige que o Access Token seja configurado antes de chamar client.get(paymentId).
                    // Como o token é por empresa, você só saberá qual token usar APÓS obter o external_reference.
                    // A solução mais simples é usar uma credencial de "Gateway de Pagamento" (ou a Master) que tenha acesso a todos os pagamentos.
                    
                    // POR ENQUANTO, vamos manter o código no processPayment, mas saiba que a chamada
                    // client.get(paymentId) PODE FALHAR se o token não estiver configurado corretamente AQUI.
                    
                    // --- MANTENDO A LÓGICA ORIGINAL POR ENQUANTO ---
                    
                    // Busca o pagamento
                    Payment payment = client.get(paymentId);
                    
                    String externalReferenceCompleta = payment.getExternalReference();

                    if (externalReferenceCompleta == null || externalReferenceCompleta.isEmpty()) {
                        System.err.println("Erro: external_reference vazio ou nulo no Payment " + paymentId + ". Ignorando notificação.");
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
                        return;
                    }

                    // Extração da empresa e da referência
                    String empresa;
                    String referenciaVendaParaDB; 
                    int underlineIndex = externalReferenceCompleta.indexOf("_");

                    if (underlineIndex != -1) {
                        empresa = externalReferenceCompleta.substring(0, underlineIndex); 
                        referenciaVendaParaDB = externalReferenceCompleta.substring(underlineIndex + 1); 
                    } else {
                        // Caso a referência seja APENAS o ID numérico/UUID (sem prefixo)
                        empresa = "default"; // Usar um valor padrão ou erro
                        referenciaVendaParaDB = externalReferenceCompleta;
                    }
                    
                    System.out.println("DEBUG - Empresa extraída: " + empresa);
                    System.out.println("DEBUG - Referência para DB: " + referenciaVendaParaDB);


                    processPayment(payment, empresa, referenciaVendaParaDB); // Passa a referência limpa

                } else {
                    System.err.println("⚠️ Payment ID inválido. Notificação ignorada.");
                }
            } else {
                System.out.println("⚠️ Notificação ignorada. Tipo ou ID inválido.");
            }

            response.setStatus(HttpServletResponse.SC_OK);
            System.out.println("--- Webhook Finalizado ---\n");

        } catch (MPApiException e) {
             System.err.println("❌ Erro na API do Mercado Pago (API Call): Status " + e.getStatusCode() + ". Conteúdo: " + (e.getApiResponse() != null ? e.getApiResponse().getContent() : "N/A"));
             e.printStackTrace();
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            System.err.println("Erro ao processar webhook: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    private void processPayment(Payment payment, String empresa, String referenciaVendaParaDB) throws Exception {
        String status = payment.getStatus();
        System.out.println("Iniciando o processamento do pagamento...");
        System.out.println("Status do pagamento consultado: " + status);
        System.out.println("Referência para busca no DB: " + referenciaVendaParaDB);

        // Busca o access_token no banco via DAO da empresa correta
        ConfigPagamentoDAO configDAO;
        VendasDAO dao;
        
        try {
            configDAO = new ConfigPagamentoDAO(empresa);
            dao = new VendasDAO(empresa);
        } catch (NamingException e) {
            System.err.println("Erro ao inicializar DAO para a empresa " + empresa + ": " + e.getMessage());
            return;
        }

        // Tenta obter o Access Token (ID 1 é um valor arbitrário, ajuste se necessário)
        String token = configDAO.accessToken(1); 

        if (token == null || token.isEmpty()) {
            System.err.println("Nenhum access token encontrado para a empresa " + empresa);
            return;
        }
        
        // Embora o token seja configurado aqui, ele DEVERIA TER SIDO CONFIGURADO ANTES da chamada client.get(paymentId) no doPost.
        // O Mercado PagoConfig.setAccessToken(token) SÓ É NECESSÁRIO se esta função fosse fazer MAIS CHAMADAS à API.
        // Já que a chamada principal foi feita no doPost, esta linha pode ser removida se o token master for usado lá.
        // Por segurança, vamos mantê-la:
        MercadoPagoConfig.setAccessToken(token); 
        System.out.println("Access token da empresa " + empresa + " configurado com sucesso!");


        // Determina o status final a ser atualizado
        String statusVenda = switch (status) {
            case "approved" -> "APROVADA";
            case "pending" -> "PENDENTE";
            case "rejected" -> "REJEITADA";
            case "cancelled" -> "CANCELADA";
            case "in_process" -> "PROCESSANDO"; // Adicionado status intermediário
            default -> null;
        };

        if (statusVenda != null) {
             boolean atualizado = dao.atualizarStatusVenda(referenciaVendaParaDB, statusVenda); // Usa o método de String
            
            // Seu método atualizarStatusVenda(String externalReference, String novoStatus) está sendo usado aqui.
            // Se a sua coluna external_reference NO DB contém a CHAVE LIMPA (UUID), isso funcionará!
            
            if (atualizado) {
                System.out.println("✅ Venda " + referenciaVendaParaDB + " atualizada para " + statusVenda);
            } else {
                System.err.println("⚠️ Nenhuma venda encontrada com referência " + referenciaVendaParaDB);
            }
        } else {
            System.out.println("Status do pagamento não reconhecido: " + status);
        }
    }
}