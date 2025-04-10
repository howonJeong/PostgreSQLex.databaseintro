-- 1. 테이블 생성

CREATE TABLE Student (
    ID INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE department (
    dept_name VARCHAR(50) PRIMARY KEY,
    building VARCHAR(50),
    budget INT
);


CREATE TABLE Course (
    c_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(50),
    dept_name VARCHAR(50)
);

CREATE TABLE Take (
    ID INT,
    c_id VARCHAR(10),
    FOREIGN KEY (ID) REFERENCES Student(ID),
    FOREIGN KEY (c_id) REFERENCES Course(c_id)
);

CREATE TABLE Teaches (
    ID INT,
    c_id VARCHAR(10),
    FOREIGN KEY (c_id) REFERENCES Course(c_id)
);

CREATE TABLE Instructor (
    ID INT PRIMARY KEY,
    name VARCHAR(50),
    dept_name VARCHAR(50),
    salary INT
);

-- 2. 데이터 삽입

-- Student
INSERT INTO Student (ID, name) VALUES (20, 'Alice');
INSERT INTO Student (ID, name) VALUES (30, 'Charlie');
INSERT INTO Student (ID, name) VALUES (40, 'Bob');

-- Course
INSERT INTO Course (c_id, title, dept_name) VALUES ('swe3003', 'DB', 'Biology');
INSERT INTO Course (c_id, title, dept_name) VALUES ('swe3004', 'OS', 'CS');
INSERT INTO Course (c_id, title, dept_name) VALUES ('swe3021', 'Multicore', 'Biology');

-- Take
INSERT INTO Take (ID, c_id) VALUES (20, 'swe3003');
INSERT INTO Take (ID, c_id) VALUES (20, 'swe3004');
INSERT INTO Take (ID, c_id) VALUES (30, 'swe3004');
INSERT INTO Take (ID, c_id) VALUES (40, 'swe3003');
INSERT INTO Take (ID, c_id) VALUES (40, 'swe3021');

-- Teaches
INSERT INTO Teaches (ID, c_id) VALUES (10101, 'swe3003');
INSERT INTO Teaches (ID, c_id) VALUES (20202, 'swe3004');
INSERT INTO Teaches (ID, c_id) VALUES (30303, 'swe3021');

-- Instructor
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (11111, 'Prof. Kim', 'Biology', 40000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (22222, 'Prof. Lee', 'Biology', 45000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (33333, 'Prof. Park', 'CS', 50000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (44444, 'Prof. Choi', 'CS', 60000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (55555, 'Prof. Jung', 'Math', 39000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (66666, 'Prof. Ahn', 'Math', 50000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (77777, 'Prof. Seo', 'Physics', 46000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (88888, 'Prof. Kim', 'Physics', 47000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (99999, 'Prof. Moon', 'Engineering', 51000);
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES (12121, 'Prof. Yoon', 'Engineering', 50000);

-- department
INSERT INTO department (dept_name, building, budget) VALUES ('Biology', 'Bldg-A', 50000);
INSERT INTO department (dept_name, building, budget) VALUES ('CS', 'Bldg-B', 70000);
INSERT INTO department (dept_name, building, budget) VALUES ('Math', 'Bldg-C', 40000);
INSERT INTO department (dept_name, building, budget) VALUES ('Physics', 'Bldg-D', 55000);
INSERT INTO department (dept_name, building, budget) VALUES ('Engineering', 'Bldg-D', 155000);


-- 3. 쿼리 실행 예제

-- 쿼리 1: 교수 ID 10101이 가르치는 과목을 듣는 학생 수
SELECT COUNT(DISTINCT ID)
FROM Take
WHERE c_id IN (
    SELECT c_id
    FROM Teaches
    WHERE Teaches.ID = 10101
);

-- 쿼리 2: 조인 방식으로 동일 결과
SELECT COUNT(DISTINCT Take.ID)
FROM Take, Teaches 
WHERE Take.c_id = Teaches.c_id AND Teaches.ID = 10101;

-- 쿼리 3: 수강한 적 있는 학생 이름 출력
SELECT DISTINCT name
FROM Student NATURAL JOIN Take;

-- 쿼리 4: Correlated Subquery 방식
SELECT DISTINCT ID, name
FROM Student S
WHERE EXISTS (
    SELECT 1
    FROM Take T
    WHERE T.ID = S.ID
)
ORDER BY ID;

-- 쿼리 5: Biology 학과의 모든 과목을 수강한 학생
SELECT DISTINCT S.ID, S.name
FROM Student AS S
WHERE NOT EXISTS (
    (SELECT c_id FROM Course WHERE dept_name = 'Biology')
    EXCEPT
    (SELECT T.c_id FROM Take AS T WHERE S.ID = T.ID)
);

-- 쿼리 5-1: CS 학과의 모든 과목을 수강한 학생
SELECT DISTINCT St.ID, St.name
FROM Student AS St
WHERE NOT EXISTS (
    (SELECT c_id FROM Course WHERE dept_name = 'CS')
    EXCEPT
    (SELECT Te.c_id FROM Take AS Te WHERE St.ID = Te.ID)
);

-- 쿼리 6: 평균 연봉이 42000 이상인 학과의 이름과 평균 연봉 출력
SELECT dept_name, avg_salary
FROM (
    SELECT dept_name, AVG(salary) AS avg_salary
    FROM Instructor
    GROUP BY dept_name
) AS avg_table
WHERE avg_salary > 42000;

-- 쿼리 7: 복잡한 쿼리 사용 시 좋은 with Clause
-- 일시적인 temporary view 만들어서 소속 query에서 사용
-- find all departments where the total salary is greater than the average of the total
-- salary at all departments
WITH dept_total(dept_name, total_salary) AS (
    SELECT dept_name, SUM(salary)
    FROM Instructor
    GROUP BY dept_name
),
dept_total_avg(avg_total_salary) AS (
    SELECT AVG(total_salary)
    FROM dept_total
)
SELECT dept_name
FROM dept_total, dept_total_avg
WHERE dept_total.total_salary >= dept_total_avg.avg_total_salary;

-- 쿼리 8: 스칼라 서브쿼리 - 산술 비교 연산 가능한 서브쿼리이고.. 출력 2개 이상의 튜플일 시 런타임 에러
-- find the number of instructor of each department
SELECT dept_name, (SELECT count(*) from instructor as I where D.dept_name = I.dept_name) as num_instructors
from department as D;

-- 쿼리 8-1: 에러 케이스
-- SELECT name from instructor as I where salary * 10 > (SELECT budget from department as D where D.dept_name = I.dept_name)
