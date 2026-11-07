<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String pageTitle = "Đăng nhập"; %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<% if ("1".equals(request.getParameter("error"))) { %>
<div class="msg err">Sai tên đăng nhập hoặc mật khẩu.</div>
<% } else if ("2".equals(request.getParameter("error"))) { %>
<div class="msg err">Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.</div>
<% } %>
<form class="login-form" method="post" action="<%= ctx %>/doLogin1.jsp">
  <label for="username">Tên đăng nhập</label>
  <input type="text" id="username" name="username" autofocus required>
  <label for="password">Mật khẩu</label>
  <input type="password" id="password" name="password" required>
  <button class="btn" type="submit">Đăng nhập</button>
</form>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
