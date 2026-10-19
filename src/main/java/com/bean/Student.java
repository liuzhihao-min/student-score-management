package com.bean;

public class Student {
    private String stuId;
    private String name;
    private String className;
    
    public Student() {}
    public Student(String stuId, String name, String className) {
        this.stuId = stuId;
        this.name = name;
        this.className = className;
    }
    // getters and setters
    public String getStuId() { return stuId; }
    public void setStuId(String stuId) { this.stuId = stuId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
}