package com.ptit.garaman.dao;

import com.ptit.garaman.model.Customer1;
import com.ptit.garaman.model.Invoice1;
import com.ptit.garaman.model.InvoicePart1;
import com.ptit.garaman.model.InvoiceService1;
import com.ptit.garaman.model.Mechanic1;
import com.ptit.garaman.model.Part1;
import com.ptit.garaman.model.Salesman1;
import com.ptit.garaman.model.Service1;
import com.ptit.garaman.model.Vehicle1;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Truy van hoa don (danh sach theo khach hang va chi tiet). */
public class InvoiceDAO1 extends DAO1 {
    public static final String STATUS_PAID = "Đã thanh toán";

    public InvoiceDAO1() {
        super();
    }

    /** Danh sach hoa don da thanh toan cua khach hang trong [startDate, endDate], moi nhat truoc. */
    public List<Invoice1> getInvoiceListByCustomer(int customerId, LocalDate startDate, LocalDate endDate) {
        String sql = "SELECT id, `time`, totalAmount, status FROM tblInvoice1 "
                + "WHERE customerId = ? AND `time` BETWEEN ? AND ? AND status = ? "
                + "ORDER BY `time` DESC, id DESC";
        List<Invoice1> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setDate(2, Date.valueOf(startDate));
            ps.setDate(3, Date.valueOf(endDate));
            ps.setString(4, STATUS_PAID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice1 inv = new Invoice1();
                    inv.setId(rs.getInt("id"));
                    inv.setTime(rs.getDate("time").toLocalDate());
                    inv.setTotalAmount(rs.getDouble("totalAmount"));
                    inv.setStatus(rs.getString("status"));
                    list.add(inv);
                }
            }
        } catch (SQLException e) {
            throw new DataAccessException("Loi lay danh sach hoa don: " + e.getMessage(), e);
        }
        return list;
    }

    /** Chi tiet hoa don (kem nhan vien ban hang, khach hang, xe, dich vu, phu tung); khong co -> null. */
    public Invoice1 getInvoiceDetailByID(int invoiceId) {
        String sql = "SELECT i.id, i.`time`, i.totalAmount, i.status, "
                + "c.id AS cId, c.username AS cUser, c.name AS cName, c.address AS cAddr, c.phoneNumber AS cPhone, "
                + "s.id AS sId, s.name AS sName, s.phoneNumber AS sPhone, "
                + "v.id AS vId, v.description AS vDesc, v.licensePlate AS vPlate "
                + "FROM tblInvoice1 i "
                + "JOIN tblMember1 c ON c.id = i.customerId "
                + "JOIN tblMember1 s ON s.id = i.employeeId "
                + "JOIN tblVehicle1 v ON v.id = i.vehicleId "
                + "WHERE i.id = ?";
        Invoice1 inv;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                inv = new Invoice1();
                inv.setId(rs.getInt("id"));
                inv.setTime(rs.getDate("time").toLocalDate());
                inv.setTotalAmount(rs.getDouble("totalAmount"));
                inv.setStatus(rs.getString("status"));

                Customer1 c = new Customer1();
                c.setId(rs.getInt("cId"));
                c.setUsername(rs.getString("cUser"));
                c.setName(rs.getString("cName"));
                c.setAddress(rs.getString("cAddr"));
                c.setPhoneNumber(rs.getString("cPhone"));
                inv.setCustomer(c);

                Salesman1 s = new Salesman1();
                s.setId(rs.getInt("sId"));
                s.setName(rs.getString("sName"));
                s.setPhoneNumber(rs.getString("sPhone"));
                inv.setSalesman(s);

                Vehicle1 v = new Vehicle1();
                v.setId(rs.getInt("vId"));
                v.setDescription(rs.getString("vDesc"));
                v.setLicensePlate(rs.getString("vPlate"));
                v.setCustomer(c);
                inv.setVehicle(v);
            }
            loadServices(inv);
            loadParts(inv);
            return inv;
        } catch (SQLException e) {
            throw new DataAccessException("Loi lay chi tiet hoa don: " + e.getMessage(), e);
        }
    }

    private void loadServices(Invoice1 inv) throws SQLException {
        String sql = "SELECT d.id, d.totalAmount, d.quantity, sv.id AS svId, sv.name AS svName, sv.price AS svPrice, "
                + "sv.description AS svDesc, m.id AS mId, m.name AS mName, m.phoneNumber AS mPhone "
                + "FROM tblInvoiceService1 d "
                + "JOIN tblService1 sv ON sv.id = d.serviceId "
                + "JOIN tblMember1 m ON m.id = d.employeeId "
                + "WHERE d.invoiceId = ? ORDER BY d.id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, inv.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceService1 d = new InvoiceService1();
                    d.setId(rs.getInt("id"));
                    d.setTotalAmount(rs.getDouble("totalAmount"));
                    d.setQuantity(rs.getInt("quantity"));
                    Service1 sv = new Service1();
                    sv.setId(rs.getInt("svId"));
                    sv.setName(rs.getString("svName"));
                    sv.setPrice(rs.getDouble("svPrice"));
                    sv.setDescription(rs.getString("svDesc"));
                    d.setService(sv);
                    Mechanic1 m = new Mechanic1();
                    m.setId(rs.getInt("mId"));
                    m.setName(rs.getString("mName"));
                    m.setPhoneNumber(rs.getString("mPhone"));
                    d.setMechanic(m);
                    inv.getInvoiceServiceList().add(d);
                }
            }
        }
    }

    private void loadParts(Invoice1 inv) throws SQLException {
        String sql = "SELECT d.id, d.totalAmount, d.quantity, p.id AS pId, p.name AS pName, p.price AS pPrice, "
                + "p.description AS pDesc, p.remainingQuantity AS pQty "
                + "FROM tblInvoicePart1 d JOIN tblPart1 p ON p.id = d.partId "
                + "WHERE d.invoiceId = ? ORDER BY d.id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, inv.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoicePart1 d = new InvoicePart1();
                    d.setId(rs.getInt("id"));
                    d.setTotalAmount(rs.getDouble("totalAmount"));
                    d.setQuantity(rs.getInt("quantity"));
                    Part1 p = new Part1();
                    p.setId(rs.getInt("pId"));
                    p.setName(rs.getString("pName"));
                    p.setPrice(rs.getDouble("pPrice"));
                    p.setDescription(rs.getString("pDesc"));
                    p.setRemainingQuantity(rs.getInt("pQty"));
                    d.setPart(p);
                    inv.getInvoicePartList().add(d);
                }
            }
        }
    }
}
