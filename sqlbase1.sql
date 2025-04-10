CREATE TABLE Instructor (
  ID varchar(5),
  name varchar(20),
  dept_name varchar(30),
  salary int
);

INSERT INTO Instructor(ID, name, dept_name, salary) VALUES
('10', 'NAM', 'Comp. Sci.', 70000),
('20', 'Alice', 'Electrical Eng.', 90000),
('1001', 'Alice', 'Computer Science', 90000),
('1002', 'Bob', 'Electrical Eng.', 85000),
('1003', 'Charlie', 'Mathematics', 78000),
('1004', 'David', 'Physics', 81000),
('1005', 'Eve', 'Computer Science', 92000),
('1006', 'Frank', 'Biology', 75000),
('1007', 'Grace', 'Chemistry', 77000),
('1008', 'Heidi', 'Electrical Eng.', 83000),
('1009', 'Ivan', 'Computer Science', 95000),
('1010', 'Judy', 'Mathematics', 76000),
('1011', 'Ken', 'Physics', 80000),
('1012', 'Laura', 'Biology', 74000),
('1013', 'Mallory', 'Computer Science', 88000),
('1014', 'Niaj', 'Mathematics', 79000),
('1015', 'Olivia', 'Physics', 82000),
('1016', 'Peggy', 'Chemistry', 77000),
('1017', 'Quentin', 'Electrical Eng.', 86000),
('1018', 'Rupert', 'Computer Science', 91000),
('1019', 'Sybil', 'Mathematics', 80000),
('1020', 'Trent', 'Biology', 73000);


CREATE TABLE Teaches (
  ID varchar(5),
  c_id varchar(10),
  semester varchar(20), 
  year varchar(20)
);

INSERT INTO Teaches(ID, c_id, semester, year) VALUES
('10', 'swe3003', 'Spring', '2025'),
('20', 'swe3003', 'Fall', '2024'),
('10', 'swe3004', 'Spring', '2024');

CREATE TABLE Course (
  c_id varchar(10),
  title varchar(10),
  dept_name varchar(20)
);

INSERT INTO Course(c_id, title, dept_name) VALUES
('swe3003', 'DB', 'Comp. Sci.'),
('swe3004', 'OS', 'Comp. Sci.');

SELECT * FROM instructor natural join teaches, course
where teaches.c_id = Course.c_id
order by ID desc;

SELECT * FROM instructor natural join teaches, course
where teaches.c_id = Course.c_id and name like 'A%'; --prefix

-- find courses that were offered in fall 2024 or in Spring 2025

(SELECT c_id from teaches where semester = 'fall' and year = '2024')
UNION
(SELECT c_id from teaches where semester = 'Spring' and year = '2025');


select dept_name, avg(salary)
from instructor
group by dept_name
having avg(salary)>80000
order by avg(salary) desc;

select dept_name, avg(salary)
from instructor
group by dept_name
having avg(salary)<80000
order by avg(salary) desc;

