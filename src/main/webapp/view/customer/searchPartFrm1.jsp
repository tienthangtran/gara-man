<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.PartDAO1, com.ptit.garaman.model.Part1, java.util.List" %>
<% String pageTitle = "Phụ tùng"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    String key = request.getParameter("key");          // null: chua tim kiem (danh sach rong)
    List<Part1> partList = null;
    if (key != null) {
        try (PartDAO1 dao = new PartDAO1()) {
            partList = dao.searchPartByName(key);
        }
    }
%>
<form class="inline" method="get" action="<%= ctx %>/view/customer/searchPartFrm1.jsp">
  <input class="wide" type="text" name="key" value="<%= Fmt1.esc(key) %>" placeholder="Nhập tên phụ tùng (ví dụ: má phanh)" autofocus>
  <button class="btn" type="submit">Tìm kiếm</button>
</form>
<% if (partList != null) {
     if (partList.isEmpty()) { %>
<div class="msg info">Không tìm thấy kết quả phù hợp</div>
<%   } else { %>
<table>
  <tr><th>TT</th><th>Tên phụ tùng</th><th class="num">Giá</th><th class="num">Tồn kho</th></tr>
  <% int i = 0; for (Part1 p : partList) { i++; %>
  <tr class="clickable">
    <td><%= i %></td>
    <td><a href="<%= ctx %>/view/customer/partDetailFrm1.jsp?id=<%= p.getId() %>&amp;key=<%= Fmt1.url(key) %>"><%= Fmt1.esc(p.getName()) %></a></td>
    <td class="num"><%= Fmt1.money(p.getPrice()) %></td>
    <td class="num"><%= p.getRemainingQuantity() %></td>
  </tr>
  <% } %>
</table>
<%   }
   } %>
<div class="actions"><a class="btn back" href="<%= ctx %>/view/customer/customerMainFrm1.jsp">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
