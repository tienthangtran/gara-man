<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ptit.garaman.dao.ServiceDAO1, com.ptit.garaman.model.Service1" %>
<% String pageTitle = "Chi tiết dịch vụ"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<%
    String key = request.getParameter("key");
    Integer id = Fmt1.parseId(request.getParameter("id"));
    Service1 service = null;
    if (id != null) {
        try (ServiceDAO1 dao = new ServiceDAO1()) {
            service = dao.getServiceDetailByID(id);
        }
    }
    String backUrl = ctx + "/view/customer/searchServiceFrm1.jsp" + (key == null ? "" : "?key=" + Fmt1.url(key));
%>
<% if (service == null) { %>
<div class="msg err">Không tìm thấy dịch vụ yêu cầu.</div>
<% } else { %>
<div class="info-list">
  <div><b>Tên dịch vụ:</b> <%= Fmt1.esc(service.getName()) %></div>
  <div><b>Giá:</b> <%= Fmt1.money(service.getPrice()) %></div>
  <div><b>Mô tả:</b></div>
  <div class="desc"><%= Fmt1.esc(service.getDescription()) %></div>
</div>
<% } %>
<div class="actions"><a class="btn back" href="<%= backUrl %>">Quay lại</a></div>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
