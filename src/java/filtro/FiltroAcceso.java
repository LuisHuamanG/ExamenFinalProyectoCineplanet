
package filtro;

import dao.AuditoriaDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
    "/admin/*",
    "/cajero/*",
    "/cliente/*"
})
public class FiltroAcceso implements Filter {

    @Override
    public void init(FilterConfig filtroConfig)
            throws ServletException {
    }

    @Override
    public void doFilter(
            ServletRequest solicitud,
            ServletResponse respuesta,
            FilterChain cadena)
            throws IOException, ServletException {

        HttpServletRequest request =
                (HttpServletRequest) solicitud;

        HttpServletResponse response =
                (HttpServletResponse) respuesta;

        // Cabeceras de seguridad
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("Cache-Control", "no-store");

        HttpSession sesion = request.getSession(false);

        // Si no existe una sesión autenticada, solicitar login.
        if (sesion == null || sesion.getAttribute("rol") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String rol = (String) sesion.getAttribute("rol");
        String ruta = request.getServletPath();

        boolean accesoPermitido = true;

        // Solo ADMIN puede acceder al panel administrativo.
        if (ruta.startsWith("/admin/")
                && !"ADMIN".equals(rol)) {
            accesoPermitido = false;
        }

        // ADMIN y CAJERO pueden acceder al área de caja.
        if (ruta.startsWith("/cajero/")
                && !("ADMIN".equals(rol)
                || "CAJERO".equals(rol))) {
            accesoPermitido = false;
        }

        // Solo CLIENTE puede acceder a su área personal.
        if (ruta.startsWith("/cliente/")
                && !"CLIENTE".equals(rol)) {
            accesoPermitido = false;
        }

        if (!accesoPermitido) {

            registrarAccesoDenegado(request, sesion, ruta);

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Acceso denegado.");

            return;
        }

        cadena.doFilter(solicitud, respuesta);
    }

    private void registrarAccesoDenegado(
            HttpServletRequest request,
            HttpSession sesion,
            String ruta) {

        Object identificadorSesion =
                sesion.getAttribute("identificador");

        String usuario = identificadorSesion == null
                ? "DESCONOCIDO"
                : identificadorSesion.toString();

        String detalle = "Rol " + sesion.getAttribute("rol")
                + " intentó acceder a " + ruta;

        try {
            AuditoriaDAO auditoria = new AuditoriaDAO();

            auditoria.registrar(
                    usuario,
                    "ACCESO_DENEGADO",
                    detalle,
                    request.getRemoteAddr()
            );

        } catch (SQLException e) {
            // No revelar detalles de la base de datos al usuario.
            request.getServletContext().log(
                    "No se pudo registrar el acceso denegado.", e);
        }
    }

    @Override
    public void destroy() {
    }
}
