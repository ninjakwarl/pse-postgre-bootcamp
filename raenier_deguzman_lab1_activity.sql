C:\Users\PSE>psql -U postgres
Password for user postgres:

psql (18.6)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# \l
                                                                  List of databases
   Name    |  Owner   | Encoding | Locale Provider |         Collate          |          Ctype           | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+--------------------------+--------------------------+--------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 school_db | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           |
 template0 | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres          +
           |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | English_Philippines.1252 | English_Philippines.1252 |        |           | =c/postgres          +
           |          |          |                 |                          |                          |        |           | postgres=CTc/postgres
(4 rows)


postgres=# \c school_db
You are now connected to database "school_db" as user "postgres".
school_db=# CREATE TABLE courses (
school_db(# course_id SERIAL PRIMARY KEY,
school_db(# course_name VARCHAR(100),
school_db(# department VARCHAR(100)
school_db(# );
CREATE TABLE
school_db=# INSERT INTO courses (course_name, department)
school_db-# VALUES
school_db-# ('Database Systems', 'IT Department'),
school_db-# ('Programming 1', 'CS Department'),
school_db-# ('Networking', 'IT Department');
INSERT 0 3
school_db=# SELECT * FROM courses;
 course_id |   course_name    |  department
-----------+------------------+---------------
         1 | Database Systems | IT Department
         2 | Programming 1    | CS Department
         3 | Networking       | IT Department
(3 rows)


school_db=# \q

C:\Users\PSE>