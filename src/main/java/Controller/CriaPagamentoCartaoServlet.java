package Controller;

import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.payment.PaymentClient;
import com.mercadopago.client.payment.PaymentCreateRequest;
import com.mercadopago.client.payment.PaymentPayerRequest;
import com.mercadopago.client.common.IdentificationRequest;
import com.mercadopago.exceptions.MPApiException;
import com.mercadopago.exceptions.MPException;
import com.mercadopago.resources.payment.Payment;
import com.google.gson.JsonObject;
import DAO.ConfigPagamentoDAO;
import DAO.VendasDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter; 
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.UUID;
import javax.naming.NamingException;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

@SuppressWarnings("serial")
@WebServlet("/criaPagamentoCartaoServlet")
public class CriaPagamentoCartaoServlet extends HttpServlet {
    
    // Função utilitária para converter Stack Trace em String
    private String getStackTraceAsString(Throwable t) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        t.printStackTrace(pw);
        return sw.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String empresa = (String) session.getAttribute("empresa");
        System.out.println("🔹 Servlet 'CriaPagamentoCartaoServlet' (BRICK - PAGAMENTO DIRETO) executado.");
        System.out.println("Empresa selecionada: " + empresa);

        if (empresa == null || empresa.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Nome da empresa ausente na sessão.\"}");
            return;
        }

        String idEmpresaParam = request.getParameter("idEmpresa");
        int idEmpresa = 0; // Inicializa a variável para ser usada em ambos os fluxos

        // Variável para armazenar o JSON bruto, útil em caso de erro no Flow 2
        String jsonBruto = null; 

        try {
            ConfigPagamentoDAO dbManager = new ConfigPagamentoDAO(empresa);
            VendasDAO dao = new VendasDAO(empresa);

            if (idEmpresaParam != null && !idEmpresaParam.isEmpty()) {
                // =======================================================
                // FLUXO 1: INICIALIZAÇÃO (FRONT QUER PUBLIC KEY E AMOUNT)
                // =======================================================
                try {
                    idEmpresa = Integer.parseInt(idEmpresaParam);
                } catch (NumberFormatException e) {
                    System.err.println("❌ Erro de formato no ID da Empresa: " + idEmpresaParam);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"ID da empresa inválido no parâmetro.\"}");
                    return;
                }
                
                session.setAttribute("idEmpresa", idEmpresa); 
                
                System.out.println("🔑 Iniciando fluxo de obtenção de chaves e dados de venda para ID: " + idEmpresa);
                
                String publicKey = dbManager.publicKey(idEmpresa);
                BigDecimal amount = dao.retornaVendaValor();
                
                // NOVO LOG: Loga o final da Public Key
                String publicKeyDisplay = publicKey != null && publicKey.length() > 4 ? "..." + publicKey.substring(publicKey.length() - 4) : publicKey;
                System.out.println("✅ Public Key obtida. Tamanho: " + (publicKey != null ? publicKey.length() : 0) + " caracteres. Final: " + publicKeyDisplay);
                
                if (publicKey == null || publicKey.isEmpty()) {
                    System.err.println("❌ Falha de Dados (401): Chave pública não encontrada ou vazia para ID: " + idEmpresa);
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
                    out.print("{\"error\": \"Chave pública não encontrada para a empresa. Verifique a configuração.\"}");
                    return;
                }
                
                if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
                    System.err.println("❌ Falha de Dados (400): Valor da transação inválido ou nulo. Valor retornado: " + amount);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"Valor da transação inválido para inicialização.\"}");
                    return;
                }
                
                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("publicKey", publicKey);
                jsonResponse.addProperty("amount", amount);
                jsonResponse.addProperty("preferenceId", UUID.randomUUID().toString()); 
                
                out.print(jsonResponse.toString());
                // LOG ATUALIZADO: Confirma o final da Public Key enviada ao front
                System.out.println("✅ Dados de inicialização enviados ao front. PublicKey final: " + publicKeyDisplay + ", Valor: " + amount);
                
            } else {
                // =======================================================
                // FLUXO 2: SUBMISSÃO DE PAGAMENTO (FRONT ENVIA O JSON DO BRICK)
                // =======================================================
                
                Object idEmpresaObj = session.getAttribute("idEmpresa");
                if (idEmpresaObj == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"ID da empresa ausente na sessão. Recarregue a página e tente novamente.\"}");
                    return;
                }
                idEmpresa = (int) idEmpresaObj;
                
                System.out.println("💳 Iniciando fluxo de criação de pagamento para ID: " + idEmpresa);

                String accessToken = dbManager.accessToken(idEmpresa); 
                
                if (accessToken == null || accessToken.isEmpty()) {
                    System.err.println("❌ Token de acesso ausente ou vazio no DB.");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print("{\"error\": \"Token de acesso (Access Token) não encontrado para a empresa.\"}");
                    return;
                }
                
                // LOG ATUALIZADO: Ajuda a confirmar que o token está sendo lido (final da chave)
                String tokenDisplay = accessToken.length() > 4 ? "..." + accessToken.substring(accessToken.length() - 4) : accessToken;
                System.out.println("🔑 Access Token obtido. Tamanho: " + accessToken.length() + " caracteres. Final: " + tokenDisplay);
                
                MercadoPagoConfig.setAccessToken(accessToken);

                // RECUPERA o CORPO JSON
                StringBuilder jb = new StringBuilder();
                try (BufferedReader reader = request.getReader()) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        jb.append(line);
                    }
                }
                
                jsonBruto = jb.toString(); // <--- Captura o JSON Bruto
                
                JSONObject jsonPayload;
                if (jsonBruto.trim().startsWith("[")) {
                    // Se for um array (estrutura enviada pelo Brick)
                    JSONArray jsonArray = new JSONArray(jsonBruto);
                    if (jsonArray.length() > 0) {
                        jsonPayload = jsonArray.getJSONObject(0);
                        System.out.println("ℹ️ JSON ajustado: Removido array externo.");
                    } else {
                        throw new JSONException("Array JSON vazio.");
                    }
                } else {
                    // Se for um objeto JSON normal
                    jsonPayload = new JSONObject(jsonBruto);
                }
                
                // EXTRAI O FORM DATA ANINHADO
                JSONObject formData = jsonPayload.getJSONObject("formData");
                JSONObject payerData = formData.getJSONObject("payer"); 
                
                System.out.println("🧾 Dados de pagamento extraídos do 'formData': " + formData);

                // Busca valor total da venda
                BigDecimal amount = dao.retornaVendaValor();
                
                if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"Valor da transação inválido.\"}");
                    return;
                }

                int idVenda = dao.retornaVenda();
                String referenciaVenda = UUID.randomUUID().toString();
                dao.atualizarStatusVenda(idVenda, referenciaVenda);

                PaymentClient client = new PaymentClient();

                PaymentCreateRequest paymentCreateRequest = PaymentCreateRequest.builder()
                        .transactionAmount(amount) 
                        .token(formData.getString("token")) 
                        .description("Pagamento via cartão - Venda #" + idVenda)
                        .installments(formData.getInt("installments"))
                        // CORREÇÃO 1: Usando a chave correta "payment_method_id" (snake_case)
                        .paymentMethodId(formData.getString("payment_method_id")) 
                        // CORREÇÃO 2: Adicionando o issuer_id
                        .issuerId(formData.getString("issuer_id")) 
                        .payer(
                            PaymentPayerRequest.builder()
                                .email(payerData.getString("email"))
                                .identification(
                                    IdentificationRequest.builder()
                                        .type(payerData
                                                .getJSONObject("identification")
                                                .getString("type"))
                                        .number(payerData
                                                .getJSONObject("identification")
                                                .getString("number"))
                                        .build()
                                )
                                .build()
                        )
                        .externalReference(empresa + "_" + referenciaVenda)
                        .build();


                System.out.println("💳 Enviando requisição de pagamento ao Mercado Pago...");

                Payment payment = client.create(paymentCreateRequest);

                System.out.println("✅ Pagamento criado com sucesso!");
                System.out.println("Status: " + payment.getStatus());
                System.out.println("ID: " + payment.getId());

                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("id", payment.getId());
                jsonResponse.addProperty("status", payment.getStatus());
                jsonResponse.addProperty("status_detail", payment.getStatusDetail());
                jsonResponse.addProperty("transaction_amount", payment.getTransactionAmount());
                jsonResponse.addProperty("description", payment.getDescription());

                out.print(jsonResponse.toString());
            }

        } catch (MPApiException e) {
            System.err.println("❌ Erro na API do Mercado Pago:");
            System.err.println("Código do Status HTTP: " + e.getStatusCode()); 
            System.err.println("Mensagem da API: " + e.getApiResponse().getContent());
            System.out.println(getStackTraceAsString(e)); 
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Erro ao criar pagamento (API MP): " + e.getMessage() + "\"}");
        } catch (JSONException e) {
             System.err.println("❌ Erro ao analisar JSON: A requisição não enviou um JSON válido. Isso indica um erro no Flow 2.");
             if (jsonBruto != null) {
                 System.err.println("❌ JSON BRUTO RECEBIDO (Tamanho: " + jsonBruto.length() + "): [" + jsonBruto + "]");
             }
             System.out.println(getStackTraceAsString(e)); 
             response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
             out.print("{\"error\": \"Corpo da requisição inválido (Não é JSON) ou estrutura de dados inesperada.\"}");
        }
        catch (MPException e) {
             System.err.println("❌ Erro no SDK do Mercado Pago ou conexão: ");
             System.out.println(getStackTraceAsString(e)); 
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
             out.print("{\"error\": \"Erro no SDK do Mercado Pago.\"}");
        }
        catch (NamingException | ClassNotFoundException | SQLException e) {
             System.err.println("❌ Erro de Banco de Dados ou Configuração (DataSource/Driver): " + e.getMessage());
             System.out.println("----------------- STACK TRACE COMPLETO DO ERRO DE DB -----------------");
             System.out.println(getStackTraceAsString(e)); 
             System.err.println("----------------------------------------------------------------------");
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
             out.print("{\"error\": \"Erro interno de configuração de dados.\"}");
        } catch (Exception e) { 
             System.err.println("❌ Erro inesperado no Servlet: " + e.getMessage());
             System.out.println(getStackTraceAsString(e));
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
             out.print("{\"error\": \"Erro inesperado no servidor: " + e.getMessage() + "\"}");
        }
    }

    private String getNgrokTunnelUrl() {
        // Implementação mantida inalterada
        try {
            URL url = new URL("http://127.0.0.1:4040/api/tunnels");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            if (conn.getResponseCode() != 200) {
                return null;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            StringBuilder response = new StringBuilder();
            String output;
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
            // ignora erro se ngrok não estiver ativo
        }
        return null;
    }
}
