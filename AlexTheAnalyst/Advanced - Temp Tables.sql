-- Geçici Tabloları Kullanma (Using Temporary Tables)
-- Geçici tablolar, yalnızca onları oluşturan oturum (session) tarafından görülebilen tablolardır.
-- Karmaşık sorgular için ara sonuçları saklamak veya kalıcı bir tabloya eklemeden önce verileri işlemek için kullanılabilirler.

-- Geçici tablolar oluşturmanın 2 yolu vardır:
-- 1. Bu daha az kullanılan yöntemdir - tıpkı gerçek bir tablo gibi oluşturup içine veri eklemektir.

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

-- Eğer bunu çalıştırırsak oluşturulur ve onu gerçekten sorgulayabiliriz.

SELECT *
FROM temp_table;
-- Tablolarımızı yenilersek (refresh) orada olmadığını fark edin. Bu gerçek bir tablo değildir. Sadece bellekte duran bir tablodur.

-- Tabi şu an içi boş, bu yüzden içine şu şekilde veri eklememiz gerekir:

INSERT INTO temp_table
VALUES ('Alex','Freberg','Lord of the Rings: The Twin Towers');

-- Şimdi bunu çalıştırıp tekrar baktığımızda verimiz orada.
SELECT *
FROM temp_table;

-- İkinci yol çok daha hızlıdır ve benim tercih ettiğim yöntemdir.
-- 2. İçine veri ekleyerek oluşturmak - daha kolay ve daha hızlıdır.

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary > 50000;

-- Eğer bu sorguyu çalıştırırsak çıktımızı alırız.
SELECT *
FROM temp_table_2; -- (Not: Burada muhtemelen salary_over_50k kastedilmiş ancak orijinal kodda temp_table_2 yazıyor, koda dokunmadım)

-- Bu benim geçici tabloları kullandığım temel yöntemdir, özellikle sadece veri sorguluyorsam ve daha sonra kullanmak üzere "kutulara" veya bu geçici tablolara koymak istediğim karmaşık verilerim varsa.
-- Bu, verileri kategorize etmeme ve ayırmama yardımcı oluyor.

