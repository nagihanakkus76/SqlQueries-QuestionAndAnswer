
-- 1. Product isimlerini (`ProductName`) ve birim ba��na miktar (`QuantityPerUnit`) de�erlerini almak i�in sorgu yaz�n.
Select ProductName, QuantityPerUnit  From Products

-- 2. �r�n Numaralar�n� (`ProductID`) ve Product isimlerini (`ProductName`) de�erlerini almak i�in sorgu yaz�n. 
-- Art�k sat�lmayan �r�nleri (`Discontinued`) filtreleyiniz. (Discontinued-Durduruldu demek 0 olan false tur ve durdurulmad� anlam�na gelir,1 ise true durduruldu olur.)
Select ProductID, ProductName From Products
Where Discontinued = 1

-- 3. Durdurulmayan (`Discontinued`) �r�n Listesini, �r�n kimli�i ve ismi (`ProductID`, `ProductName`) de�erleriyle almak i�in bir sorgu yaz�n.
Select ProductID, ProductName From Products
Where Discontinued = 0

-- 4. �r�nlerin maliyeti 20'dan az olan �r�n listesini (`ProductID`, `ProductName`, `UnitPrice`) almak i�in bir sorgu yaz�n.
Select ProductID, ProductName, UnitPrice From Products
Where UnitPrice < 20

-- 5. �r�nlerin maliyetinin 15 ile 25 aras�nda oldu�u �r�n listesini (`ProductID`, `ProductName`, `UnitPrice`) almak i�in bir sorgu yaz�n.
Select ProductID, ProductName, UnitPrice From Products
Where UnitPrice Between 15 and 25

-- 6. �r�n listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) sto�un sipari�teki miktardan az oldu�unu almak i�in bir sorgu yaz�n.
Select ProductName, UnitsOnOrder, UnitsInStock From Products
Where UnitsInStock < UnitsOnOrder

-- 7. �smi `a` ile ba�layan �r�nleri listeleyeniz.
Select * From Products
Where ProductName LIKE 'a%'

-- 8. �smi `i` ile biten �r�nleri listeleyeniz.
Select * From Products
Where ProductName LIKE '%i'

-- 9. �r�n birim fiyatlar�na %18�lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) i�in bir sorgu yaz�n.
-- UnitPrice Money t�r�nden oldu�u i�in Kdvli halide moneye d�n��t�r�ld�. 
-- D�n���m �ncesi(21.240000)
-- D�n���m Sonras� (21,24)
Select ProductName, UnitPrice,Cast((UnitPrice * 1.18) as money)  AS UnitPriceKDV  From Products

-- 10. Fiyat� 30 dan b�y�k ka� �r�n var?
Select Count(*) as ProductCount From Products
Where UnitPrice > 30 

-- 11. �r�nlerin ad�n� tamamen k���lt�p fiyat s�ras�na g�re tersten listele
Select LOWER(ProductName) As LowerProductName, UnitPrice From Products
Order By UnitPrice DESC

-- 12. �al��anlar�n ad ve soyadlar�n� yanyana gelecek �ekilde yazd�r
Select CONCAT(FirstName, ' ', LastName) AS FullName From Employees

-- 13. Region alan� NULL olan ka� tedarik�im var?
Select Count(*) AS RegionNullCount  From Suppliers
Where Region IS Null 

-- 14.A Null olmayanlar? Say�s� isteniyorsa
Select Count(*) AS RegionNotNullCount  From Suppliers
Where Region IS Not Null 

-- 14.A Null olmayanlar?
Select * From Suppliers
Where Region IS NOT Null 

-- 15. �r�n adlar�n�n hepsinin soluna TR koy ve b�y�lt�p olarak ekrana yazd�r.
Select UPPER(CONCAT('TR', ' ', ProductName)) AS UpperProductName From Products

-- 16.A Fiyat� 20den k���k �r�nlerin ad�n�n ba��na TR ekle
Select CONCAT('TR', ' ', ProductName) AS UpperProductName, UnitPrice From Products
Where UnitPrice < 20

-- 17. En pahal� �r�n listesini (`ProductName` , `UnitPrice`) almak i�in bir sorgu yaz�n.
Select Top 1 ProductID, ProductName, UnitPrice From Products
Order By UnitPrice DESC

-- 18. En pahal� on �r�n�n �r�n listesini (`ProductName` , `UnitPrice`) almak i�in bir sorgu yaz�n.
Select Top 10 ProductID, ProductName, UnitPrice From Products
Order By UnitPrice DESC

-- 19. �r�nlerin ortalama fiyat�n�n �zerindeki �r�n listesini (`ProductName` , `UnitPrice`) almak i�in bir sorgu yaz�n.
Select ProductID, ProductName, UnitPrice From Products
Where UnitPrice > (Select AVG(UnitPrice) From Products) --(28,8663)

-- 20. Stokta olan �r�nler sat�ld���nda elde edilen miktar ne kadard�r.
Select Sum(UnitPrice * UnitsInStock) AS TotalPrice From Products

-- 21. Mevcut ve Durdurulan �r�nlerin say�lar�n� almak i�in bir sorgu yaz�n.
Select COUNT(*) AS InStockAndDiscontinued From Products
Where UnitsInStock > 0 AND Discontinued = 1 

-- 22. �r�nleri kategori isimleriyle birlikte almak i�in bir sorgu yaz�n.
Select ProductID, ProductName, CategoryName From Products AS P
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID 
Order By CategoryName,ProductName

-- 23. �r�nlerin kategorilerine g�re fiyat ortalamas�n� almak i�in bir sorgu yaz�n.
Select C.CategoryID, CategoryName, AVG(UnitPrice) As AveragePriceCategory From Categories  AS C
INNER JOIN Products As P ON C.CategoryID = P.CategoryID 
Group By C.CategoryID , C.CategoryName

-- 24. En pahal� �r�n�m�n ad�, fiyat� ve kategorisin ad� nedir?
Select Top 1 ProductName, UnitPrice, CategoryName From Products   AS P
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID 
Order By UnitPrice DESC

-- 25. En �ok sat�lan �r�n�n�n ad�, kategorisinin ad� ve tedarik�isinin ad�
Select ProductID, ProductName, CategoryName, CompanyName From Products   AS P
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID
INNER JOIN Suppliers AS S ON S.SupplierID = P.SupplierID
Where ProductID = 
(Select Top 1 ProductID From [Order Details]
Group By ProductID
Order By Sum(Quantity) Desc)
