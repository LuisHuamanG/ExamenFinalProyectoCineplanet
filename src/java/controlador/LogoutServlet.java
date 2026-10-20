package controlador;

import dao.AuditoriaDAO;
import util.SesionSegura;
import util.ProteccionCSRF;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {
        
        String tokenCSRF = request.getParameter("tokenCSRF");

            if (!ProteccionCSRF.validarToken(request, tokenCSRF)) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Solicitud no válida. Recargue la página e intente nuevamente.");
                return;
            }

        HttpSession sesion = request.getSession(false);

        if (sesion != null) {
            String identificador
                    = (String) sesion.getAttribute("identificador");

            if (identificador != null) {
                try {
                    auditoriaDAO.registrar(
                            identificador,
                            "LOGOUT",
                            "Cierre de sesión",
                            request.getRemoteAddr());
                } catch (SQLException e) {
                    getServletContext().log(
                            "No se pudo registrar el cierre de sesión.",
                            e);
                }
            }
        }

        SesionSegura.cerrarSesion(request);

        response.setHeader("Cache-Control", "no-store");
        response.sendRedirect(
                request.getContextPath() + "/login.jsp");
    }
}
