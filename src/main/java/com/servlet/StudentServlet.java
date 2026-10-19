package com.servlet;

import com.bean.Student;
import com.bean.User;
import com.dao.StudentDao;
import com.util.PageBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private StudentDao studentDao = new StudentDao();

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            String stuId = req.getParameter("stuId");
            studentDao.deleteStudent(stuId);
            resp.sendRedirect(req.getContextPath() + "/StudentServlet?msg=delete_success");
            return;
        }

        int currentPage = 1;
        int pageSize = 10;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            currentPage = Integer.parseInt(pageStr);
        }

        int totalCount = studentDao.getTotalCount();
        int start = (currentPage - 1) * pageSize;
        List<Student> list = studentDao.getStudentsByPage(start, pageSize);
        PageBean<Student> pageBean = new PageBean<>(currentPage, pageSize, totalCount, list);

        req.setAttribute("pageBean", pageBean);
        req.getRequestDispatcher("/pages/admin/studentManage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            String stuId = req.getParameter("stuId");
            String name = req.getParameter("name");
            String className = req.getParameter("className");
            if (stuId == null || stuId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/StudentServlet?error=empty");
                return;
            }
            Student stu = new Student(stuId, name, className);
            if (studentDao.addStudent(stu)) {
                resp.sendRedirect(req.getContextPath() + "/StudentServlet?msg=add_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/StudentServlet?error=add_failed");
            }
        } else {
            doGet(req, resp);
        }
    }
}