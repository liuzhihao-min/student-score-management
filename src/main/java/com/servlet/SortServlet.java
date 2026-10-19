package com.servlet;

import com.bean.Course;
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
import java.util.List;
import java.util.Map;

@WebServlet("/SortServlet")
public class SortServlet extends HttpServlet {
    private ScoreDao scoreDao = new ScoreDao();
    private CourseDao courseDao = new CourseDao();

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

        String type = req.getParameter("type");
        String order = req.getParameter("order");
        if (order == null) order = "asc";

        if ("course".equals(type)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            List<Score> sortedScores = scoreDao.sortByCourse(courseId, order);
            Course course = courseDao.findById(courseId);
            req.setAttribute("course", course);
            req.setAttribute("sortedScores", sortedScores);
            req.setAttribute("order", order);
            req.getRequestDispatcher("/pages/admin/sortResult.jsp").forward(req, resp);
        } else if ("avg".equals(type)) {
            List<Map<String, Object>> avgList = scoreDao.sortByAvgScore(order);
            req.setAttribute("avgList", avgList);
            req.setAttribute("order", order);
            req.getRequestDispatcher("/pages/admin/sortResult.jsp").forward(req, resp);
        } else {
            List<Course> courses = courseDao.getAllCourses();
            req.setAttribute("courses", courses);
            req.getRequestDispatcher("/pages/admin/sortResult.jsp").forward(req, resp);
        }
    }
}