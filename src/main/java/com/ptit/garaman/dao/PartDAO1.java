package com.ptit.garaman.dao;

import com.ptit.garaman.model.Part1;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Module tim kiem thong tin phu tung. */
public class PartDAO1 extends DAO1 {

    public PartDAO1() {
        super();
    }

    /** Tim cac phu tung co ten chua tu khoa (khong phan biet hoa thuong). Rong -> tat ca. */
    public List<Part1> searchPartByName(String key) {
        String sql = "SELECT id, name, price, description, remainingQuantity FROM tblPart1 "
                + "WHERE LOWER(name) LIKE ? ESCAPE '!' ORDER BY id";
        List<Part1> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, likePattern(key));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi tim phu tung: " + e.getMessage(), e);
        }
        return list;
    }

    /** Lay chi tiet phu tung theo id; khong co -> null. */
    public Part1 getPartDetailByID(int id) {
        String sql = "SELECT id, name, price, description, remainingQuantity FROM tblPart1 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi lay chi tiet phu tung: " + e.getMessage(), e);
        }
    }

    private static Part1 map(ResultSet rs) throws SQLException {
        Part1 p = new Part1();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getDouble("price"));
        p.setDescription(rs.getString("description"));
        p.setRemainingQuantity(rs.getInt("remainingQuantity"));
        return p;
    }
}
