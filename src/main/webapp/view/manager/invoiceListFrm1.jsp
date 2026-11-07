<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.CustomerDAO1, com.ptit.garaman.dao.InvoiceDAO1, com.ptit.garaman.model.Customer1, com.ptit.garaman.model.Invoice1, java.time.LocalDate, java.util.List" %>
<% String pageTitle = "Thông tin khách hàng"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    Integer customerId = Fmt1.parseId(request.getParameter("customerId"));
    LocalDate startDate = Fmt1.parseIso(request.getParameter("startDate"));
    LocalDate endDate = Fmt1.parseIso(request.getParameter("endDate"));
    Customer1 customer = null;
    List<Invoice1> invoiceList = null;
    double total = 0;
    boolean valid = customerId != null && startDate != null && endDate != null && !startDate.isAfter(endDate);
    if (valid) {
        try (CustomerDAO1 cdao = new CustomerDAO1()) {
            customer = cdao.getCustomerByID(customerId);
        }
        if (customer != null) {
            try (InvoiceDAO1 idao = new InvoiceDAO1()) {
                invoiceList = idao.getInvoiceListByCustomer(customerId, startDate, endDate);
            }
            for (Invoice1 inv : invoiceList) {
                total += inv.getTotalAmount();
            }
        }
    }
    String range = "startDate=" + Fmt1.iso(startDate) + "&amp;endDate=" + Fmt1.iso(endDate);
%>
<% if (customer == null) { %>
<div class="msg err">Thông tin khách hàng hoặc khoảng thời gian không hợp lệ.</div>
<% } else { %>
<div class="info-list">
  <div><b>Tên tài khoản:</b> <%= Fmt1.esc(customer.getUsername()) %></div>
  <div><b>Tên khách hàng:</b> <%= Fmt1.esc(customer.getName()) %></div>
  <div><b>Số điện thoại:</b> <%= Fmt1.esc(customer.getPhoneNumber()) %></div>
  <div><b>Địa chỉ:</b> <%= Fmt1.esc(customer.getAddress()) %></div>
  <div><b>Ngày bắt đầu:</b> <%= Fmt1.date(startDate) %></div>
  <div><b>Ngày kết thúc:</b> <%= Fmt1.date(endDate) %></div>
  <div><b>Tổng tiền hóa đơn:</b> <%= Fmt1.money(total) %></div>
</div>
<% if (invoiceList.isEmpty()) { %>
<div class="msg info">Khách hàng không có hóa đơn nào trong khoảng thời gian đã chọn.</div>
<% } else { %>
<table>
  <tr><th>STT</th><th>Thời gian</th><th>Trạng thái</th><th class="num">Tổng tiền</th><th></th></tr>
  <% int i = 0; for (Invoice1 inv : invoiceList) { i++; %>
  <tr class="clickable">
    <td><%= i %></td>
    <td><%= Fmt1.date(inv.getTime()) %></td>
    <td><%= Fmt1.esc(inv.getStatus()) %></td>
    <td class="num"><%= Fmt1.money(inv.getTotalAmount()) %></td>
    <td><a href="<%= ctx %>/view/manager/invoiceDetailFrm1.jsp?id=<%= inv.getId() %>&amp;customerId=<%= customerId %>&amp;<%= range %>">Xem hóa đơn</a></td>
  </tr>
  <% } %>
</table>
<% } } %>
<div class="actions"><a class="btn back" href="<%= ctx %>/view/manager/customerStatisticByRevenueFrm1.jsp?<%= valid ? range : "" %>">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
