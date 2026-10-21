package controlador;

import conexion.ConexionSQL;
import dao.CompraClienteDAO;
import modelo.CompraCliente;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ComprasClienteServlet",
            urlPatterns = {"/cliente/ComprasServlet", "/cliente/comprobante"})
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

            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idCliente = (Integer) sesion.getAttribute("idCliente");
        String idVentaParam = request.getParameter("id");

        // Caso A: Consulta de un comprobante específico con ?id=
        if (idVentaParam != null && !idVentaParam.trim().isEmpty()) {
            consultarComprobante(request, response, idCliente, idVentaParam.trim());
            return;
        }

        // Caso B: Listado normal de compras del cliente
        try {
            CompraClienteDAO compraDAO = new CompraClienteDAO();
            List<CompraCliente> compras = compraDAO.listarPorCliente(idCliente);
            request.setAttribute("compras", compras);
            request.getRequestDispatcher("/cliente/compras.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Error al consultar las compras del cliente.", e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "No se pudieron consultar las compras. Intente más tarde.");
        }
    }

    private void consultarComprobante(
            HttpServletRequest request,
            HttpServletResponse response,
            int idCliente,
            String idVenta)
            throws ServletException, IOException {

        // Consulta estricta exigida: WHERE idVenta = ? AND idCliente = ?
        String sql = "SELECT idVenta, total, fechaVenta, medioPago FROM Venta WHERE idVenta = ? AND idCliente = ?";

        try (Connection con = ConexionSQL.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(idVenta));
            ps.setInt(2, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("idVenta", rs.getInt("idVenta"));
                    request.setAttribute("total", rs.getBigDecimal("total"));
                    request.setAttribute("fechaVenta", rs.getTimestamp("fechaVenta"));
                    request.setAttribute("mensaje", "Comprobante cargado correctamente");
                } else {
                    // Si el idVenta no le pertenece a este idCliente
                    request.setAttribute("mensaje", "Compra no encontrada");
                }
            }

        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("mensaje", "Compra no encontrada");
        }

        request.getRequestDispatcher("/cliente/comprobante.jsp").forward(request, response);
    }
}