-- Creating tables for PH-EmployeeDB 1
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);


-- Table 2
CREATE TABLE employees (
  	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

--Table 3
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);


--Table 4
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

--DROP TABLE salaries


--Tabla 5
CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (dept_no,emp_no)
);

--DROP TABLE dept_emp

--Tabla 6
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR(40) ,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, from_date)
);

--DROP TABLE titles

--SELECT * FROM titles;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;
DROP TABLE retirement_info

--Retirement tTitles
SELECT 
    emp.emp_no, 
	emp.first_name, 
	emp.last_name,
	--emp.birth_date,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees AS emp
JOIN titles AS t ON emp.emp_no = t.emp_no
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp.emp_no ASC;
SELECT * FROM retirement_titles;
DROP TABLE retirement_titles



-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no)
emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;
SELECT * FROM unique_titles;

-- Retiring Titles
select 
   count(*),
   title
into retiring_titles
from unique_titles
group by title
order by count desc;	
SELECT * FROM retiring_titles;


-- Deliverable 2: The Employees Eligible for the Mentorship Program

SELECT DISTINCT ON  (e.emp_no)
   e.emp_no,
   e.first_name,
   e.last_name,
   e.birth_date,
   dept.from_date,
   dept.to_date,
   t.title  
INTO mentorship_eligibilty
FROM employees AS e
JOIN dept_emp AS dept ON e.emp_no = dept.emp_no
JOIN titles AS t ON e.emp_no = t.emp_no
WHERE dept.to_date = '9999-01-01'
AND birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY e.emp_no ASC;
SELECT * FROM mentorship_eligibilty;
DROP TABLE mentorship_eligibilty

-- Total Employees Eligible for the Mentorship Program

SELECT 
    COUNT(*),
	title
FROM mentorship_eligibilty
GROUP BY title
ORDER BY COUNT DESC;






