<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生成绩管理系统 - 登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .login-container {
            width: 380px;
            margin: 80px auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 25px;
            color: #1e3c72;
        }
        .tabs {
            display: flex;
            border-bottom: 2px solid #ddd;
            margin-bottom: 20px;
        }
        .tab {
            flex: 1;
            text-align: center;
            padding: 10px;
            cursor: pointer;
            font-weight: bold;
            color: #555;
            transition: 0.2s;
        }
        .tab.active {
            color: #007bff;
            border-bottom: 2px solid #007bff;
            margin-bottom: -2px;
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
        button {
            width: 100%;
            background: #007bff;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 30px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background: #0056b3;
        }
        .register-link {
            text-align: center;
            margin-top: 15px;
        }
        .register-link a {
            color: #007bff;
            text-decoration: none;
        }
        .error-msg {
            text-align: center;
            margin-top: 10px;
            color: red;
            font-size: 14px;
        }
    </style>
</head>
<body class="login-body">
<div class="login-container">
    <h2>学生成绩管理系统</h2>
    <div class="tabs">
        <div class="tab active" data-role="student">学生登录</div>
        <div class="tab" data-role="admin">管理员登录</div>
    </div>
    <form id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <input type="hidden" name="role" id="roleInput" value="student">
        <div class="input-group">
            <label>用户名</label>
            <input type="text" name="username" required>
        </div>
        <div class="input-group">
            <label>密码</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit">登录</button>
    </form>
    <div class="register-link">
        <a href="register.jsp">学生注册</a>
    </div>
    <div class="error-msg">${error}</div>
</div>

<script>
    // 切换标签逻辑
    const tabs = document.querySelectorAll('.tab');
    const roleInput = document.getElementById('roleInput');
    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // 移除所有active
            tabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            // 设置隐藏域的值
            const role = this.getAttribute('data-role');
            roleInput.value = role;
        });
    });
</script>
</body>
</html>