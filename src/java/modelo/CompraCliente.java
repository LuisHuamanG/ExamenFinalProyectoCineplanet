/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modelo;

/**
 *
 * @author Luis
 */


import java.math.BigDecimal;
import java.sql.Timestamp;

public class CompraCliente {

    private int idVenta;
    private Timestamp fechaVenta;
    private String sede;
    private String canal;
    private String medioPago;
    private BigDecimal total;
    private String estado;

    public CompraCliente(
            int idVenta,
            Timestamp fechaVenta,
            String sede,
            String canal,
            String medioPago,
            BigDecimal total,
            String estado) {

        this.idVenta = idVenta;
        this.fechaVenta = fechaVenta;
        this.sede = sede;
        this.canal = canal;
        this.medioPago = medioPago;
        this.total = total;
        this.estado = estado;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public Timestamp getFechaVenta() {
        return fechaVenta;
    }

    public String getSede() {
        return sede;
    }

    public String getCanal() {
        return canal;
    }

    public String getMedioPago() {
        return medioPago;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public String getEstado() {
        return estado;
    }
}
