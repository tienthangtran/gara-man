package com.ptit.garaman.model;

/** Xe cua khach hang (bang tblVehicle1). */
public class Vehicle1 {
    private int id;
    private String description;
    private String licensePlate;
    private Customer1 customer;

    public Vehicle1() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public Customer1 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer1 customer) {
        this.customer = customer;
    }
}
