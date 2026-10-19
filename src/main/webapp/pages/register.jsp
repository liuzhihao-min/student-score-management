<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>注册学生账号</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .btn-group {
            margin-top: 20px;
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        .btn-group a, .btn-group button {
            flex: 1;
            text-align: center;
            min-width: 100px;
            padding: 8px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-group a:hover, .btn-group button:hover {
            background: #0056b3;
        }
        .success-msg {
            text-align: center;
            background: #e6ffed;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        .error-msg {
            text-align: center;
            background: #ffe6e6;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        .login-container {
            width: 400px;
            margin: 80px auto;
            background: rgba(255,255,255,0.95);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
            margin-top: 0;
        }
        .input-group {
            margin-bottom: 15px;
        }
        .input-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .input-group input {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button, .btn-link {
            background: #007bff;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 30px;
            cursor: pointer;
            font-size: 14px;
        }
        button:hover {
            background: #0056b3;
        }
        .form-footer {
            text-align: center;
            margin-top: 15px;
        }
        .form-footer a {
            color: #007bff;
            text-decoration: none;
            margin-left: 10px;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>学生注册</h2>

    <%
        String successMsg = (String) request.getAttribute("successMsg");
        String errorMsg = (String) request.getAttribute("error");
        if (successMsg != null && !successMsg.isEmpty()) {
    %>
        <div class="success-msg">
            <%= successMsg %>
        </div>
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/pages/login.jsp">去登录</a>
            <button onclick="location.reload()">继续注册</button>
        </div>
    <%
        } else {
            if (errorMsg != null && !errorMsg.isEmpty()) {
    %>
        <div class="error-msg">
            <%= errorMsg %>
        </div>
    <%
            }
    %>
    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
        <div class="input-group">
            <label>用户名</label>
            <input type="text" name="username" required>
        </div>
        <div class="input-group">
            <label>密码</label>
            <input type="password" name="password" required>
        </div>
        <div class="input-group">
            <label>学号</label>
            <input type="text" name="stuId" required>
        </div>
        <div class="input-group">
            <label>姓名</label>
            <input type="text" name="name" required>
        </div>
        <div class="input-group">
            <label>班级</label>
            <input type="text" name="className" required>
        </div>
        <div class="form-footer">
            <button type="submit">注册</button>
            <a href="login.jsp">返回登录</a>
        </div>
    </form>
    <%
        }
    %>
</div>
</body>
</html>>