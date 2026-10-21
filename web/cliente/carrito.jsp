<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.sql.*, conexion.ConexionSQL, java.util.*"%>
<%
    List<String> butacas = (List<String>) session.getAttribute("butacasSeleccionadas");
    if (butacas == null) butacas = new ArrayList<String>();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Carrito de Compras | Cineplanet</title>
    <style>
        body { font-family: sans-serif; background: #f4f6f9; padding: 20px; }
        .contenedor { max-width: 700px; margin: auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .error { background: #ffebee; color: #c62828; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-weight: bold; }
        .seccion { margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { text-align: left; padding: 8px; border-bottom: 1px solid #eee; }
        .precio-item { font-weight: bold; }
        .btn-pagar { background: #2e7d32; color: #fff; border: none; padding: 12px 25px; font-size: 16px; border-radius: 5px; cursor: pointer; width: 100%; font-weight: bold; }
    </style>
</head>
<body>
<div class="contenedor">
    <h2>Carrito de Compras</h2>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/cliente/CarritoServlet" method="post">
        <input type="hidden" name="tokenCSRF" value="<%= util.ProteccionCSRF.obtenerToken(request) %>">
        <input type="hidden" name="accion" value="pagar">
        <input type="hidden" name="idFuncion" value="1">
        <input type="hidden" name="idSede" value="1">

        <div class="seccion">
            <h3>1. Entradas Seleccionadas</h3>
            <p><strong>Butacas:</strong> 
                <% if(butacas.isEmpty()) { %>
                    <label><input type="checkbox" name="butacas" value="F7" checked> F7</label>
                    <label><input type="checkbox" name="butacas" value="F8" checked> F8</label>
                <% } else { %>
                    <c:forEach var="b" items="${sessionScope.butacasSeleccionadas}">
                        <input type="hidden" name="butacas" value="${b}">
                        <span style="background:#e8f5e9; padding:4px 8px; border-radius:3px; margin-right:5px;">${b}</span>
                    </c:forEach>
                <% } %>
            </p>
            <p>Precio referencial por entrada: <span id="precio-ref-entrada" class="precio-item">S/ 24.90</span></p>
        </div>

        <div class="seccion">
            <h3>2. Dulcería (Opcional)</h3>
            <table>
                <tr>
                    <th>Producto</th>
                    <th>Precio</th>
                    <th>Cantidad</th>
                </tr>
                <tr>
                    <td>Combo Clásico (Canchita + Bebida)</td>
                    <td id="precio-ref-combo" class="precio-item">S/ 32.90</td>
                    <td>
                        <input type="hidden" name="idProducto" value="1">
                        <input type="number" name="cantidad" value="1" min="0" max="10" style="width:50px;">
                    </td>
                </tr>
            </table>
        </div>

        <div class="seccion">
            <h3>3. Medio de Pago</h3>
            <label><input type="radio" name="medioPago" value="TARJETA" checked> Tarjeta (Débito/Crédito)</label><br><br>
            <label><input type="radio" name="medioPago" value="YAPE"> Yape</label><br><br>
            <label><input type="radio" name="medioPago" value="PLIN"> Plin</label>
        </div>

        <button type="submit" class="btn-pagar">Pagar y Confirmar Compra</button>
    </form>
</div>
</body>
</html>