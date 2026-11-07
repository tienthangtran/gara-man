<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String pageTitle = "Trang khách hàng"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="menu">
  <a class="btn" href="<%= ctx %>/view/customer/searchServiceFrm1.jsp">Tìm kiếm thông tin dịch vụ</a>
  <a class="btn" href="<%= ctx %>/view/customer/searchPartFrm1.jsp">Tìm kiếm thông tin phụ tùng</a>
</div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
