package com.servlet;

import com.bean.Score;
import com.bean.User;
import com.dao.ScoreDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/ScoreServlet")
public class ScoreServlet extends HttpServlet {
    private ScoreDao scoreDao = new ScoreDao();

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if ("addOrUpdate".equals(action)) {
            String stuId = req.getParameter("stuId");
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            double scoreValue = Double.parseDouble(req.getParameter("score"));
            if (scoreValue < 0 || scoreValue > 100) {
                req.setAttribute("error", "分数必须在0-100之间");
                req.getRequestDispatcher("/pages/admin/scoreManage.jsp").forward(req, resp);
                return;
            }
            String dateStr = req.getParameter("examDate");
            Date examDate = null;
            try {
                examDate = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
            } catch (Exception e) {
                examDate = new Date();
            }
            Score score = new Score();
            score.setStuId(stuId);
            score.setCourseId(courseId);
            score.setScore(scoreValue);
            score.setExamDate(examDate);

            if (scoreDao.saveOrUpdate(score)) {
                resp.sendRedirect(req.getContextPath() + "/pages/admin/scoreManage.jsp?msg=success");
            } else {
                req.setAttribute("error", "操作失败");
                req.getRequestDispatcher("/pages/admin/scoreManage.jsp").forward(req, resp);
            }
        } else if ("delete".equals(action)) {
            // 可扩展删除逻辑
        }
    }
}