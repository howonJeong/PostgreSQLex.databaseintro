CREATE TABLE student (
    student_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE course (
    course_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(50)
);

CREATE TABLE takes (
    student_id INT,
    course_id VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

-- Students
INSERT INTO student (student_id, name) VALUES (1, 'Alice');
INSERT INTO student (student_id, name) VALUES (2, 'Bob');
INSERT INTO student (student_id, name) VALUES (3, 'Charlie');
INSERT INTO student (student_id, name) VALUES (4, 'Diana');

-- Courses
INSERT INTO course (course_id, title) VALUES ('CS101', 'Intro to CS');
INSERT INTO course (course_id, title) VALUES ('CS102', 'Data Structures');
INSERT INTO course (course_id, title) VALUES ('CS103', 'Algorithms');
INSERT INTO course (course_id, title) VALUES ('CS104', 'Databases');

-- Takes
INSERT INTO takes (student_id, course_id) VALUES (1, 'CS101');
INSERT INTO takes (student_id, course_id) VALUES (1, 'CS104');
INSERT INTO takes (student_id, course_id) VALUES (2, 'CS102');
INSERT INTO takes (student_id, course_id) VALUES (3, 'CS103');
INSERT INTO takes (student_id, course_id) VALUES (4, 'CS101');
INSERT INTO takes (student_id, course_id) VALUES (4, 'CS102');

--query 1. natural join을 하기엔 3개이상의 테이블에서 중복되는 이름의, 그러나 다른 의미의 attribute가 있을 때 해결.
-- ex. dept_name of student = dept_name of takes != dept_name of course

--모호하여 결과 x
SELECT *
FROM (student NATURAL JOIN takes) JOIN course;

--using을 사용하여 이명 칼럼을 기준으로 조인
SELECT *
FROM (student NATURAL JOIN takes) JOIN course USING(course_id);

--using을 사용하여 이명 칼럼을 기준으로 조인
SELECT *
FROM (student NATURAL JOIN takes) JOIN course USING(course_id);


--on을 사용시
SELECT *
FROM (student NATURAL JOIN takes) JOIN course;
