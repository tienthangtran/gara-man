<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.MemberDAO1, com.ptit.garaman.model.Member1" %>
<%
    String ctx = request.getContextPath();
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(ctx + "/login1.jsp");
        return;
    }
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
        response.sendRedirect(ctx + "/login1.jsp?error=2");
        return;
    }
    Member1 m;
    try (MemberDAO1 dao = new MemberDAO1()) {
        m = dao.checkLogin(username, password);
    }
    if (m == null) {
        response.sendRedirect(ctx + "/login1.jsp?error=1");
        return;
    }
    // Chong session fixation: tao session moi sau khi dang nhap
    HttpSession old = request.getSession(false);
    if (old != null) {
        old.invalidate();
    }
    request.getSession(true).setAttribute("member", m);
    response.sendRedirect(ctx + "/index1.jsp");
%>
