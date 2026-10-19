<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.User, com.util.PageBean, java.util.*" %>
<%
    // 登录验证
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"admin".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    PageBean<User> pageBean = (PageBean<User>) request.getAttribute("pageBean");
    if (pageBean == null) {
        out.println("<p class='error-msg'>无法加载用户数据</p>");
        pageBean = new PageBean<>(1, 10, 0, new ArrayList<>());
    }
    List<User> userList = pageBean.getList();

    String msgCode = request.getParameter("msg");
    String errCode = request.getParameter("error");
    String msg = "", error = "";
    if ("add_success".equals(msgCode)) msg = "添加用户成功";
    else if ("delete_success".equals(msgCode)) msg = "删除用户成功";
    else if ("update_success".equals(msgCode)) msg = "密码修改成功";
    else if ("add_failed".equals(errCode)) error = "添加失败，用户名可能已存在";
    else if ("empty".equals(errCode)) error = "用户名和密码不能为空";
    else if ("empty_password".equals(errCode)) error = "新密码不能为空";
%>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h2>系统用户管理</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
    </ul>

    <% if (!msg.isEmpty()) { %>
        <div class="success-msg"><%= msg %></div>
    <% } %>
    <% if (!error.isEmpty()) { %>
        <div class="error-msg"><%= error %></div>
    <% } %>

    <h3>添加新用户</h3>
    <form action="${pageContext.request.contextPath}/UserManageServlet" method="post">
        <input type="hidden" name="action" value="add">
        用户名: <input type="text" name="username" required><br>
        密码: <input type="password" name="password" required><br>
        角色: <select name="role"><option value="student">学生</option><option value="admin">管理员</option></select><br>
        关联学号（学生必填）: <input type="text" name="relatedId"><br>
        <button type="submit">添加用户</button>
    </form>

    <h3>用户列表</h3>
    <table>
        <tr><th>ID</th><th>用户名</th><th>角色</th><th>关联学号</th><th>操作</th></tr>
        <% for (User u : userList) { %>
        <tr>
            <td><%= u.getUserId() %></td>
            <td><%= u.getUsername() %></td>
            <td><%= u.getRole() %></td>
            <td><%= u.getRelatedId() != null ? u.getRelatedId() : "" %></td>
            <td>
                <a href="javascript:void(0);" onclick="showDeleteModal('${pageContext.request.contextPath}/UserManageServlet?action=delete&userId=<%= u.getUserId() %>')">删除</a>
                <form action="${pageContext.request.contextPath}/UserManageServlet" method="post" style="display:inline">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                    <input type="text" name="newPassword" placeholder="新密码" required>
                    <button type="submit">改密</button>
                </form>
             </td>
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
        <div class="modal-body">确定要删除这条记录吗？删除后无法恢复。</div>
        <div class="modal-footer">
            <button class="btn-cancel" id="modalCancelBtn">取消</button>
            <button class="btn-confirm" id="modalConfirmBtn">确认删除</button>
        </div>
    </div>
</div>
<script>
    (function() {
        var modal = document.getElementById('deleteModal');
        var confirmBtn = document.getElementById('modalConfirmBtn');
        var cancelBtn = document.getElementById('modalCancelBtn');
        var pendingUrl = null;
        window.showDeleteModal = function(url) { pendingUrl = url; modal.style.display = 'block'; };
        function hideModal() { modal.style.display = 'none'; pendingUrl = null; }
        confirmBtn.onclick = function() { if(pendingUrl) window.location.href = pendingUrl; hideModal(); };
        cancelBtn.onclick = function() { hideModal(); };
        window.onclick = function(event) { if(event.target === modal) hideModal(); };
    })();
</script>
</body>
</html>