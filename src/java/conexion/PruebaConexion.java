package conexion;

import java.sql.Connection;

public class PruebaConexion {

    public static void main(String[] args) {

        Connection con = ConexionSQL.getConexion();

        if (con != null) {
            System.out.println("CONEXION EXITOSA A BD_CineplanetFinal");
            ConexionSQL.closeConexion(con);
        } else {
            System.out.println("NO SE PUDO CONECTAR");
        }
    }
}