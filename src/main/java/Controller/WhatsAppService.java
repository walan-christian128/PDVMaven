package Controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Serviço responsável por enviar mensagens e gerenciar sessões
 * com o servidor Node (WPPConnect) usando credenciais e instância específicas.
 * O nome da instância e o Token de Acesso são passados em tempo de execução
 * (buscados do banco de dados).
 */
public class WhatsAppService {

    // VARIÁVEIS FIXAS REMOVIDAS: A URL base e o Token são OBRIGATÓRIOS NOS PARÂMETROS DOS MÉTODOS!

    // =========================================================================
    // 🔑 MÉTODOS PARA GERENCIAMENTO DE SESSÃO (Chamados pelo GerarQRCodeServlet)
    // =========================================================================

    /**
     * Inicia a sessão WPPConnect para uma instância específica (nome da base).
     * @param instanceName O nome da base de dados (Ex: "empresa_a").
     * @param accessToken O token de segurança específico para esta API.
     * @return String JSON com a resposta da API (deve conter o QR Code em Base64).
     */
    public static String iniciarSessao(String instanceName, String accessToken) {
        String endpoint = "http://localhost:21465/api/" + instanceName + "/start-session";
        
        System.out.println("DEBUG: Tentando iniciar sessão: " + endpoint);
        try {
            // Passamos o accessToken para o método de requisição
            return enviarPost(endpoint, "{}", "Início de Sessão", accessToken);
        } catch (Exception e) {
            System.err.println("Erro ao iniciar sessão WPPConnect: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Erro de conexão com a API: " + e.getMessage() + "\"}";
        }
    }

    /**
     * Consulta o status da sessão (Ex: CONNECTED, QRCODE, DISCONNECTED).
     */
    public static String obterStatusSessao(String instanceName, String accessToken) {
        String endpoint = "http://localhost:21465/api/" + instanceName + "/status";
        
        System.out.println("DEBUG: Tentando obter status: " + endpoint);
        try {
            return enviarGet(endpoint, "Consulta de Status", accessToken); 
        } catch (Exception e) {
            System.err.println("Erro ao obter status da sessão: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Erro de conexão com a API: " + e.getMessage() + "\"}";
        }
    }
    
    /**
     * Desconecta e encerra a sessão WPPConnect.
     */
    public static String desconectarSessao(String instanceName, String accessToken) {
        String endpoint = "http://localhost:21465/api/" + instanceName + "/close-session";
        
        System.out.println("DEBUG: Tentando desconectar sessão: " + endpoint);
        try {
            return enviarPost(endpoint, "{}", "Encerramento de Sessão", accessToken);
        } catch (Exception e) {
            System.err.println("Erro ao desconectar sessão WPPConnect: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Erro de conexão com a API: " + e.getMessage() + "\"}";
        }
    }

    // =========================================================================
    // 📦 MÉTODO ORIGINAL PARA ENVIO DE MENSAGENS (Adaptado)
    // =========================================================================
    
    /**
     * Envia uma mensagem de notificação de alteração de status.
     *
     * @param instanceName O nome da base de dados (que é a instância da API).
     * @param accessToken O token de segurança específico para esta API.
     * @param numero Número do cliente (ex: 5531991815107).
     * @param nome Nome do cliente.
     * @param idPedido ID do pedido.
     * @param novoStatus Novo status do pedido.
     */
    public static void enviarStatusPedidoTemplate(String instanceName, String accessToken, String numero, String nome, int idPedido, String novoStatus) {
         String mensagemAEnviar = ""; 
        try {
            String numeroLimpo = numero.replaceAll("[^0-9]", "");
            
            // 3. Lógica Condicional para definir a mensagem (mantida do seu código original)
            if ("Pendente".equals(novoStatus)) {
                
                mensagemAEnviar = "👋 Olá " + nome +
                    ", o seu pedido #" + idPedido + " foi registrado com sucesso e está *Pendente* de processamento. ⏳" +
                    "\n\nEstamos aguardando a confirmação do pagamento para dar continuidade. Assim que aprovado, enviaremos um novo aviso!";
                
            } else if ("Em Preparo".equals(novoStatus)) {
                
                mensagemAEnviar = "⚙️ Olá " + nome +
                    ", ÓTIMA NOTÍCIA! Seu pedido #" + idPedido +
                    " já está *Em Preparo*! Nossa equipe está trabalhando para embalar seus itens com cuidado. 📦" +
                    "\n\nVocê receberá uma nova notificação assim que ele for enviado para Entrega.";
                
            } else if ("Em Rota de Entrega".equals(novoStatus)) {
                
                mensagemAEnviar = "🚚 Olá " + nome +
                    ", seu pedido #" + idPedido +
                    " está **Em Rota de Entrega** e deve chegar em breve! 📦" +
                    "\n\n👉 Gentileza, se possível, Compartilhar a sua localização aproximada via WhatsApp. Obrigado!";
                
            } else if ("Entregue".equals(novoStatus)) {
                
                mensagemAEnviar = "🥳 Olá " + nome +
                    ", seu pedido #" + idPedido +
                    " foi **Entregue** com sucesso! ✅" +
                    "\n\nAgradecemos a sua compra! Esperamos que tenha gostado. Qualquer dúvida, estamos à disposição.";
                
            } else if ("Reprovado".equals(novoStatus)) {
                
                mensagemAEnviar = "❌ Olá " + nome +
                    ", lamentamos informar que o seu pedido #" + idPedido +
                    " foi *Reprovado*." +
                    "\n\nIsso geralmente ocorre devido a problemas com o pagamento. Por favor, entre em contato com nossa central para regularizar a situação ou refazer o pedido.";
                
            } else {
                
                // Mensagem padrão ou para status não mapeados
                mensagemAEnviar = "👋 Olá " + nome +
                    ", o status do seu pedido #" + idPedido +
                    " foi atualizado para: " + novoStatus + " ✅";
            }
            
            // 4. Montagem do JSON
            String json = "{"
                    + "\"phone\":\"" + escapeJson(numeroLimpo) + "\","
                    + "\"message\":\"" + escapeJson(mensagemAEnviar) + "\""
                    + "}";

            // Endpoint AGORA É DINÂMICO
            String endpoint = "http://localhost:21465/api/" + instanceName + "/send-message";

            System.out.println("\n=== DEBUG ENVIO WPP ===");
            System.out.println("Instância/Base: " + instanceName);
            System.out.println("Telefone (limpo): " + numeroLimpo);
            System.out.println("JSON enviado: " + json);

            // Chamada do método de POST DINÂMICO
            String resposta = enviarPost(endpoint, json, "Envio de Mensagem", accessToken);

            System.out.println("Resposta do servidor Node: " + resposta);

        } catch (Exception e) {
            System.err.println("Erro ao enviar mensagem ao WPPConnect:");
            e.printStackTrace();
        }
    }


    // =========================================================================
    // ⚙️ MÉTODOS DE REQUISIÇÃO GENÉRICOS (Ajustados para receber o Token)
    // =========================================================================

    /**
     * Envia um POST genérico para o servidor Node (WPPConnect).
     */
    private static String enviarPost(String urlStr, String json, String logAction, String accessToken) throws Exception {

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");

        // Configuração de Headers
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken); // USA O TOKEN PASSADO
        conn.setDoOutput(true);
        conn.setConnectTimeout(5000); // 5 segundos
        conn.setReadTimeout(10000); // 10 segundos

        // Envia o JSON
        try (OutputStream os = conn.getOutputStream()) {
            os.write(json.getBytes(StandardCharsets.UTF_8));
        }

        return lerResposta(conn, logAction);
    }
    
    /**
     * Envia um GET genérico para o servidor Node (WPPConnect).
     */
    private static String enviarGet(String urlStr, String logAction, String accessToken) throws Exception {

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        // Configuração de Headers
        conn.setRequestProperty("Authorization", "Bearer " + accessToken); // USA O TOKEN PASSADO
        conn.setConnectTimeout(5000); 
        conn.setReadTimeout(10000);

        return lerResposta(conn, logAction);
    }
    
    /**
     * Função auxiliar para ler a resposta de qualquer requisição.
     */
    private static String lerResposta(HttpURLConnection conn, String logAction) throws Exception {
        
        int status = conn.getResponseCode();
        
        // Log do Status Code
        if (status >= 200 && status < 300) {
            System.out.println("Status HTTP (" + logAction + "): " + status + " (Sucesso)");
        } else {
            System.err.println("Status HTTP (" + logAction + "): " + status + " (Erro na Requisição)");
        }

        // Leitura da Resposta (seja sucesso ou erro)
        BufferedReader br;
        try {
            // Usa getInputStream para 2xx, e getErrorStream para outros códigos
            br = new BufferedReader(new InputStreamReader(
                (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream(), 
                StandardCharsets.UTF_8
            ));
        } catch (Exception e) {
            return "{\"success\": false, \"message\": \"Erro ao ler stream de resposta (" + status + ").\"}";
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