-- Pencere Fonksiyonları (Window Functions)

-- Pencere fonksiyonları gerçekten güçlüdür ve bir nevi group by gibidir - ancak gruplandırma yaparken her şeyi tek bir satıra sıkıştırmazlar.
-- Pencere fonksiyonları bir bölüme (partition) veya bir gruba bakmamızı sağlar, ancak çıktıda her biri kendi benzersiz satırlarını korur.
-- Ayrıca Row Numbers (Satır Numaraları), rank ve dense rank gibi konulara da bakacağız.

SELECT * FROM employee_demographics;

-- Önce group by işlemine bir bakalım
SELECT gender, ROUND(AVG(salary),1)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;

-- Şimdi benzer bir şeyi pencere fonksiyonu ile yapmayı deneyelim

SELECT dem.employee_id, dem.first_name, gender, salary,
AVG(salary) OVER()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- Şimdi istediğimiz sütunları ekleyebiliriz ve çalışır. Bu çıktının aynısını select ifadesindeki bir alt sorgu ile de elde edebilirdik,
-- ama pencere fonksiyonlarının çok daha fazla işlevi vardır, hadi bir göz atalım.


-- Eğer partition kullanırsak, bu biraz group by gibidir ancak satırları birleştirmez (roll up yapmaz) - sadece hesaplama yaparken bir sütuna dayalı olarak böler veya ayırır.

SELECT dem.employee_id, dem.first_name, gender, salary,
AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;


-- Şimdi cinsiyetler için maaşların ne olduğunu görmek isteseydik bunu sum (toplama) kullanarak yapabilirdik, ama aynı zamanda kümülatif toplam (rolling total) almak için order by da kullanabilirdik.

SELECT dem.employee_id, dem.first_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY employee_id)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;


-- Şimdi row_number, rank ve dense rank fonksiyonlarına bakalım


SELECT dem.employee_id, dem.first_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- Maaşa göre sıralamayı deneyelim, böylece cinsiyete göre en yüksek maaş alan çalışanların sırasını görebiliriz.
SELECT dem.employee_id, dem.first_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary desc)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- Bunu rank ile karşılaştıralım
SELECT dem.employee_id, dem.first_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary desc) row_num,
Rank() OVER(PARTITION BY gender ORDER BY salary desc) rank_1 
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- Rank'in Tom ve Jerry'de 5 numarasında tekrar ettiğini, ancak sonra 6'yı atlayıp 7'ye gittiğini fark edin -- bu, konumsal sıralamaya dayanır.


-- Bunu dense rank ile karşılaştıralım
SELECT dem.employee_id, dem.first_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary desc) row_num,
Rank() OVER(PARTITION BY gender ORDER BY salary desc) rank_1,
dense_rank() OVER(PARTITION BY gender ORDER BY salary desc) dense_rank_2 -- Bu, rank gibi konumsal olmak yerine sayısal olarak sıralanır (sıra atlamaz).
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;