# 学生成绩管理系统

Java Web 课程设计 · 山东师范大学 计算机科学与技术（计工本 2403）

一个基于 **Servlet + JSP + MySQL** 的学生成绩管理系统，提供管理员与学生两种角色：
管理员负责学生、课程、成绩、公告的维护与统计，学生登录后可查询自己的成绩与公告。

- 作者：刘志豪（202411000516）、徐文泽（202411000524）

---

## 技术栈

| 层次 | 技术 |
| --- | --- |
| 后端 | Java Servlet（Jakarta Servlet 5+）、JDBC |
| 视图 | JSP + JSTL 3.0（Jakarta EE 9+） |
| 数据库 | MySQL 8.0 |
| 容器 | Apache Tomcat 10.x |
| 开发工具 | Eclipse（`.classpath` / `.project` 已随仓库提供） |

## 功能

**通用**

- 注册 / 登录 / 注销，基于 `HttpSession` 的身份校验，管理员与学生的页面互相隔离
- 个人资料查看与修改、头像上传
- 分页查询（`PageBean`）

**管理员**

- 学生管理：增删改查（`StudentServlet` / `StudentDao`）
- 成绩管理：录入、修改、删除（`ScoreServlet` / `ScoreDao`）
- 条件查询与排序（`QueryServlet` / `SortServlet`）
- 班级统计（`StatServlet`），按课程 / 班级汇总平均分、最高分、及格率
- 公告管理：发布、编辑、删除（`AnnouncementServlet`）
- 用户管理：账号与角色维护（`UserManageServlet`）
- 数据导出（`ExportServlet`，生成 CSV）

**学生**

- 查看本人成绩、排序与筛选（`StudentScoreServlet`）
- 查看公告（`AnnouncementServlet`）
- 个人信息维护（`StudentProfileServlet`）

## 目录结构

```
src/main/java/com/
├── bean/       实体类（Student / Course / Score / User / Announcement）
├── dao/        数据访问层（JDBC，含 DBUtil 连接工具）
├── servlet/    控制层（15 个 Servlet）
└── util/       PageBean 分页工具
src/main/webapp/
├── pages/      JSP 页面（admin / student / common）
├── css/ js/    样式与脚本
├── images/     图片资源
└── WEB-INF/lib 依赖 jar（JSTL 3.0、mysql-connector-j 8.0.33）
DB/student_system.sql   建库建表 + 初始数据
```

## 本地运行

1. **准备数据库**：安装 MySQL 8，执行 `DB/student_system.sql`，会创建 `student_system` 库与所需数据表。
2. **配置连接**：编辑 `src/main/java/com/dao/DBUtil.java`，把 `USER` / `PASSWORD` 改成你自己的 MySQL 账号密码。
3. **部署**：用 Eclipse 导入本项目（`File → Import → Existing Projects into Workspace`），添加到 Tomcat 10，然后
   `Run As → Run on Server`。
4. **访问**：浏览器打开 `http://localhost:8080/<项目名>/`，会跳转到登录页。

> 依赖说明：`src/main/webapp/WEB-INF/lib` 下的 jar 已随仓库提供，无需额外配置构建工具；
> 若在 IDEA 中运行，需把这两个 jar 加入 Artifact 的 `WEB-INF/lib`。

## 说明

- 数据库密码在仓库中已置为占位符，请自行填写，不要提交真实密码。
- 本项目为课程作业，代码以教学为目的，生产环境还需补充密码加密（如 BCrypt）、
  SQL 注入防护校验、CSRF 防护与连接池（如 HikariCP）。
