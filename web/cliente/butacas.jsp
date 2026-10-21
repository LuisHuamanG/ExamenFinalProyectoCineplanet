<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.util.Set, java.util.HashSet, conexion.ConexionSQL"%>
<%
    int idFuncion = 1;
    String idFParam = request.getParameter("idFuncion");
    if (idFParam != null && !idFParam.trim().isEmpty()) {
        try { 
            idFuncion = Integer.parseInt(idFParam.trim()); 
        } catch(Exception ignored) {}
    }
    
    // Obtener las butacas activas vendidas sin usar try-with-resources
    Set<String> ocupadas = new HashSet<String>();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = ConexionSQL.getConexion();
        if (con != null) {
            String sql = "SELECT butaca FROM Entrada WHERE idFuncion = ? AND estado = 'ACTIVA'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, idFuncion);
            rs = ps.executeQuery();
            while (rs.next()) {
                ocupadas.add(rs.getString("butaca").trim().toUpperCase());
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
    <title>Selección de Butacas | Cineplanet</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #0b192c; color: #333; margin: 0; padding: 30px 10px; }
        .contenedor { max-width: 820px; margin: auto; background: #ffffff; padding: 30px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.25); }
        h2 { text-align: center; color: #1e3e62; margin-top: 0; }
        p.subtitulo { text-align: center; color: #666; margin-bottom: 25px; }
        .pantalla { background: linear-gradient(to bottom, #1e3e62, #0b192c); color: #fff; text-align: center; padding: 12px; border-radius: 8px; font-weight: bold; letter-spacing: 4px; margin: 0 auto 35px auto; max-width: 600px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
        .sala { display: flex; flex-direction: column; align-items: center; gap: 8px; }
        .fila { display: flex; align-items: center; gap: 6px; }
        .fila-letra { width: 25px; font-weight: bold; text-align: center; color: #1e3e62; }
        .butaca { width: 38px; height: 36px; display: inline-flex; justify-content: center; align-items: center; border-radius: 6px; font-size: 11px; font-weight: bold; cursor: pointer; border: 1.5px solid #2e7d32; background: #e8f5e9; color: #1b5e20; user-select: none; transition: 0.15s ease-in-out; }
        .butaca:hover { background: #c8e6c9; }
        .butaca.ocupada { background: #e0e0e0; color: #9e9e9e; border-color: #bdbdbd; cursor: not-allowed; }
        .leyenda { display: flex; justify-content: center; gap: 25px; margin: 30px 0 20px 0; font-size: 14px; }
        .cuadro { width: 18px; height: 18px; display: inline-block; vertical-align: middle; margin-right: 6px; border-radius: 4px; }
        .btn-continuar { background: #ff6500; color: #ffffff; border: none; padding: 14px 20px; font-size: 16px; border-radius: 8px; cursor: pointer; width: 100%; font-weight: bold; }
        .btn-continuar:hover { background: #e65100; }
    </style>
</head>
<body>

<div class="contenedor">
    <h2>Selección de Butacas</h2>
    <p class="subtitulo">Función #<%= idFuncion %> · Selecciona tus asientos (Máximo 10)</p>
    
    <div class="pantalla">PANTALLA</div>

    <form action="${pageContext.request.contextPath}/cliente/CarritoServlet" method="post">
        <input type="hidden" name="tokenCSRF" value="<%= util.ProteccionCSRF.obtenerToken(request) %>">
        <input type="hidden" name="idFuncion" value="<%= idFuncion %>">
        <input type="hidden" name="idSede" value="1">

        <div class="sala">
            <% 
                char[] filas = {'A','B','C','D','E','F','G','H','I','J'};
                for (int i = 0; i < filas.length; i++) {
                    char f = filas[i];
            %>
                <div class="fila">
                    <span class="fila-letra"><%= f %></span>
                    <% for (int c = 1; c <= 12; c++) { 
                        String cod = "" + f + c;
                        boolean isOcupada = ocupadas.contains(cod);
                    %>
                        <% if (isOcupada) { %>
                            <div class="butaca ocupada" title="Butaca ocupada"><%= cod %></div>
                        <% } else { %>
                            <label class="butaca" id="lbl-<%= cod %>">
                                <input type="checkbox" name="butacas" value="<%= cod %>" style="display:none;" 
                                       onchange="actualizarSeleccion(this, '<%= cod %>')">
                                <%= cod %>
                            </label>
                        <% } %>
                    <% } %>
                </div>
            <% } %>
        </div>

        <div class="leyenda">
            <div><span class="cuadro" style="background:#e8f5e9; border:1.5px solid #2e7d32;"></span> Disponible</div>
            <div><span class="cuadro" style="background:#ffe082; border:1.5px solid #ff8f00;"></span> Seleccionada</div>
            <div><span class="cuadro" style="background:#e0e0e0; border:1.5px solid #bdbdbd;"></span> Ocupada</div>
        </div>

        <button type="submit" class="btn-continuar">Continuar al Carrito de Compras</button>
    </form>
</div>

<script>
    function actualizarSeleccion(chk, cod) {
        var lbl = document.getElementById('lbl-' + cod);
        if (chk.checked) {
            lbl.style.background = '#ffe082';
            lbl.style.borderColor = '#ff8f00';
            lbl.style.color = '#e65100';
        } else {
            lbl.style.background = '#e8f5e9';
            lbl.style.borderColor = '#2e7d32';
            lbl.style.color = '#1b5e20';
        }
    }
</script>

</body>
</html>