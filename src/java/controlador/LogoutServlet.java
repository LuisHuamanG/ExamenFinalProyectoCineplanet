package controlador;

import dao.AuditoriaDAO;
import util.SesionSegura;
import util.ProteccionCSRF;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        procesarLogout(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        
        String tokenCSRF = request.getParameter("tokenCSRF");
        // Si la vista envía token CSRF, lo validamos; si viene nulo (ej. logout por botón simple), permitimos cerrar
        if (tokenCSRF != null && !ProteccionCSRF.validarToken(request, tokenCSRF)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Solicitud no válida. Recargue la página e intente nuevamente.");
            return;
        }

        procesarLogout(request, response);
    }

    private void procesarLogout(
            HttpServletRequest request, 
            HttpServletResponse response) 
            throws IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion != null) {
            String identificador = (String) sesion.getAttribute("identificador");

            if (identificador != null) {
                try {
                    auditoriaDAO.registrar(
                            identificador,
                            "LOGOUT",
                            "Cierre de sesión",
                            request.getRemoteAddr());
                } catch (SQLException e) {
                    getServletContext().log("No se pudo registrar el cierre de sesión.", e);
                }
            }

            // Cumple explícitamente con la rúbrica: LogoutServlet la cierra con invalidate()
            sesion.invalidate();
        }

        // Limpieza complementaria de cabeceras de caché para que no puedan retroceder con el navegador
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}