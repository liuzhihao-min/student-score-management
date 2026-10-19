package com.servlet;

import com.bean.User;
import com.dao.ScoreDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/StatServlet")
public class StatServlet extends HttpServlet {
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        List<String> classes = scoreDao.getAllClasses();
        req.setAttribute("classList", classes);

        String selectedClass = req.getParameter("className");
        if (selectedClass != null && !selectedClass.isEmpty()) {
            Map<String, Object> stat = scoreDao.classStatistics(selectedClass);
            req.setAttribute("stat", stat);
            req.setAttribute("selectedClass", selectedClass);

            // 获取分数段分布（若需图表）
            List<Integer> scores = scoreDao.getScoresByClass(selectedClass);
            int[] buckets = new int[5];
            for (int score : scores) {
                if (score < 20) buckets[0]++;
                else if (score < 40) buckets[1]++;
                else if (score < 60) buckets[2]++;
                else if (score < 80) buckets[3]++;
                else buckets[4]++;
            }
            req.setAttribute("buckets", buckets);
        }
        req.getRequestDispatcher("/pages/admin/classStat.jsp").forward(req, resp);
    }
}