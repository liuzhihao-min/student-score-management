package com.servlet;

import com.bean.Score;
import com.bean.User;
import com.dao.CourseDao;
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

@WebServlet("/StudentScoreServlet")
public class StudentScoreServlet extends HttpServlet {
    private ScoreDao scoreDao = new ScoreDao();
    private CourseDao courseDao = new CourseDao();

    // 检查学生登录状态
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

        String action = req.getParameter("action");
        if ("export".equals(action)) {
            // 导出 CSV
            exportCSV(resp, user.getRelatedId());
        } else {
            // 查询页面：获取课程列表并转发到 JSP
            req.setAttribute("courseList", courseDao.getAllCourses());
            req.getRequestDispatcher("/pages/student/myScore.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = checkStudent(req, resp);
        if (user == null) return;

        String stuId = user.getRelatedId();
        String yearStr = req.getParameter("year");
        String courseIdStr = req.getParameter("courseId");
        Integer year = null;
        Integer courseId = null;
        if (yearStr != null && !yearStr.isEmpty()) {
            year = Integer.parseInt(yearStr);
        }
        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            courseId = Integer.parseInt(courseIdStr);
        }
        List<Score> scores = scoreDao.getScoresByStudentWithFilters(stuId, year, courseId);
        req.setAttribute("scores", scores);
        req.setAttribute("courseList", courseDao.getAllCourses());
        req.setAttribute("selectedYear", yearStr);
        req.setAttribute("selectedCourse", courseIdStr);
        req.getRequestDispatcher("/pages/student/myScore.jsp").forward(req, resp);
    }

    private void exportCSV(HttpServletResponse resp, String stuId) throws IOException {
        List<Score> scores = scoreDao.getScoresByStudent(stuId);
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment;filename=my_scores.csv");
        PrintWriter out = resp.getWriter();
        out.println("课程,分数,考试日期");
        for (Score s : scores) {
            out.printf("%s,%.1f,%s\n", s.getCourseName(), s.getScore(), s.getExamDate().toString());
        }
        out.flush();
        out.close();
    }
}