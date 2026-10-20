/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

/**
 *
 * @author Luis
 */

import conexion.ConexionSQL;
import modelo.UsuarioSesion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public UsuarioSesion autenticar(
            String usuario,
            String hash) throws SQLException {

        String sql = "SELECT idUsuario, usuario, nombre, rol "
                   + "FROM Usuario "
                   + "WHERE usuario = ? AND clave = ?";

        try (Connection con = ConexionSQL.getConexion()) {

            if (con == null) {
                throw new SQLException("Error de conexión");
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, usuario);
                ps.setString(2, hash);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        return new UsuarioSesion(
                                rs.getInt("idUsuario"),
                                rs.getString("usuario"),
                                rs.getString("nombre"),
                                rs.getString("rol")
                        );
                    }
                }
            }
        }

        return null;
    }
}
