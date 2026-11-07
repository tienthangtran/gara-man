<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.model.Member1" %>
<%
    Member1 m = (Member1) session.getAttribute("member");
    String base = request.getContextPath();
    if (m == null) {
        response.sendRedirect(base + "/login1.jsp");
    } else if ("manager".equals(m.getRole())) {
        response.sendRedirect(base + "/view/manager/managerMainFrm1.jsp");
    } else if ("customer".equals(m.getRole())) {
        response.sendRedirect(base + "/view/customer/customerMainFrm1.jsp");
    } else {
        String pageTitle = "Chưa hỗ trợ";
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="msg info">Tài khoản vai trò "<%= Fmt1.esc(m.getRole()) %>" chưa có giao diện trong phiên bản này
  (các module đã triển khai: Khách hàng - tìm kiếm dịch vụ/phụ tùng; Quản lý - thống kê khách hàng theo doanh thu).</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
<%  } %>
