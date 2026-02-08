-- SQL Projesi - Veri Temizleme (Data Cleaning)

-- Veri Seti: https://www.kaggle.com/datasets/swaptr/layoffs-2022


SELECT * FROM world_layoffs.layoffs;


-- Yapmak istediğimiz ilk şey bir hazırlık (staging) tablosu oluşturmak. 
-- Bu, üzerinde çalışacağımız ve verileri temizleyeceğimiz tablodur. 
-- Bir şeyler ters giderse diye ham verilerin olduğu tabloyu (orijinalini) saklamak istiyoruz.
CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT layoffs_staging 
SELECT * FROM world_layoffs.layoffs;


-- Şimdi veri temizliği yaparken genellikle birkaç adımı izleriz:
-- 1. Kopyaları (duplicates) kontrol et ve kaldır
-- 2. Verileri standartlaştır ve hataları düzelt
-- 3. Null (boş) değerlere bak
-- 4. Gereksiz sütunları ve satırları kaldır


-- 1. Kopyaları Kaldırma (Remove Duplicates)

# Önce kopyaları kontrol edelim

SELECT *
FROM world_layoffs.layoffs_staging
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		world_layoffs.layoffs_staging;


SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
-- Doğrulamak için sadece 'Oda' şirketine bakalım
SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Oda'
;
-- Bunların hepsi meşru girişler gibi görünüyor ve silinmemeli. Doğru olmak için gerçekten her bir satıra bakmamız gerekiyor.

-- Bunlar gerçek kopyalarımız 
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;

-- Bunlar, satır numarası > 1 olan, yani silmek istediklerimiz.

-- Bunu şu şekilde yazmak isteyebilirsiniz (CTE ile silme):
WITH DELETE_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1
)
DELETE
FROM DELETE_CTE
;

-- (Not: MySQL'de CTE üzerinden delete bazen sorun çıkarabilir, alternatif CTE yazımı):
WITH DELETE_CTE AS (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, 
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
	FROM world_layoffs.layoffs_staging
)
DELETE FROM world_layoffs.layoffs_staging
WHERE (company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num) IN (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num
	FROM DELETE_CTE
) AND row_num > 1;


-- Bence iyi bir çözüm olan bir yöntem: Yeni bir sütun oluşturup bu satır numaralarını eklemek. 
-- Sonra satır numarası 2'den büyük olanları silmek, ardından o sütunu silmek.
-- Hadi yapalım!!

ALTER TABLE world_layoffs.layoffs_staging ADD row_num INT;


SELECT *
FROM world_layoffs.layoffs_staging
;

CREATE TABLE `world_layoffs`.`layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);

INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging;

-- Artık buna sahip olduğumuza göre, row_num değeri 2 veya daha büyük olan satırları silebiliriz.

DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;







-- 2. Veriyi Standartlaştırma (Standardize Data)

SELECT * FROM world_layoffs.layoffs_staging2;

-- Endüstriye (industry) bakarsak, bazı null ve boş satırlarımız var gibi görünüyor, bunlara bir göz atalım.
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- Bunlara bir bakalım
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';

-- Burada bir sorun yok.
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'airbnb%';

-- Airbnb bir seyahat (travel) şirketi gibi görünüyor ama burası doldurulmamış.
-- Diğerleri için de aynı olduğuna eminim. Yapabileceğimiz şey:
-- Aynı şirket adına sahip başka bir satır varsa, onu null olmayan endüstri değerleriyle güncelleyecek bir sorgu yazmaktır.
-- Bu işi kolaylaştırır, böylece binlerce satır olsaydı hepsini manuel olarak kontrol etmek zorunda kalmazdık.

-- Boşlukları (blank) null olarak ayarlamalıyız çünkü bunlarla çalışmak genellikle daha kolaydır.
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Şimdi kontrol edersek hepsi null oldu.

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- Şimdi mümkünse bu null değerleri doldurmamız gerekiyor.

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Ve kontrol edersek, bu null değerleri doldurmak için doldurulmuş bir satırı olmayan tek şirket Bally's gibi görünüyor.
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- ---------------------------------------------------

-- Ayrıca Kripto'nun (Crypto) birden fazla farklı varyasyonu olduğunu fark ettim. Bunu standartlaştırmalıyız - diyelim ki hepsini 'Crypto' yapacağız.
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Şimdi bu halledildi:
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

-- --------------------------------------------------
-- Şuna da bakmamız gerekiyor:

SELECT *
FROM world_layoffs.layoffs_staging2;

-- Her şey iyi görünüyor ancak görünüşe göre bazı "United States" ve sonunda nokta olan "United States." kayıtlarımız var. Bunu standartlaştıralım.
SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- Şimdi bunu tekrar çalıştırırsak düzelmiş olur.
SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;


-- Tarih sütunlarını da düzeltelim:
SELECT *
FROM world_layoffs.layoffs_staging2;

-- Bu alanı güncellemek için str_to_date kullanabiliriz.
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Şimdi veri tipini düzgün bir şekilde dönüştürebiliriz.
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM world_layoffs.layoffs_staging2;





-- 3. Null Değerlere Bakış (Look at Null Values)

-- total_laid_off, percentage_laid_off ve funds_raised_millions içindeki null değerler normal görünüyor. Bunu değiştirmek istediğimi sanmıyorum.
-- Null kalmalarını seviyorum çünkü EDA (Keşifsel Veri Analizi) aşamasında hesaplamaları kolaylaştırıyor.

-- Yani null değerlerle ilgili değiştirmek istediğim bir şey yok.




-- 4. Gereken sütun ve satırları kaldırma

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL;


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Gerçekten kullanamayacağımız yararsız verileri silme
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM world_layoffs.layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


SELECT * FROM world_layoffs.layoffs_staging2;