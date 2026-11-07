<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession s = request.getSession(false);
    if (s != null) {
        s.invalidate();
    }
    response.sendRedirect(request.getContextPath() + "/login1.jsp");
%>
