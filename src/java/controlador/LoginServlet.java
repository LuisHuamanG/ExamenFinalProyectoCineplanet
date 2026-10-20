
package controlador;

import dao.AuditoriaDAO;
import dao.ClienteDAO;
import dao.UsuarioDAO;
import modelo.UsuarioSesion;
import util.ControlIntentos;
import util.Seguridad;
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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String tokenCSRF = request.getParameter("tokenCSRF");

        if (!ProteccionCSRF.validarToken(request, tokenCSRF)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Solicitud no válida. Recargue la página e intente nuevamente.");
            return;
        }

        String identificador = request.getParameter("usuario");
        String clave = request.getParameter("clave");

        if (identificador == null || clave == null
                || identificador.trim().isEmpty()
                || clave.isEmpty()) {

            request.setAttribute("mensaje",
                "Usuario o clave incorrectos");
            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        identificador = identificador.trim();

        String ip = request.getRemoteAddr();

        try {
            if (ControlIntentos.estaBloqueado(identificador)) {
                auditoriaDAO.registrar(
                        identificador,
                        "BLOQUEO",
                        "Intento durante el periodo de bloqueo",
                        ip);

                request.setAttribute("mensaje",
                        "No se pudo iniciar sesión. Intente nuevamente más tarde.");
                request.getRequestDispatcher("/login.jsp")
                        .forward(request, response);
                return;
            }

            String hash = Seguridad.sha256(clave);

            UsuarioSesion usuario =
                    usuarioDAO.autenticar(identificador, hash);

            if (usuario != null) {

                ControlIntentos.registrarExito(identificador);

                HttpSession sesion =
                        SesionSegura.iniciarSesion(request);

                sesion.setAttribute("usuarioSesion", usuario);
                sesion.setAttribute("rol", usuario.getRol());
                sesion.setAttribute("identificador",
                        usuario.getIdentificador());
                sesion.setAttribute("nombre", usuario.getNombre());
                sesion.setAttribute("idUsuario", usuario.getId());

                auditoriaDAO.registrar(
                        identificador,
                        "LOGIN_OK",
                        "Inicio de sesión correcto",
                        ip);

                if ("ADMIN".equals(usuario.getRol())) {
                    response.sendRedirect(
                            request.getContextPath() + "/admin/");
                } else {
                    response.sendRedirect(
                            request.getContextPath() + "/cajero/");
                }
                return;
            }

            Integer idCliente =
                    clienteDAO.validarCliente(identificador, hash);

            if (idCliente != null) {

                ControlIntentos.registrarExito(identificador);

                HttpSession sesion =
                        SesionSegura.iniciarSesion(request);

                sesion.setAttribute("rol", "CLIENTE");
                sesion.setAttribute("idCliente", idCliente);
                sesion.setAttribute("identificador", identificador);

                auditoriaDAO.registrar(
                        identificador,
                        "LOGIN_OK",
                        "Inicio de sesión de cliente",
                        ip);

                response.sendRedirect(
                        request.getContextPath() + "/cliente/");
                return;
            }

            ControlIntentos.registrarFallo(identificador);

            auditoriaDAO.registrar(
                    identificador,
                    "LOGIN_FALLIDO",
                    "Credenciales no válidas",
                    ip);

            if (ControlIntentos.estaBloqueado(identificador)) {
                auditoriaDAO.registrar(
                        identificador,
                        "BLOQUEO",
                        "Cuenta bloqueada por tres intentos fallidos",
                        ip);
            }

            request.setAttribute("mensaje",
                    "No se pudo iniciar sesión. Verifique sus datos.");
            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log(
                    "Error interno durante el inicio de sesión.", e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error interno. Intente más tarde.");
        }
    }
}
