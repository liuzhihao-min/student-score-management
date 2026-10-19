package com.servlet;

import com.bean.User;
import com.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/AdminProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class AdminProfileServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    private User checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return null;
        }
        return user;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = checkAdmin(req, resp);
        if (user == null) return;
        req.getRequestDispatcher("/pages/admin/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = checkAdmin(req, resp);
        if (user == null) return;

        String action = req.getParameter("action");
        if ("updatePassword".equals(action)) {
            String oldPassword = req.getParameter("oldPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "两次输入的新密码不一致");
                doGet(req, resp);
                return;
            }
            User dbUser = userDao.findByUsername(user.getUsername());
            if (!dbUser.getPassword().equals(oldPassword)) {
                req.setAttribute("error", "原密码错误");
                doGet(req, resp);
                return;
            }
            userDao.updatePassword(user.getUserId(), newPassword);
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=密码已修改，请重新登录");
        } else if ("updateAvatar".equals(action)) {
            Part filePart = req.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "avatars";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
                String avatarPath = "uploads/avatars/" + fileName;
                if (userDao.updateAvatar(user.getUserId(), avatarPath)) {
                    user.setAvatar(avatarPath);
                    req.getSession().setAttribute("user", user);
                    req.setAttribute("success", "头像上传成功");
                } else {
                    req.setAttribute("error", "头像保存失败");
                }
            } else {
                req.setAttribute("error", "请选择图片文件");
            }
            doGet(req, resp);
        } else {
            doGet(req, resp);
        }
    }
}