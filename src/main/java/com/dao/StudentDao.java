package com.dao;

import com.bean.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDao {

    // 新增学生
    public boolean addStudent(Student stu) {
        String sql = "INSERT INTO student(stu_id, name, class) VALUES(?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, stu.getStuId());
            ps.setString(2, stu.getName());
            ps.setString(3, stu.getClassName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除学生
    public boolean deleteStudent(String stuId) {
        String sql = "DELETE FROM student WHERE stu_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, stuId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询所有学生（不分页，保留兼容）
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student ORDER BY stu_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Student stu = new Student();
                stu.setStuId(rs.getString("stu_id"));
                stu.setName(rs.getString("name"));
                stu.setClassName(rs.getString("class"));
                list.add(stu);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 按学号查找
    public Student findByStuId(String stuId) {
        String sql = "SELECT * FROM student WHERE stu_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, stuId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Student stu = new Student();
                stu.setStuId(rs.getString("stu_id"));
                stu.setName(rs.getString("name"));
                stu.setClassName(rs.getString("class"));
                return stu;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 按姓名模糊查询
    public List<Student> findByNameLike(String name) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE name LIKE ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student stu = new Student();
                stu.setStuId(rs.getString("stu_id"));
                stu.setName(rs.getString("name"));
                stu.setClassName(rs.getString("class"));
                list.add(stu);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ========== 新增分页相关方法 ==========
    // 获取学生总数
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM student";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 分页查询学生
    public List<Student> getStudentsByPage(int start, int pageSize) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student ORDER BY stu_id LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student stu = new Student();
                stu.setStuId(rs.getString("stu_id"));
                stu.setName(rs.getString("name"));
                stu.setClassName(rs.getString("class"));
                list.add(stu);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean updateStudent(Student stu) {
        String sql = "UPDATE student SET name=?, class=? WHERE stu_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, stu.getName());
            ps.setString(2, stu.getClassName());
            ps.setString(3, stu.getStuId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}