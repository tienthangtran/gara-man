<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.ServiceDAO1, com.ptit.garaman.model.Service1, java.util.List" %>
<% String pageTitle = "Dịch vụ"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    String key = request.getParameter("key");          // null: chua tim kiem (danh sach rong)
    List<Service1> serviceList = null;
    if (key != null) {
        try (ServiceDAO1 dao = new ServiceDAO1()) {
            serviceList = dao.searchServiceByName(key);
        }
    }
%>
<form class="inline" method="get" action="<%= ctx %>/view/customer/searchServiceFrm1.jsp">
  <input class="wide" type="text" name="key" value="<%= Fmt1.esc(key) %>" placeholder="Nhập tên dịch vụ (ví dụ: thay dầu)" autofocus>
  <button class="btn" type="submit">Tìm kiếm</button>
</form>
<% if (serviceList != null) {
     if (serviceList.isEmpty()) { %>
<div class="msg info">Không tìm thấy kết quả phù hợp</div>
<%   } else { %>
<table>
  <tr><th>TT</th><th>Tên dịch vụ</th><th class="num">Giá</th></tr>
  <% int i = 0; for (Service1 s : serviceList) { i++; %>
  <tr class="clickable">
    <td><%= i %></td>
    <td><a href="<%= ctx %>/view/customer/serviceDetailFrm1.jsp?id=<%= s.getId() %>&amp;key=<%= Fmt1.url(key) %>"><%= Fmt1.esc(s.getName()) %></a></td>
    <td class="num"><%= Fmt1.money(s.getPrice()) %></td>
  </tr>
  <% } %>
</table>
<%   }
   } %>
<div class="actions"><a class="btn back" href="<%= ctx %>/view/customer/customerMainFrm1.jsp">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
