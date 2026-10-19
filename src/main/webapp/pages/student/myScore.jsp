<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.User, com.bean.Score, com.bean.Course, com.dao.ScoreDao, com.dao.StudentDao, com.dao.CourseDao, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"student".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    StudentDao studentDao = new StudentDao();
    com.bean.Student currentStudent = studentDao.findByStuId(user.getRelatedId());

    List<Score> scores = (List<Score>) request.getAttribute("scores");
    if (scores == null) {
        ScoreDao scoreDao = new ScoreDao();
        scores = scoreDao.getScoresByStudent(user.getRelatedId());
    }
    
    CourseDao courseDao = new CourseDao();
    List<Course> courseList = (List<Course>) request.getAttribute("courseList");
    if (courseList == null) {
        courseList = courseDao.getAllCourses();
    }
    
    String selectedYear = (String) request.getAttribute("selectedYear");
    String selectedCourse = (String) request.getAttribute("selectedCourse");
    
    Set<Integer> yearSet = new TreeSet<>(Collections.reverseOrder());
    for (Score s : scores) {
        if (s.getExamDate() != null) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(s.getExamDate());
            yearSet.add(cal.get(java.util.Calendar.YEAR));
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>我的成绩</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .filter-form {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .filter-form div { display: flex; flex-direction: column; }
        .filter-form label { font-size: 12px; margin-bottom: 4px; }
        .btn-export { background: #28a745; }
        .btn-export:hover { background: #218838; }
        .student-info { font-size: 14px; color: gray; margin-left: 15px; font-weight: normal; }
    </style>
</head>
<body>
<div class="container">
    <h2>
        学生：<%= user.getUsername() %>
        <span class="student-info">
            学号：<%= currentStudent.getStuId() %> | 班级：<%= currentStudent.getClassName() %>
        </span>
    </h2>
    <ul class="menu menu-student">
        <li><a href="${pageContext.request.contextPath}/StudentScoreServlet">刷新</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/student/announcements.jsp">公告中心</a></li>
        <li><a href="${pageContext.request.contextPath}/StudentProfileServlet">个人中心</a></li>
        <li><a href="${pageContext.request.contextPath}/StudentScoreServlet?action=export" class="btn-export">导出我的成绩 (CSV)</a></li>
        <li><a href="${pageContext.request.contextPath}/LogoutServlet">退出登录</a></li>
    </ul>

    <form action="${pageContext.request.contextPath}/StudentScoreServlet" method="post" class="filter-form">
        <div>
            <label>年份</label>
            <select name="year">
                <option value="">全部</option>
                <% for (Integer y : yearSet) { %>
                    <option value="<%= y %>" <%= (selectedYear != null && Integer.toString(y).equals(selectedYear)) ? "selected" : "" %>><%= y %></option>
                <% } %>
            </select>
        </div>
        <div>
            <label>课程</label>
            <select name="courseId">
                <option value="">全部</option>
                <% for (Course c : courseList) { %>
                    <option value="<%= c.getCourseId() %>" <%= (selectedCourse != null && selectedCourse.equals(String.valueOf(c.getCourseId()))) ? "selected" : "" %>><%= c.getCourseName() %></option>
                <% } %>
            </select>
        </div>
        <button type="submit">查询</button>
    </form>

    <h3>成绩列表</h3>
    <% if (scores.isEmpty()) { %>
        <p>暂无成绩数据。</p>
    <% } else { %>
        <table border="1">
            <tr><th>课程</th><th>分数</th><th>考试日期</th></tr>
            <% for (Score s : scores) { %>
            <tr>
                <td><%= s.getCourseName() %></td>
                <td class="<%= s.getScore() < 60 ? "fail" : "" %>"><%= s.getScore() %></td>
                <td><%= s.getExamDate() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>
</div>
</body>
</html>>