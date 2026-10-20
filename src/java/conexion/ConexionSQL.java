
package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Luis
 */
public class ConexionSQL {

    public static Connection getConexion() {
        Connection con = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            String url = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=BD_CineplanetFinal;"
                    + "encrypt=false;";

            String usr = "sa";
            String psw = "123";

            con = DriverManager.getConnection(url, usr, psw);

        } catch (ClassNotFoundException e) {
            System.out.println("Error >> Driver no instalado!! " + e.getMessage());

        } catch (SQLException e) {
            System.out.println("Error >> de conexion con la BD: " + e.getMessage());

        } catch (Exception e) {
            System.out.println("Error >> general: " + e.getMessage());
        }

        return con;
    }

    public static void closeConexion(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                System.out.println("Problemas al cerrar la conexion");
            }
        }
    }
}