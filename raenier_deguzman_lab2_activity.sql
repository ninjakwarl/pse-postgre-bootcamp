CREATE TABLE public.course (
	course_id int4 NOT NULL,
	course_name varchar(50) NULL,
	department varchar(50) NULL,
	CONSTRAINT course_course_id_not_null NOT NULL course_id,
	CONSTRAINT course_pkey PRIMARY KEY (course_id)
);

CREATE TABLE public.enrollments (
	enrollment_id serial4 NOT NULL,
	student_id int4 NULL,
	course_id int4 NULL,
	enrollment_date date NULL,
	CONSTRAINT enrollments_enrollment_id_not_null NOT NULL enrollment_id,
	CONSTRAINT enrollments_pkey PRIMARY KEY (enrollment_id)
);

CREATE TABLE public.students (
	student_id serial4 NOT NULL,
	first_name varchar(50) NULL,
	last_name varchar(50) NULL,
	age int4 NULL,
	CONSTRAINT students_pkey PRIMARY KEY (student_id),
	CONSTRAINT students_student_id_not_null NOT NULL student_id
);

INSERT INTO course (course_id, course_name,department) 
values 
(1,'Introduction to Programming','ComSci Department'),
(2,'Accounting 101','Accountancy Department'),
(3,'Network Administration','IT Department');

INSERT INTO students (first_name, last_name, age)
VALUES
('Karl', 'Saycon', 25),
('Ana', 'Reyes', 21),
('John', 'Dela Cruz', 23);


INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2024-01-10'),
(1, 2, '2024-01-15'),
(2, 2, '2024-02-01'),
(3, 3, '2024-02-10');