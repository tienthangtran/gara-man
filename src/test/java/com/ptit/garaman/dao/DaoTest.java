package com.ptit.garaman.dao;

import static org.junit.jupiter.api.Assertions.*;

import com.ptit.garaman.model.*;
import com.ptit.garaman.util.Fmt1;
import com.ptit.garaman.util.PasswordUtil1;
import java.time.LocalDate;
import java.util.List;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

/** Kiem thu cac DAO tren H2 (che do MySQL) nap tu database/garaman.sql. */
class DaoTest {

    @BeforeAll
    static void setUp() throws Exception {
        java.net.URL sql = DaoTest.class.getResource("/db/garaman.sql");
        assertNotNull(sql);
        System.setProperty("db.driver", "org.h2.Driver");
        System.setProperty("db.url", "jdbc:h2:mem:garaman_test;MODE=MySQL;DB_CLOSE_DELAY=-1;INIT=RUNSCRIPT FROM '"
                + new java.io.File(sql.toURI()).getAbsolutePath() + "'");
        System.setProperty("db.user", "sa");
        System.setProperty("db.password", "");
    }

    @Test
    void login() {
        try (MemberDAO1 dao = new MemberDAO1()) {
            Member1 m = dao.checkLogin("manager1", "123456");
            assertNotNull(m);
            assertEquals("manager", m.getRole());
            assertNull(m.getPassword());
            assertEquals("customer", dao.checkLogin("KH001", "123456").getRole());
            assertNull(dao.checkLogin("manager1", "sai"));
            assertNull(dao.checkLogin("khongtontai", "123456"));
            assertNull(dao.checkLogin("' OR '1'='1", "x"));
            assertNull(dao.checkLogin("", ""));
        }
    }

    @Test
    void passwordUtil() {
        String h = PasswordUtil1.hash("abc");
        assertTrue(PasswordUtil1.verify("abc", h));
        assertFalse(PasswordUtil1.verify("abd", h));
        assertFalse(PasswordUtil1.verify("abc", "plain"));
    }

    @Test
    void searchService() {
        try (ServiceDAO1 dao = new ServiceDAO1()) {
            List<Service1> r = dao.searchServiceByName("dầu");
            assertEquals(2, r.size());
            assertEquals("Thay dầu máy", r.get(0).getName());
            assertEquals(2, dao.searchServiceByName("THAY DẦU").size()); // khong phan biet hoa thuong
            assertEquals(1, dao.searchServiceByName("máy").size());
            assertTrue(dao.searchServiceByName("khong co").isEmpty());
            assertTrue(dao.searchServiceByName("%").isEmpty());          // % duoc escape
            assertEquals(3, dao.searchServiceByName("").size());
            Service1 s = dao.getServiceDetailByID(1);
            assertEquals("Thay dầu máy", s.getName());
            assertEquals(250000, s.getPrice(), 0.001);
            assertTrue(s.getDescription().startsWith("Thay dầu máy định kỳ"));
            assertNull(dao.getServiceDetailByID(999));
        }
    }

    @Test
    void searchPart() {
        try (PartDAO1 dao = new PartDAO1()) {
            List<Part1> r = dao.searchPartByName("má phanh");
            assertEquals(2, r.size());
            assertEquals("Má phanh trước", r.get(0).getName());
            assertEquals("Má phanh sau", r.get(1).getName());
            Part1 p = dao.getPartDetailByID(1);
            assertEquals("Má phanh trước", p.getName());
            assertEquals(500000, p.getPrice(), 0.001);
            assertEquals(12, p.getRemainingQuantity());
            assertTrue(dao.searchPartByName("xyz").isEmpty());
            assertNull(dao.getPartDetailByID(0));
        }
    }

