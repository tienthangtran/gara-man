package com.ptit.garaman.dao;

import com.ptit.garaman.model.Customer1;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Lay thong tin khach hang. */
public class CustomerDAO1 extends DAO1 {

    public CustomerDAO1() {
        super();
    }

    /** Lay khach hang (role = customer) theo id; khong co -> null. */
    public Customer1 getCustomerByID(int id) {
        String sql = "SELECT id, username, name, birthday, address, email, phoneNumber, role "
                + "FROM tblMember1 WHERE id = ? AND role = 'customer'";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Customer1 c = new Customer1();
                c.setId(rs.getInt("id"));
                c.setUsername(rs.getString("username"));
                c.setName(rs.getString("name"));
                Date b = rs.getDate("birthday");
                c.setBirthday(b == null ? null : b.toLocalDate());
                c.setAddress(rs.getString("address"));
                c.setEmail(rs.getString("email"));
                c.setPhoneNumber(rs.getString("phoneNumber"));
                c.setRole(rs.getString("role"));
                return c;
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi lay khach hang: " + e.getMessage(), e);
        }
    }
}
