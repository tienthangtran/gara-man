<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String pageTitle = "Chọn loại báo cáo"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="menu">
  <a class="btn" href="<%= ctx %>/view/manager/customerStatisticByRevenueFrm1.jsp">Thống kê khách hàng theo doanh thu</a>
  <a class="btn disabled" href="#" title="Chưa triển khai">Thống kê dịch vụ (chưa triển khai)</a>
  <a class="btn disabled" href="#" title="Chưa triển khai">Thống kê phụ tùng (chưa triển khai)</a>
  <a class="btn disabled" href="#" title="Chưa triển khai">Thống kê nhà cung cấp (chưa triển khai)</a>
</div>
<div class="actions"><a class="btn back" href="<%= ctx %>/view/manager/managerMainFrm1.jsp">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
