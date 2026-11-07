package com.ptit.garaman.model;

/** Chi tiet phu tung trong hoa don (bang tblInvoicePart1); chua Part1. */
public class InvoicePart1 {
    private int id;
    private double totalAmount;
    private int quantity;
    private Part1 part;

    public InvoicePart1() {
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

    public Part1 getPart() {
        return part;
    }

    public void setPart(Part1 part) {
        this.part = part;
    }

    /** Don gia thuc te tai thoi diem lap hoa don = thanh tien / so luong. */
    public double getUnitPrice() {
        return quantity == 0 ? 0 : totalAmount / quantity;
    }
}
