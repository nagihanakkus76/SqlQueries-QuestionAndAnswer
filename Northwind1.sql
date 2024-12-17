
-- 1. Product isimlerini (`ProductName`) ve birim baþýna miktar (`QuantityPerUnit`) deðerlerini almak için sorgu yazýn.
Select ProductName, QuantityPerUnit  From Products

-- 2. Ürün Numaralarýný (`ProductID`) ve Product isimlerini (`ProductName`) deðerlerini almak için sorgu yazýn. 
-- Artýk satýlmayan ürünleri (`Discontinued`) filtreleyiniz. (Discontinued-Durduruldu demek 0 olan false tur ve durdurulmadý anlamýna gelir,1 ise true durduruldu olur.)
Select ProductID, ProductName From Products
Where Discontinued = 1

-- 3. Durdurulmayan (`Discontinued`) Ürün Listesini, Ürün kimliði ve ismi (`ProductID`, `ProductName`) deðerleriyle almak için bir sorgu yazýn.
Select ProductID, ProductName From Products
Where Discontinued = 0

-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazýn.
Select ProductID, ProductName, UnitPrice From Products
Where UnitPrice < 20

-- 5. Ürünlerin maliyetinin 15 ile 25 arasýnda olduðu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazýn.
Select ProductID, ProductName, UnitPrice From Products
Where UnitPrice Between 15 and 25

-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoðun sipariþteki miktardan az olduðunu almak için bir sorgu yazýn.
Select ProductName, UnitsOnOrder, UnitsInStock From Products
Where UnitsInStock < UnitsOnOrder

-- 7. Ýsmi `a` ile baþlayan ürünleri listeleyeniz.
Select * From Products
Where ProductName LIKE 'a%'

-- 8. Ýsmi `i` ile biten ürünleri listeleyeniz.
Select * From Products
Where ProductName LIKE '%i'

-- 9. Ürün birim fiyatlarýna %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazýn.
-- UnitPrice Money türünden olduðu için Kdvli halide moneye dönüþtürüldü. 
-- Dönüþüm Öncesi(21.240000)
-- Dönüþüm Sonrasý (21,24)
Select ProductName, UnitPrice,Cast((UnitPrice * 1.18) as money)  AS UnitPriceKDV  From Products

-- 10. Fiyatý 30 dan büyük kaç ürün var?
Select Count(*) as ProductCount From Products
Where UnitPrice > 30 

-- 11. Ürünlerin adýný tamamen küçültüp fiyat sýrasýna göre tersten listele
Select LOWER(ProductName) As LowerProductName, UnitPrice From Products
Order By UnitPrice DESC

-- 12. Çalýþanlarýn ad ve soyadlarýný yanyana gelecek þekilde yazdýr
Select CONCAT(FirstName, ' ', LastName) AS FullName From Employees

-- 13. Region alaný NULL olan kaç tedarikçim var?
Select Count(*) AS RegionNullCount  From Suppliers
Where Region IS Null 

-- 14.A Null olmayanlar? Sayýsý isteniyorsa
Select Count(*) AS RegionNotNullCount  From Suppliers
Where Region IS Not Null 

-- 14.A Null olmayanlar?
Select * From Suppliers
Where Region IS NOT Null 

-- 15. Ürün adlarýnýn hepsinin soluna TR koy ve büyültüp olarak ekrana yazdýr.
Select UPPER(CONCAT('TR', ' ', ProductName)) AS UpperProductName From Products

-- 16.A Fiyatý 20den küçük ürünlerin adýnýn baþýna TR ekle
Select CONCAT('TR', ' ', ProductName) AS UpperProductName, UnitPrice From Products
Where UnitPrice < 20

-- 17. En pahalý ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazýn.
Select Top 1 ProductID, ProductName, UnitPrice From Products
Order By UnitPrice DESC

-- 18. En pahalý on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazýn.
Select Top 10 ProductID, ProductName, UnitPrice From Products
Order By UnitPrice DESC

-- 19. Ürünlerin ortalama fiyatýnýn üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazýn.
Select ProductID, ProductName, UnitPrice From Products
Where UnitPrice > (Select AVG(UnitPrice) From Products) --(28,8663)

-- 20. Stokta olan ürünler satýldýðýnda elde edilen miktar ne kadardýr.
Select Sum(UnitPrice * UnitsInStock) AS TotalPrice From Products

-- 21. Mevcut ve Durdurulan ürünlerin sayýlarýný almak için bir sorgu yazýn.
Select COUNT(*) AS InStockAndDiscontinued From Products
Where UnitsInStock > 0 AND Discontinued = 1 

-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazýn.
Select ProductID, ProductName, CategoryName From Products AS P
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID 
Order By CategoryName,ProductName

-- 23. Ürünlerin kategorilerine göre fiyat ortalamasýný almak için bir sorgu yazýn.
Select C.CategoryID, CategoryName, AVG(UnitPrice) As AveragePriceCategory From Categories  AS C
INNER JOIN Products As P ON C.CategoryID = P.CategoryID 
Group By C.CategoryID , C.CategoryName

-- 24. En pahalý ürünümün adý, fiyatý ve kategorisin adý nedir?
Select Top 1 ProductName, UnitPrice, CategoryName From Products   AS P
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID 
Order By UnitPrice DESC

-- 25. En çok satýlan ürününün adý, kategorisinin adý ve tedarikçisinin adý
Select ProductID, ProductName, CategoryName, CompanyName From Products   AS P
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID
INNER JOIN Suppliers AS S ON S.SupplierID = P.SupplierID
Where ProductID = 
(Select Top 1 ProductID From [Order Details]
Group By ProductID
Order By Sum(Quantity) Desc)
