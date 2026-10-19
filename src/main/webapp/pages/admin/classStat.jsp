<%@ page import="com.bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>班级统计</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .charts-container {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            justify-content: center;
            margin-top: 30px;
        }
        .chart-box {
            flex: 1;
            min-width: 300px;
            background: white;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        canvas {
            max-height: 300px;
            width: 100%;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>班级成绩统计（平均分 & 及格率）</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
    </ul>

    <form action="${pageContext.request.contextPath}/StatServlet" method="get">
        班级: <select name="className">
            <option value="">请选择</option>
            <%
                List<String> classList = (List<String>) request.getAttribute("classList");
                if (classList != null) {
                    for (String cls : classList) {
            %>
                <option value="<%= cls %>" <%= cls.equals(request.getParameter("className")) ? "selected" : "" %>><%= cls %></option>
            <%  }
            } %>
        </select>
        <button type="submit">统计</button>
    </form>

    <%
        Map<String, Object> stat = (Map<String, Object>) request.getAttribute("stat");
        if (stat != null) {
            double avg = (Double) stat.get("avgScore");
            double passRate = (Double) stat.get("passRate") * 100;
            String selectedClass = (String) request.getAttribute("selectedClass");
            int[] buckets = (int[]) request.getAttribute("buckets");
    %>
        <h3>班级：<%= selectedClass %></h3>
        <p>平均分：<%= String.format("%.2f", avg) %></p>
        <p>及格率：<%= String.format("%.2f", passRate) %>%</p>

        <div class="charts-container">
            <!-- 扇形图 -->
            <div class="chart-box">
                <canvas id="pieChart" width="400" height="300"></canvas>
            </div>
            <!-- 直方图 -->
            <div class="chart-box">
                <canvas id="barChart" width="400" height="300"></canvas>
            </div>
        </div>

        <script>
            // 分数段标签
            const labels = ['0-20分', '20-40分', '40-60分', '60-80分', '80-100分'];
            const dataValues = <%= Arrays.toString(buckets) %>;

            // 扇形图
            const pieCtx = document.getElementById('pieChart').getContext('2d');
            new Chart(pieCtx, {
                type: 'pie',
                data: {
                    labels: labels,
                    datasets: [{
                        data: dataValues,
                        backgroundColor: ['#ff6384', '#ffce56', '#4bc0c0', '#36a2eb', '#9966ff']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'bottom' },
                        title: { display: true, text: '分数段分布（扇形图）' }
                    }
                }
            });

            // 直方图（柱状图）
            const barCtx = document.getElementById('barChart').getContext('2d');
            new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '人数',
                        data: dataValues,
                        backgroundColor: '#36a2eb',
                        borderColor: '#1e88e5',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: { beginAtZero: true, stepSize: 1, title: { display: true, text: '学生人数' } }
                    },
                    plugins: {
                        title: { display: true, text: '分数段分布（直方图）' }
                    }
                }
            });
        </script>
    <%
        } else if (request.getParameter("className") != null && !request.getParameter("className").isEmpty()) {
    %>
        <div class="error-msg">暂无成绩数据</div>
    <% } %>
</div>
</body>
</html>