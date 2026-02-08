-- Having ve Where Karşılaştırması

-- Her ikisi de veri satırlarını filtrelemek için oluşturulmuştur, ancak 2 farklı şeyi filtrelerler
-- Where, veri sütunlarına dayalı olarak satırları filtreler
-- Having, gruplandırma yapıldığında toplanmış (aggregate) sütunlara dayalı olarak satırları filtreler

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
;


-- Where kullanarak ortalama yaşa göre filtrelemeyi deneyelim

SELECT gender, AVG(age)
FROM employee_demographics
WHERE AVG(age) > 40
GROUP BY gender
;
-- Bu, işlem sırası nedeniyle çalışmaz. Arka planda Where, group by'dan önce gelir. Bu nedenle henüz gruplanmamış verileri filtreleyemezsiniz
-- Having ifadesinin oluşturulma nedeni budur

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

SELECT gender, AVG(age) as AVG_age
FROM employee_demographics
GROUP BY gender
HAVING AVG_age > 40
;