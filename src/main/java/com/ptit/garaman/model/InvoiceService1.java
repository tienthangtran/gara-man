package com.ptit.garaman.model;

/** Chi tiet dich vu trong hoa don (bang tblInvoiceService1); chua Service1. */
public class InvoiceService1 {
    private int id;
    private double totalAmount;
    private int quantity;
    private Service1 service;
    private Mechanic1 mechanic;

    public InvoiceService1() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Service1 getService() {
        return service;
    }

    public void setService(Service1 service) {
        this.service = service;
    }

    public Mechanic1 getMechanic() {
        return mechanic;
    }

    public void setMechanic(Mechanic1 mechanic) {
        this.mechanic = mechanic;
    }

    /** Don gia thuc te tai thoi diem lap hoa don = thanh tien / so luong. */
    public double getUnitPrice() {
        return quantity == 0 ? 0 : totalAmount / quantity;
    }
}
