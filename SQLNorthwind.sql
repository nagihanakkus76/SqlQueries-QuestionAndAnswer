-- product tablosundaki bütün verileri getir

select * from Products

-- product tablosundaki ilk beþ veriyi getir

select Top 5 * from Products

--products tablosundaki ProductName, QuantityPerUnit , UnitPrice , UnitsInStock kolonlarýný getir

select ProductName, QuantityPerUnit, UnitPrice, UnitsInStock from Products

--products tablosundaki ProductName, QuantityPerUnit , UnitPrice , UnitsInStock  kolonlarýndaki ilk beþini getir
select top 5 ProductName, QuantityPerUnit, UnitPrice, UnitsInStock from Products

-- order tablosundaki bütün verileri getir
SELECT * FROM Orders

--orders tablosundaki RequiredDate, OrderDate, ShippedDate kolonlarýndaki tüm verileri getir

select RequiredDate, OrderDate, ShippedDate from Orders

-- Where koþullarý
-- = eþittir
-- <> eþit deðildir
-- < küçüktür
-- > büyüktür
-- <= küçük eþittir
-- >=büyük eþittir
-- Between arasýndadýr
-- LIKE -ile baþlar , -ile biter
-- IN içindedir
-- NOT LIKE -ile baþlamaz, -ile bitmez


-- products id si 1 olan ürünü getir

 select * from Products
 Where productId = 1

 --UnitPrice kolonu  6ile 25 deðeri arasýndaki tüm deðerleri getir
 select * from Products
 Where unitPrice Between 6 and 25

 --Product tablosundaki ProductName, QuantityPerUnit , UnitPrice , ReorderLevel kolonlarýný içeren ve
 --ReorderLevel i 0 vr 15 arasýndaki verileri getir
 select ProductName, QuantityPerUnit, UnitPrice, ReorderLevel from Products
 Where ReorderLevel Between 0 and 15

 --Products tablosundaki productName ve unitsInStock  kolonlarýnýn verileri unitsInStock deðerleri 25-50 arasýnda olan (25 ve 50 dahil)listeleyen sorgu

 Select ProductName, UnitsInStock from Products
 where UnitsInStock >=25 and UnitsInStock <=50

 --Products tablosundaki CategoryID si 1 veya 3 olan verileri listeleyen sorguyu yazýnýz

 Select * from Products
 Where CategoryID = 1 or CategoryID = 3

 -- in komutu kullanýmý

 --Products tablosundaki QuantityPerUnit kolonundaki deðerleri '24 - 12 oz bottles' olan ve
 --'24 - 250 ml bottles'  bütün verileri listeleyen  sorguyu yazýnýz.

 select * from Products
 Where QuantityPerUnit IN ('24 - 12 oz bottles','24 - 250 ml bottles')

  select * from Products
 Where QuantityPerUnit = '24 - 12 oz bottles' OR QuantityPerUnit ='24 - 250 ml bottles'

 --Products tablosundaki CategoryID si 3e eþit olmayan verileri listeleyin
 Select * from Products
 Where CategoryID <> 3

 --Sýralama iþlemi - ORDER BY

 -- Products tablosdaki tüm verileri ProductName de ki verilere göre a dan z ye sýralayan komutu yazýnýz
  Select * from Products
  ORDER BY ProductName --yada Asc yazýlabilir ancak default deðeri zaten asc olduðu için yazmaya gerek yoktur

