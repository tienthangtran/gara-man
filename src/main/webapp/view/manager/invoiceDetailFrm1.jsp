<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.InvoiceDAO1, com.ptit.garaman.model.Invoice1, com.ptit.garaman.model.InvoicePart1, com.ptit.garaman.model.InvoiceService1" %>
<% String pageTitle = "Chi tiết hóa đơn"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    Integer id = Fmt1.parseId(request.getParameter("id"));
    Integer customerId = Fmt1.parseId(request.getParameter("customerId"));
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    Invoice1 invoice = null;
    if (id != null) {
        try (InvoiceDAO1 dao = new InvoiceDAO1()) {
            invoice = dao.getInvoiceDetailByID(id);
        }
    }
    String backUrl = ctx + "/view/manager/invoiceListFrm1.jsp";
    if (customerId != null && Fmt1.parseIso(startDate) != null && Fmt1.parseIso(endDate) != null) {
        backUrl += "?customerId=" + customerId + "&amp;startDate=" + Fmt1.iso(Fmt1.parseIso(startDate))
                + "&amp;endDate=" + Fmt1.iso(Fmt1.parseIso(endDate));
    } else {
        backUrl = ctx + "/view/manager/customerStatisticByRevenueFrm1.jsp";
    }
%>
<% if (invoice == null) { %>
<div class="msg err">Không tìm thấy hóa đơn yêu cầu.</div>
<% } else { %>
<div class="info-list">
  <div><b>Thời gian:</b> <%= Fmt1.date(invoice.getTime()) %></div>
  <div><b>Trạng thái:</b> <%= Fmt1.esc(invoice.getStatus()) %></div>
  <div><b>Nhân viên bán hàng:</b> <%= Fmt1.esc(invoice.getSalesman().getName()) %></div>
  <div><b>Khách hàng:</b> <%= Fmt1.esc(invoice.getCustomer().getName()) %></div>
  <div><b>Biển xe:</b> <%= Fmt1.esc(invoice.getVehicle().getLicensePlate()) %>
    <% if (invoice.getVehicle().getDescription() != null) { %>(<%= Fmt1.esc(invoice.getVehicle().getDescription()) %>)<% } %></div>
</div>

<h2>Hóa đơn dịch vụ</h2>
<table>
  <tr><th>STT</th><th>Tên</th><th>Kỹ thuật viên</th><th class="num">Giá</th><th class="num">Số lượng</th><th class="num">Tổng tiền</th></tr>
  <% int i = 0; for (InvoiceService1 d : invoice.getInvoiceServiceList()) { i++; %>
  <tr>
    <td><%= i %></td>
    <td><%= Fmt1.esc(d.getService().getName()) %></td>
    <td><%= Fmt1.esc(d.getMechanic().getName()) %></td>
    <td class="num"><%= Fmt1.money(d.getUnitPrice()) %></td>
    <td class="num"><%= d.getQuantity() %></td>
    <td class="num"><%= Fmt1.money(d.getTotalAmount()) %></td>
  </tr>
  <% } if (i == 0) { %><tr><td colspan="6"><i>Không có dịch vụ.</i></td></tr><% } %>
</table>

<h2>Hóa đơn phụ tùng</h2>
<table>
  <tr><th>STT</th><th>Tên</th><th class="num">Giá</th><th class="num">Số lượng</th><th class="num">Tổng tiền</th></tr>
  <% int j = 0; for (InvoicePart1 d : invoice.getInvoicePartList()) { j++; %>
  <tr>
    <td><%= j %></td>
    <td><%= Fmt1.esc(d.getPart().getName()) %></td>
    <td class="num"><%= Fmt1.money(d.getUnitPrice()) %></td>
    <td class="num"><%= d.getQuantity() %></td>
    <td class="num"><%= Fmt1.money(d.getTotalAmount()) %></td>
  </tr>
  <% } if (j == 0) { %><tr><td colspan="5"><i>Không có phụ tùng.</i></td></tr><% } %>
</table>
<div class="total">Tổng tiền: <%= Fmt1.money(invoice.getTotalAmount()) %></div>
<% } %>
<div class="actions"><a class="btn back" href="<%= backUrl %>">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
