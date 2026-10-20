
package controlador;

import dao.CompraClienteDAO;
import modelo.CompraCliente;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ComprasClienteServlet",
            urlPatterns = {"/cliente/ComprasServlet"})
public class ComprasClienteServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null
                || !"CLIENTE".equals(sesion.getAttribute("rol"))
                || !(sesion.getAttribute("idCliente") instanceof Integer)) {

            response.sendRedirect(
                    request.getContextPath() + "/index.jsp");
            return;
        }

        int idCliente = (Integer) sesion.getAttribute("idCliente");

        try {
            CompraClienteDAO compraDAO = new CompraClienteDAO();

            List<CompraCliente> compras =
                    compraDAO.listarPorCliente(idCliente);

            request.setAttribute("compras", compras);

            request.getRequestDispatcher(
                    "/cliente/compras.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log(
                    "Error al consultar las compras del cliente.", e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "No se pudieron consultar las compras. Intente más tarde.");
        }
    }
}
