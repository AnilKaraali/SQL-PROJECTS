#UNIONS (BİRLEŞİMLER)

#Union, satırları birleştirmenizi sağlar - join'lerde (birleştirmelerde) yaptığımız gibi bir sütunun diğerinin yanına konduğu sütun birleştirmesi değildir.
#Join'ler verileri (yan yana) birleştirmenize olanak tanır.

#Şimdi, aynı türden verileri tutmalısınız, aksi takdirde bahşişleri (tips) isimlerle karıştırmaya başlarsanız gerçekten kafa karıştırıcı olur, ancak bunu (teknik olarak) yapabilirsiniz.
#Hadi deneyelim ve rastgele bazı verileri bir araya getirmek için Union kullanalım, sonra gerçek bir kullanım örneğine bakacağız.

SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT occupation, salary
FROM employee_salary;

#Gördüğünüz gibi verileri temel olarak birleştirdik, ancak farklı sütunlarda yan yana değil, aynı sütunlarda üst üste.
#Bu açıkçası iyi bir şey değil çünkü verileri karıştırıyorsunuz, ancak isterseniz yapılabilir.

SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

-- Kopyaların (tekrar eden verilerin) atıldığını fark ettiniz mi? Union aslında Union Distinct'in kısaltmasıdır.

SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

-- Tüm değerleri göstermek (kopyalar dahil) için UNION ALL kullanabiliriz

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;



#Şimdi gerçekten UNION kullanmayı deneyelim
# Park departmanı bütçesini kısmaya çalışıyor ve işten çıkarabilecekleri yaşlı çalışanları veya maaşını düşürebilecekleri ya da işten çıkarabilecekleri yüksek maaşlı çalışanları belirlemek istiyor.
-- Buna yardımcı olacak bazı sorgular oluşturalım

SELECT first_name, last_name, 'Old'
FROM employee_demographics
WHERE age > 50;



SELECT first_name, last_name, 'Old Lady' as Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Old Man'
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Highly Paid Employee'
FROM employee_salary
WHERE salary >= 70000
ORDER BY first_name
;