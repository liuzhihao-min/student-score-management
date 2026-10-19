<%@ page import="com.bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.util.PageBean, com.bean.Student, java.util.*" %>
<%
    PageBean<Student> pageBean = (PageBean<Student>) request.getAttribute("pageBean");
    if (pageBean == null) {
        out.println("<p class='error-msg'>无法加载学生数据</p>");
        pageBean = new PageBean<>(1, 10, 0, new ArrayList<>());
    }
    List<Student> studentList = pageBean.getList();

    String msgCode = request.getParameter("msg");
    String errCode = request.getParameter("error");
    String msg = "", error = "";
    if ("add_success".equals(msgCode)) msg = "添加学生成功";
    else if ("delete_success".equals(msgCode)) msg = "删除学生成功";
    else if ("add_failed".equals(errCode)) error = "添加失败，学号可能已存在";
    else if ("empty".equals(errCode)) error = "学号不能为空";
%>
<!DOCTYPE html>
<html>
<head>
    <title>学生信息管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h2>学生信息管理</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
    </ul>

    <% if (!msg.isEmpty()) { %>
        <div class="success-msg"><%= msg %></div>
    <% } %>
    <% if (!error.isEmpty()) { %>
        <div class="error-msg"><%= error %></div>
    <% } %>

    <h3>新增学生</h3>
    <form action="${pageContext.request.contextPath}/StudentServlet" method="post">
        <input type="hidden" name="action" value="add">
        学号: <input type="text" name="stuId" required>
        姓名: <input type="text" name="name" required>
        班级: <input type="text" name="className" required>
        <button type="submit">添加</button>
    </form>

    <h3>学生列表</h3>
    <table>
        <tr><th>学号</th><th>姓名</th><th>班级</th><th>操作</th></tr>
        <% for (Student s : studentList) { %>
        <tr>
            <td><%= s.getStuId() %></td>
            <td><%= s.getName() %></td>
            <td><%= s.getClassName() %></td>
            <td><a href="javascript:void(0);" onclick="showDeleteModal('${pageContext.request.contextPath}/StudentServlet?action=delete&stuId=<%= s.getStuId() %>')">删除</a></td>
        </tr>
        <% } %>
    </table>

    <div class="pagination">
        <a href="?page=1">首页</a>
        <% if (pageBean.hasPrevious()) { %>
            <a href="?page=<%= pageBean.getCurrentPage() - 1 %>">上一页</a>
        <% } %>
        <span><%= pageBean.getCurrentPage() %> / <%= pageBean.getTotalPage() %></span>
        <% if (pageBean.hasNext()) { %>
            <a href="?page=<%= pageBean.getCurrentPage() + 1 %>">下一页</a>
        <% } %>
        <a href="?page=<%= pageBean.getTotalPage() %>">末页</a>
        <span>共 <%= pageBean.getTotalCount() %> 条</span>
    </div>
</div>
<!-- 自定义删除确认模态框 -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">⚠️ 确认删除</div>
        <div class="modal-body">
            确定要删除这条记录吗？删除后无法恢复。
        </div>
        <div class="modal-footer">
            <button class="btn-cancel" id="modalCancelBtn">取消</button>
            <button class="btn-confirm" id="modalConfirmBtn">确认删除</button>
        </div>
    </div>
</div>

<script>
    // 模态框逻辑
    (function() {
        var modal = document.getElementById('deleteModal');
        var confirmBtn = document.getElementById('modalConfirmBtn');
        var cancelBtn = document.getElementById('modalCancelBtn');
        var pendingUrl = null;  // 存储待跳转的删除链接

        // 显示模态框，并记录要删除的 URL
        window.showDeleteModal = function(url) {
            pendingUrl = url;
            modal.style.display = 'block';
        };

        // 隐藏模态框
        function hideModal() {
            modal.style.display = 'none';
            pendingUrl = null;
        }

        // 确认删除：跳转到 pendingUrl
        confirmBtn.onclick = function() {
            if (pendingUrl) {
                window.location.href = pendingUrl;
            }
            hideModal();
        };

        // 取消删除
        cancelBtn.onclick = function() {
            hideModal();
        };

        // 点击模态框背景（半透明层）也关闭
        window.onclick = function(event) {
            if (event.target === modal) {
                hideModal();
            }
        };
    })();
</script>
</body>
</html>