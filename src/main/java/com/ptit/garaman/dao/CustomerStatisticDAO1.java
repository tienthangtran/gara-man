package com.ptit.garaman.dao;

import com.ptit.garaman.model.CustomerStatistic1;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Module thong ke khach hang theo doanh thu. */
public class CustomerStatisticDAO1 extends DAO1 {

    public CustomerStatisticDAO1() {
        super();
    }

    /**
     * Thong ke doanh thu theo khach hang trong [startDate, endDate] (bao gom 2 dau),
     * chi tinh hoa don da thanh toan, sap xep giam dan theo doanh thu.
     */
    public List<CustomerStatistic1> getCustomerStatisticByRevenue(LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT m.id, m.username, m.name, m.address, m.phoneNumber, "
                + "SUM(i.totalAmount) AS revenue, COUNT(i.id) AS amount "
                + "FROM tblInvoice1 i JOIN tblMember1 m ON m.id = i.customerId "
                + "WHERE i.`time` BETWEEN ? AND ? AND i.status = ? "
                + "GROUP BY m.id, m.username, m.name, m.address, m.phoneNumber "
                + "ORDER BY revenue DESC, m.name";
        List<CustomerStatistic1> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));
            ps.setString(3, InvoiceDAO1.STATUS_PAID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomerStatistic1 s = new CustomerStatistic1();
                    s.setId(rs.getInt("id"));
                    s.setUsername(rs.getString("username"));
                    s.setName(rs.getString("name"));
                    s.setAddress(rs.getString("address"));
                    s.setPhoneNumber(rs.getString("phoneNumber"));
                    s.setRole("customer");
                    s.setRevenue(rs.getDouble("revenue"));
                    s.setAmount(rs.getInt("amount"));
                    s.setStartDate(startDate);
                    s.setEndDate(endDate);
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi thong ke khach hang: " + e.getMessage(), e);
        }
        return list;
    }
}
