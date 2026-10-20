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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AuditoriaDAO {

    public boolean registrar(
            String usuario,
            String evento,
            String detalle,
            String ip) throws SQLException {

        String sql = "INSERT INTO Auditoria "
                   + "(usuario, evento, detalle, ip) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection con = ConexionSQL.getConexion()) {

            if (con == null) {
                throw new SQLException("No se pudo conectar con la base de datos.");
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, usuario);
                ps.setString(2, evento);
                ps.setString(3, detalle);
                ps.setString(4, ip);

                return ps.executeUpdate() == 1;
            }
        }
    }
}

