# BudgetTrack - Dynamic Budget Management System

A dynamic web-based Budget Management System built with Java Servlets, JSP, CSS, and MySQL.

## Tech Stack
- Java 21
- Jakarta EE Servlets
- JSP (JavaServer Pages)
- MySQL (via XAMPP)
- Apache Tomcat 10.1
- CSS3 (Flexbox + Media Queries)
- Chart.js

## Project Structure
```
src/
└── main/
    ├── java/com/budgetmanagement/
    │   ├── config/        # DBConnection
    │   ├── controllers/   # Servlets + Filter
    │   ├── model/         # User, Transaction
    │   ├── service/       # UserService, TransactionService
    │   └── util/          # ValidationUtil
    └── webapp/
        ├── css/           # style.css
        ├── index.jsp
        └── WEB-INF/
            ├── web.xml
            ├── schema.sql
            ├── lib/       # JAR files
            └── pages/     # All JSP pages
```

## Setup Instructions
1. Install XAMPP and start MySQL
2. Create database by running `src/main/webapp/WEB-INF/schema.sql` in phpMyAdmin
3. Update DB password in `DBConnection.java` if needed (default is blank for XAMPP)
4. Import project into Eclipse as a Dynamic Web Project
5. Add JARs from `WEB-INF/lib/` to build path
6. Deploy on Apache Tomcat 10.1
7. Visit `http://localhost:8085/BudgeManagement/login`

## Default Admin Account
- Email: admin@budget.com
- Password: Admin@123
