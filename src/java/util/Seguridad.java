/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 *
 * @author Luis
 */

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Seguridad {

    public static String sha256(String texto) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            byte[] hash = md.digest(
                texto.getBytes(StandardCharsets.UTF_8)
            );

            return String.format("%064x", new BigInteger(1, hash));

        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(
                "No se encuentra el algoritmo SHA-256", e
            );
        }
    }
}
