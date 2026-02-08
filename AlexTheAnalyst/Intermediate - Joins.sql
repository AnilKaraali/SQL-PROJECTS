-- Birleştirmeler (Joins)

-- Join'ler (Birleştirmeler), ortak bir sütunları varsa 2 (veya daha fazla) tabloyu birleştirmenize olanak tanır.
-- Sütun adının aynı olması gerektiği anlamına gelmez, ancak içindeki veriler aynıdır ve tabloları birleştirmek için kullanılabilir.
-- Bugün inceleyeceğimiz birkaç birleştirme türü var: inner join, outer join ve self join.


-- İşte ilk 2 tablo - ortak olan ve birleştirme yapabileceğimiz hangi sütunlara ve verilere sahip olduğumuzu görelim
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

-- Inner join ile başlayalım -- inner join'ler her iki sütunda da aynı olan satırları döndürür.

-- Aynı sütunlara sahip olduğumuz için bunların hangi tablodan geldiğini belirtmemiz gerekiyor
SELECT *
FROM employee_demographics
JOIN employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id;

-- Ron Swanson'ın sonuçlarda olmadığını fark ettiniz mi? Bunun nedeni, demografi tablosunda bir çalışan kimliğine (employee_id) sahip olmamasıdır. Doğum tarihini, yaşını veya cinsiyetini vermeyi reddetti.

-- Takma ad (aliasing) kullanın!
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


-- DIŞ BİRLEŞTİRMELER (OUTER JOINS)

-- Dış birleştirmeler için sol (left) ve sağ (right) birleştirme seçeneklerimiz vardır.
-- Sol birleştirme (Left Join), birleşmede eşleşme olmasa bile sol tablodan her şeyi alır, ancak sağ tablodan yalnızca eşleşenleri döndürür.
-- Sağ birleştirme (Right Join) için tam tersi geçerlidir.

SELECT *
FROM employee_salary sal
LEFT JOIN employee_demographics dem
	ON dem.employee_id = sal.employee_id;

-- Böylece sol tablodan veya maaş tablosundan her şeyi aldığımızı fark edeceksiniz. Ron Swanson ile bir eşleşme olmamasına rağmen.
-- Sağ tabloda eşleşme olmadığı için hepsi Null (boş) olarak görünür.

-- Eğer bunu sağ birleştirme (right join) olarak değiştirirsek, temel olarak bir inner join gibi görünür.
-- Bunun nedeni demografi tablosundan her şeyi ve sol veya maaş tablosundan yalnızca eşleşmeleri almamızdır. Hepsinde eşleşme olduğu için
-- biraz inner join gibi görünür.
SELECT *
FROM employee_salary sal
RIGHT JOIN employee_demographics dem
	ON dem.employee_id = sal.employee_id;



-- Kendiyle Birleştirme (Self Join)

-- Self join, bir tabloyu kendisine bağladığınız yerdir.

SELECT *
FROM employee_salary;

-- Yapabileceğimiz şey bir "gizli noel baba" (çekiliş) yapmaktır, böylece daha yüksek ID'ye sahip kişi, diğer kişinin gizli noel babası olur.


SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id = emp2.employee_id
    ;

-- Şimdi onlara gizli noel babalarını atayacak şekilde değiştirelim
SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1  = emp2.employee_id
    ;



SELECT emp1.employee_id as emp_santa, emp1.first_name as santa_first_name, emp1.last_name as santa_last_name, emp2.employee_id, emp2.first_name, emp2.last_name
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1  = emp2.employee_id
    ;

-- Yani Leslie, Ron'un gizli noel babasıdır ve bu böyle devam eder -- Mark Brandanowitz'e gizli noel baba çıkmadı ama o hak etmiyor çünkü Ann'in kalbini kırdı, yani sorun yok.






-- Birden fazla tabloyu birleştirme

-- Şimdi birleştirebileceğimiz başka bir tablomuz var - ona bir göz atalım
SELECT * FROM parks_and_recreation.parks_departments;


SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
JOIN parks_departments dept
	ON dept.department_id = sal.dept_id;

-- Şimdi bunu yaptığımızda fark edin, bu bir inner join olduğu için Andy'yi eledi çünkü o herhangi bir departmanın parçası değildi.

-- Eğer bir left join yaparsak onu yine de dahil ederiz çünkü sol tablodan (bu durumda maaş tablosu) her şeyi alıyoruz.
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
LEFT JOIN parks_departments dept
	ON dept.department_id = sal.dept_id;