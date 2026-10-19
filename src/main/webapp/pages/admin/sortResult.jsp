<%@ page import="com.bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.Course, com.bean.Score, com.dao.CourseDao, java.util.*" %>
<%
    CourseDao courseDao = new CourseDao();
    List<Course> courses = courseDao.getAllCourses();
%>
<!DOCTYPE html>
<html>
<head>
    <title>成绩排序</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h2>成绩排序</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
    </ul>

    <h3>按课程分数排序</h3>
    <form action="${pageContext.request.contextPath}/SortServlet" method="get">
        <input type="hidden" name="type" value="course">
        课程: <select name="courseId">
            <% for (Course c : courses) { %>
                <option value="<%= c.getCourseId() %>"><%= c.getCourseName() %></option>
            <% } %>
        </select>
        排序: <select name="order"><option value="asc">升序</option><option value="desc">降序</option></select>
        <button type="submit">排序</button>
    </form>

    <h3>按平均分排序</h3>
    <form action="${pageContext.request.contextPath}/SortServlet" method="get">
        <input type="hidden" name="type" value="avg">
        排序: <select name="order"><option value="asc">升序</option><option value="desc">降序</option></select>
        <button type="submit">排序</button>
    </form>

    <%
        List<Score> sortedScores = (List<Score>) request.getAttribute("sortedScores");
        Course course = (Course) request.getAttribute("course");
        String order = (String) request.getAttribute("order");
        if (sortedScores != null && course != null) {
    %>
        <h3><%= course.getCourseName() %> 成绩排序（<%= "asc".equals(order) ? "升序" : "降序" %>）</h3>
        <table><tr><th>学号</th><th>姓名</th><th>分数</th></tr>
        <% for (Score s : sortedScores) { %>
        <tr><td><%= s.getStuId() %></td><td><%= s.getStudentName() %></td><td class="<%= s.getScore()<60 ? "fail":"" %>"><%= s.getScore() %></td></tr>
        <% } %></table>
    <%
        }
        List<Map<String, Object>> avgList = (List<Map<String, Object>>) request.getAttribute("avgList");
        if (avgList != null) {
    %>
        <h3>平均分排序（<%= "asc".equals(order) ? "升序" : "降序" %>）</h3>
        <table><tr><th>学号</th><th>姓名</th><th>平均分</th></tr>
        <% for (Map<String, Object> map : avgList) { %>
        <tr><td><%= map.get("stuId") %></td><td><%= map.get("name") %></td><td><%= map.get("avgScore") %></td></tr>
        <% } %></table>
    <% } %>
</div>
</body>
</html>>