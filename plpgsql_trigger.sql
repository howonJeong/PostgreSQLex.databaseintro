DROP TABLE IF EXISTS instructor CASCADE;
DROP TABLE IF EXISTS department CASCADE;

CREATE TABLE department (
    dept_name VARCHAR(50) PRIMARY KEY,
    budget INT
);

CREATE TABLE instructor (
    ID INT PRIMARY KEY,
    name VARCHAR(50),
    dept_name VARCHAR(50),
    salary INT,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

INSERT INTO department (dept_name, budget) VALUES 
('CS', 50000),
('Math', 40000),
('Physics', 45000),
('Biology', 35000);

CREATE OR REPLACE FUNCTION update_budget()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.dept_name IS NOT NULL THEN
        UPDATE department
        SET budget = budget + NEW.salary
        WHERE dept_name = NEW.dept_name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER my_trigger
AFTER INSERT ON instructor
FOR EACH ROW
EXECUTE FUNCTION update_budget();

INSERT INTO instructor (ID, name, dept_name, salary) VALUES 
(1, 'Alice', 'CS', 7000),
(3, 'Charlie', 'Math', 5000),
(4, 'David', 'Physics', 7200),
(5, 'Eva', 'Biology', 4600);

SELECT * FROM department order by dept_name;

INSERT INTO instructor (ID, name, dept_name, salary) VALUES (6, 'Joe', 'CS', 8000);

SELECT * FROM department order by dept_name;

