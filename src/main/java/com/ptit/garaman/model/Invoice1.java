package com.ptit.garaman.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Hoa don (bang tblInvoice1). */
public class Invoice1 {
    private int id;
    private LocalDate time;
    private double totalAmount;
    private String status;
    private Salesman1 salesman;
    private Customer1 customer;
    private Vehicle1 vehicle;
    private List<InvoiceService1> invoiceServiceList = new ArrayList<>();
    private List<InvoicePart1> invoicePartList = new ArrayList<>();

    public Invoice1() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getTime() {
        return time;
    }

    public void setTime(LocalDate time) {
        this.time = time;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Salesman1 getSalesman() {
        return salesman;
    }

    public void setSalesman(Salesman1 salesman) {
        this.salesman = salesman;
    }

    public Customer1 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer1 customer) {
        this.customer = customer;
    }

    public Vehicle1 getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle1 vehicle) {
        this.vehicle = vehicle;
    }

    public List<InvoiceService1> getInvoiceServiceList() {
        return invoiceServiceList;
    }

    public void setInvoiceServiceList(List<InvoiceService1> invoiceServiceList) {
        this.invoiceServiceList = invoiceServiceList;
    }

    public List<InvoicePart1> getInvoicePartList() {
        return invoicePartList;
    }

    public void setInvoicePartList(List<InvoicePart1> invoicePartList) {
        this.invoicePartList = invoicePartList;
    }
}
