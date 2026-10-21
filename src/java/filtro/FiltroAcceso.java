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

@WebFilter(filterName = "FiltroAcceso", urlPatterns = {
    "/admin/*",
    "/cajero/*",
    "/cliente/*",
    "/VentaServlet",
    "/AuditoriaServlet",
    "/comprobante",
    "/carrito",
    "/tienda"
})
public class FiltroAcceso implements Filter {

    @Override
    public void init(FilterConfig filtroConfig) throws ServletException {
    }

    @Override
    public void doFilter(
            ServletRequest solicitud,
            ServletResponse respuesta,
            FilterChain cadena)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) solicitud;
        HttpServletResponse response = (HttpServletResponse) respuesta;

        // Cabeceras anti-caché y seguridad exigidas
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");

        HttpSession sesion = request.getSession(false);

        // Si no existe una sesión autenticada, redirigir a login
        if (sesion == null || sesion.getAttribute("rol") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String rol = (String) sesion.getAttribute("rol");
        String ruta = request.getServletPath();

        boolean accesoPermitido = true;

        // 1. Solo ADMIN puede acceder a /admin/, /VentaServlet y /AuditoriaServlet
        if ((ruta.startsWith("/admin/") || ruta.equals("/VentaServlet") || ruta.equals("/AuditoriaServlet"))
                && !"ADMIN".equals(rol)) {
            accesoPermitido = false;
        }

        // 2. Solo CAJERO (y ADMIN) pueden acceder al área de caja
        if (ruta.startsWith("/cajero/") && !("ADMIN".equals(rol) || "CAJERO".equals(rol))) {
            accesoPermitido = false;
        }

        // 3. Solo CLIENTE puede acceder a su área y compras
        if ((ruta.startsWith("/cliente/") || ruta.equals("/comprobante") || ruta.equals("/carrito") || ruta.equals("/tienda"))
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

        Object identificadorSesion = sesion.getAttribute("identificador");
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
            request.getServletContext().log("No se pudo registrar el acceso denegado.", e);
        }
    }

    @Override
    public void destroy() {
    }
}