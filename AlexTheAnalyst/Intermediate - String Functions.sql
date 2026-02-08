#Şimdi string (metin) fonksiyonlarına bakalım. Bunlar metinleri değiştirmemize ve onlara farklı şekillerde bakmamıza yardımcı olur.

SELECT * FROM bakery.customers;


#Length, her bir değerin uzunluğunu bize verir.
SELECT LENGTH('sky');

#Şimdi her ismin uzunluğunu görebiliriz.
SELECT first_name, LENGTH(first_name) 
FROM employee_demographics;

#Upper, tüm metin karakterlerini büyük harfe çevirir.
SELECT UPPER('sky');

SELECT first_name, UPPER(first_name) 
FROM employee_demographics;

#Lower, tüm metin karakterlerini küçük harfe çevirir.
SELECT LOWER('sky');

SELECT first_name, LOWER(first_name) 
FROM employee_demographics;

#Şimdi, başında veya sonunda boşluk olan değerleriniz varsa, TRIM kullanarak bu boşluktan kurtulabiliriz.
SELECT TRIM('sky'   );

#Eğer ortada boşluk varsa bu çalışmaz (TRIM sadece baş ve sonu temizler).
SELECT LTRIM('     I           love           SQL');

#Sadece sol tarafı kırpmak için LTRIM de vardır.
SELECT LTRIM('     I love SQL');


#Sadece sağ tarafı kırpmak için RTRIM de vardır.
SELECT RTRIM('I love SQL    ');


#Şimdi sırada Left var. Left, sol taraftan belirli miktarda karakter almamıza olanak tanır.
SELECT LEFT('Alexander', 4);

SELECT first_name, LEFT(first_name,4) 
FROM employee_demographics;

#Right temel olarak bunun tersidir - sağ taraftan başlayarak alır.
SELECT RIGHT('Alexander', 6);

SELECT first_name, RIGHT(first_name,4) 
FROM employee_demographics;

#Şimdi substring'e bakalım, bu benim şahsen çok sevdiğim ve çok kullandığım bir fonksiyondur.
#Substring, bir başlangıç noktası ve kaç karakter istediğinizi belirlemenize olanak tanır, böylece metnin herhangi bir yerinden karakter alabilirsiniz. 
SELECT SUBSTRING('Alexander', 2, 3);

#Bunu telefonlarda baştaki alan kodunu almak için kullanabiliriz.
SELECT birth_date, SUBSTRING(birth_date,1,4) as birth_year
FROM employee_demographics;

#Replace (değiştirme) fonksiyonunu da kullanabiliriz.
SELECT REPLACE(first_name,'a','z')
FROM employee_demographics;

#Sırada Locate var - burada kullanabileceğimiz 2 argümanımız var: neyi aradığımızı ve nerede arayacağımızı belirtebiliriz.
#Bu, o karakterin metin içindeki konumunu döndürecektir.
SELECT LOCATE('x', 'Alexander');

#Şimdi Alexander'da 2 tane 'e' var - eğer onu bulmaya çalışırsak ne olur?
SELECT LOCATE('e', 'Alexander');
#Yalnızca ilk pozisyonun konumunu döndürecektir.

#Bunu ilk ismimiz üzerinde deneyelim.
SELECT first_name, LOCATE('a',first_name) 
FROM employee_demographics;

#Daha uzun metinlerin yerini de bulabilirsiniz.
SELECT first_name, LOCATE('Mic',first_name) 
FROM employee_demographics;

#Şimdi concatenate (birleştirme) işlemine bakalım - bu, metinleri bir araya getirecektir.
SELECT CONCAT('Alex', 'Freberg');

#Burada ad ve soyad sütunlarını birleştirebiliriz.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;