package com.ptit.garaman.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Locale;

/** Tien ich dinh dang hien thi cho cac trang JSP. */
public final class Fmt1 {
    private static final DateTimeFormatter DMY = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private Fmt1() {
    }

    /** 250000 -> "250.000 đ". */
    public static String money(double v) {
        DecimalFormatSymbols s = new DecimalFormatSymbols(Locale.ROOT);
        s.setGroupingSeparator('.');
        return new DecimalFormat("#,##0", s).format(Math.round(v)) + " đ";
    }

    /** LocalDate -> "dd/MM/yyyy" (null -> chuoi rong). */
    public static String date(LocalDate d) {
        return d == null ? "" : d.format(DMY);
    }

    /** LocalDate -> "yyyy-MM-dd" dung cho input type=date / tham so URL. */
    public static String iso(LocalDate d) {
        return d == null ? "" : d.toString();
    }

    /** Doc "yyyy-MM-dd"; tra null neu rong hoac sai dinh dang. */
    public static LocalDate parseIso(String s) {
        if (s == null || s.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(s.trim());
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    /** Doc so nguyen duong tu tham so; tra null neu khong hop le. */
    public static Integer parseId(String s) {
        try {
            int v = Integer.parseInt(s.trim());
            return v > 0 ? v : null;
        } catch (RuntimeException e) {
            return null;
        }
    }

    /** Escape HTML de chong XSS. */
    public static String esc(Object o) {
        if (o == null) {
            return "";
        }
        String s = o.toString();
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (char c : s.toCharArray()) {
            switch (c) {
                case '&': sb.append("&amp;"); break;
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }

    /** Ma hoa tham so URL (UTF-8). */
    public static String url(String s) {
        return s == null ? "" : URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
