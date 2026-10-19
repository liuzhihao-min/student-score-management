package com.servlet;

import com.bean.Announcement;
import com.bean.User;
import com.dao.AnnouncementDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AnnouncementServlet")
public class AnnouncementServlet extends HttpServlet {
    private AnnouncementDao dao = new AnnouncementDao();

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
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteAnnouncement(id);
            resp.sendRedirect(req.getContextPath() + "/AnnouncementServlet?msg=delete_success");
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Announcement a = dao.getAnnouncementById(id);
            req.setAttribute("announcement", a);
            req.getRequestDispatcher("/pages/admin/editAnnouncement.jsp").forward(req, resp);
        } else {
            // 显示公告列表
            List<Announcement> list = dao.getAllAnnouncements();
            req.setAttribute("announcements", list);
            req.getRequestDispatcher("/pages/admin/manageAnnouncements.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            Announcement a = new Announcement();
            a.setTitle(title);
            a.setContent(content);
            if (dao.addAnnouncement(a)) {
                resp.sendRedirect(req.getContextPath() + "/AnnouncementServlet?msg=add_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/AnnouncementServlet?error=add_failed");
            }
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            Announcement a = new Announcement();
            a.setId(id);
            a.setTitle(title);
            a.setContent(content);
            if (dao.updateAnnouncement(a)) {
                resp.sendRedirect(req.getContextPath() + "/AnnouncementServlet?msg=update_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/AnnouncementServlet?error=update_failed");
            }
        } else {
            doGet(req, resp);
        }
    }
}