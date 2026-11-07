package com.ptit.garaman.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Lop co so cua cac DAO: giu ket noi CSDL (con).
 * Thu tu cau hinh: tham so JVM (-Ddb.url) > bien moi truong (DB_URL) > db.properties.
 * Dung try-with-resources de tu dong dong ket noi: try (ServiceDAO1 dao = new ServiceDAO1()) { ... }
 */
public class DAO1 implements AutoCloseable {
    protected Connection con;

    public DAO1() {
        try {
            String driver = cfg("db.driver", "DB_DRIVER");
            if (driver != null && !driver.isEmpty()) {
                Class.forName(driver);
            }
            con = DriverManager.getConnection(cfg("db.url", "DB_URL"), cfg("db.user", "DB_USER"),
                    cfg("db.password", "DB_PASSWORD"));
        } catch (ClassNotFoundException | SQLException e) {
            throw new DataAccessException("Khong the ket noi CSDL: " + e.getMessage(), e);
        }
    }

    /** Dung cho kiem thu: truyen san ket noi. */
    protected DAO1(Connection con) {
        this.con = con;
    }

    private static String cfg(String prop, String env) {
        String v = System.getProperty(prop);
        if (v == null) {
            v = System.getenv(env);
        }
        if (v == null) {
            v = FILE.getProperty(prop);
        }
        return v;
    }

    private static final Properties FILE = new Properties();

    static {
        try (InputStream in = DAO1.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                FILE.load(in);
            }
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    @Override
    public void close() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException ignored) {
            // bo qua loi khi dong
        }
    }

    /** Loi truy cap du lieu (unchecked de JSP de xu ly). */
    public static class DataAccessException extends RuntimeException {
        private static final long serialVersionUID = 1L;

        public DataAccessException(String msg, Throwable cause) {
            super(msg, cause);
        }
    }

    /** Escape ky tu dac biet cua LIKE (% _ !) bang ky tu thoat '!' (dung cung ESCAPE '!' trong SQL). */
    protected static String likePattern(String key) {
        String k = key == null ? "" : key.trim();
        k = k.replace("!", "!!").replace("%", "!%").replace("_", "!_");
        return "%" + k.toLowerCase() + "%";
    }
}
