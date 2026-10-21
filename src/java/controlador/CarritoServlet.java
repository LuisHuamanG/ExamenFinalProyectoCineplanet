package controlador;

import dao.AuditoriaDAO;
import dao.VentaDAO;
import util.ProteccionCSRF;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CarritoServlet", urlPatterns = {"/cliente/CarritoServlet", "/cliente/carrito"})
public class CarritoServlet extends HttpServlet {

    private final VentaDAO ventaDAO = new VentaDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirige o muestra la vista del carrito
        request.getRequestDispatcher("/cliente/carrito.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession sesion = request.getSession(false);

        // 1. Validar sesión de cliente activa
        if (sesion == null || !"CLIENTE".equals(sesion.getAttribute("rol"))
                || !(sesion.getAttribute("idCliente") instanceof Integer)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idCliente = (Integer) sesion.getAttribute("idCliente");
        String identificador = (String) sesion.getAttribute("identificador");
        String ip = request.getRemoteAddr();

        // 2. Validación de Token CSRF
        String tokenCSRF = request.getParameter("tokenCSRF");
        if (tokenCSRF != null && !ProteccionCSRF.validarToken(request, tokenCSRF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Solicitud CSRF no válida.");
            return;
        }

        String accion = request.getParameter("accion");

        // Acción: Procesar el pago final
        if ("pagar".equalsIgnoreCase(accion)) {
            procesarPago(request, response, idCliente, identificador, ip);
        } else {
            // Guardar selección temporal en sesión (butacas y dulcería)
            guardarEnSesion(request, response, sesion);
        }
    }

    private void guardarEnSesion(HttpServletRequest request, HttpServletResponse response, HttpSession sesion)
            throws ServletException, IOException {

        String[] butacasArr = request.getParameterValues("butacas");
        String idFuncionStr = request.getParameter("idFuncion");
        String idSedeStr = request.getParameter("idSede");

        if (idFuncionStr != null) {
            sesion.setAttribute("idFuncionSeleccionada", Integer.parseInt(idFuncionStr));
        }
        if (idSedeStr != null) {
            sesion.setAttribute("idSedeSeleccionada", Integer.parseInt(idSedeStr));
        }

        if (butacasArr != null) {
            List<String> listaButacas = new ArrayList<>(Arrays.asList(butacasArr));
            sesion.setAttribute("butacasSeleccionadas", listaButacas);
        }

        response.sendRedirect(request.getContextPath() + "/cliente/carrito.jsp");
    }

    private void procesarPago(HttpServletRequest request, HttpServletResponse response,
                              int idCliente, String identificador, String ip)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        // A. Validar Sede y Función
        Integer idSede = (Integer) sesion.getAttribute("idSedeSeleccionada");
        Integer idFuncion = (Integer) sesion.getAttribute("idFuncionSeleccionada");

        if (idSede == null) {
            String pSede = request.getParameter("idSede");
            idSede = (pSede != null) ? Integer.parseInt(pSede) : 1;
        }
        if (idFuncion == null) {
            String pFunc = request.getParameter("idFuncion");
            idFuncion = (pFunc != null) ? Integer.parseInt(pFunc) : 1;
        }

        // B. Validar Butacas (filas A-J, 1-12 y máximo 10 entradas)
        String[] butacasArr = request.getParameterValues("butacas");
        @SuppressWarnings("unchecked")
        List<String> butacas = (butacasArr != null) ? Arrays.asList(butacasArr) 
                : (List<String>) sesion.getAttribute("butacasSeleccionadas");

        if (butacas == null || butacas.isEmpty() || butacas.size() > 10) {
            request.setAttribute("error", "Debe seleccionar entre 1 y 10 butacas.");
            request.getRequestDispatcher("/cliente/carrito.jsp").forward(request, response);
            return;
        }

        for (String b : butacas) {
            // Expresión regular: Fila A-J seguida de número del 1 al 12
            if (!b.matches("^[A-J]([1-9]|1[0-2])$")) {
                request.setAttribute("error", "Formato de butaca inválido: " + b);
                request.getRequestDispatcher("/cliente/carrito.jsp").forward(request, response);
                return;
            }
        }

        // C. Validar Medio de Pago (solo TARJETA, YAPE o PLIN)
        String medioPago = request.getParameter("medioPago");
        if (medioPago == null || (!"TARJETA".equals(medioPago) && !"YAPE".equals(medioPago) && !"PLIN".equals(medioPago))) {
            request.setAttribute("error", "Medio de pago no permitido. Solo se acepta TARJETA, YAPE o PLIN.");
            request.getRequestDispatcher("/cliente/carrito.jsp").forward(request, response);
            return;
        }

        // D. Procesar Dulcería (cantidades entre 1 y 10)
        Map<Integer, Integer> dulceria = new HashMap<>();
        String[] prodIds = request.getParameterValues("idProducto");
        String[] cantidades = request.getParameterValues("cantidad");

        if (prodIds != null && cantidades != null) {
            for (int i = 0; i < prodIds.length; i++) {
                try {
                    int cant = Integer.parseInt(cantidades[i]);
                    if (cant > 0) {
                        if (cant > 10) {
                            request.setAttribute("error", "La cantidad por producto no puede exceder 10 unidades.");
                            request.getRequestDispatcher("/cliente/carrito.jsp").forward(request, response);
                            return;
                        }
                        dulceria.put(Integer.parseInt(prodIds[i]), cant);
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        // E. Registrar transacción en VentaDAO (precios se leen desde la BD)
        try {
            int idVenta = ventaDAO.registrar(idCliente, idSede, idFuncion, butacas, dulceria, "WEB", medioPago);

            // Registrar evento de seguridad en Auditoria
            auditoriaDAO.registrar(identificador, "COMPRA", "Compra #" + idVenta + " confirmada por " + medioPago, ip);

            // Limpiar datos temporales de la sesión
            sesion.removeAttribute("butacasSeleccionadas");
            sesion.removeAttribute("idFuncionSeleccionada");

            // Redirigir al comprobante seguro
            response.sendRedirect(request.getContextPath() + "/cliente/comprobante?id=" + idVenta);

        } catch (Exception ex) {
            // Si la butaca ya fue vendida o hubo rollback
            request.setAttribute("error", "No se pudo completar la compra: " + ex.getMessage());
            request.getRequestDispatcher("/cliente/carrito.jsp").forward(request, response);
        }
    }
}