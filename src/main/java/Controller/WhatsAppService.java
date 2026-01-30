package Controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Serviço responsável por enviar mensagens ao servidor Node (WPPConnect).
 *
 * MUDANÇA CRÍTICA:
 * - A chave 'chatId' foi substituída por 'phone' no JSON payload,
 * pois o teste CURL confirmou que este é o formato funcional.
 * - Adicionado tratamento para garantir que o número é composto apenas por dígitos.
 */
public class WhatsAppService {

    // URL base do servidor Node (WPPConnect)
    private static final String BASE_URL = "http://localhost:21465/api/default";

    // Token de autenticação (Mantenha este token atualizado)
    private static final String ACCESS_TOKEN =
            "$2b$10$ixqIlWSBItVw2BDoEkuVs.xF0txGxnaXliCXN8yKXKQcnRJA4U.WC";

    /**
     * Envia uma mensagem de notificação de alteração de status.
     *
     * @param numero Número do cliente (ex: 5531991815107).
     * @param nome Nome do cliente.
     * @param idPedido ID do pedido.
     * @param novoStatus Novo status do pedido.
     */
    public static void enviarStatusPedidoTemplate(String numero, String nome, int idPedido, String novoStatus) {
        String mensagemAEnviar = "";
        try {
            // 1. Limpeza e Formatação do Número (Garantindo apenas dígitos)
            String numeroLimpo = numero.replaceAll("[^0-9]", "");

            if ("Pendente".equals(novoStatus)) {

                mensagemAEnviar = "👋 Olá *" + nome + "*, o seu pedido *#" + idPedido + "* foi registrado com sucesso e está *Pendente* de processamento. ⏳"
                        + "\n\nEstamos aguardando a confirmação do pagamento para dar continuidade. Assim que aprovado, enviaremos um novo aviso!";

            } else if ("Em Preparo".equals(novoStatus)) {

                mensagemAEnviar = "⚙️ Olá *" + nome + "*, ÓTIMA NOTÍCIA! Seu pedido *#" + idPedido + "* já está *Em Preparo*! Nossa equipe está trabalhando para embalar seus itens com cuidado. 📦"
                        + "\n\nVocê receberá uma nova notificação assim que ele for enviado para Entrega.";

            } else if ("Em Rota de Entrega".equals(novoStatus)) {

                mensagemAEnviar = "🚚 Olá *" + nome + "*, seu pedido *#" + idPedido + "* está **Em Rota de Entrega** e deve chegar em breve! 📦"
                        + "\n\n👉 *Gentileza, se possível, Compartilhar a sua localização aproximada via WhatsApp.* Obrigado!";

            } else if ("Entregue".equals(novoStatus)) {

                mensagemAEnviar = "🥳 Olá *" + nome + "*, seu pedido *#" + idPedido + "* foi **Entregue** com sucesso! ✅"
                        + "\n\nAgradecemos a sua compra! Esperamos que tenha gostado. Qualquer dúvida, estamos à disposição.";

            } else if ("Reprovado".equals(novoStatus)) {

                mensagemAEnviar = "❌ Olá *" + nome + "*, lamentamos informar que o seu pedido *#" + idPedido + "* foi *Reprovado*."
                        + "\n\nIsso geralmente ocorre devido a problemas com o pagamento. Por favor, entre em contato com nossa central para regularizar a situação ou refazer o pedido.";

            } else if ("Cancelado".equals(novoStatus)) {

                mensagemAEnviar = "🚫 Olá *" + nome + "*, confirmamos o **Cancelamento** do seu pedido *#" + idPedido + "*."
                        + "\n\nCaso o pagamento já tenha sido efetuado, nosso setor financeiro entrará em contato para o estorno. Se foi um engano, estamos aqui para ajudar!";

            } else {

                // Mensagem padrão para status não mapeados
                mensagemAEnviar = "👋 Olá *" + nome + "*, o status do seu pedido *#" + idPedido + "* foi atualizado para: *" + novoStatus + "* ✅";
            }

            // 2. Construção do JSON mantendo a chave "phone"
            String json = "{"
                    + "\"phone\":\"" + escapeJson(numeroLimpo) + "\","
                    + "\"message\":\"" + escapeJson(mensagemAEnviar) + "\""
                    + "}";

            String endpoint = BASE_URL + "/send-message";

            System.out.println("\n=== DEBUG ENVIO WPP ===");
            System.out.println("Telefone (limpo): " + numeroLimpo);
            System.out.println("JSON enviado: " + json);

            String resposta = enviarPost(endpoint, json);

            System.out.println("Resposta do servidor Node: " + resposta);

        } catch (Exception e) {
            System.err.println("Erro ao enviar mensagem ao WPPConnect:");
            e.printStackTrace();
        }
    }


    /**
     * Envia um POST genérico para o servidor Node (WPPConnect).
     */
    private static String enviarPost(String urlStr, String json) throws Exception {

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");

        // Configuração de Headers
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Authorization", "Bearer " + ACCESS_TOKEN);
        conn.setDoOutput(true);

        // Envia o JSON
        try (OutputStream os = conn.getOutputStream()) {
            os.write(json.getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        
        // Log do Status Code
        if (status >= 200 && status < 300) {
            System.out.println("Status HTTP: " + status + " (Sucesso)");
        } else {
            System.err.println("Status HTTP: " + status + " (Erro na Requisição)");
        }


        // Leitura da Resposta (seja sucesso ou erro)
        BufferedReader br;
        try {
            if (status >= 200 && status < 300) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            } else {
                // Tenta ler o corpo da resposta de erro
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }
        } catch (Exception e) {
            // Se o getErrorStream falhar
            return "Erro ao ler stream de resposta.";
        }
        

        StringBuilder sb = new StringBuilder();
        String linha;

        while ((linha = br.readLine()) != null) {
            sb.append(linha);
        }

        return sb.toString();
    }


    /**
     * Escapa caracteres especiais para que o JSON seja válido.
     */
    private static String escapeJson(String s) {
        if (s == null) return "";

        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}