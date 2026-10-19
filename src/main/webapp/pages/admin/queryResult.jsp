<%@ page import="com.bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.Student, com.bean.Score, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>成绩查询</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h2>成绩查询</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
    </ul>

    <form action="${pageContext.request.contextPath}/QueryServlet" method="get">
        <select name="type">
            <option value="stuId">按学号精确查询</option>
            <option value="name">按姓名模糊查询</option>
        </select>
        <input type="text" name="keyword" placeholder="请输入学号或姓名" required>
        <button type="submit">查询</button>
    </form>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) out.println("<div class='error-msg'>" + error + "</div>");
        Student stu = (Student) request.getAttribute("student");
        List<Score> scores = (List<Score>) request.getAttribute("scores");
        if (stu != null) {
    %>
        <h3>学生：<%= stu.getName() %>（<%= stu.getStuId() %>，<%= stu.getClassName() %>）</h3>
        <table>
            <tr><th>课程</th><th>分数</th><th>考试日期</th></tr>
            <% for (Score s : scores) { %>
            <tr><td><%= s.getCourseName() %></td><td class="<%= s.getScore()<60 ? "fail":"" %>"><%= s.getScore() %></td><td><%= s.getExamDate() %></td></tr>
            <% } %>
        </table>
    <%
        } else {
            List<Student> studentList = (List<Student>) request.getAttribute("studentList");
            if (studentList != null && !studentList.isEmpty()) {
    %>
        <h3>匹配的学生：</h3>
        <ul>
            <% for (Student s : studentList) { %>
                <li><%= s.getName() %>（<%= s.getStuId() %>）- <%= s.getClassName() %></li>
            <% } %>
        </ul>
        <h3>所有成绩：</h3>
        <table>
            <tr><th>学号</th><th>姓名</th><th>课程</th><th>分数</th><th>考试日期</th></tr>
            <% if (scores != null) for (Score s : scores) { %>
            <tr>
                <td><%= s.getStuId() %></td><td><%= s.getStudentName() %></td><td><%= s.getCourseName() %></td>
                <td class="<%= s.getScore()<60 ? "fail":"" %>"><%= s.getScore() %></td><td><%= s.getExamDate() %></td>
            </tr>
            <% } %>
        </table>
    <% } } %>
</div>
</body>
</html>