
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi cuenta | Cineplanet</title>
</head>
<body>

    <h1>Bienvenido a Cineplanet</h1>

    <p>
        DNI:
        <c:out value="${sessionScope.identificador}"/>
    </p>

    <p>
        Código de cliente:
        <c:out value="${sessionScope.idCliente}"/>
    </p>

    <h2>Mi cuenta</h2>
    <p>Desde aquí podrás consultar tus compras de entradas y dulcería.</p>
    
        <p>
        <a href="${pageContext.request.contextPath}/cliente/ComprasServlet">
            Consultar mis compras
        </a>
        </p>


    <form action="${pageContext.request.contextPath}/LogoutServlet"
          method="post">

        <input type="hidden" name="tokenCSRF"
               value="<%= util.ProteccionCSRF.obtenerToken(request) %>">

        <button type="submit">Cerrar sesión</button>
    </form>


</body>
</html>
