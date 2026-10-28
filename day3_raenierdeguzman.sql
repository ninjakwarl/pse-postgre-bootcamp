C:\Program Files\PostgreSQL\18\bin>psql -U postgres
Password for user postgres:

psql (18.6)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# \l
                                                                      List of databases
      Name       |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |    Access privileges
-----------------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-------------------------
 postgres        | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_backup_demo | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_maintenance | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =Tc/postgres           +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres  +
                 |          |          |                 |                          |                          |        |           | student_user=c/postgres
 template0       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(6 rows)


postgres=# CREATE DATABASE company_db;
CREATE DATABASE
postgres=# \c company_db
You are now connected to database "company_db" as user "postgres".
company_db=# CREATE TABLE departments (
company_db(#
company_db(#     dept_id SERIAL PRIMARY KEY,
company_db(#
company_db(#     dept_name VARCHAR(100)
company_db(#
company_db(# );
CREATE TABLE
company_db=# CREATE TABLE employees (
company_db(#
company_db(#     emp_id SERIAL PRIMARY KEY,
company_db(#
company_db(#     emp_name VARCHAR(100),
company_db(#
company_db(#     salary NUMERIC,
company_db(#
company_db(#     dept_id INT
company_db(#
company_db(# );
CREATE TABLE
company_db=# CREATE TABLE projects (
company_db(#
company_db(#     project_id SERIAL PRIMARY KEY,
company_db(#
company_db(#     project_name VARCHAR(100),
company_db(#
company_db(#     dept_id INT
company_db(#
company_db(# );
CREATE TABLE
company_db=# CREATE TABLE employee_projects (
company_db(#
company_db(#     emp_id INT,
company_db(#
company_db(#     project_id INT
company_db(#
company_db(# );
CREATE TABLE
company_db=# \l
                                                                      List of databases
      Name       |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |    Access privileges
-----------------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-------------------------
 company_db      | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 postgres        | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_backup_demo | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_maintenance | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =Tc/postgres           +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres  +
                 |          |          |                 |                          |                          |        |           | student_user=c/postgres
 template0       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(7 rows)


company_db=#

company_db=# INSERT INTO departments (dept_name) VALUES ('IT'), ('HR'), ('Finance'), ('Marketing');
INSERT 0 4
company_db=# INSERT INTO employees (emp_name, salary, dept_id) VALUES
company_db-# ('Karl', 50000, 1),
company_db-# ('Ana', 45000, 2),
company_db-# ('John', 60000, 1),
company_db-# ('Lisa', 55000, 3),
company_db-# ('Mark', 40000, 4);
INSERT 0 5
company_db=# INSERT INTO projects (project_name, dept_id) VALUES
company_db-# ('System Upgrade', 1),
company_db-# ('Recruitment Drive', 2),
company_db-# ('Budget Planning', 3),
company_db-# ('Ad Campaign', 4);
INSERT 0 4
company_db=# INSERT INTO employee_projects VALUES (1,1),(1,2),(2,2),(3,1),(4,3),(5,4);
INSERT 0 6
company_db=#

company_db=# SELECT
company_db-#     e.emp_name AS "Employee Name",
company_db-#     d.dept_name AS "Department Name",
company_db-#     p.project_name AS "Project Name"
company_db-# FROM employees e
company_db-# INNER JOIN departments d
company_db-#     ON e.dept_id = d.dept_id
company_db-# INNER JOIN employee_projects ep
company_db-#     ON e.emp_id = ep.emp_id
company_db-# INNER JOIN projects p
company_db-#     ON ep.project_id = p.project_id
company_db-# ORDER BY e.emp_id, p.project_id;
 Employee Name | Department Name |   Project Name
---------------+-----------------+-------------------
 Karl          | IT              | System Upgrade
 Karl          | IT              | Recruitment Drive
 Ana           | HR              | Recruitment Drive
 John          | IT              | System Upgrade
 Lisa          | Finance         | Budget Planning
 Mark          | Marketing       | Ad Campaign
(6 rows)


company_db=#

company_db=# SELECT
company_db-#     d.dept_name AS "Department Name",
company_db-#     COUNT(e.emp_id) AS "Total Employees"
company_db-# FROM departments d
company_db-# LEFT JOIN employees e
company_db-#     ON d.dept_id = e.dept_id
company_db-# GROUP BY d.dept_id, d.dept_name
company_db-# ORDER BY d.dept_id;
 Department Name | Total Employees
-----------------+-----------------
 IT              |               2
 HR              |               1
 Finance         |               1
 Marketing       |               1
(4 rows)


company_db=#

company_db=# SELECT
company_db-#     d.dept_name AS "Department",
company_db-#     ROUND(AVG(e.salary), 2) AS "Average Salary",
company_db-#     COUNT(DISTINCT p.project_id) AS "Total Projects Handled"
company_db-# FROM departments d
company_db-# LEFT JOIN employees e
company_db-#     ON d.dept_id = e.dept_id
company_db-# LEFT JOIN projects p
company_db-#     ON d.dept_id = p.dept_id
company_db-# GROUP BY d.dept_id, d.dept_name
company_db-# ORDER BY d.dept_id;
 Department | Average Salary | Total Projects Handled
------------+----------------+------------------------
 IT         |       55000.00 |                      1
 HR         |       45000.00 |                      1
 Finance    |       55000.00 |                      1
 Marketing  |       40000.00 |                      1
(4 rows)


company_db=#

company_db=# SELECT
company_db-#     CONCAT(e.emp_name, ' - ', d.dept_name) AS "Employee - Department"
company_db-# FROM employees e
company_db-# INNER JOIN departments d
company_db-#     ON e.dept_id = d.dept_id
company_db-# WHERE d.dept_name = 'IT'
company_db-# ORDER BY e.emp_id;
 Employee - Department
-----------------------
 Karl - IT
 John - IT
(2 rows)


company_db=#

company_db=# SELECT * FROM employees;
 emp_id | emp_name | salary | dept_id
--------+----------+--------+---------
      1 | Karl     |  50000 |       1
      2 | Ana      |  45000 |       2
      3 | John     |  60000 |       1
      4 | Lisa     |  55000 |       3
      5 | Mark     |  40000 |       4
(5 rows)


company_db=# INSERT INTO employees (emp_name, salary, dept_id) VALUES ('NewEmployee', 48000, 1);
INSERT 0 1
company_db=# SELECT * FROM employees;
 emp_id |  emp_name   | salary | dept_id
--------+-------------+--------+---------
      1 | Karl        |  50000 |       1
      2 | Ana         |  45000 |       2
      3 | John        |  60000 |       1
      4 | Lisa        |  55000 |       3
      5 | Mark        |  40000 |       4
      6 | NewEmployee |  48000 |       1
(6 rows)


company_db=# UPDATE employees SET salary = 70000 WHERE emp_name = 'Karl';
UPDATE 1
company_db=# SELECT * FROM employees;
 emp_id |  emp_name   | salary | dept_id
--------+-------------+--------+---------
      2 | Ana         |  45000 |       2
      3 | John        |  60000 |       1
      4 | Lisa        |  55000 |       3
      5 | Mark        |  40000 |       4
      6 | NewEmployee |  48000 |       1
      1 | Karl        |  70000 |       1
(6 rows)


company_db=# DELETE FROM employees WHERE emp_name = 'Mark';
DELETE 1
company_db=# SELECT * FROM employees;
 emp_id |  emp_name   | salary | dept_id
--------+-------------+--------+---------
      2 | Ana         |  45000 |       2
      3 | John        |  60000 |       1
      4 | Lisa        |  55000 |       3
      6 | NewEmployee |  48000 |       1
      1 | Karl        |  70000 |       1
(5 rows)


company_db=#


C:\postgresql_backups>pg_dump -U postgres -d company_db -f company_backup.sql
Password:


C:\postgresql_backups>dir
 Volume in drive C is Windows
 Volume Serial Number is 62FE-3091

 Directory of C:\postgresql_backups

28/10/2026  16:16    <DIR>          .
28/10/2026  16:16             5,649 company_backup.sql
28/10/2026  14:08             3,624 pse_backup_demo.dump
               2 File(s)          9,273 bytes
               1 Dir(s)  111,880,433,664 bytes free

C:\postgresql_backups>


C:\postgresql_backups>psql -U postgres
Password for user postgres:

psql (18.6)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# \l
                                                                      List of databases
      Name       |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |    Access privileges
-----------------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-------------------------
 company_db      | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 postgres        | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_backup_demo | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_maintenance | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =Tc/postgres           +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres  +
                 |          |          |                 |                          |                          |        |           | student_user=c/postgres
 template0       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(7 rows)


postgres=# DROP DATABASE company_db;
DROP DATABASE
postgres=# \l
                                                                      List of databases
      Name       |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |    Access privileges
-----------------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-------------------------
 postgres        | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_backup_demo | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_maintenance | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =Tc/postgres           +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres  +
                 |          |          |                 |                          |                          |        |           | student_user=c/postgres
 template0       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(6 rows)


postgres=#



C:\postgresql_backups>psql -U postgres
Password for user postgres:

psql (18.6)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# \l
                                                                      List of databases
      Name       |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |    Access privileges
-----------------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-------------------------
 postgres        | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_backup_demo | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_maintenance | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =Tc/postgres           +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres  +
                 |          |          |                 |                          |                          |        |           | student_user=c/postgres
 template0       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(6 rows)


postgres=# CREATE DATABASE company_db;
CREATE DATABASE
postgres=# \l
                                                                      List of databases
      Name       |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |    Access privileges
-----------------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-------------------------
 company_db      | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 postgres        | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_backup_demo | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_maintenance | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =Tc/postgres           +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres  +
                 |          |          |                 |                          |                          |        |           | student_user=c/postgres
 template0       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(7 rows)


postgres=# \c company_db
You are now connected to database "company_db" as user "postgres".
company_db=# \dt
Did not find any tables.
company_db=#

C:\postgresql_backups>psql -U postgres -d company_db -f company_backup.sql
Password for user postgres:

SET
SET
SET
SET
SET
SET
 set_config
------------

(1 row)


SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
ALTER TABLE
COPY 4
COPY 6
COPY 5
COPY 4
 setval
--------
      4
(1 row)


 setval
--------
      6
(1 row)


 setval
--------
      4
(1 row)


ALTER TABLE
ALTER TABLE
ALTER TABLE

C:\postgresql_backups>


C:\postgresql_backups>psql -U postgres
Password for user postgres:

psql (18.6)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# \l
                                                                      List of databases
      Name       |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |    Access privileges
-----------------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-------------------------
 company_db      | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 postgres        | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_backup_demo | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 pse_maintenance | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =Tc/postgres           +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres  +
                 |          |          |                 |                          |                          |        |           | student_user=c/postgres
 template0       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1       | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres            +
                 |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(7 rows)


postgres=# \c company_db
You are now connected to database "company_db" as user "postgres".
company_db=# \dt
                List of tables
 Schema |       Name        | Type  |  Owner
--------+-------------------+-------+----------
 public | departments       | table | postgres
 public | employee_projects | table | postgres
 public | employees         | table | postgres
 public | projects          | table | postgres
(4 rows)


company_db=# SELECT * FROM departments;
 dept_id | dept_name
---------+-----------
       1 | IT
       2 | HR
       3 | Finance
       4 | Marketing
(4 rows)


company_db=# SELECT * FROM employee_projects;
 emp_id | project_id
--------+------------
      1 |          1
      1 |          2
      2 |          2
      3 |          1
      4 |          3
      5 |          4
(6 rows)


company_db=# SELECT * FROM employees;
 emp_id |  emp_name   | salary | dept_id
--------+-------------+--------+---------
      2 | Ana         |  45000 |       2
      3 | John        |  60000 |       1
      4 | Lisa        |  55000 |       3
      6 | NewEmployee |  48000 |       1
      1 | Karl        |  70000 |       1
(5 rows)


company_db=# SELECT * FROM projects;
 project_id |   project_name    | dept_id
------------+-------------------+---------
          1 | System Upgrade    |       1
          2 | Recruitment Drive |       2
          3 | Budget Planning   |       3
          4 | Ad Campaign       |       4
(4 rows)


company_db=#

C:\postgresql_backups>pg_basebackup -U postgres -D C:\postgresql_backups\backup_lab3 -Fp -Xs -P
Password:

77867/77867 kB (100%), 1/1 tablespace

C:\postgresql_backups>dir C:\postgresql_backups\backup_lab3
 Volume in drive C is Windows
 Volume Serial Number is 62FE-3091

 Directory of C:\postgresql_backups\backup_lab3

28/10/2026  16:24    <DIR>          .
28/10/2026  16:22    <DIR>          ..
28/10/2026  16:24               225 backup_label
28/10/2026  16:24           323,549 backup_manifest
28/10/2026  16:24    <DIR>          base
28/10/2026  16:24                45 current_logfiles
28/10/2026  16:24    <DIR>          global
28/10/2026  16:24    <DIR>          log
28/10/2026  16:24    <DIR>          pg_commit_ts
28/10/2026  16:24    <DIR>          pg_dynshmem
28/10/2026  16:24             5,718 pg_hba.conf
28/10/2026  16:24             2,753 pg_ident.conf
28/10/2026  16:24    <DIR>          pg_logical
28/10/2026  16:24    <DIR>          pg_multixact
28/10/2026  16:24    <DIR>          pg_notify
28/10/2026  16:24    <DIR>          pg_replslot
28/10/2026  16:24    <DIR>          pg_serial
28/10/2026  16:24    <DIR>          pg_snapshots
28/10/2026  16:24    <DIR>          pg_stat
28/10/2026  16:24    <DIR>          pg_stat_tmp
28/10/2026  16:24    <DIR>          pg_subtrans
28/10/2026  16:24    <DIR>          pg_tblspc
28/10/2026  16:24    <DIR>          pg_twophase
28/10/2026  16:24                 3 PG_VERSION
28/10/2026  16:24    <DIR>          pg_wal
28/10/2026  16:24    <DIR>          pg_xact
28/10/2026  16:24                90 postgresql.auto.conf
28/10/2026  16:24            33,445 postgresql.conf
               8 File(s)        365,828 bytes
              20 Dir(s)  111,753,490,432 bytes free

C:\postgresql_backups>


company_db=# SELECT
company_db-#     e.emp_name AS "Employee Name",
company_db-#     d.dept_name AS "Department",
company_db-#     COUNT(DISTINCT ep.project_id) AS "Total Projects",
company_db-#     RANK() OVER (ORDER BY e.salary DESC) AS "Rank by Salary"
company_db-# FROM employees e
company_db-# INNER JOIN departments d
company_db-#     ON e.dept_id = d.dept_id
company_db-# LEFT JOIN employee_projects ep
company_db-#     ON e.emp_id = ep.emp_id
company_db-# GROUP BY
company_db-#     e.emp_id,
company_db-#     e.emp_name,
company_db-#     d.dept_name,
company_db-#     e.salary
company_db-# ORDER BY e.salary DESC;
 Employee Name | Department | Total Projects | Rank by Salary
---------------+------------+----------------+----------------
 Karl          | IT         |              2 |              1
 John          | IT         |              1 |              2
 Lisa          | Finance    |              1 |              3
 NewEmployee   | IT         |              0 |              4
 Ana           | HR         |              1 |              5
(5 rows)


company_db=#