package com.servlet;

import com.bean.User;
import com.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String roleChosen = req.getParameter("role"); // 前端传递的期望角色

        UserDao dao = new UserDao();
        User user = dao.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            // 检查角色是否匹配
            if (roleChosen != null && !roleChosen.equals(user.getRole())) {
                req.setAttribute("error", "登录身份错误：您选择的身份与账号不匹配");
                req.getRequestDispatcher("pages/login.jsp").forward(req, resp);
                return;
            }
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            if ("admin".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/pages/admin/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/pages/student/myScore.jsp");
            }
        } else {
            req.setAttribute("error", "用户名或密码错误");
            req.getRequestDispatcher("pages/login.jsp").forward(req, resp);
        }
    }
}