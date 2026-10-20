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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SesionSegura {

    public static HttpSession iniciarSesion(
            HttpServletRequest solicitud) {

        HttpSession sesionAnterior = solicitud.getSession(false);

        if (sesionAnterior != null) {
            sesionAnterior.invalidate();
        }

        HttpSession sesionNueva = solicitud.getSession(true);

        sesionNueva.setMaxInactiveInterval(15 * 60);

        return sesionNueva;
    }

    public static void cerrarSesion(HttpServletRequest solicitud) {

        HttpSession sesion = solicitud.getSession(false);

        if (sesion != null) {
            sesion.invalidate();
        }
    }
}
