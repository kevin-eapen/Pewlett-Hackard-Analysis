-- Deliverable 1: The Number of Retiring Employees by Title

-- Create new table with retiring employees by title
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    ti.title,
    ti.from_date,
    ti.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

-- Remove duplicates from retirement_titles and create new table
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
    first_name,
    last_name,
    title
INTO unique_titles
FROM retirement_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no ASC, to_date DESC;

-- Retrieve count of retiring employees by most recent title
SELECT COUNT(emp_no) AS title_total, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY title_total DESC;

-- Deliverable 2: The Employees Eligible for the Mentorship Program

-- Create new table for employees eligible for mentorship program
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    ti.title
-- INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;


-- ADDITIONAL QUERIES AND TABLES

-- Find total number of employees with the 'Manager' title
SELECT COUNT(e.emp_no) AS employee_count, ti.title
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (ti.to_date = '9999-01-01')
GROUP BY ti.title
ORDER BY employee_count DESC;

-- Confirming same results as above using DISTINCT ON and WITH
-- Company-wide employees by title
WITH company_wide_titles AS (
    SELECT e.emp_no,
    e.first_name,
    e.last_name,
    ti.title,
    ti.from_date,
    ti.to_date
    FROM employees AS e
    INNER JOIN titles as ti
    ON (e.emp_no = ti.emp_no)
    ORDER BY e.emp_no ASC),
    -- Use Dictinct with Orderby to remove duplicate rows    
    company_wide_unique_titles AS (
    SELECT DISTINCT ON (emp_no) emp_no,
        first_name,
        last_name,
        title
    FROM company_wide_titles
    WHERE to_date = ('9999-01-01')
    ORDER BY emp_no ASC, to_date DESC)
-- Retrieve count of company-wide employees by most recent title
SELECT COUNT(emp_no) AS title_total, title
FROM company_wide_unique_titles
GROUP BY title
ORDER BY title_total DESC;

-- Find total number of employees at PH
SELECT COUNT(*) FROM employees;

-- Mentorship eligibilty for employees born 1960-01-01 - 1965-12-31
-- Create new table for employees eligible for mentorship program
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    ti.title
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1964-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Retrieve count of mentorship-eligible employees by title
WITH mentorship_titles AS (
    SELECT DISTINCT ON (e.emp_no) e.emp_no,
        e.first_name,
        e.last_name,
        e.birth_date,
        de.from_date,
        de.to_date,
        ti.title
    FROM employees AS e
    INNER JOIN dept_emp AS de
    ON (e.emp_no = de.emp_no)
    INNER JOIN titles AS ti
    ON (e.emp_no = ti.emp_no)
    WHERE (de.to_date = '9999-01-01')
    AND (e.birth_date BETWEEN '1964-01-01' AND '1965-12-31')
    ORDER BY e.emp_no)
-- Table with counts per title
SELECT COUNT(emp_no) AS title_total, title
FROM mentorship_titles
GROUP BY title
ORDER BY title_total DESC;
