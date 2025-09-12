package Model;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    // Método que gera o hash da senha usando SHA-256
	public static String hashPassword(String password) {
	    if (password == null) {
	        throw new IllegalArgumentException("A senha não pode ser nula");
	    }

	    try {
	        MessageDigest md = MessageDigest.getInstance("SHA-256");
	        byte[] hash = md.digest(password.getBytes());

	        // Convertendo o hash para hexadecimal
	        StringBuilder hexString = new StringBuilder();
	        for (byte b : hash) {
	            String hex = Integer.toHexString(0xff & b);
	            if (hex.length() == 1) {
					hexString.append('0');
				}
	            hexString.append(hex);
	        }
	        return hexString.toString();

	    } catch (NoSuchAlgorithmException e) {
	        throw new RuntimeException(e);
	    }
	}
}