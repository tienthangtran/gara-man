package com.ptit.garaman.model;

import java.time.LocalDate;

/** Thong ke khach hang: doanh thu (revenue) va so hoa don (amount) trong khoang [startDate, endDate]. */
public class CustomerStatistic1 extends Customer1 {
    private double revenue;
    private int amount;
    private LocalDate startDate;
    private LocalDate endDate;

    public CustomerStatistic1() {
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }
}
