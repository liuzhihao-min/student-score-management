<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bean.User, com.bean.Announcement, com.dao.AnnouncementDao, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"student".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    AnnouncementDao dao = new AnnouncementDao();
    List<Announcement> announcements = dao.getAllAnnouncements();
%>
<!DOCTYPE html>
<html>
<head>
    <title>公告中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .announcement-list {
            margin-top: 20px;
        }
        .announcement-item {
            background: white;
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            cursor: pointer;
            transition: 0.2s;
        }
        .announcement-item:hover {
            transform: translateX(5px);
            background: #f8f9ff;
        }
        .announcement-title {
            font-size: 18px;
            font-weight: 600;
            color: #1e3c72;
            margin-bottom: 8px;
        }
        .announcement-meta {
            font-size: 12px;
            color: #888;
            margin-bottom: 10px;
        }
        .announcement-preview {
            color: #555;
            font-size: 14px;
            line-height: 1.4;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .empty-msg {
            text-align: center;
            padding: 40px;
            color: #888;
        }
        /* 模态框样式 */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 10000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: white;
            width: 500px;
            max-width: 90%;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 12px 30px rgba(0,0,0,0.3);
        }
        .modal-header {
            background: #007bff;
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
        }
        .modal-body {
            padding: 20px;
            max-height: 60vh;
            overflow-y: auto;
            white-space: pre-wrap;
            line-height: 1.6;
        }
        .modal-footer {
            padding: 12px 20px;
            text-align: right;
            border-top: 1px solid #eee;
        }
        .modal-footer button {
            background: #007bff;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 30px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>公告中心</h2>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/StudentScoreServlet">返回成绩页</a></li>
        <li><a href="${pageContext.request.contextPath}/StudentProfileServlet">个人中心</a></li>
        <li><a href="${pageContext.request.contextPath}/LogoutServlet">退出登录</a></li>
    </ul>

    <div class="announcement-list">
        <% if (announcements == null || announcements.isEmpty()) { %>
            <div class="empty-msg">暂无公告</div>
        <% } else {
            for (Announcement a : announcements) { %>
                <div class="announcement-item" onclick="showDetail('<%= a.getTitle() %>', '<%= a.getContent().replace("\n", "\\n").replace("'", "\\'") %>')">
                    <div class="announcement-title"><%= a.getTitle() %></div>
                    <div class="announcement-meta">发布时间：<%= a.getCreateTime() %></div>
                    <div class="announcement-preview"><%= a.getContent().length() > 100 ? a.getContent().substring(0, 100) + "..." : a.getContent() %></div>
                </div>
        <%   }
        } %>
    </div>
</div>

<!-- 模态框 -->
<div id="detailModal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header" id="modalTitle"></div>
        <div class="modal-body" id="modalContent"></div>
        <div class="modal-footer">
            <button onclick="closeModal()">关闭</button>
        </div>
    </div>
</div>

<script>
    function showDetail(title, content) {
        document.getElementById('modalTitle').innerText = title;
        document.getElementById('modalContent').innerText = content;
        document.getElementById('detailModal').style.display = 'flex';
    }
    function closeModal() {
        document.getElementById('detailModal').style.display = 'none';
    }
    // 点击模态框背景关闭
    document.getElementById('detailModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>
</body>
</html>