package com.dao;

import com.bean.Score;
import java.sql.*;
import java.util.*;

public class ScoreDao {
    
    // 录入或修改成绩（如果已有成绩则更新，否则插入）
    public boolean saveOrUpdate(Score score) {
        // 分数校验在Servlet中已做，此处不做重复校验
        // 先检查是否已存在该学生该课程的成绩
        String checkSql = "SELECT score_id FROM score WHERE stu_id=? AND course_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setString(1, score.getStuId());
            ps.setInt(2, score.getCourseId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // 更新
                String updateSql = "UPDATE score SET score=?, exam_date=? WHERE score_id=?";
                try (PreparedStatement ps2 = conn.prepareStatement(updateSql)) {
                    ps2.setDouble(1, score.getScore());
                    ps2.setDate(2, new java.sql.Date(score.getExamDate().getTime()));
                    ps2.setInt(3, rs.getInt("score_id"));
                    return ps2.executeUpdate() > 0;
                }
            } else {
                // 插入
                String insertSql = "INSERT INTO score(stu_id, course_id, score, exam_date) VALUES(?,?,?,?)";
                try (PreparedStatement ps2 = conn.prepareStatement(insertSql)) {
                    ps2.setString(1, score.getStuId());
                    ps2.setInt(2, score.getCourseId());
                    ps2.setDouble(3, score.getScore());
                    ps2.setDate(4, new java.sql.Date(score.getExamDate().getTime()));
                    return ps2.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 获取某学生的所有成绩（关联课程名）
    public List<Score> getScoresByStudent(String stuId) {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT s.score_id, s.stu_id, st.name as student_name, s.course_id, c.course_name, s.score, s.exam_date " +
                     "FROM score s JOIN student st ON s.stu_id=st.stu_id JOIN course c ON s.course_id=c.course_id " +
                     "WHERE s.stu_id=? ORDER BY c.course_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, stuId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Score sc = new Score();
                sc.setScoreId(rs.getInt("score_id"));
                sc.setStuId(rs.getString("stu_id"));
                sc.setStudentName(rs.getString("student_name"));
                sc.setCourseId(rs.getInt("course_id"));
                sc.setCourseName(rs.getString("course_name"));
                sc.setScore(rs.getDouble("score"));
                sc.setExamDate(rs.getDate("exam_date"));
                list.add(sc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 获取所有学生的成绩（用于管理端列表）
    public List<Score> getAllScores() {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT s.score_id, s.stu_id, st.name as student_name, st.class, s.course_id, c.course_name, s.score, s.exam_date " +
                     "FROM score s JOIN student st ON s.stu_id=st.stu_id JOIN course c ON s.course_id=c.course_id ORDER BY st.stu_id, c.course_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Score sc = new Score();
                sc.setScoreId(rs.getInt("score_id"));
                sc.setStuId(rs.getString("stu_id"));
                sc.setStudentName(rs.getString("student_name"));
                sc.setCourseId(rs.getInt("course_id"));
                sc.setCourseName(rs.getString("course_name"));
                sc.setScore(rs.getDouble("score"));
                sc.setExamDate(rs.getDate("exam_date"));
                list.add(sc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 按课程排序（某门课程的所有学生成绩，按分数升/降序）
    public List<Score> sortByCourse(int courseId, String order) {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT s.score_id, s.stu_id, st.name as student_name, s.course_id, c.course_name, s.score, s.exam_date " +
                     "FROM score s JOIN student st ON s.stu_id=st.stu_id JOIN course c ON s.course_id=c.course_id " +
                     "WHERE s.course_id=? ORDER BY s.score " + (order.equalsIgnoreCase("asc") ? "ASC" : "DESC");
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Score sc = new Score();
                sc.setScoreId(rs.getInt("score_id"));
                sc.setStuId(rs.getString("stu_id"));
                sc.setStudentName(rs.getString("student_name"));
                sc.setCourseId(rs.getInt("course_id"));
                sc.setCourseName(rs.getString("course_name"));
                sc.setScore(rs.getDouble("score"));
                sc.setExamDate(rs.getDate("exam_date"));
                list.add(sc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 按学生平均分排序（返回Map包含学号、姓名、平均分）
    public List<Map<String,Object>> sortByAvgScore(String order) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT st.stu_id, st.name, AVG(s.score) as avg_score " +
                     "FROM student st LEFT JOIN score s ON st.stu_id=s.stu_id " +
                     "GROUP BY st.stu_id ORDER BY avg_score " + (order.equalsIgnoreCase("asc") ? "ASC" : "DESC");
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> map = new HashMap<>();
                map.put("stuId", rs.getString("stu_id"));
                map.put("name", rs.getString("name"));
                map.put("avgScore", rs.getDouble("avg_score"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 班级统计（平均分、及格率）
    public Map<String,Object> classStatistics(String className) {
        Map<String,Object> result = new HashMap<>();
        String sql = "SELECT AVG(s.score) as avg_score, " +
                     "SUM(CASE WHEN s.score >= 60 THEN 1 ELSE 0 END)/COUNT(*) as pass_rate " +
                     "FROM student st LEFT JOIN score s ON st.stu_id=s.stu_id " +
                     "WHERE st.class=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, className);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result.put("avgScore", rs.getDouble("avg_score"));
                result.put("passRate", rs.getDouble("pass_rate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // 获取所有班级列表
    public List<String> getAllClasses() {
        List<String> classes = new ArrayList<>();
        String sql = "SELECT DISTINCT class FROM student";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                classes.add(rs.getString("class"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return classes;
    }
    public List<Score> getAllScoresByPage(int start, int pageSize) {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT s.score_id, s.stu_id, st.name as student_name, st.class, s.course_id, c.course_name, s.score, s.exam_date " +
                     "FROM score s JOIN student st ON s.stu_id=st.stu_id JOIN course c ON s.course_id=c.course_id " +
                     "ORDER BY st.stu_id, c.course_id LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Score sc = new Score();
                // 设置属性...
                list.add(sc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
 // 获取某班级所有学生的成绩（用于分数段统计）
    public List<Integer> getScoresByClass(String className) {
        List<Integer> scores = new ArrayList<>();
        String sql = "SELECT s.score FROM score s JOIN student st ON s.stu_id=st.stu_id WHERE st.class=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, className);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                scores.add(rs.getInt("score"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return scores;
    }
 // 根据学号、年份（可选）、课程ID（可选）查询成绩
    public List<Score> getScoresByStudentWithFilters(String stuId, Integer year, Integer courseId) {
        List<Score> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.score_id, s.stu_id, st.name as student_name, s.course_id, c.course_name, s.score, s.exam_date " +
            "FROM score s JOIN student st ON s.stu_id=st.stu_id JOIN course c ON s.course_id=c.course_id " +
            "WHERE s.stu_id = ? "
        );
        List<Object> params = new ArrayList<>();
        params.add(stuId);
        if (year != null) {
            sql.append("AND YEAR(s.exam_date) = ? ");
            params.add(year);
        }
        if (courseId != null) {
            sql.append("AND s.course_id = ? ");
            params.add(courseId);
        }
        sql.append("ORDER BY s.exam_date DESC, c.course_id");
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof Integer) {
                    ps.setInt(i+1, (Integer) params.get(i));
                } else {
                    ps.setString(i+1, (String) params.get(i));
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Score sc = new Score();
                sc.setScoreId(rs.getInt("score_id"));
                sc.setStuId(rs.getString("stu_id"));
                sc.setStudentName(rs.getString("student_name"));
                sc.setCourseId(rs.getInt("course_id"));
                sc.setCourseName(rs.getString("course_name"));
                sc.setScore(rs.getDouble("score"));
                sc.setExamDate(rs.getDate("exam_date"));
                list.add(sc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}