# Alt Sorgular (Subqueries)

#Yani alt sorgular, sorgular içindeki sorgulardır. Bunun nasıl göründüğüne bakalım.

SELECT *
FROM employee_demographics;


#Şimdi diyelim ki aslında Park ve Bahçeler Departmanında çalışan çalışanlara bakmak istiyoruz, tabloları birleştirebiliriz (join) veya bir alt sorgu kullanabiliriz
#Bunu şu şekilde yapabiliriz:

SELECT *
FROM employee_demographics
WHERE employee_id IN 
			(SELECT employee_id
				FROM employee_salary
                WHERE dept_id = 1);
                
#Yani o alt sorguyu where ifadesinde kullanıyoruz ve eğer sadece alt sorguyu seçip çalıştırırsak, bu temel olarak dış sorguda seçim yaptığımız bir listedir.

SELECT *
FROM employee_demographics
WHERE employee_id IN 
			(SELECT employee_id, salary
				FROM employee_salary
                WHERE dept_id = 1);

#Şimdi eğer alt sorguda 1'den fazla sütun bulundurmaya çalışırsak, işlenenin (operand) yalnızca 1 sütun içermesi gerektiğini söyleyen bir hata alırız.

#Alt sorguları select ve from ifadelerinde de kullanabiliriz - bunu nasıl yapabileceğimize bakalım

-- Diyelim ki maaşlara bakmak ve onları ortalama maaşla karşılaştırmak istiyoruz

SELECT first_name, salary, AVG(salary)
FROM employee_salary;
-- Eğer bunu çalıştırırsak işe yaramayacak, toplama (aggregate) fonksiyonu ile sütunlar kullanıyoruz bu yüzden group by kullanmamız gerekiyor
-- Ancak bunu yaparsak tam olarak istediğimizi elde edemeyiz
SELECT first_name, salary, AVG(salary)
FROM employee_salary
GROUP BY first_name, salary;

-- Bu bize GRUP BAŞINA ortalamayı veriyor ki biz bunu istemiyoruz
-- İşte alt sorgu için iyi bir kullanım örneği

SELECT first_name, 
salary, 
(SELECT AVG(salary) 
	FROM employee_salary)
FROM employee_salary;


-- Bunu FROM İfadesinde de kullanabiliriz
-- Bunu burada kullandığımızda, sanki üzerinden sorgu yaptığımız küçük bir tablo oluşturuyor gibiyiz
SELECT *
FROM (SELECT gender, MIN(age), MAX(age), COUNT(age),AVG(age)
FROM employee_demographics
GROUP BY gender) 
;
-- Şimdi bu çalışmıyor çünkü onu isimlendirmemiz (alias vermemiz) gerektiğini söyleyen bir hata alıyoruz

SELECT gender, AVG(Min_age)
FROM (SELECT gender, MIN(age) Min_age, MAX(age) Max_age, COUNT(age) Count_age ,AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender) AS Agg_Table
GROUP BY gender
;