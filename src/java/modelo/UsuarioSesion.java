/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modelo;

/**
 *
 * @author Luis
 */

public class UsuarioSesion {

    private int id;
    private String identificador;
    private String nombre;
    private String rol;

    public UsuarioSesion(
            int id,
            String identificador,
            String nombre,
            String rol) {

        this.id = id;
        this.identificador = identificador;
        this.nombre = nombre;
        this.rol = rol;
    }

    public int getId() {
        return id;
    }

    public String getIdentificador() {
        return identificador;
    }

    public String getNombre() {
        return nombre;
    }

    public String getRol() {
        return rol;
    }
}
