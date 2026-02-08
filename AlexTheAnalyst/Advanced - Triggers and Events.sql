-- Tetikleyiciler (Triggers)

-- Bir Tetikleyici, bir tabloda bir olay gerçekleştiğinde otomatik olarak çalışan bir kod bloğudur.

-- Örneğin elimizde fatura ve ödemeler adında 2 tablo var - bir müşteri ödeme yaptığında, faturadaki "toplam ödenen" alanını güncellemesini istiyoruz,
-- böylece müşterinin faturasını gerçekten ödediğini yansıtabiliriz.


SELECT * FROM employee_salary;

SELECT * FROM employee_demographics;

-- Yani aslında ödemeler tablosuna yeni bir satır veya veri eklendiğinde, doğru faturayı güncelleyecek bir tetikleyici istiyoruz
-- ödenen tutar ile birlikte.
-- Haydi bunu yazalım.
USE parks_and_recreation;
DELIMITER $$

CREATE TRIGGER employee_insert2
    -- BEFORE (ÖNCE) da yapabiliriz, ancak bu ders için AFTER (SONRA) yapmamız gerekiyor.
	AFTER INSERT ON employee_salary
    -- Bu, eklenen her satır için tetikleyicinin etkinleştiği anlamına gelir. MSSQL gibi bazı SQL veritabanlarında toplu (batch) tetikleyiciler veya tablo düzeyinde tetikleyiciler vardır,
    -- bunlar sadece bir kez tetiklenir, ancak maalesef MySQL bu işleve sahip değildir.
    FOR EACH ROW
    
    -- Şimdi, tetiklendiğinde çalışmasını istediğimiz kod bloğumuzu yazabiliriz.
BEGIN
-- Müşteri faturaları tablomuzu güncellemek istiyoruz.
-- Ve toplam ödenen = total_paid (eğer daha önce ödeme yaptılarsa) + NEW.amount_paid olarak ayarlamak istiyoruz.
-- NEW, yalnızca eklenen yeni satırlardan gelen veriyi ifade eder. Silinen veya güncellenen satırlar için OLD da vardır, ancak bizim için NEW gerekli.
    INSERT INTO employee_demographics (employee_id, first_name, last_name) VALUES (NEW.employee_id,NEW.first_name,NEW.last_name);
END $$

DELIMITER ; 

-- Şimdi çalıştıralım ve oluşturalım.


-- Artık oluşturulduğuna göre test edelim.

-- Ödemeler tablosuna bir ödeme ekleyelim ve Fatura tablosunda güncellenip güncellenmediğini görelim.

-- Eklemek istediğimiz değerleri koyalım - bu 3 numaralı faturayı tamamen ödeyelim.
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);
-- Şimdi ödemeler tablosunda güncellendi, tetikleyici çalıştı ve fatura tablosundaki ilgili değerleri güncelledi.

DELETE FROM employee_salary
WHERE employee_id = 13;



-- -------------------------------------------------------------------------

-- Şimdi Olaylara (Events) bakalım.

-- Ben bunlara genellikle "İşler" (Jobs) derim çünkü yıllarca MSSQL'de öyle adlandırdım, ancak MySQL'de bunlara Olaylar (Events) denir.

-- Olaylar, bir zamanlamaya göre yürütülen görevler veya kod bloklarıdır. Bunlar birçok nedenden dolayı harikadır. Verileri belirli bir zamanda içe aktarmak gibi.
-- Raporların dosyalara aktarılmasını zamanlamak ve daha pek çok şey.
-- Tüm bunları her gün, her pazartesi, her ayın ilk günü sabah 10'da olacak şekilde planlayabilirsiniz. Gerçekten ne zaman isterseniz.

-- Bu, MySQL'de otomasyona gerçekten yardımcı olur.

-- Diyelim ki Park ve Bahçeler'in, 60 yaşın üzerindeki herkesin ömür boyu maaşla hemen emekli edildiği bir politikası var.
-- Tek yapmamız gereken onları demografi tablosundan silmek.

SELECT * FROM parks_and_recreation.employee_demographics;

SHOW EVENTS;

-- Bu olayları şu şekilde silebilir veya değiştirebiliriz:
DROP EVENT IF EXISTS delete_retirees;
DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO BEGIN
	DELETE
	FROM parks_and_recreation.employee_demographics
    WHERE age >= 60;
END $$


-- Eğer tekrar çalıştırırsak Jerry'nin artık kovulduğunu görebilirsiniz -- yani emekli edildiğini demek istedim.
SELECT * FROM parks_and_recreation.employee_demographics;