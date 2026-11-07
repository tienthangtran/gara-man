package com.ptit.garaman.dao;

import com.ptit.garaman.model.Member1;
import com.ptit.garaman.util.PasswordUtil1;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Dang nhap / lay thong tin thanh vien. */
public class MemberDAO1 extends DAO1 {

    public MemberDAO1() {
        super();
    }

    /** Tra ve Member1 (khong kem mat khau) neu dung tai khoan/mat khau, nguoc lai tra null. */
    public Member1 checkLogin(String username, String password) {
        if (username == null || password == null || username.trim().isEmpty()) {
            return null;
        }
        String sql = "SELECT id, username, password, name, birthday, address, email, phoneNumber, role "
                + "FROM tblMember1 WHERE username = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && PasswordUtil1.verify(password, rs.getString("password"))) {
                    Member1 m = new Member1();
                    m.setId(rs.getInt("id"));
                    m.setUsername(rs.getString("username"));
                    m.setName(rs.getString("name"));
                    Date b = rs.getDate("birthday");
                    m.setBirthday(b == null ? null : b.toLocalDate());
                    m.setAddress(rs.getString("address"));
                    m.setEmail(rs.getString("email"));
                    m.setPhoneNumber(rs.getString("phoneNumber"));
                    m.setRole(rs.getString("role"));
                    return m;
                }
                return null;
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi dang nhap: " + e.getMessage(), e);
        }
    }
}
