package com.servlet;

import com.bean.Score;
import com.bean.Student;
import com.bean.User;
import com.dao.ScoreDao;
import com.dao.StudentDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/QueryServlet")
public class QueryServlet extends HttpServlet {
    private StudentDao studentDao = new StudentDao();
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

        String type = req.getParameter("type");
        String keyword = req.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            req.setAttribute("error", "请输入查询关键字");
            req.getRequestDispatcher("/pages/admin/queryResult.jsp").forward(req, resp);
            return;
        }
        if ("stuId".equals(type)) {
            Student stu = studentDao.findByStuId(keyword);
            if (stu != null) {
                List<Score> scores = scoreDao.getScoresByStudent(stu.getStuId());
                req.setAttribute("student", stu);
                req.setAttribute("scores", scores);
            } else {
                req.setAttribute("error", "未找到该学号的学生");
            }
        } else if ("name".equals(type)) {
            List<Student> students = studentDao.findByNameLike(keyword);
            if (students != null && !students.isEmpty()) {
                List<Score> allScores = new ArrayList<>();
                for (Student stu : students) {
                    allScores.addAll(scoreDao.getScoresByStudent(stu.getStuId()));
                }
                req.setAttribute("studentList", students);
                req.setAttribute("scores", allScores);
            } else {
                req.setAttribute("error", "未找到该姓名的学生");
            }
        }
        req.getRequestDispatcher("/pages/admin/queryResult.jsp").forward(req, resp);
    }
}