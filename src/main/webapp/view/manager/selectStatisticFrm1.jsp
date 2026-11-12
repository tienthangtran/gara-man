<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String pageTitle = "Chọn loại báo cáo"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<div class="menu">
  <a class="btn" href="<%= ctx %>/view/manager/customerStatisticByRevenueFrm1.jsp">Thống kê khách hàng theo doanh thu</a>
</div>
<div class="actions"><a class="btn back" href="<%= ctx %>/view/manager/managerMainFrm1.jsp">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