--2.yöntem productName tabloda ikinci kolonda olduðu için kolon numarasýnýda yazabiliriz. 3.kolonda olsaydý 2 yerine 3 yazardik
Select * from Products
 ORDER BY 2 asc 

  -- -- Products tablosdaki tüm verileri ProductName de ki verilere göre z den a ya sýralayan komutu yazýnýz
  Select * from Products
  ORDER BY ProductName DESC

  --products tablosundaki ProductName, UnitPrice, CategoryID kolonlarýndaki verileri UnitPrice deðerine göre artan þekilde listeyen
  --CategoryId si 2 E eþit olmayan ve  ProductName kolonu içerisindeki verilerden 'on' sözcüðü geçen verilerin listelendiði sorguyu yazýnýz.

  Select ProductName, UnitPrice, CategoryID from Products
  Where CategoryID <> 2  and ProductName LIKE '%on%'
  ORDER BY UnitPrice

  -- Category tablosuna veri ekleme
  select * from Categories
  insert into Categories (CategoryName,Description)
  Values('Teknoloji','Teknoloji kategorisi açýklama')
  
  -- category tablosundan veri silme

  delete from Categories
  where CategoryName = 'Teknoloji' -- kategori adý yerine categoryID sine göre çalýþmak doðru olan  

  -- Update  - güncelleme iþlemi  update <tabla_adý> set kolon1=deðer1, kolon2=deðer2 where <koþul>

  update Categories set CategoryName='Bahçe Gereçleri', Description='Bahçe Gereçleri Açýklamasý' 
  where CategoryID=12

  --Aggregate Fonksiyonlarý
  --COUNT() : Belirli bir sütundaki deðerlerin sayýsýný döndürür.
  --SUM() : Bir sütundaki tüm deðerlerin toplamýný hesaplar.
  --AVG() : Bir sütundaki tüm deðerlerin ortalamasýný hesaplar.
  --MIN() : Bir sütundaki en küçük deðeri bulur.
  --MAX() :Bir sütundaki en büyük deðeri bulur.

  --GROUP BY: belli bir sütuna göre gruplanmýþ veriler üzerinde uygulanmak için kullanýlýr.
  --HAVING : GROUP BY ile kullanýldýðýnda belirli koþullarý filtrelemek için kullanýlýr.

  Select * from Products
  -- Products tablosundaki UnitPrice kolonundaki en küçük veriyi getiren sorguyu yazýnýz
  select  MIN(UnitPrice) as MinUnitPrice from Products

   -- Products tablosundaki UnitPrice kolonundaki en büyük veriyi getiren sorguyu yazýnýz
  select  MAX(UnitPrice) as MaxUnitPrice from Products

  --Products tablosundaki UnitPrice deðerlerinin toplamý, en küçüðü, en büyüðü , kaç tane veri olduðunu,ortalamasýný bulan sorguyu yazýn
  --(SUM(),MÝN(),MAX(),COUNT(),AVG())
  select SUM(UnitPrice) as SumUnitPrice, 
  MIN(UnitPrice) as MinUnitPrice,  
  MAX(UnitPrice) as MaxUnitPrice,
  COUNT(UnitPrice) as CountUnitPrice,
  AVG(UnitPrice) as AvgUnitPrice 
  from Products

  -- Group By => verileri belirli ya da birden fazla sütuna göre gruplandýrmak için vardýr.
  --Genellikle toplam, ortalama,max.,min., gibi toplu iþlemler ile birliklte kullanýlýr.

  --Þehirlere göre müþteri sayýsý
  Select * from Customers

  Select City , COUNT(CustomerID) As CustomerCount From Customers
  Group By City
  
  --Ýlgili müþteri kaç tane sipariþ verdi
  Select * From Orders

  Select CustomerID,COUNT(OrderID) As OrderCount From Orders
  Group By customerID

  --Çalýþanlarýn aldýðý sipariþ sayýsý 

  Select EmployeeId , COUNT(OrderID) As OrderCount From Orders
  Group By EmployeeID

  --Çalýþanlarýn aldýðý sipariþ sayýsýný çoktan aza doðru sýralayýnýz 
  Select EmployeeId , COUNT(OrderID) As OrderCount From Orders
  Group By EmployeeID
  Order By OrderCount DESC

  --1996-07-04 00:00:00.000
  --Aylýk Toplam Sipariþ Sayýsýný Bulunuz

  Select MONTH(OrderDate) AS Ay, COUNT(OrderID) AS AylikSiparis From Orders
  Group By  MONTH(OrderDate)
  Order By  MONTH(OrderDate)

  --Yýllýk Toplam Sipariþ Sayýsýný Bulunuz
   Select YEAR(OrderDate) AS WhichYear, COUNT(OrderID) AS [Total Order] From Orders
  Group By  YEAR(OrderDate)
  Order By  YEAR(OrderDate)


  --Ürünün kategorisine göre en yüksek fiyat
  Select * From Products

  Select CategoryID, Max(UnitPrice) as MaxPrice From Products
  Group BY CategoryID

  --HAVING : Group By ifadesi ile birlikte kullanýlýr. Temel olarak Where koþuluna benzer. Farký ise Aggregate fonksiyonlarda HAVING kullanýlýr.
  
  -- Ýlgili CategoryID ye ait ürünün stok miktarý toplamý 50 den fazla olan ürünlerin ortalama fiyatý

  Select CategoryID, AVG(UnitPrice) As AVGPrice  from Products
  Group BY CategoryID 
  HAVING SUM(UnitsInStock) > 50

  --Her bir þehir için üçten fazla müþterisi olan þehirleri listeleyiniz.
  Select city, COUNT(CustomerID) as CustomerCount From Customers
  Group By city
  HAVING COUNT(CustomerID) >3 
   --Her bir þehir için üçten az müþterisi olan þehirleri listeleyiniz.
   Select city, COUNT(CustomerID) as CustomerCount From Customers
  Group By city
  HAVING COUNT(CustomerID) <3
  Order By CustomerCount DESC