
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de administración | Cineplanet</title>
</head>
<body>

    <c:if test="${empty sessionScope.usuarioSesion
                  or sessionScope.rol ne 'ADMIN'}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <h1>Panel de administración de Cineplanet</h1>

    <p>
        Bienvenido,
        <c:out value="${sessionScope.nombre}"/>.
    </p>

    <p>
        Rol: 
        <c:out value="${sessionScope.rol}"/>.
    </p>

    <p>El inicio de sesión se ha procesado correctamente.</p>

    

    <form action="${pageContext.request.contextPath}/LogoutServlet"
          method="post">

        <input type="hidden" name="tokenCSRF"
               value="<%= util.ProteccionCSRF.obtenerToken(request) %>">

        <button type="submit">Cerrar sesión</button>
    </form>


    
</body>
</html>
