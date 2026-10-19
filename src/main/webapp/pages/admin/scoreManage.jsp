<%@ page import="com.bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.Student, com.bean.Course, com.dao.StudentDao, com.dao.CourseDao, java.util.*" %>
<%
    StudentDao studentDao = new StudentDao();
    CourseDao courseDao = new CourseDao();
    List<Student> students = studentDao.getAllStudents();
    List<Course> courses = courseDao.getAllCourses();
    String msgCode = request.getParameter("msg");
    String errorMsg = (String) request.getAttribute("error");
    String msg = "";
    if ("success".equals(msgCode)) msg = "成绩保存成功！";
%>
<!DOCTYPE html>
<html>
<head>
    <title>成绩管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h2>成绩录入/修改</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
    </ul>

    <form action="${pageContext.request.contextPath}/ScoreServlet" method="post">
        <input type="hidden" name="action" value="addOrUpdate">
        选择学生: <select name="stuId">
            <% for (Student s : students) { %>
                <option value="<%= s.getStuId() %>"><%= s.getName() %>（<%= s.getStuId() %>）</option>
            <% } %>
        </select><br>
        选择课程: <select name="courseId">
            <% for (Course c : courses) { %>
                <option value="<%= c.getCourseId() %>"><%= c.getCourseName() %></option>
            <% } %>
        </select><br>
        分数: <input type="number" name="score" step="0.1" min="0" max="100" required><br>
        考试日期: <input type="date" name="examDate" required><br>
        <button type="submit">保存成绩</button>
    </form>

    <p class="success-msg">${param.msg}</p>
    <p class="error-msg">${error}</p>
</div>
</body>
</html>