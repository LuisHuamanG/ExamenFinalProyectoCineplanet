
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis compras - Cineplanet</title>
</head>
<body>

    <h1>Mis compras</h1>

    <p>
        Cliente:
        <c:out value="${sessionScope.identificador}"/>
    </p>

    <p>Consulta el historial de tus compras de Cineplanet.</p>

    <p>
        <a href="${pageContext.request.contextPath}/cliente/index.jsp">
            Volver a mi cuenta
        </a>
    </p>

    <hr>

    <c:choose>
        <c:when test="${empty compras}">
            <p>Aún no tienes compras registradas.</p>
        </c:when>

        <c:otherwise>
            <table border="1" cellpadding="8" cellspacing="0">
                <thead>
                    <tr>
                        <th>N.º de compra</th>
                        <th>Fecha</th>
                        <th>Sede</th>
                        <th>Canal</th>
                        <th>Medio de pago</th>
                        <th>Total</th>
                        <th>Estado</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="compra" items="${compras}">
                        <tr>
                            <td>
                                <c:out value="${compra.idVenta}"/>
                            </td>
                            <td>
                                <fmt:formatDate
                                    value="${compra.fechaVenta}"
                                    pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <c:out value="${compra.sede}"/>
                            </td>
                            <td>
                                <c:out value="${compra.canal}"/>
                            </td>
                            <td>
                                <c:out value="${compra.medioPago}"/>
                            </td>
                            <td>
                                S/
                                <c:out value="${compra.total}"/>
                            </td>
                            <td>
                                <c:out value="${compra.estado}"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <hr>

    <form action="${pageContext.request.contextPath}/LogoutServlet"
          method="post">
        <input type="hidden" name="tokenCSRF"
               value="<%= util.ProteccionCSRF.obtenerToken(request) %>">
        <button type="submit">Cerrar sesión</button>
    </form>

</body>
</html>
