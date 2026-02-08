-- Ortak Tablo İfadeleri (CTE) Kullanımı
-- Bir CTE, ana sorgu içinde referans verilebilen bir alt sorgu bloğu tanımlamanıza olanak tanır.
-- Özellikle özyinelemeli (recursive) sorgular veya daha üst bir seviyeye referans vermeyi gerektiren sorgular için yararlıdır.
-- Bu konuya bir sonraki derste bakacağız.

-- Bir CTE yazmanın temellerine bir göz atalım:


-- İlk olarak, CTE'ler "With" anahtar kelimesi kullanılarak başlar. Şimdi bu CTE'ye istediğimiz herhangi bir ismi verebiliriz.
-- Sonra "AS" deriz ve parantez içinde istediğimiz alt sorguyu/tabloyu oluştururuz.
WITH CTE_Example AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary), AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- CTE'yi tanımladıktan hemen sonra sorgulayabiliriz
SELECT *
FROM CTE_Example;


-- Şimdi eğer buraya aşağıya gelirsem, bu çalışmayacaktır çünkü (CTE kapsamı bittiği için) aynı sözdizimini kullanmıyor.
SELECT *
FROM CTE_Example;



-- Şimdi bu CTE içindeki sütunları, onsuz yapamayacağımız hesaplamaları bu veriler üzerinde
-- yapmak için kullanabiliriz.

WITH CTE_Example AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- Burada isimleri belirtmek için ters tırnak (back tick) kullanmak zorunda olduğuma dikkat edin - onlar olmadan çalışmaz
SELECT gender, ROUND(AVG(`SUM(salary)`/`COUNT(salary)`),2)
FROM CTE_Example
GROUP BY gender;



-- Ayrıca sadece tek bir With İfadesi ile birden fazla CTE oluşturma yeteneğine de sahibiz.

WITH CTE_Example AS 
(
SELECT employee_id, gender, birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
), -- Sadece virgül kullanarak ayırmamız gerekiyor
CTE_Example2 AS 
(
SELECT employee_id, salary
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
)
-- Şimdi bunu biraz değiştirirsek, bu iki CTE'yi birleştirebiliriz
SELECT *
FROM CTE_Example cte1
LEFT JOIN CTE_Example2 cte2
	ON cte1. employee_id = cte2. employee_id;


-- Size göstermek istediğim son şey, CTE içindeki sütunları yeniden adlandırarak aslında hayatımızı kolaylaştırabileceğimizdir.
-- Yaptığımız ilk CTE'yi ele alalım. Sütun isimleri yüzünden ters tırnak işaretleri kullanmak zorunda kalmıştık.

-- Onları şu şekilde yeniden adlandırabiliriz:
WITH CTE_Example (gender, sum_salary, min_salary, max_salary, count_salary) AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- Burada isimleri belirtmek için ters tırnak kullanmak zorunda olduğuma dikkat edin - onlar olmadan çalışmaz (Not: Alias kullandığımız için artık gerekmez ama yorumu çevirdim)
SELECT gender, ROUND(AVG(sum_salary/count_salary),2)
FROM CTE_Example
GROUP BY gender;