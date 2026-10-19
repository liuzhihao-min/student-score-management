<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.User, com.bean.Announcement, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Announcement> list = (List<Announcement>) request.getAttribute("announcements");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>公告管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .btn-add { background: #28a745; margin-bottom: 15px; display: inline-block; }
        .btn-add:hover { background: #218838; }
        .announcement-table td, .announcement-table th { text-align: left; }
        .content-preview { max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .announcement-table td a { margin-right: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>公告管理</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">返回后台首页</a></li>
    </ul>

    <% if ("add_success".equals(msg)) { %>
        <div class="success-msg">公告添加成功</div>
    <% } else if ("update_success".equals(msg)) { %>
        <div class="success-msg">公告修改成功</div>
    <% } else if ("delete_success".equals(msg)) { %>
        <div class="success-msg">公告删除成功</div>
    <% } %>
    <% if ("add_failed".equals(error)) { %>
        <div class="error-msg">添加失败</div>
    <% } else if ("update_failed".equals(error)) { %>
        <div class="error-msg">修改失败</div>
    <% } %>

    <a class="btn btn-add" href="${pageContext.request.contextPath}/pages/admin/addAnnouncement.jsp">发布新公告</a>

    <table class="announcement-table">
        <thead>
            <tr><th>ID</th><th>标题</th><th>内容预览</th><th>发布时间</th><th>操作</th></tr>
        </thead>
        <tbody>
            <% if (list == null || list.isEmpty()) { %>
                <tr><td colspan="5">暂无公告</td></tr>
            <% } else {
                for (Announcement a : list) { %>
                <tr>
                    <td><%= a.getId() %></td>
                    <td><%= a.getTitle() %></td>
                    <td class="content-preview"><%= a.getContent() %></td>
                    <td><%= a.getCreateTime() %></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/AnnouncementServlet?action=edit&id=<%= a.getId() %>">编辑</a>
                        <a href="javascript:void(0);" onclick="showDeleteModal('${pageContext.request.contextPath}/AnnouncementServlet?action=delete&id=<%= a.getId() %>')">删除</a>
                    </td>
                </tr>
            <% } } %>
        </tbody>
    </table>
</div>

<!-- 自定义删除确认模态框（复用全局样式） -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">⚠️ 确认删除</div>
        <div class="modal-body">确定要删除这条公告吗？删除后无法恢复。</div>
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

        window.showDeleteModal = function(url) {
            pendingUrl = url;
            modal.style.display = 'block';
        };

        function hideModal() {
            modal.style.display = 'none';
            pendingUrl = null;
        }

        confirmBtn.onclick = function() {
            if (pendingUrl) {
                window.location.href = pendingUrl;
            }
            hideModal();
        };

        cancelBtn.onclick = function() {
            hideModal();
        };

        window.onclick = function(event) {
            if (event.target === modal) {
                hideModal();
            }
        };
    })();
</script>
</body>
</html>