-- EDA (Keşifsel Veri Analizi)

-- Burada sadece verileri keşfedeceğiz ve eğilimleri, kalıpları veya aykırı değerler gibi ilginç şeyleri bulacağız.

-- Normalde EDA sürecine başladığınızda ne aradığınıza dair bir fikriniz olur.

-- Bu bilgilerle sadece etrafa bakacağız ve ne bulacağımızı göreceğiz!

SELECT * FROM world_layoffs.layoffs_staging2;

-- DAHA KOLAY SORGULAR

SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;






-- Bu işten çıkarmaların ne kadar büyük olduğunu görmek için Yüzdeye bakıyoruz
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Hangi şirketlerin 1 değerine sahip olduğunu, yani şirketin temel olarak %100'ünün işten çıkarıldığını görelim
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;
-- Bunlar çoğunlukla bu süre zarfında iflas eden girişimler (startup'lar) gibi görünüyor

-- Eğer toplanan fonlara (funds_raised_millions) göre sıralarsak bu şirketlerin bazılarının ne kadar büyük olduğunu görebiliriz
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt bir elektrikli araç şirketi gibi görünüyor, Quibi! O şirketi tanıyorum - vay canına, 2 milyar dolar gibi bir para topladılar ve battılar - acı verici
















-- BİRAZ DAHA ZOR VE ÇOĞUNLUKLA GROUP BY KULLANILAN SORGULAR--------------------------------------------------------------------------------------------------

-- Tek seferde en büyük işten çıkarmayı yapan şirketler

SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;
-- bu sadece tek bir günde olanlar

-- Toplamda en çok işten çıkarma yapan şirketler
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;



-- Konuma göre
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- bu, son 3 yıldaki veya veri setindeki toplam

SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;


SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;






-- DAHA ZOR SORGULAR------------------------------------------------------------------------------------------------------------------------------------

-- Daha önce en çok işten çıkarma yapan şirketlere bakmıştık. Şimdi buna yıl bazında bakalım. Bu biraz daha zor.
-- Şuna bakmak istiyorum:

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;




-- Ay Bazında Kümülatif (Yuvarlanan) İşten Çıkarma Toplamı
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- Şimdi bunu bir CTE içinde kullanalım, böylece üzerinden sorgu yapabiliriz
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;