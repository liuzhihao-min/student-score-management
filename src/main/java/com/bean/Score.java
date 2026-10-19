package com.bean;

import java.util.Date;

public class Score {
    private int scoreId;
    private String stuId;
    private String studentName;   // 辅助字段，展示时使用
    private int courseId;
    private String courseName;
    private double score;
    private Date examDate;
    
    // constructors
    public Score() {}
    // getters and setters
    public int getScoreId() { return scoreId; }
    public void setScoreId(int scoreId) { this.scoreId = scoreId; }
    public String getStuId() { return stuId; }
    public void setStuId(String stuId) { this.stuId = stuId; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }
    public Date getExamDate() { return examDate; }
    public void setExamDate(Date examDate) { this.examDate = examDate; }
}