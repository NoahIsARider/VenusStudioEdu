-- PostgreSQL Joins Example File
-- This file demonstrates various JOIN operations in PostgreSQL

-- 1. Setup sample tables for demonstration
-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100)
);

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER,
    salary DECIMAL(10,2),
    hire_date DATE
);

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER,
    start_date DATE,
    end_date DATE
);

-- Create employee_projects table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS employee_projects (
    employee_id INTEGER,
    project_id INTEGER,
    hours_worked DECIMAL(6,2),
    PRIMARY KEY (employee_id, project_id)
);

-- 2. Insert sample data
INSERT INTO departments (name, location) VALUES
('Engineering', 'Building A'),
('Marketing', 'Building B'),
('Sales', 'Building C'),
('HR', 'Building D');

INSERT INTO employees (name, department_id, salary, hire_date) VALUES
('Alice Johnson', 1, 75000.00, '2020-01-15'),
('Bob Smith', 2, 65000.00, '2019-03-22'),
('Charlie Brown', 3, 70000.00, '2021-07-10'),
('Diana Prince', 1, 80000.00, '2018-11-05'),
('Eve Wilson', 3, 68000.00, '2020-05-30'),
('Frank Miller', NULL, 60000.00, '2022-01-01');  -- Employee with no department

INSERT INTO projects (name, department_id, start_date, end_date) VALUES
('Website Redesign', 1, '2023-01-01', '2023-06-30'),
('Marketing Campaign', 2, '2023-02-01', '2023-05-31'),
('Sales Tool Development', 3, '2023-03-01', '2023-09-30'),
('HR System Upgrade', 4, '2023-04-01', '2023-08-31');

INSERT INTO employee_projects (employee_id, project_id, hours_worked) VALUES
(1, 1, 120.50),  -- Alice on Website Redesign
(2, 2, 80.25),   -- Bob on Marketing Campaign
(3, 3, 95.75),   -- Charlie on Sales Tool Development
(4, 1, 110.00),  -- Diana on Website Redesign
(1, 3, 45.50);   -- Alice also on Sales Tool Development

-- 3. INNER JOIN Examples
-- Find employees and their departments
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

-- Find employees, their departments, and projects they work on
SELECT e.name AS employee_name, d.name AS department_name, p.name AS project_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
INNER JOIN employee_projects ep ON e.id = ep.employee_id
INNER JOIN projects p ON ep.project_id = p.id;

-- 4. LEFT JOIN Examples
-- Find all employees and their departments (including those without departments)
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;

-- Find all employees and projects they work on (including those not assigned to projects)
SELECT e.name AS employee_name, p.name AS project_name, ep.hours_worked
FROM employees e
LEFT JOIN employee_projects ep ON e.id = ep.employee_id
LEFT JOIN projects p ON ep.project_id = p.id;

-- 5. RIGHT JOIN Examples
-- Find all departments and their employees (including departments with no employees)
SELECT d.name AS department_name, e.name AS employee_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;

-- 5. FULL OUTER JOIN Examples
-- Find all employees and departments, regardless of matching
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;

-- 6. CROSS JOIN Examples
-- Generate all possible combinations of employees and departments
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
CROSS JOIN departments d;

-- 7. Self JOIN Examples
-- Find employees who were hired before others in the same department
SELECT e1.name AS senior_employee, e2.name AS junior_employee, 
       e1.hire_date AS senior_hire_date, e2.hire_date AS junior_hire_date
FROM employees e1
INNER JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.hire_date < e2.hire_date;

-- 8. Advanced JOIN with Aggregation
-- Calculate total hours worked by department
SELECT d.name AS department_name, SUM(ep.hours_worked) AS total_hours
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
LEFT JOIN employee_projects ep ON e.id = ep.employee_id
GROUP BY d.id, d.name;

-- Find average salary by department with employee count
SELECT d.name AS department_name, 
       COUNT(e.id) AS employee_count,
       AVG(e.salary) AS average_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name;

-- 9. JOIN with Subqueries
-- Find employees working on projects for other departments
SELECT e.name AS employee_name, 
       d1.name AS employee_department,
       d2.name AS project_department,
       p.name AS project_name
FROM employees e
JOIN departments d1 ON e.department_id = d1.id
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id
JOIN departments d2 ON p.department_id = d2.id
WHERE e.department_id != p.department_id;

-- 10. LATERAL JOIN Examples (PostgreSQL specific)
-- For each department, find the highest paid employee
SELECT d.name AS department_name, e.name AS highest_paid_employee, e.salary
FROM departments d
LEFT JOIN LATERAL (
    SELECT name, salary
    FROM employees e2
    WHERE e2.department_id = d.id
    ORDER BY salary DESC
    LIMIT 1
) e ON true;

-- 11. JOIN with USING clause (when column names are identical)
-- Create a table with same column name for demonstration
CREATE TABLE IF NOT EXISTS employee_backup (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER,
    salary DECIMAL(10,2)
);

INSERT INTO employee_backup (name, department_id, salary) VALUES
('Alice Johnson', 1, 75000.00),
('Bob Smith', 2, 65000.00);

-- Join using common column name
SELECT e.name AS current_name, eb.name AS backup_name
FROM employees e
JOIN employee_backup eb USING (id);

-- 12. NATURAL JOIN Examples
-- Automatically joins on columns with same names
SELECT e.name AS employee_name, d.name AS department_name
FROM employees e
NATURAL JOIN departments d;  -- This will not work as intended since no column names match except id

-- Clean up (uncomment if needed)
-- DROP TABLE IF EXISTS employee_projects, projects, employees, departments, employee_backup;