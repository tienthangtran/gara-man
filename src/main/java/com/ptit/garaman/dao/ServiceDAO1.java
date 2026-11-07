package com.ptit.garaman.dao;

import com.ptit.garaman.model.Service1;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Module tim kiem thong tin dich vu. */
public class ServiceDAO1 extends DAO1 {

    public ServiceDAO1() {
        super();
    }

    /** Tim cac dich vu co ten chua tu khoa (khong phan biet hoa thuong). Rong -> tat ca. */
    public List<Service1> searchServiceByName(String key) {
        String sql = "SELECT id, name, price, description FROM tblService1 "
                + "WHERE LOWER(name) LIKE ? ESCAPE '!' ORDER BY id";
        List<Service1> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, likePattern(key));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi tim dich vu: " + e.getMessage(), e);
        }
        return list;
    }

    /** Lay chi tiet dich vu theo id; khong co -> null. */
    public Service1 getServiceDetailByID(int id) {
        String sql = "SELECT id, name, price, description FROM tblService1 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi lay chi tiet dich vu: " + e.getMessage(), e);
        }
    }

    private static Service1 map(ResultSet rs) throws SQLException {
        Service1 s = new Service1();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setPrice(rs.getDouble("price"));
        s.setDescription(rs.getString("description"));
        return s;
    }
}
