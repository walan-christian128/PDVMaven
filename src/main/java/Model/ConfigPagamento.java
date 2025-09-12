package Model;

public class ConfigPagamento {

    private Integer id;
    private Integer empresaId;
    private String gateway;
    private String chavePix;
    private String clientId;
    private String clientSecret;
    private String publicKey; // Corrigido para camelCase, mas o getter é o principal
    private String accessToken;

    // Construtor padrão
    public ConfigPagamento() {
    }

    // Construtor completo (sem ID - usado para INSERT)
    public ConfigPagamento(Integer empresaId, String gateway, String chavePix,
                           String clientId, String clientSecret, String accessToken, String publicKey) {
        this.empresaId = empresaId;
        this.gateway = gateway;
        this.chavePix = chavePix;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.accessToken = accessToken;
        this.publicKey = publicKey;
    }

    // Construtor completo (com ID - usado para UPDATE ou busca)
    public ConfigPagamento(Integer id, Integer empresaId, String gateway, String chavePix,
                           String clientId, String clientSecret, String accessToken,String publicKey) {
        this.id = id;
        this.empresaId = empresaId;
        this.gateway = gateway;
        this.chavePix = chavePix;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.accessToken = accessToken;
        this.publicKey = publicKey;
    }

    // Getters e Setters
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getEmpresaId() {
        return empresaId;
    }
    public void setEmpresaId(Integer empresaId) {
        this.empresaId = empresaId;
    }

    public String getGateway() {
        return gateway;
    }
    public void setGateway(String gateway) {
        this.gateway = gateway;
    }

    public String getChavePix() {
        return chavePix;
    }
    public void setChavePix(String chavePix) {
        this.chavePix = chavePix;
    }

    public String getClientId() {
        return clientId;
    }
    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public String getClientSecret() {
        return clientSecret;
    }
    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }

    // 💡 Método Corrigido: `getPublicKey()`
    public String getPublicKey() {
		return publicKey;
	}

	public void setPublicKey(String publicKey) {
		this.publicKey = publicKey;
	}

    public String getAccessToken() {
        return accessToken;
    }
    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    // Para debug e logs
    @Override
    public String toString() {
        return "ConfigPagamento{" +
                "id=" + id +
                ", empresaId=" + empresaId +
                ", gateway='" + gateway + '\'' +
                ", chavePix='" + chavePix + '\'' +
                ", clientId='" + clientId + '\'' +
                ", clientSecret='" + (clientSecret != null ? "***" : null) + '\'' +
                ", accessToken='" + (accessToken != null ? "***" : null) + '\'' +
                ", publicKey='" + publicKey + '\'' +
                '}';
    }
}