SELECT *
FROM employee_demographics;


SELECT gender
FROM employee_demographics
GROUP BY gender
;


SELECT first_name
FROM employee_demographics
GROUP BY gender
;





SELECT occupation
FROM employee_salary
GROUP BY occupation
;


SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary
;


SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
;

SELECT gender, MIN(age), MAX(age), COUNT(age),AVG(age)
FROM employee_demographics
GROUP BY gender
;



SELECT *
FROM customers
ORDER BY first_name;

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_demographics
ORDER BY first_name;

SELECT *
FROM employee_demographics
ORDER BY first_name DESC;


SELECT *
FROM employee_demographics
ORDER BY gender, age;

SELECT *
FROM employee_demographics
ORDER BY gender DESC, age DESC;


SELECT *
FROM employee_demographics
ORDER BY 5 DESC, 4 DESC;