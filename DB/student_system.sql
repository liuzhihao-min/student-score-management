-- =============================================
-- 学生成绩管理系统 - 数据库初始化脚本
-- 数据库名: student_system
-- =============================================

CREATE DATABASE IF NOT EXISTS student_system
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE student_system;

-- =============================================
-- 1. 学生信息表
-- =============================================
CREATE TABLE IF NOT EXISTS student (
    stu_id   VARCHAR(20) PRIMARY KEY COMMENT '学号',
    name     VARCHAR(50) NOT NULL  COMMENT '姓名',
    class    VARCHAR(50) NOT NULL  COMMENT '班级'
) ENGINE=InnoDB;

-- =============================================
-- 2. 课程信息表
-- =============================================
CREATE TABLE IF NOT EXISTS course (
    course_id   INT AUTO_INCREMENT PRIMARY KEY COMMENT '课程编号',
    course_name VARCHAR(100) NOT NULL COMMENT '课程名称',
    teacher     VARCHAR(50)  COMMENT '授课教师'
) ENGINE=InnoDB;

-- =============================================
-- 3. 成绩表
-- =============================================
CREATE TABLE IF NOT EXISTS score (
    score_id  INT AUTO_INCREMENT PRIMARY KEY COMMENT '成绩编号',
    stu_id    VARCHAR(20)    NOT NULL COMMENT '学号',
    course_id INT            NOT NULL COMMENT '课程编号',
    score     DECIMAL(5, 2)  DEFAULT 0 COMMENT '分数',
    exam_date DATE           COMMENT '考试日期',
    FOREIGN KEY (stu_id)    REFERENCES student(stu_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================
-- 4. 用户信息表
-- =============================================
CREATE TABLE IF NOT EXISTS user (
    user_id    INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户编号',
    username   VARCHAR(50)  NOT NULL UNIQUE COMMENT '账号',
    password   VARCHAR(100) NOT NULL COMMENT '密码',
    role       VARCHAR(20)  NOT NULL DEFAULT 'student' COMMENT '角色: admin / student',
    related_id VARCHAR(20)  COMMENT '关联学号',
    avatar     VARCHAR(255) COMMENT '头像路径'
) ENGINE=InnoDB;

-- =============================================
-- 5. 公告表
-- =============================================
CREATE TABLE IF NOT EXISTS announcement (
    id          INT AUTO_INCREMENT PRIMARY KEY COMMENT '公告编号',
    title       VARCHAR(200) NOT NULL COMMENT '标题',
    content     TEXT         NOT NULL COMMENT '内容',
    create_time DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间'
) ENGINE=InnoDB;

-- =============================================
-- 初始数据
-- =============================================

-- 管理员账号 (密码: 123456)
INSERT INTO user (username, password, role) VALUES ('admin', '123456', 'admin');

-- 课程数据
INSERT INTO course (course_name, teacher) VALUES ('Java程序设计', '张老师');
INSERT INTO course (course_name, teacher) VALUES ('数据库原理',   '李老师');
INSERT INTO course (course_name, teacher) VALUES ('计算机网络',   '王老师');
INSERT INTO course (course_name, teacher) VALUES ('操作系统',     '赵老师');
INSERT INTO course (course_name, teacher) VALUES ('数据结构',     '陈老师');

-- 学生数据
INSERT INTO student (stu_id, name, class) VALUES ('2023001', '张三', '计算机2301');
INSERT INTO student (stu_id, name, class) VALUES ('2023002', '李四', '计算机2301');
INSERT INTO student (stu_id, name, class) VALUES ('2023003', '王五', '计算机2302');
INSERT INTO student (stu_id, name, class) VALUES ('2023004', '赵六', '计算机2302');

-- 学生用户账号 (密码: 123456)
INSERT INTO user (username, password, role, related_id) VALUES ('2023001', '123456', 'student', '2023001');
INSERT INTO user (username, password, role, related_id) VALUES ('2023002', '123456', 'student', '2023002');
INSERT INTO user (username, password, role, related_id) VALUES ('2023003', '123456', 'student', '2023003');
INSERT INTO user (username, password, role, related_id) VALUES ('2023004', '123456', 'student', '2023004');

-- 成绩数据
-- 张三
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023001', 1, 85.5, '2026-01-10');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023001', 2, 78.0, '2026-01-12');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023001', 3, 90.0, '2026-01-14');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023001', 4, 66.0, '2026-01-16');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023001', 5, 72.0, '2026-01-18');
-- 李四
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023002', 1, 92.0, '2026-01-10');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023002', 2, 55.0, '2026-01-12');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023002', 3, 81.0, '2026-01-14');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023002', 4, 59.0, '2026-01-16');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023002', 5, 88.0, '2026-01-18');
-- 王五
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023003', 1, 73.0, '2026-01-10');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023003', 2, 69.0, '2026-01-12');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023003', 3, 95.0, '2026-01-14');
-- 赵六
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023004', 1, 44.0, '2026-01-10');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023004', 2, 77.0, '2026-01-12');
INSERT INTO score (stu_id, course_id, score, exam_date) VALUES ('2023004', 5, 63.0, '2026-01-18');

-- 公告数据
INSERT INTO announcement (title, content) VALUES
('系统上线通知', '学生成绩管理系统正式上线运行，欢迎各位老师和同学使用！'),
('成绩查询说明', '同学们可以在"我的成绩"页面查看各科成绩，支持按考试年份和课程筛选。'),
('期末考试安排', '本学期期末考试将于第18周进行，请同学们合理安排复习时间。');
