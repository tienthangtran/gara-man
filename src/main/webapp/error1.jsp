<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% String pageTitle = "Đã xảy ra lỗi"; response.setStatus(500); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    // Lay nguyen nhan goc (Caused by cuoi cung) de de tim loi
    String rootMsg = null;
    Throwable t = exception;
    while (t != null) {
        if (t.getMessage() != null && !(t.getClass().getName().startsWith("org.apache.jasper"))) {
            rootMsg = t.getClass().getSimpleName() + ": " + t.getMessage();
        }
        t = t.getCause();
    }
%>
<div class="msg err">Hệ thống gặp lỗi khi xử lý yêu cầu.
  <% if (rootMsg != null) { %><br><b>Nguyên nhân:</b> <%= Fmt1.esc(rootMsg) %><% } %></div>
<p>Nếu là lỗi kết nối cơ sở dữ liệu: kiểm tra MySQL (XAMPP) đang chạy, đã import <code>garaman.sql</code>,
   và <code>db.user</code>, <code>db.password</code>, <code>db.url</code> trong <code>db.properties</code>.</p>
<div class="actions"><a class="btn back" href="<%= ctx %>/index1.jsp">Về trang chính</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