    @Test
    void customerStatistic() {
        LocalDate s = LocalDate.of(2026, 1, 1), e = LocalDate.of(2026, 9, 17);
        try (CustomerStatisticDAO1 dao = new CustomerStatisticDAO1()) {
            List<CustomerStatistic1> r = dao.getCustomerStatisticByRevenue(s, e);
            assertEquals(2, r.size());                       // KH003 khong co hoa don
            assertEquals("KH001", r.get(0).getUsername());
            assertEquals(3500000, r.get(0).getRevenue(), 0.001);  // hoa don 2025 va hoa don chua thanh toan bi loai
            assertEquals(2, r.get(0).getAmount());
            assertEquals("KH002", r.get(1).getUsername());
            assertEquals(2100000, r.get(1).getRevenue(), 0.001);
            assertEquals(1, r.get(1).getAmount());
            // ngay bien duoc bao gom
            assertEquals(1, dao.getCustomerStatisticByRevenue(LocalDate.of(2026, 6, 1), LocalDate.of(2026, 6, 1)).size());
            // khong co du lieu
            assertTrue(dao.getCustomerStatisticByRevenue(LocalDate.of(2020, 1, 1), LocalDate.of(2020, 12, 31)).isEmpty());
            // them hoa don 2025 -> KH001 doanh thu 4.5tr
            assertEquals(4500000, dao.getCustomerStatisticByRevenue(LocalDate.of(2025, 1, 1), e).get(0).getRevenue(), 0.001);
        }
    }

    @Test
    void invoices() {
        LocalDate s = LocalDate.of(2026, 1, 1), e = LocalDate.of(2026, 9, 17);
        try (CustomerDAO1 cdao = new CustomerDAO1(); InvoiceDAO1 idao = new InvoiceDAO1()) {
            Customer1 c = cdao.getCustomerByID(5);
            assertEquals("Nguyễn Văn A", c.getName());
            assertEquals("Hà Đông, TP. Hà Nội", c.getAddress());
            assertNull(cdao.getCustomerByID(1));             // quan ly khong phai khach hang
            assertNull(cdao.getCustomerByID(999));

            List<Invoice1> list = idao.getInvoiceListByCustomer(5, s, e);
            assertEquals(2, list.size());
            assertEquals(LocalDate.of(2026, 6, 1), list.get(0).getTime());   // moi nhat truoc
            assertEquals(1000000, list.get(0).getTotalAmount(), 0.001);
            assertEquals(1, idao.getInvoiceListByCustomer(6, LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31)).size()); // hoa don 4 chua thanh toan bi loai

            Invoice1 inv = idao.getInvoiceDetailByID(2);
            assertEquals("Trần Thị Ngọc C", inv.getSalesman().getName());
            assertEquals("Nguyễn Văn A", inv.getCustomer().getName());
            assertEquals("30A-123.45", inv.getVehicle().getLicensePlate());
            assertEquals(1, inv.getInvoiceServiceList().size());
            assertEquals("Thay dầu máy", inv.getInvoiceServiceList().get(0).getService().getName());
            assertEquals(250000, inv.getInvoiceServiceList().get(0).getUnitPrice(), 0.001);
            assertEquals(2, inv.getInvoiceServiceList().get(0).getQuantity());
            assertEquals(1, inv.getInvoicePartList().size());
            assertEquals("Má phanh trước", inv.getInvoicePartList().get(0).getPart().getName());
            assertNull(idao.getInvoiceDetailByID(999));

            // tong chi tiet = tong hoa don, voi moi hoa don mau
            for (int id = 1; id <= 5; id++) {
                Invoice1 x = idao.getInvoiceDetailByID(id);
                double sum = 0;
                for (InvoiceService1 d : x.getInvoiceServiceList()) sum += d.getTotalAmount();
                for (InvoicePart1 d : x.getInvoicePartList()) sum += d.getTotalAmount();
                assertEquals(x.getTotalAmount(), sum, 0.001, "hoa don " + id);
            }
        }
    }

    @Test
    void formatting() {
        assertEquals("250.000 đ", Fmt1.money(250000));
        assertEquals("3.500.000 đ", Fmt1.money(3500000));
        assertEquals("01/06/2026", Fmt1.date(LocalDate.of(2026, 6, 1)));
        assertNull(Fmt1.parseIso("abc"));
        assertNull(Fmt1.parseId("-3"));
        assertEquals("&lt;script&gt;", Fmt1.esc("<script>"));
    }
}
