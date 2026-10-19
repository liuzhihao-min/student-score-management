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
    <title>管理员个人中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .profile-container { display: flex; gap: 30px; flex-wrap: wrap; margin-top: 20px; }
        .profile-card { flex: 1; min-width: 280px; background: white; border-radius: 16px; padding: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .avatar-preview { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #007bff; margin-bottom: 15px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 6px; }
        button { background: #007bff; color: white; border: none; padding: 8px 16px; border-radius: 30px; cursor: pointer; }
        .success-msg { color: green; background: #e6ffed; padding: 8px; border-radius: 6px; margin-bottom: 15px; }
        .error-msg { color: red; background: #ffe6e6; padding: 8px; border-radius: 6px; margin-bottom: 15px; }
        .info-msg { color: #856404; background: #fff3cd; padding: 8px; border-radius: 6px; margin-bottom: 15px; }
    </style>
</head>
<body>
<div class="container">
    <h2>个人中心 - 管理员</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
        <li><a href="${pageContext.request.contextPath}/LogoutServlet">退出登录</a></li>
    </ul>

    <% if (request.getAttribute("success") != null) { %>
        <div class="success-msg"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error-msg"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="profile-container">
        <!-- 修改头像 -->
        <div class="profile-card">
            <h3>修改头像</h3>
            <div style="text-align:center;">
                <img id="avatarImg" class="avatar-preview" src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "images/default-avatar.png" %>" alt="头像">
            </div>
            <form action="${pageContext.request.contextPath}/AdminProfileServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updateAvatar">
                <div class="form-group">
                    <label>选择新头像</label>
                    <input type="file" name="avatar" accept="image/jpeg,image/png" required>
                </div>
                <button type="submit">上传头像</button>
            </form>
        </div>

        <!-- 修改密码 -->
        <div class="profile-card">
            <h3>修改密码</h3>
            <form action="${pageContext.request.contextPath}/AdminProfileServlet" method="post">
                <input type="hidden" name="action" value="updatePassword">
                <div class="form-group">
                    <label>原密码</label>
                    <input type="password" name="oldPassword" required>
                </div>
                <div class="form-group">
                    <label>新密码</label>
                    <input type="password" name="newPassword" required>
                </div>
                <div class="form-group">
                    <label>确认新密码</label>
                    <input type="password" name="confirmPassword" required>
                </div>
                <button type="submit">修改密码</button>
            </form>
        </div>

        <!-- 账号信息 -->
        <div class="profile-card">
            <h3>账号信息</h3>
            <div class="form-group">
                <label>用户名</label>
                <input type="text" value="<%= user.getUsername() %>" disabled>
            </div>
            <div class="info-msg">管理员账号名称不可修改</div>
        </div>
    </div>
</div>
<script>
    document.querySelector('input[name="avatar"]').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(ev) {
                document.getElementById('avatarImg').src = ev.target.result;
            };
            reader.readAsDataURL(file);
        }
    });
</script>
</body>
</html>