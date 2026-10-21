package dao;

import conexion.ConexionSQL;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

public class VentaDAO {

    public int registrar(int idCliente, int idSede, int idFuncion, List<String> butacas, 
                          Map<Integer, Integer> dulceria, String canal, String medioPago) throws Exception {

        Connection con = null;
        int idVentaGenerada = -1;

        try {
            con = ConexionSQL.getConexion();
            if (con == null) throw new SQLException("Error de conexión a la base de datos.");

            // 1. INICIAR TRANSACCIÓN ÚNICA
            con.setAutoCommit(false);

            // A. Obtener precio unitario real de la función desde la BD
            BigDecimal precioEntradaBD = BigDecimal.ZERO;
            String sqlPrecioFunc = "SELECT precio FROM Funcion WHERE idFuncion = ?";
            try (PreparedStatement psF = con.prepareStatement(sqlPrecioFunc)) {
                psF.setInt(1, idFuncion);
                try (ResultSet rsF = psF.executeQuery()) {
                    if (rsF.next()) {
                        precioEntradaBD = rsF.getBigDecimal("precio");
                    } else {
                        throw new Exception("Función no encontrada.");
                    }
                }
            }

            // B. Verificar y bloquear butacas libres
            String sqlCheckButaca = "SELECT COUNT(*) FROM Entrada WHERE idFuncion = ? AND butaca = ? AND estado = 'ACTIVA'";
            for (String b : butacas) {
                try (PreparedStatement psB = con.prepareStatement(sqlCheckButaca)) {
                    psB.setInt(1, idFuncion);
                    psB.setString(2, b);
                    try (ResultSet rsB = psB.executeQuery()) {
                        if (rsB.next() && rsB.getInt(1) > 0) {
                            throw new Exception("La butaca " + b + " ya fue vendida.");
                        }
                    }
                }
            }

            // C. Calcular total de entradas
            BigDecimal totalEntradas = precioEntradaBD.multiply(new BigDecimal(butacas.size()));

            // D. Calcular total de dulcería leyendo precios oficiales de Producto
            BigDecimal totalDulceria = BigDecimal.ZERO;
            String sqlPrecioProd = "SELECT precio FROM Producto WHERE idProducto = ? AND activo = 1";
            for (Map.Entry<Integer, Integer> item : dulceria.entrySet()) {
                int idProd = item.getKey();
                int cant = item.getValue();
                try (PreparedStatement psP = con.prepareStatement(sqlPrecioProd)) {
                    psP.setInt(1, idProd);
                    try (ResultSet rsP = psP.executeQuery()) {
                        if (rsP.next()) {
                            BigDecimal precioProdBD = rsP.getBigDecimal("precio");
                            totalDulceria = totalDulceria.add(precioProdBD.multiply(new BigDecimal(cant)));
                        } else {
                            throw new Exception("Producto no disponible.");
                        }
                    }
                }
            }

            BigDecimal totalVenta = totalEntradas.add(totalDulceria);

            // E. Insertar cabecera en Venta
            String sqlVenta = "INSERT INTO Venta (idCliente, idSede, canal, medioPago, total, estado) VALUES (?, ?, ?, ?, ?, 'PAGADA')";
            try (PreparedStatement psV = con.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS)) {
                psV.setInt(1, idCliente);
                psV.setInt(2, idSede);
                psV.setString(3, canal);
                psV.setString(4, medioPago);
                psV.setBigDecimal(5, totalVenta);
                psV.executeUpdate();

                try (ResultSet rsKeys = psV.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        idVentaGenerada = rsKeys.getInt(1);
                    } else {
                        throw new SQLException("No se pudo obtener el ID de venta.");
                    }
                }
            }

            // F. Insertar Entradas y descontar butacas
            String sqlInsertEntrada = "INSERT INTO Entrada (idCliente, idFuncion, butaca, precioPagado, idVenta, estado) VALUES (?, ?, ?, ?, ?, 'ACTIVA')";
            String sqlUpdateFuncion = "UPDATE Funcion SET butacasDisponibles = butacasDisponibles - 1 WHERE idFuncion = ? AND butacasDisponibles > 0";

            for (String b : butacas) {
                try (PreparedStatement psE = con.prepareStatement(sqlInsertEntrada)) {
                    psE.setInt(1, idCliente);
                    psE.setInt(2, idFuncion);
                    psE.setString(3, b);
                    psE.setBigDecimal(4, precioEntradaBD);
                    psE.setInt(5, idVentaGenerada);
                    psE.executeUpdate();
                }

                try (PreparedStatement psU = con.prepareStatement(sqlUpdateFuncion)) {
                    psU.setInt(1, idFuncion);
                    int filas = psU.executeUpdate();
                    if (filas == 0) {
                        throw new Exception("No hay butacas disponibles en la sala.");
                    }
                }
            }

            // G. Insertar DetalleVenta para dulcería
            String sqlDetalle = "INSERT INTO DetalleVenta (idVenta, idProducto, cantidad, precioUnit) VALUES (?, ?, ?, ?)";
            for (Map.Entry<Integer, Integer> item : dulceria.entrySet()) {
                int idProd = item.getKey();
                int cant = item.getValue();

                BigDecimal precioUnitario = BigDecimal.ZERO;
                try (PreparedStatement psP2 = con.prepareStatement(sqlPrecioProd)) {
                    psP2.setInt(1, idProd);
                    try (ResultSet rsP2 = psP2.executeQuery()) {
                        if (rsP2.next()) precioUnitario = rsP2.getBigDecimal("precio");
                    }
                }

                try (PreparedStatement psD = con.prepareStatement(sqlDetalle)) {
                    psD.setInt(1, idVentaGenerada);
                    psD.setInt(2, idProd);
                    psD.setInt(3, cant);
                    psD.setBigDecimal(4, precioUnitario);
                    psD.executeUpdate();
                }
            }

            // 2. CONFIRMAR TRANSACCIÓN
            con.commit();

        } catch (Exception e) {
            // ROLLBACK EN CASO DE ERROR O BUTACA DUPLICADA
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error en rollback: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    System.err.println("Error al cerrar conexión: " + ex.getMessage());
                }
            }
        }

        return idVentaGenerada;
    }
}