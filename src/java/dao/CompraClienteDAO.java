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
import modelo.CompraCliente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CompraClienteDAO {

    public List<CompraCliente> listarPorCliente(
            int idCliente) throws SQLException {

        List<CompraCliente> compras = new ArrayList<>();

        String sql = "SELECT v.idVenta, v.fechaVenta, s.nombre AS sede, "
                   + "v.canal, v.medioPago, v.total, v.estado "
                   + "FROM Venta v "
                   + "INNER JOIN Sede s ON v.idSede = s.idSede "
                   + "WHERE v.idCliente = ? "
                   + "ORDER BY v.fechaVenta DESC";

        try (Connection con = ConexionSQL.getConexion()) {

            if (con == null) {
                throw new SQLException("No se pudo conectar con la base de datos.");
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idCliente);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        CompraCliente compra = new CompraCliente(
                                rs.getInt("idVenta"),
                                rs.getTimestamp("fechaVenta"),
                                rs.getString("sede"),
                                rs.getString("canal"),
                                rs.getString("medioPago"),
                                rs.getBigDecimal("total"),
                                rs.getString("estado")
                        );

                        compras.add(compra);
                    }
                }
            }
        }

        return compras;
    }
}
