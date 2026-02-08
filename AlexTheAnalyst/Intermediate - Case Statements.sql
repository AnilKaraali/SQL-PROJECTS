-- Case İfadeleri (Durum Koşulları)

-- Case İfadesi, Select İfadenize mantık eklemenize olanak tanır; tıpkı diğer programlama dillerindeki if-else ifadesi veya Excel'deki benzer şeyler gibi

SELECT * FROM employee_demographics;


SELECT first_name, 
last_name, 
CASE
	WHEN age <= 30 THEN 'Genç'
END
FROM employee_demographics;


--

SELECT first_name, 
last_name, 
CASE
	WHEN age <= 30 THEN 'Genç'
    WHEN age BETWEEN 31 AND 50 THEN 'Yaşlı'
    WHEN age >= 50 THEN "Ölümün Eşiğinde"
END
FROM employee_demographics;


-- Çalışanlara ikramiye verilmesine bir bakalım

SELECT * FROM employee_salary;

-- Pawnee Konseyi ikramiye ve maaş artış yapısına dair bir not gönderdi, bu yüzden buna uymamız gerekiyor
-- Temel olarak, eğer 45 binden az kazanıyorlarsa %5 zam alıyorlar - çok cömertçe
-- Eğer 45 binden fazla kazanıyorlarsa %7 zam alıyorlar
-- Eğer Finans Departmanı için çalışıyorlarsa %10 ikramiye alıyorlar

SELECT first_name, last_name, salary,
CASE
	WHEN salary > 45000 THEN salary + (salary * 0.05)
    WHEN salary < 45000 THEN salary + (salary * 0.07)
END AS new_salary
FROM employee_salary;



-- Şimdi İkramiyeleri de hesaba katmamız gerekiyor, yeni bir sütun oluşturalım
SELECT first_name, last_name, salary,
CASE
	WHEN salary > 45000 THEN salary + (salary * 0.05)
    WHEN salary < 45000 THEN salary + (salary * 0.07)
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary;

-- Gördüğünüz gibi ikramiye alan tek kişi Ben