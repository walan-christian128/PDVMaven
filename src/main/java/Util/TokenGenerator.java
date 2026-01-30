package Util;

public class TokenGenerator {

    /**
     * IMPORTANTE: Para o WPPConnect aceitar as requisições, 
     * o token deve ser IGUAL ao 'secretKey' definido no config.js do Node.
     */
    public static String generateSecureToken() {
        // Retorne exatamente a string que está no seu config.js
        return "THISISMYSECURETOKEN";
    }
    
    public static void main(String[] args) {
        System.out.println("Token a ser usado: " + generateSecureToken());
    }
}