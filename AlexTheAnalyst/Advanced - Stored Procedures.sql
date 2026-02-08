-- Şimdi bir saklı yordamın (stored procedure) nasıl oluşturulacağına bakalım

-- Öncelikle çok basit bir sorgu yazalım
SELECT *
FROM employee_salary
WHERE salary >= 60000;

-- Şimdi bunu bir saklı yordamın içine koyalım.
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 60000;

-- Şimdi bunu çalıştırırsak, işlem başarılı olacak ve saklı yordamı oluşturacaktır
-- Yenile'ye (refresh) tıklayıp orada olduğunu görebiliriz

-- Bize bir çıktı vermediğine dikkat edin, bunun nedeni...

-- Eğer onu çağırmak ve kullanmak istersek, şunu yazarak çağırabiliriz:
CALL large_salaries();

-- Gördüğünüz gibi, oluşturduğumuz saklı yordamın içindeki sorguyu çalıştırdı


-- Şu an yazdığımız yöntem aslında en iyi uygulama (best practice) değil.
-- Genellikle bir saklı yordam yazarken böyle basit bir sorgunuz olmaz. Genelde daha karmaşıktır.

-- Bu saklı yordama başka bir sorgu eklemeye çalışsaydık çalışmazdı. O ayrı bir sorgu olurdu:
CREATE PROCEDURE large_salaries2()
SELECT *
FROM employee_salary
WHERE salary >= 60000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;


-- En iyi uygulama, saklı yordamın içinde ne olduğunu gerçekten kontrol etmek için bir sınırlayıcı (delimiter) ve Begin/End (Başla/Bitir) kullanmaktır.
-- Bunu nasıl yapabileceğimize bir bakalım.
-- Sınırlayıcı (delimiter), varsayılan olarak sorguları ayıran şeydir; bunu iki $$ işareti gibi bir şeye değiştirebiliriz.
-- Kariyerim boyunca SQL ile çalışan pek çok kişinin bunu kullandığını gördüm, bu yüzden ben de bunu benimsedim.

-- Bu sınırlayıcıyı değiştirdiğimizde, artık ilk noktalı virgülden sonra durmak yerine
-- her şeyi tek bir bütün birim veya sorgu olarak okur.
DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
END $$

-- Şimdi kullandıktan sonra varsayılan hale getirmek için sınırlayıcıyı geri değiştiriyoruz
DELIMITER ;

-- SP'yi görmek için yenileyelim
-- Şimdi bu saklı yordamı çalıştırabiliriz
CALL large_salaries2();

-- Gördüğünüz gibi, saklı yordamımızda bulunan 2 sorgu olan 2 çıktımız var



-- Ayrıca Stored Procedures üzerine sağ tıklayıp "create" diyerek de bir tane oluşturabiliriz:

-- Eğer prosedür zaten varsa onu silecektir (drop).
USE `parks_and_recreation`;
DROP procedure IF EXISTS `large_salaries3`;
-- Bizim için otomatik olarak sınırlayıcıyı ekler
DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
END $$

DELIMITER ;

-- Ve sonunda tekrar eski haline getirir

-- Bu, Saklı Yordamlarınızı daha hızlı yazmanıza yardımcı olacak gerçekten iyi bir seçenek olabilir, ancak her iki yol da
-- çalışır

-- Eğer "finish"e tıklarsak aynı şekilde oluşturulduğunu görürüz ve çalıştırırsak

CALL large_order_totals3();

-- sonuçlarımızı alırız



-- -------------------------------------------------------------------------

-- Parametreler de ekleyebiliriz
USE `parks_and_recreation`;
DROP procedure IF EXISTS `large_salaries3`;
-- Bizim için otomatik olarak sınırlayıcıyı ekler
DELIMITER $$
CREATE PROCEDURE large_salaries3(employee_id_param INT)
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000
    AND employee_id_param = employee_id;
END $$

DELIMITER ;



CALL large_salaries3(1);