package com.servlet;

import com.bean.User;
import com.dao.UserDao;
import com.util.PageBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/UserManageServlet")
public class UserManageServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    // 权限检查方法
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
            int userId = Integer.parseInt(req.getParameter("userId"));
            userDao.deleteUser(userId);
            resp.sendRedirect(req.getContextPath() + "/UserManageServlet?msg=delete_success");
            return;
        }

        // 分页参数
        int currentPage = 1;
        int pageSize = 10;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            currentPage = Integer.parseInt(pageStr);
        }

        int totalCount = userDao.getTotalCount();
        int start = (currentPage - 1) * pageSize;
        List<User> list = userDao.getUsersByPage(start, pageSize);
        PageBean<User> pageBean = new PageBean<>(currentPage, pageSize, totalCount, list);

        req.setAttribute("pageBean", pageBean);
        req.getRequestDispatcher("/pages/admin/userManage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String role = req.getParameter("role");
            String relatedId = req.getParameter("relatedId");

            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/UserManageServlet?error=empty");
                return;
            }

            boolean success = userDao.addUser(username, password, role, relatedId);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/UserManageServlet?msg=add_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/UserManageServlet?error=add_failed");
            }
        } else if ("update".equals(action)) {
            int userId = Integer.parseInt(req.getParameter("userId"));
            String newPwd = req.getParameter("newPassword");
            if (newPwd != null && !newPwd.isEmpty()) {
                userDao.updatePassword(userId, newPwd);
                resp.sendRedirect(req.getContextPath() + "/UserManageServlet?msg=update_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/UserManageServlet?error=empty_password");
            }
        } else {
            doGet(req, resp);
        }
    }
}