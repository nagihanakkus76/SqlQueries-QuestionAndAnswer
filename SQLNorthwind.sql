-- product tablosundaki b�t�n verileri getir

select * from Products

-- product tablosundaki ilk be� veriyi getir

select Top 5 * from Products

--products tablosundaki ProductName, QuantityPerUnit , UnitPrice , UnitsInStock kolonlar�n� getir

select ProductName, QuantityPerUnit, UnitPrice, UnitsInStock from Products

--products tablosundaki ProductName, QuantityPerUnit , UnitPrice , UnitsInStock  kolonlar�ndaki ilk be�ini getir
select top 5 ProductName, QuantityPerUnit, UnitPrice, UnitsInStock from Products

-- order tablosundaki b�t�n verileri getir
SELECT * FROM Orders

--orders tablosundaki RequiredDate, OrderDate, ShippedDate kolonlar�ndaki t�m verileri getir

select RequiredDate, OrderDate, ShippedDate from Orders

-- Where ko�ullar�
-- = e�ittir
-- <> e�it de�ildir
-- < k���kt�r
-- > b�y�kt�r
-- <= k���k e�ittir
-- >=b�y�k e�ittir
-- Between aras�ndad�r
-- LIKE -ile ba�lar , -ile biter
-- IN i�indedir
-- NOT LIKE -ile ba�lamaz, -ile bitmez


-- products id si 1 olan �r�n� getir

 select * from Products
 Where productId = 1

 --UnitPrice kolonu  6ile 25 de�eri aras�ndaki t�m de�erleri getir
 select * from Products
 Where unitPrice Between 6 and 25

 --Product tablosundaki ProductName, QuantityPerUnit , UnitPrice , ReorderLevel kolonlar�n� i�eren ve
 --ReorderLevel i 0 vr 15 aras�ndaki verileri getir
 select ProductName, QuantityPerUnit, UnitPrice, ReorderLevel from Products
 Where ReorderLevel Between 0 and 15

 --Products tablosundaki productName ve unitsInStock  kolonlar�n�n verileri unitsInStock de�erleri 25-50 aras�nda olan (25 ve 50 dahil)listeleyen sorgu

 Select ProductName, UnitsInStock from Products
 where UnitsInStock >=25 and UnitsInStock <=50

 --Products tablosundaki CategoryID si 1 veya 3 olan verileri listeleyen sorguyu yaz�n�z

 Select * from Products
 Where CategoryID = 1 or CategoryID = 3

 -- in komutu kullan�m�

 --Products tablosundaki QuantityPerUnit kolonundaki de�erleri '24 - 12 oz bottles' olan ve
 --'24 - 250 ml bottles'  b�t�n verileri listeleyen  sorguyu yaz�n�z.

 select * from Products
 Where QuantityPerUnit IN ('24 - 12 oz bottles','24 - 250 ml bottles')

  select * from Products
 Where QuantityPerUnit = '24 - 12 oz bottles' OR QuantityPerUnit ='24 - 250 ml bottles'

 --Products tablosundaki CategoryID si 3e e�it olmayan verileri listeleyin
 Select * from Products
 Where CategoryID <> 3

 --S�ralama i�lemi - ORDER BY

 -- Products tablosdaki t�m verileri ProductName de ki verilere g�re a dan z ye s�ralayan komutu yaz�n�z
  Select * from Products
  ORDER BY ProductName --yada Asc yaz�labilir ancak default de�eri zaten asc oldu�u i�in yazmaya gerek yoktur

