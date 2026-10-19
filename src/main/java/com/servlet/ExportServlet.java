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
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/ExportServlet")
public class ExportServlet extends HttpServlet {
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

        List<Score> list = scoreDao.getAllScores();
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment;filename=scores.csv");
        PrintWriter out = resp.getWriter();
        out.println("学号,姓名,课程,分数,考试日期");
        for (Score s : list) {
            out.printf("%s,%s,%s,%.1f,%s\n",
                s.getStuId(),
                s.getStudentName(),
                s.getCourseName(),
                s.getScore(),
                s.getExamDate().toString());
        }
        out.flush();
        out.close();
    }
}