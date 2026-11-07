package com.ptit.garaman.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/** Bam mat khau bang PBKDF2-HMAC-SHA256, dinh dang: pbkdf2$soLanLap$salt(hex)$hash(hex). */
public final class PasswordUtil1 {
    private static final int ITERATIONS = 65536;
    private static final int KEY_BITS = 256;

    private PasswordUtil1() {
    }

    public static String hash(String password) {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return "pbkdf2$" + ITERATIONS + "$" + toHex(salt) + "$" + toHex(derive(password, salt, ITERATIONS));
    }

    public static boolean verify(String password, String stored) {
        if (password == null || stored == null) {
            return false;
        }
        String[] p = stored.split("\\$");
        if (p.length != 4 || !"pbkdf2".equals(p[0])) {
            return false;
        }
        try {
            byte[] expected = fromHex(p[3]);
            byte[] actual = derive(password, fromHex(p[2]), Integer.parseInt(p[1]));
            return MessageDigest.isEqual(expected, actual);
        } catch (RuntimeException e) {
            return false;
        }
    }

    private static byte[] derive(String password, byte[] salt, int iterations) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, KEY_BITS);
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException(e);
        }
    }

    private static String toHex(byte[] b) {
        StringBuilder sb = new StringBuilder();
        for (byte x : b) {
            sb.append(String.format("%02x", x));
        }
        return sb.toString();
    }

    private static byte[] fromHex(String s) {
        byte[] out = new byte[s.length() / 2];
        for (int i = 0; i < out.length; i++) {
            out[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16);
        }
        return out;
    }
}
