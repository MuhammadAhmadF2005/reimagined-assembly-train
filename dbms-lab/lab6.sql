--2024335
--Muhammad Ahmad

CREATE TABLE Employee ( 
    emp_id INT PRIMARY KEY, 
    emp_name VARCHAR(50), 
    department_id INT, 
    salary DECIMAL(10,2) 
); 

CREATE TABLE Department ( 
    department_id INT PRIMARY KEY, 
    department_name VARCHAR(50), 
    min_salary DECIMAL(10,2) 
); 

CREATE TABLE Project ( 
    project_id INT PRIMARY KEY, 
    project_name VARCHAR(50), 
    emp_id INT 
); 

INSERT INTO Employee (emp_id, emp_name, department_id, salary) VALUES 
(1, 'Alice', 1, 60000), 
(2, 'Bob', 2, 75000), 
(3, 'Charlie', 1, 50000), 
(4, 'David', NULL, 55000), 
(5, 'Eve', 3, 80000); 

INSERT INTO Department (department_id, department_name, min_salary) VALUES 
(1, 'HR', 40000), 
(2, 'IT', 50000), 
(3, 'Finance', 70000), 
(4, 'Marketing', 45000); 

INSERT INTO Project (project_id, project_name, emp_id) VALUES 
(1, 'Project A', 1), 
(2, 'Project B', 2), 
(3, 'Project C', 3), 
(4, 'Project D', 5), 
(5, 'Project E', NULL); 


-- Task 1: 
SELECT e.emp_name, d.department_name
FROM Employee e
INNER JOIN Department d ON e.department_id = d.department_id;

-- Task 2: 
SELECT e.emp_name, d.department_name
FROM Employee e
LEFT JOIN Department d ON e.department_id = d.department_id;

-- Task 3: 
SELECT e.emp_name, d.department_name
FROM Employee e
RIGHT JOIN Department d ON e.department_id = d.department_id;

-- Task 4:
SELECT e.emp_name, d.department_name
FROM Employee e
FULL OUTER JOIN Department d ON e.department_id = d.department_id;

-- Task 5: 
SELECT * FROM Project 
INNER JOIN Employee USING emp_id;