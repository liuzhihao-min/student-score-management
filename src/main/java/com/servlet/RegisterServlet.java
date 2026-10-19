package com.servlet;

import com.bean.Student;
import com.dao.StudentDao;
import com.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String stuId = req.getParameter("stuId");
        String name = req.getParameter("name");
        String className = req.getParameter("className");

        // 校验非空
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            stuId == null || stuId.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            className == null || className.trim().isEmpty()) {
            req.setAttribute("error", "所有字段都不能为空");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
            return;
        }

        StudentDao studentDao = new StudentDao();
        if (studentDao.findByStuId(stuId) != null) {
            req.setAttribute("error", "学号已存在，请核对");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
            return;
        }

        Student stu = new Student(stuId, name, className);
        if (!studentDao.addStudent(stu)) {
            req.setAttribute("error", "学生信息注册失败");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
            return;
        }

        UserDao userDao = new UserDao();
        if (userDao.registerStudent(username, password, stuId)) {
            // 注册成功，设置成功消息，并停留在注册页面
            req.setAttribute("successMsg", "注册成功！请记好您的账号密码。");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "用户名已存在或注册失败");
            req.getRequestDispatcher("/pages/register.jsp").forward(req, resp);
        }
    }
}