-- LIMIT ve ALIASING (Takma Ad Kullanımı)

-- Limit, çıktıda kaç satır istediğinizi belirlemenize yarar


SELECT *
FROM employee_demographics
LIMIT 3;

-- Eğer sıralama gibi bir şeyi değiştirirsek veya group by kullanırsak çıktı değişecektir

SELECT *
FROM employee_demographics
ORDER BY first_name
LIMIT 3;

-- Şimdi limit içinde, virgül kullanarak erişebileceğimiz ve başlangıç noktasını belirten ek bir parametre var

SELECT *
FROM employee_demographics
ORDER BY first_name;

SELECT *
FROM employee_demographics
ORDER BY first_name
LIMIT 3,2;

-- Bu ifade şimdi "3. sıradan başla ve ondan sonraki 2 satırı al" diyor
-- Bence bu özellik çok fazla kullanılmıyor

-- Eğer en yaşlı üçüncü kişiyi seçmek isterseniz bunu şu şekilde kullanabilirsiniz:
SELECT *
FROM employee_demographics
ORDER BY age desc;
-- Donna olduğunu görebiliyoruz - hadi onu seçmeyi deneyelim
SELECT *
FROM employee_demographics
ORDER BY age desc
LIMIT 2,1;


-- ALIASING (TAKMA AD KULLANIMI)

-- Aliasing, sütunun adını değiştirmenin sadece bir yoludur (çoğunlukla)
-- Join (birleştirme) işlemlerinde de kullanılabilir, ancak buna orta seviye serisinde bakacağız


SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
;
-- Bir Alias (Takma ad) kullandığımızı belirtmek için AS anahtar kelimesini kullanabiliriz
SELECT gender, AVG(age) AS Avg_age
FROM employee_demographics
GROUP BY gender
;

-- Aslında buna ihtiyacımız yok, ancak daha açık/belirgin oluyor ki ben genellikle bunu tercih ederim
SELECT gender, AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender
;