--2.y�ntem productName tabloda ikinci kolonda oldu�u i�in kolon numaras�n�da yazabiliriz. 3.kolonda olsayd� 2 yerine 3 yazardik
Select * from Products
 ORDER BY 2 asc 

  -- -- Products tablosdaki t�m verileri ProductName de ki verilere g�re z den a ya s�ralayan komutu yaz�n�z
  Select * from Products
  ORDER BY ProductName DESC

  --products tablosundaki ProductName, UnitPrice, CategoryID kolonlar�ndaki verileri UnitPrice de�erine g�re artan �ekilde listeyen
  --CategoryId si 2 E e�it olmayan ve  ProductName kolonu i�erisindeki verilerden 'on' s�zc��� ge�en verilerin listelendi�i sorguyu yaz�n�z.

  Select ProductName, UnitPrice, CategoryID from Products
  Where CategoryID <> 2  and ProductName LIKE '%on%'
  ORDER BY UnitPrice

  -- Category tablosuna veri ekleme
  select * from Categories
  insert into Categories (CategoryName,Description)
  Values('Teknoloji','Teknoloji kategorisi a��klama')
  
  -- category tablosundan veri silme

  delete from Categories
  where CategoryName = 'Teknoloji' -- kategori ad� yerine categoryID sine g�re �al��mak do�ru olan  

  -- Update  - g�ncelleme i�lemi  update <tabla_ad�> set kolon1=de�er1, kolon2=de�er2 where <ko�ul>

  update Categories set CategoryName='Bah�e Gere�leri', Description='Bah�e Gere�leri A��klamas�' 
  where CategoryID=12

  --Aggregate Fonksiyonlar�
  --COUNT() : Belirli bir s�tundaki de�erlerin say�s�n� d�nd�r�r.
  --SUM() : Bir s�tundaki t�m de�erlerin toplam�n� hesaplar.
  --AVG() : Bir s�tundaki t�m de�erlerin ortalamas�n� hesaplar.
  --MIN() : Bir s�tundaki en k���k de�eri bulur.
  --MAX() :Bir s�tundaki en b�y�k de�eri bulur.

  --GROUP BY: belli bir s�tuna g�re gruplanm�� veriler �zerinde uygulanmak i�in kullan�l�r.
  --HAVING : GROUP BY ile kullan�ld���nda belirli ko�ullar� filtrelemek i�in kullan�l�r.

  Select * from Products
  -- Products tablosundaki UnitPrice kolonundaki en k���k veriyi getiren sorguyu yaz�n�z
  select  MIN(UnitPrice) as MinUnitPrice from Products

   -- Products tablosundaki UnitPrice kolonundaki en b�y�k veriyi getiren sorguyu yaz�n�z
  select  MAX(UnitPrice) as MaxUnitPrice from Products

  --Products tablosundaki UnitPrice de�erlerinin toplam�, en k�����, en b�y��� , ka� tane veri oldu�unu,ortalamas�n� bulan sorguyu yaz�n
  --(SUM(),M�N(),MAX(),COUNT(),AVG())
  select SUM(UnitPrice) as SumUnitPrice, 
  MIN(UnitPrice) as MinUnitPrice,  
  MAX(UnitPrice) as MaxUnitPrice,
  COUNT(UnitPrice) as CountUnitPrice,
  AVG(UnitPrice) as AvgUnitPrice 
  from Products

  -- Group By => verileri belirli ya da birden fazla s�tuna g�re grupland�rmak i�in vard�r.
  --Genellikle toplam, ortalama,max.,min., gibi toplu i�lemler ile birliklte kullan�l�r.

  --�ehirlere g�re m��teri say�s�
  Select * from Customers

  Select City , COUNT(CustomerID) As CustomerCount From Customers
  Group By City
  
  --�lgili m��teri ka� tane sipari� verdi
  Select * From Orders

  Select CustomerID,COUNT(OrderID) As OrderCount From Orders
  Group By customerID

  --�al��anlar�n ald��� sipari� say�s� 

  Select EmployeeId , COUNT(OrderID) As OrderCount From Orders
  Group By EmployeeID

  --�al��anlar�n ald��� sipari� say�s�n� �oktan aza do�ru s�ralay�n�z 
  Select EmployeeId , COUNT(OrderID) As OrderCount From Orders
  Group By EmployeeID
  Order By OrderCount DESC

  --1996-07-04 00:00:00.000
  --Ayl�k Toplam Sipari� Say�s�n� Bulunuz

  Select MONTH(OrderDate) AS Ay, COUNT(OrderID) AS AylikSiparis From Orders
  Group By  MONTH(OrderDate)
  Order By  MONTH(OrderDate)

  --Y�ll�k Toplam Sipari� Say�s�n� Bulunuz
   Select YEAR(OrderDate) AS WhichYear, COUNT(OrderID) AS [Total Order] From Orders
  Group By  YEAR(OrderDate)
  Order By  YEAR(OrderDate)


  --�r�n�n kategorisine g�re en y�ksek fiyat
  Select * From Products

  Select CategoryID, Max(UnitPrice) as MaxPrice From Products
  Group BY CategoryID

  --HAVING : Group By ifadesi ile birlikte kullan�l�r. Temel olarak Where ko�uluna benzer. Fark� ise Aggregate fonksiyonlarda HAVING kullan�l�r.
  
  -- �lgili CategoryID ye ait �r�n�n stok miktar� toplam� 50 den fazla olan �r�nlerin ortalama fiyat�

  Select CategoryID, AVG(UnitPrice) As AVGPrice  from Products
  Group BY CategoryID 
  HAVING SUM(UnitsInStock) > 50

  --Her bir �ehir i�in ��ten fazla m��terisi olan �ehirleri listeleyiniz.
  Select city, COUNT(CustomerID) as CustomerCount From Customers
  Group By city
  HAVING COUNT(CustomerID) >3 
   --Her bir �ehir i�in ��ten az m��terisi olan �ehirleri listeleyiniz.
   Select city, COUNT(CustomerID) as CustomerCount From Customers
  Group By city
  HAVING COUNT(CustomerID) <3
  Order By CustomerCount DESC