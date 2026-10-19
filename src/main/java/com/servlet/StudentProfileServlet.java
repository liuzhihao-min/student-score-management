package com.servlet;

import com.bean.User;
import com.bean.Student;
import com.dao.UserDao;
import com.dao.StudentDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/StudentProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class StudentProfileServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private StudentDao studentDao = new StudentDao();

    private User checkStudent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || !"student".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return null;
        }
        return user;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = checkStudent(req, resp);
        if (user == null) return;
        // 获取学生信息
        Student student = studentDao.findByStuId(user.getRelatedId());
        req.setAttribute("student", student);
        req.getRequestDispatcher("/pages/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = checkStudent(req, resp);
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
            req.setAttribute("success", "密码修改成功，请重新登录");
            // 更新session中的密码？可选，这里直接让重新登录
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=密码已修改，请重新登录");
        } else if ("updateName".equals(action)) {
            String newName = req.getParameter("newName");
            if (newName != null && !newName.trim().isEmpty()) {
                Student student = studentDao.findByStuId(user.getRelatedId());
                student.setName(newName);
                // 注意：StudentDao需要添加updateStudent方法，或者直接用delete+add? 推荐写update方法
                // 这里假设StudentDao中有updateStudent方法
                studentDao.updateStudent(student); // 需要你实现这个方法
                req.setAttribute("success", "姓名修改成功");
            } else {
                req.setAttribute("error", "姓名不能为空");
            }
            doGet(req, resp);
        } else if ("updateAvatar".equals(action)) {
            Part filePart = req.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "avatars";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
                String avatarPath = "uploads/avatars/" + fileName;
                userDao.updateAvatar(user.getUserId(), avatarPath); // 需要在UserDao中实现
                user.setAvatar(avatarPath); // 更新session中的头像路径
                req.getSession().setAttribute("user", user);
                req.setAttribute("success", "头像上传成功");
            } else {
                req.setAttribute("error", "请选择图片文件");
            }
            doGet(req, resp);
        }
    }
}