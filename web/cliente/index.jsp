<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi cuenta | Cineplanet</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; margin: 0; padding: 25px; color: #333; }
        .contenedor { max-width: 600px; margin: auto; background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h1 { color: #0b192c; margin-top: 0; }
        .datos-cliente { background: #eef2f7; padding: 12px 18px; border-radius: 6px; margin: 15px 0; font-size: 14px; }
        .alerta-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            padding: 12px 16px;
            border-radius: 6px;
            margin: 16px 0;
            font-weight: bold;
            display: inline-block;
            width: 100%;
            box-sizing: border-box;
        }
        .btn-comprar {
            display: inline-block;
            background-color: #ff6500;
            color: #fff;
            padding: 14px 22px;
            font-size: 16px;
            font-weight: bold;
            text-decoration: none;
            border-radius: 6px;
            margin-right: 12px;
            margin-bottom: 15px;
            transition: background 0.2s;
        }
        .btn-comprar:hover { background-color: #e65100; }
        .btn-secundario {
            display: inline-block;
            background-color: #1e3e62;
            color: #fff;
            padding: 14px 22px;
            font-size: 15px;
            text-decoration: none;
            border-radius: 6px;
            margin-bottom: 15px;
            transition: background 0.2s;
        }
        .btn-secundario:hover { background-color: #0b192c; }
        .btn-logout {
            background: #d32f2f;
            color: #fff;
            border: none;
            padding: 10px 18px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 20px;
        }
        .btn-logout:hover { background: #b71c1c; }
    </style>
</head>
<body>

<div class="contenedor">
    <h1>Bienvenido a Cineplanet</h1>

    <c:if test="${not empty mensaje}">
        <div class="alerta-error">
            <c:out value="${mensaje}"/>
        </div>
    </c:if>

    <div class="datos-cliente">
        <p style="margin: 4px 0;"><strong>Cliente:</strong> <c:out value="<script>alert('XSS')</script>"/></p>
        <p style="margin: 4px 0;"><strong>DNI:</strong> <c:out value="${sessionScope.identificador}"/></p>
        <p style="margin: 4px 0;"><strong>Código de cliente:</strong> <c:out value="${sessionScope.idCliente}"/></p>
    </div>

    <h2>Servicios disponibles</h2>
    <p>Elige una función o revisa tu historial de compras:</p>

    <div>
        <!-- Botón principal para ir a la selección de butacas de la función 1 -->
        <a href="${pageContext.request.contextPath}/cliente/butacas.jsp?idFuncion=1" class="btn-comprar">
            🎟️ Comprar Entradas
        </a>

        <!-- Enlace para revisar compras anteriores -->
        <a href="${pageContext.request.contextPath}/cliente/ComprasServlet" class="btn-secundario">
            📋 Consultar mis compras
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/LogoutServlet" method="post">
        <input type="hidden" name="tokenCSRF" value="<%= util.ProteccionCSRF.obtenerToken(request) %>">
        <button type="submit" class="btn-logout">Cerrar sesión</button>
    </form>
</div>

</body>
</html>