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
    <title>管理员后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h1>欢迎，管理员 <%= user.getUsername() %></h1>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/UserManageServlet">用户管理</a></li>
        <li><a href="${pageContext.request.contextPath}/StudentServlet">学生信息管理</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/admin/scoreManage.jsp">成绩管理</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/admin/queryResult.jsp">成绩查询</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/admin/sortResult.jsp">成绩排序</a></li>
        <li><a href="${pageContext.request.contextPath}/StatServlet">班级统计</a></li>
        <li><a href="${pageContext.request.contextPath}/AnnouncementServlet">公告管理</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/admin/export.jsp">导出Excel</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminProfileServlet">个人中心</a></li>
        <li><a href="${pageContext.request.contextPath}/LogoutServlet">退出登录</a></li>
    </ul>
    <div style="text-align: center; margin-top: 40px;">
        <p>欢迎使用学生成绩管理系统，请从上方菜单选择功能。</p>
    </div>
</div>
</body>
</html>