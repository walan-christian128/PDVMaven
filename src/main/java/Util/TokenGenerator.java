package Util; // Crie um novo pacote chamado 'Util'

import java.security.SecureRandom;
import java.util.Base64;

public class TokenGenerator {

    /**
     * Gera um token seguro de 32 bytes (256 bits) codificado em Base64.
     * Este token é robusto o suficiente para ser usado como ACCESS_TOKEN da API.
     * @return String contendo o token de acesso.
     */
    public static String generateSecureToken() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] tokenBytes = new byte[32]; // 32 bytes = 256 bits de segurança
        secureRandom.nextBytes(tokenBytes);
        
        // Codifica os bytes para uma string Base64 segura para URL/JSON
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }
    
    // Você pode testar no método main:
    public static void main(String[] args) {
        System.out.println("Token Gerado: " + generateSecureToken());
    }
}