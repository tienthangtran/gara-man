<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.PartDAO1, com.ptit.garaman.model.Part1" %>
<% String pageTitle = "Chi tiết phụ tùng"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    String key = request.getParameter("key");
    Integer id = Fmt1.parseId(request.getParameter("id"));
    Part1 part = null;
    if (id != null) {
        try (PartDAO1 dao = new PartDAO1()) {
            part = dao.getPartDetailByID(id);
        }
    }
    String backUrl = ctx + "/view/customer/searchPartFrm1.jsp" + (key == null ? "" : "?key=" + Fmt1.url(key));
%>
<% if (part == null) { %>
<div class="msg err">Không tìm thấy phụ tùng yêu cầu.</div>
<% } else { %>
<div class="info-list">
  <div><b>Tên phụ tùng:</b> <%= Fmt1.esc(part.getName()) %></div>
  <div><b>Giá:</b> <%= Fmt1.money(part.getPrice()) %></div>
  <div><b>Số lượng tồn kho:</b> <%= part.getRemainingQuantity() %></div>
  <div><b>Mô tả:</b></div>
  <div class="desc"><%= Fmt1.esc(part.getDescription()) %></div>
</div>
<% } %>
<div class="actions"><a class="btn back" href="<%= backUrl %>">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
