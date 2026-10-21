<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, conexion.ConexionSQL"%>
<%
    String idVentaParam = request.getParameter("id");
    int idVenta = 0;
    if (idVentaParam != null && !idVentaParam.trim().isEmpty()) {
        try { 
            idVenta = Integer.parseInt(idVentaParam.trim()); 
        } catch(Exception ignored) {}
    }
    
    // Si no viene por parámetro, obtener la última venta realizada
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    double total = 0.0;
    String fecha = "";
    String medioPago = "";
    String sede = "Cineplanet Alcázar";
    
    try {
        con = ConexionSQL.getConexion();
        if (con != null) {
            String sql;
            if (idVenta > 0) {
                sql = "SELECT v.idVenta, v.total, v.fechaVenta, v.medioPago, s.nombre AS sede " +
                      "FROM Venta v JOIN Sede s ON s.idSede = v.idSede WHERE v.idVenta = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, idVenta);
            } else {
                sql = "SELECT TOP 1 v.idVenta, v.total, v.fechaVenta, v.medioPago, s.nombre AS sede " +
                      "FROM Venta v JOIN Sede s ON s.idSede = v.idSede ORDER BY v.idVenta DESC";
                ps = con.prepareStatement(sql);
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                idVenta = rs.getInt("idVenta");
                total = rs.getDouble("total");
                fecha = rs.getString("fechaVenta");
                medioPago = rs.getString("medioPago");
                sede = rs.getString("sede");
            }
        }
    } catch(Exception ignored) {
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
        if (ps != null) try { ps.close(); } catch(Exception ignored) {}
        ConexionSQL.closeConexion(con);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Comprobante de Compra | Cineplanet</title>
    <style>
        body { font-family: Arial, sans-serif; background: #0b192c; padding: 30px 15px; margin: 0; }
        .ticket { max-width: 480px; margin: auto; background: #ffffff; padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); border-top: 6px solid #2e7d32; }
        .cabecera { text-align: center; border-bottom: 2px dashed #e0e0e0; padding-bottom: 20px; margin-bottom: 20px; }
        .cabecera h2 { margin: 0 0 5px 0; color: #1e3e62; }
        .cabecera p { margin: 0 0 10px 0; color: #777; font-size: 14px; }
        .cabecera h3 { margin: 0; color: #ff6500; }
        .fila { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 15px; }
        .fila span { color: #555; }
        .fila strong { color: #222; }
        .total { font-size: 20px; font-weight: bold; color: #2e7d32; border-top: 2px dashed #e0e0e0; padding-top: 15px; margin-top: 20px; }
        .btn-volver { display: block; text-align: center; margin-top: 25px; background: #1e3e62; color: #fff; text-decoration: none; padding: 12px; border-radius: 6px; font-weight: bold; }
        .btn-volver:hover { background: #0b192c; }
    </style>
</head>
<body>

<div class="ticket">
    <div class="cabecera">
        <h2>CINEPLANET</h2>
        <p>Comprobante Electrónico de Compra</p>
        <h3>Compra #<%= idVenta %></h3>
    </div>

    <div class="fila"><span>Sede:</span><strong><%= sede %></strong></div>
    <div class="fila"><span>Fecha de Venta:</span><span><%= fecha %></span></div>
    <div class="fila"><span>Medio de Pago:</span><strong><%= medioPago %></strong></div>
    <div class="fila"><span>Estado:</span><strong style="color:#2e7d32;">PAGADA</strong></div>

    <div class="fila total">
        <span>TOTAL COBRADO:</span>
        <span>S/ <%= String.format(java.util.Locale.US, "%.2f", total) %></span>
    </div>

    <a href="${pageContext.request.contextPath}/cliente/index.jsp" class="btn-volver">Volver a Mi Cuenta</a>
</div>

</body>
</html>