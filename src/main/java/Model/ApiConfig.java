package Model;

/**
 * Representa as configurações de acesso à API de Mensagens
 * (usando o WPPConnect como base).
 */
public class ApiConfig {

    private int id; // Mapeia para id_connection no banco
    // Renomeado para sessionName para refletir a coluna 'session_name' no DB
    private String sessionName; 
    private String accessToken; // Mapeia para access_token
    private String sessionStatus; // Mapeia para session_status
    private String numeroWhatsapp; // Mapeia para numero_whatsapp (Adicionado da sua imagem do DB)

    // Construtor
    public ApiConfig() {}

    // Construtor com parâmetros
    public ApiConfig(String sessionName, String accessToken) {
        this.sessionName = sessionName;
        this.accessToken = accessToken;
        this.sessionStatus = "DISCONNECTED"; // Status inicial
    }
    
    // --- Getters e Setters ---

    public int getId() {
        return id;
    }

    // Nota: O DB usa 'id_connection', então este é o setter para o ID
    public void setId(int id) {
        this.id = id;
    }

    // GETTER: Renomeado de getNomeBase() para getSessionName()
    public String getSessionName() {
        return sessionName;
    }

    // SETTER: Renomeado de setNomeBase() para setSessionName()
    public void setSessionName(String sessionName) {
        this.sessionName = sessionName;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getSessionStatus() {
        return sessionStatus;
    }

    public void setSessionStatus(String sessionStatus) {
        this.sessionStatus = sessionStatus;
    }
    
    // Getter e Setter para o novo campo numero_whatsapp
    public String getNumeroWhatsapp() {
        return numeroWhatsapp;
    }

    public void setNumeroWhatsapp(String numeroWhatsapp) {
        this.numeroWhatsapp = numeroWhatsapp;
    }
}