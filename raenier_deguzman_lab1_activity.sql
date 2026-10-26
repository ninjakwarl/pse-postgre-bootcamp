CREATE DATABASE school_db;

CREATE TABLE public.courses (
	course_id serial4 NOT NULL,
	course_name varchar(100) NULL,
	department varchar(100) NULL,
	CONSTRAINT courses_course_id_not_null NOT NULL course_id,
	CONSTRAINT courses_pkey PRIMARY KEY (course_id)
);
