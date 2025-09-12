package DAO;

import java.time.Instant;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class TokenServiceDAO {
    private static final String SECRET_KEY = "MinhaChaveSecreta";
    private static final long TEMPO_EXPIRACAO = 3600; // 1 hora

    public static String gerarToken() {
        long timestamp = Instant.now().getEpochSecond(); // Pega o tempo atual
        String data = timestamp + ":" + SECRET_KEY; // Junta o tempo com a chave secreta

        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(SECRET_KEY.getBytes(), "HmacSHA256"));
            byte[] hash = mac.doFinal(data.getBytes());
            String token = Base64.getUrlEncoder().withoutPadding().encodeToString(hash) + "." + timestamp;

            System.out.println("Token gerado: " + token);  // Print para depuração

            return token;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao gerar token", e);
        }
    }


    public static boolean validarToken(String tokenRecebido) {
        String[] partes = tokenRecebido.split("\\.");
        if (partes.length != 2) {
			return false;
		}

        try {
            long timestampRecebido = Long.parseLong(partes[1]);
            long agora = Instant.now().getEpochSecond();
            long diferenca = agora - timestampRecebido;



            return diferenca <= TEMPO_EXPIRACAO;
        } catch (NumberFormatException e) {
            return false;
        }
    }





}
