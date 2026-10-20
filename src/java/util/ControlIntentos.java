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

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public class ControlIntentos {

    private static final int MAX_INTENTOS = 3;
    private static final long TIEMPO_BLOQUEO = 5 * 60 * 1000L;

    private static final ConcurrentMap<String, EstadoIntentos> intentos =
            new ConcurrentHashMap<>();

    public static boolean estaBloqueado(String usuario) {

        EstadoIntentos estado = intentos.get(usuario);

        if (estado == null) {
            return false;
        }

        synchronized (estado) {
            if (estado.bloqueadoHasta > System.currentTimeMillis()) {
                return true;
            }

            if (estado.bloqueadoHasta != 0) {
                estado.intentosFallidos = 0;
                estado.bloqueadoHasta = 0;
            }

            return false;
        }
    }

    public static void registrarFallo(String usuario) {

        EstadoIntentos estado = intentos.computeIfAbsent(
                usuario, clave -> new EstadoIntentos());

        synchronized (estado) {
            if (estado.bloqueadoHasta > System.currentTimeMillis()) {
                return;
            }

            if (estado.bloqueadoHasta != 0) {
                estado.intentosFallidos = 0;
                estado.bloqueadoHasta = 0;
            }

            estado.intentosFallidos++;

            if (estado.intentosFallidos >= MAX_INTENTOS) {
                estado.bloqueadoHasta =
                        System.currentTimeMillis() + TIEMPO_BLOQUEO;
            }
        }
    }

    public static void registrarExito(String usuario) {
        intentos.remove(usuario);
    }

    private static class EstadoIntentos {
        private int intentosFallidos;
        private long bloqueadoHasta;
    }
}
