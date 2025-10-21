package Controller;

import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.payment.PaymentClient;
import com.mercadopago.client.payment.PaymentCreateRequest;
import com.mercadopago.client.payment.PaymentPayerRequest;
import com.mercadopago.client.common.IdentificationRequest;
import com.mercadopago.exceptions.MPApiException;
import com.mercadopago.exceptions.MPException;
import com.mercadopago.resources.payment.Payment;
import com.mercadopago.core.MPRequestOptions;
import com.google.gson.JsonObject;
import DAO.ConfigPagamentoDAO;
import DAO.VendasDAO;
import Model.ConfigPagamento;
import Model.Vendas; // Importar o modelo Vendas
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter; 
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.UUID;
import java.util.Collections;
import javax.naming.NamingException;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

@SuppressWarnings("serial")
@WebServlet("/criaPagamentoCartaoServlet")
public class CriaPagamentoCartaoServlet extends HttpServlet {
    
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

        if (empresa == null || empresa.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Nome da empresa ausente na sessão.\"}");
            return;
        }

        String idEmpresaParam = request.getParameter("idEmpresa");
        int idEmpresa = 0;
        String jsonBruto = null; 
        ConfigPagamento config = null; 

        try {
            ConfigPagamentoDAO dbManager = new ConfigPagamentoDAO(empresa);
            VendasDAO dao = new VendasDAO(empresa);

            if (idEmpresaParam != null && !idEmpresaParam.isEmpty()) {
                // FLUXO 1: INICIALIZAÇÃO (FRONT QUER PUBLIC KEY E AMOUNT)
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
                
                config = dbManager.getConfiguracaoMP(idEmpresa);
                
                if (config == null || config.getPublicKey() == null || config.getPublicKey().isEmpty()) {
                    System.err.println("❌ Falha de Dados (401): Chave pública ou config MP não encontrada para ID: " + idEmpresa);
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
                    out.print("{\"error\": \"Chave pública não encontrada para a empresa. Verifique a configuração.\"}");
                    return;
                }
                
                String publicKey = config.getPublicKey();
                
                session.setAttribute("configPagamento", config);

                BigDecimal amount = dao.retornaVendaValor();
                
                String publicKeyDisplay = publicKey.length() > 4 ? "..." + publicKey.substring(publicKey.length() - 4) : publicKey;
                System.out.println("✅ Public Key obtida. Final: " + publicKeyDisplay);
                
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
                System.out.println("✅ Dados de inicialização enviados ao front.");
                
            } else {
                // FLUXO 2: SUBMISSÃO DE PAGAMENTO (FRONT ENVIA O JSON DO BRICK)
                
                Object idEmpresaObj = session.getAttribute("idEmpresa");
                Object configObj = session.getAttribute("configPagamento");
                
                if (idEmpresaObj == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"ID da empresa ausente na sessão. Recarregue a página.\"}");
                    return;
                }
                idEmpresa = (int) idEmpresaObj;
                
                if (configObj instanceof ConfigPagamento) {
                    config = (ConfigPagamento) configObj;
                } else {
                    // Se não estiver na sessão, busca no DB usando o ID da empresa (se necessário)
                    config = dbManager.getConfiguracaoMP(idEmpresa); 
                }

                if (config == null || config.getAccessToken() == null || config.getAccessToken().isEmpty()) {
                    System.err.println("❌ Token de acesso ausente ou vazio no DB.");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print("{\"error\": \"Token de acesso (Access Token) não encontrado para a empresa.\"}");
                    return;
                }

                String accessToken = config.getAccessToken(); 
                MercadoPagoConfig.setAccessToken(accessToken); 

                // RECUPERA o CORPO JSON
                StringBuilder jb = new StringBuilder();
                try (BufferedReader reader = request.getReader()) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        jb.append(line);
                    }
                }
                
                jsonBruto = jb.toString();
                
                JSONObject jsonPayload;
                if (jsonBruto.trim().startsWith("[")) {
                    JSONArray jsonArray = new JSONArray(jsonBruto);
                    if (jsonArray.length() > 0) {
                        jsonPayload = jsonArray.getJSONObject(0);
                    } else {
                        throw new JSONException("Array JSON vazio.");
                    }
                } else {
                    jsonPayload = new JSONObject(jsonBruto);
                }
                
                // CORREÇÃO DO JSON ANINHADO:
                JSONObject outerFormData = jsonPayload.getJSONObject("formData");
                JSONObject innerFormData = outerFormData.getJSONObject("formData"); 
                JSONObject payerData = innerFormData.getJSONObject("payer");
                
                BigDecimal amount = dao.retornaVendaValor();
                
                if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"Valor da transação inválido.\"}");
                    return;
                }

                // Lógica de Vendas Unificada
                int idVenda = dao.retornaVenda();
                String referenciaVenda = UUID.randomUUID().toString();
                String idempotencyKey = UUID.randomUUID().toString(); 
                
                // 1. Cria e configura o objeto Vendas (Status PENDENTE)
                Vendas vendaParaAtualizar = new Vendas(); // Assumindo que você tem o modelo Vendas importado
                // Defina apenas os campos necessários para a atualização de status/referência
                vendaParaAtualizar.setExternalReference(referenciaVenda);
                vendaParaAtualizar.setPgTotalOnline(amount);
                vendaParaAtualizar.setSetStatusVenda("PENDENTE"); 

                // 2. Atualiza o banco de dados
                boolean atualizado = dao.atualizarVendaOnline(idVenda, vendaParaAtualizar); // Adapte o nome do método DAO
                // Seu método original: dao.atualizarStatusVenda(idVenda, referenciaVenda);

                if (atualizado) {
                    System.out.println("Venda " + idVenda + " (Cartão) atualizada com externalReference " + referenciaVenda + " e Status PENDENTE.");
                } else {
                    System.err.println("Falha ao atualizar a venda " + idVenda + " (Cartão). Verifique se ela existe.");
                }

                // LOGS DE DEBUG ADICIONADOS AQUI
                String payerEmail = payerData.getString("email");
                String cardToken = innerFormData.getString("token");
                String tokenDisplay = cardToken.length() > 10 ? cardToken.substring(0, 4) + "... (Token)" : cardToken + " (Token)";
                
                System.out.println("DEBUG MP PAYER EMAIL: " + payerEmail);
                System.out.println("DEBUG MP CARD TOKEN: " + tokenDisplay);
                System.out.println("DEBUG MP AMOUNT: " + amount);
                // ------------------------------------

                PaymentClient client = new PaymentClient();

                PaymentCreateRequest paymentCreateRequest = PaymentCreateRequest.builder()
                        .transactionAmount(amount) 
                        .token(cardToken)
                        .description("Pagamento via cartão - Venda #" + idVenda)
                        .installments(innerFormData.getInt("installments"))
                        .paymentMethodId(innerFormData.getString("payment_method_id")) 
                        .issuerId(innerFormData.getString("issuer_id")) 
                        .payer(
                            PaymentPayerRequest.builder()
                                .email(payerEmail)
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

                System.out.println("💳 Enviando requisição de pagamento ao Mercado Pago com Idempotency Key: " + idempotencyKey);
                
                // CORREÇÃO FINAL: Usando MPRequestOptions
                MPRequestOptions requestOptions = MPRequestOptions.builder()
                    .customHeaders(Collections.singletonMap("X-Idempotency-Key", idempotencyKey))
                    .build();

                Payment payment = client.create(paymentCreateRequest, requestOptions); 
                // Fim da Correção

                System.out.println("✅ Pagamento criado com sucesso!");
                System.out.println("Status: " + payment.getStatus());

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
            String mpErrorContent = e.getApiResponse() != null ? e.getApiResponse().getContent() : "Conteúdo de erro indisponível.";
            System.err.println("Mensagem da API: " + mpErrorContent); 
            System.out.println(getStackTraceAsString(e)); 
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Erro ao criar pagamento (API MP): " + e.getMessage() + "\", \"mp_detail\": " + JSONObject.stringToValue(mpErrorContent) + "}");
        } catch (JSONException e) {
             System.err.println("❌ Erro ao analisar JSON: A requisição não enviou um JSON válido.");
             if (jsonBruto != null) {
                 System.err.println("❌ JSON BRUTO RECEBIDO: [" + jsonBruto + "]");
             }
             System.out.println(getStackTraceAsString(e)); 
             response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
             out.print("{\"error\": \"Corpo da requisição inválido.\"}");
        }
        catch (MPException e) {
             System.err.println("❌ Erro no SDK do Mercado Pago ou conexão: ");
             System.out.println(getStackTraceAsString(e)); 
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
             out.print("{\"error\": \"Erro no SDK do Mercado Pago.\"}");
        }
        catch (NamingException | ClassNotFoundException | SQLException e) {
             System.err.println("❌ Erro de Banco de Dados ou Configuração: " + e.getMessage());
             System.out.println(getStackTraceAsString(e)); 
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
             out.print("{\"error\": \"Erro interno de configuração de dados.\"}");
        } catch (Exception e) { 
             System.err.println("❌ Erro inesperado no Servlet: " + e.getMessage());
             System.out.println(getStackTraceAsString(e));
             response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
             out.print("{\"error\": \"Erro inesperado no servidor: " + e.getMessage() + "\"}");
        }
    }
}