<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>发布公告</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 6px; }
        textarea { height: 200px; }
    </style>
</head>
<body>
<div class="container">
    <h2>发布新公告</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/AnnouncementServlet">返回公告列表</a></li>
    </ul>
    <form action="${pageContext.request.contextPath}/AnnouncementServlet" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label>标题</label>
            <input type="text" name="title" required>
        </div>
        <div class="form-group">
            <label>内容</label>
            <textarea name="content" required></textarea>
        </div>
        <button type="submit">发布</button>
    </form>
</div>
</body>
</html>