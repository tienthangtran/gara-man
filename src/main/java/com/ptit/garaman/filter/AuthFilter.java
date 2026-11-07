package com.ptit.garaman.filter;

import com.ptit.garaman.model.Member1;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Dat UTF-8 cho request va kiem tra quyen truy cap:
 *  /view/customer/*  -> chi role "customer"
 *  /view/manager/*   -> chi role "manager"
 * Chua dang nhap -> chuyen ve login1.jsp; sai quyen -> ve index1.jsp (tu dieu huong theo role).
 */
public class AuthFilter implements Filter {
    public static final String SESSION_MEMBER = "member";

    // Bat buoc khai bao: Servlet 3.1 (Jetty 9.4) khong co ban mac dinh cua init/destroy nhu Servlet 4.0
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        HttpServletRequest r = (HttpServletRequest) req;
        HttpServletResponse resp = (HttpServletResponse) res;
        String path = r.getRequestURI().substring(r.getContextPath().length());

        String required = null;
        if (path.startsWith("/view/customer/")) {
            required = "customer";
        } else if (path.startsWith("/view/manager/")) {
            required = "manager";
        }
        if (required != null) {
            HttpSession session = r.getSession(false);
            Member1 m = session == null ? null : (Member1) session.getAttribute(SESSION_MEMBER);
            if (m == null) {
                resp.sendRedirect(r.getContextPath() + "/login1.jsp");
                return;
            }
            if (!required.equals(m.getRole())) {
                resp.sendRedirect(r.getContextPath() + "/index1.jsp");
                return;
            }
        }
        chain.doFilter(req, res);
    }
}
