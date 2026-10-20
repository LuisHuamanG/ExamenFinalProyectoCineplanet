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


import java.security.SecureRandom;
import java.util.Base64;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class ProteccionCSRF {

    private static final String ATRIBUTO_TOKEN = "tokenCSRF";
    private static final SecureRandom ALEATORIO = new SecureRandom();

    public static String obtenerToken(HttpServletRequest solicitud) {
        HttpSession sesion = solicitud.getSession();

        String token = (String) sesion.getAttribute(ATRIBUTO_TOKEN);

        if (token == null) {
            byte[] bytes = new byte[32];
            ALEATORIO.nextBytes(bytes);
            token = Base64.getUrlEncoder().withoutPadding()
                    .encodeToString(bytes);

            sesion.setAttribute(ATRIBUTO_TOKEN, token);
        }

        return token;
    }

    public static boolean validarToken(
            HttpServletRequest solicitud,
            String tokenRecibido) {

        if (tokenRecibido == null || tokenRecibido.isEmpty()) {
            return false;
        }

        HttpSession sesion = solicitud.getSession(false);

        if (sesion == null) {
            return false;
        }

        String tokenGuardado =
                (String) sesion.getAttribute(ATRIBUTO_TOKEN);

        if (tokenGuardado == null) {
            return false;
        }

        return java.security.MessageDigest.isEqual(
                tokenGuardado.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                tokenRecibido.getBytes(java.nio.charset.StandardCharsets.UTF_8)
        );
    }

    public static void renovarToken(HttpSession sesion) {
        byte[] bytes = new byte[32];
        ALEATORIO.nextBytes(bytes);

        String token = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(bytes);

        sesion.setAttribute(ATRIBUTO_TOKEN, token);
    }
}
