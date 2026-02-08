SELECT * 
FROM parks_and_recreation.employee_demographics;



SELECT first_name
FROM employee_demographics;


SELECT first_name, last_name
FROM employee_demographics;



SELECT last_name, first_name, gender, age
FROM employee_demographics;


SELECT last_name, 
first_name, 
gender, 
age
FROM employee_demographics;


SELECT first_name,
 last_name,
 total_money_spent,
 total_money_spent + 100
FROM customers;


SELECT first_name, 
last_name,
salary,
salary + 100
FROM employee_salary;


SELECT first_name, 
last_name,
salary,
(salary + 100) * 10
FROM employee_salary;




SELECT department_id
FROM employee_salary;

SELECT DISTINCT department_id
FROM employee_salary;