<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.CustomerStatisticDAO1, com.ptit.garaman.model.CustomerStatistic1, java.time.LocalDate, java.util.List" %>
<% String pageTitle = "Thống kê khách hàng theo doanh thu"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    String sStart = request.getParameter("startDate");
    String sEnd = request.getParameter("endDate");
    boolean submitted = sStart != null || sEnd != null;
    LocalDate startDate = Fmt1.parseIso(sStart);
    LocalDate endDate = Fmt1.parseIso(sEnd);
    String error = null;
    List<CustomerStatistic1> customerStatistic = null;
    if (submitted) {
        if (startDate == null || endDate == null) {
            error = "Vui lòng chọn đầy đủ ngày bắt đầu và ngày kết thúc.";
        } else if (startDate.isAfter(endDate)) {
            error = "Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.";
        } else {
            try (CustomerStatisticDAO1 dao = new CustomerStatisticDAO1()) {
                customerStatistic = dao.getCustomerStatisticByRevenue(startDate, endDate);
            }
        }
    }
%>
<form class="inline" method="get" action="<%= ctx %>/view/manager/customerStatisticByRevenueFrm1.jsp">
  <label for="startDate">Ngày bắt đầu</label>
  <input type="date" id="startDate" name="startDate" value="<%= Fmt1.iso(startDate) %>" required>
  <label for="endDate">Ngày kết thúc</label>
  <input type="date" id="endDate" name="endDate" value="<%= Fmt1.iso(endDate) %>" required>
  <button class="btn" type="submit">Xem thống kê</button>
</form>
<% if (error != null) { %>
<div class="msg err"><%= Fmt1.esc(error) %></div>
<% } else if (customerStatistic != null) {
     if (customerStatistic.isEmpty()) { %>
<div class="msg info">Không có dữ liệu doanh thu trong khoảng thời gian đã chọn</div>
<%   } else { %>
<table>
  <tr><th>STT</th><th>Tài khoản</th><th>Khách hàng</th><th>Số điện thoại</th><th class="num">Số hóa đơn</th><th class="num">Doanh thu</th></tr>
  <% int i = 0; for (CustomerStatistic1 c : customerStatistic) { i++; %>
  <tr class="clickable">
    <td><%= i %></td>
    <td><a href="<%= ctx %>/view/manager/invoiceListFrm1.jsp?customerId=<%= c.getId() %>&amp;startDate=<%= Fmt1.iso(startDate) %>&amp;endDate=<%= Fmt1.iso(endDate) %>"><%= Fmt1.esc(c.getUsername()) %></a></td>
    <td><%= Fmt1.esc(c.getName()) %></td>
    <td><%= Fmt1.esc(c.getPhoneNumber()) %></td>
    <td class="num"><%= c.getAmount() %></td>
    <td class="num"><%= Fmt1.money(c.getRevenue()) %></td>
  </tr>
  <% } %>
</table>
<%   }
   } %>
<div class="actions"><a class="btn back" href="<%= ctx %>/view/manager/selectStatisticFrm1.jsp">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
