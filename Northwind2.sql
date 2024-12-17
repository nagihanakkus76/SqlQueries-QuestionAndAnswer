--1. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletiþim numarasýný (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazýn.
Select ProductID, ProductName, CompanyName, Phone  From Products As P
INNER JOIN Suppliers As S ON P.SupplierID = S.SupplierID
Where UnitsInStock <= 0

--2. 1998 yýlý mart ayýndaki sipariþlerimin adresi, sipariþi alan çalýþanýn adý, çalýþanýn soyadý
Select E.EmployeeID,OrderDate, FirstName, LastName, ShipAddress From Orders As O
INNER JOIN Employees As E ON O.EmployeeID = E.EmployeeID
Where YEAR(OrderDate) = 1998 And MONTH(OrderDate) = 3
Order By E.EmployeeID, FirstName,LastName,ShipAddress

--3. 1997 yýlý þubat ayýnda kaç sipariþim var?            
Select COUNT(*) As OrderCount From Orders 
Where YEAR(OrderDate) = 1997 And MONTH(OrderDate) = 2

--4. London þehrinden 1998 yýlýnda kaç sipariþim var?
Select COUNT(*) OrderCount From Orders 
Where YEAR(OrderDate) = 1998 And ShipCity = 'London'

--5. 1997 yýlýnda sipariþ veren müþterilerimin contactname ve telefon numarasý                
Select Distinct ContactName,Phone From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O.CustomerID
Where YEAR(OrderDate) = 1997
Order By ContactName

--6. Taþýma ücreti 40 üzeri olan sipariþlerim           
Select * From Orders
Where Freight > 40

--7. Taþýma ücreti 40 ve üzeri olan sipariþlerimin þehri, müþterisinin adý               
Select Distinct ShipCity, CompanyName From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O.CustomerID
Where Freight >= 40

--8. 1997 yýlýnda verilen sipariþlerin tarihi, þehri, çalýþan adý -soyadý ( ad soyad birleþik olacak ve büyük harf),
Select OrderID,OrderDate,ShipCity,UPPER(CONCAT(FirstName , ' ', LastName )) As FullName From Orders As O --UPPER(FirstName + ' '+ LastName) 
INNER JOIN Employees AS E ON E.EmployeeID = O.EmployeeID
Where YEAR(OrderDate) = 1997
Order By FullName,ShipCity

--9.. 1997 yýlýnda sipariþ veren müþterilerin contactname i, ve telefon numaralarý ( telefon formatý 2223322 gibi olmalý )
Select OrderDate,ContactName,REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', '') AS FormattedPhoneNumber From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O.CustomerID
Where YEAR(OrderDate) = 1997
Order By OrderDate,ContactName

--10. Sipariþ tarihi, müþteri contact name, çalýþan ad, çalýþan soyad
Select OrderDate, ContactName,FirstName, LastName From Orders As o
INNER JOIN Customers As C ON C. CustomerID = O.CustomerID
INNER JOIN Employees As E ON E.EmployeeID = O.EmployeeID
ORDER BY OrderDate, ContactName

--11. Geciken sipariþlerim?                        
Select * From Orders
Where ShippedDate > RequiredDate

--12. Geciken sipariþlerimin tarihi, müþterisinin adý             
Select OrderDate, CompanyName From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O. CustomerID
Where ShippedDate > RequiredDate

--13. 10248 nolu sipariþte satýlan ürünlerin adý, kategorisinin adý, adedi                
Select OD.OrderID, ProductName,CategoryName, Quantity From [Order Details] As OD
INNER JOIN Products As P  ON P.ProductID = OD.ProductID
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID
Where OD.OrderID = 10248 

--14. 10248 nolu sipariþin ürünlerinin adý , tedarikçi adý
Select OD.OrderID, ProductName, CompanyName From [Order Details] As OD
INNER JOIN Products As P  ON P.ProductID = OD.ProductID
INNER JOIN Suppliers As S ON P.SupplierID = S.SupplierID
Where OD.OrderID = 10248 

--15. 3 numaralý ID ye sahip çalýþanýn 1997 yýlýnda sattýðý ürünlerin adý ve adeti       
Select EmployeeID, ProductName, Quantity From Orders As O
INNER JOIN [Order Details] As OD ON O.OrderID =OD.OrderID
INNER JOIN Products As P On P.ProductID = OD.ProductID
Where EmployeeID = 3 And YEAR(OrderDate) = 1997
Order By ProductName

--16. 1997 yýlýnda bir defasinda en çok satýþ yapan çalýþanýmýn ID,Ad soyad         
Select Top 1 O.OrderID, E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice* OD.Quantity) As Total From Orders As O
INNER JOIN [Order Details] As OD ON O.OrderID =OD.OrderID
INNER JOIN Employees As E On E.EmployeeID = O.EmployeeID
Where YEAR(OrderDate) = 1997
Group By O.OrderID, E.EmployeeID, E.FirstName, E.LastName
Order By Total Desc

--17. 1997 yýlýnda en çok satýþ yapan çalýþanýmýn ID,Ad soyad ****
Select Top 1 E.EmployeeID As EmployeeId,E.FirstName  As FirstName,E.LastName As LastName ,OD.Quantity From Orders O 
JOIN Employees E on O.EmployeeID = E.EmployeeID
JOIN [Order Details] od on O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997
ORDER BY od.quantity DESC

--18. En pahalý ürünümün adý,fiyatý ve kategorisin adý nedir?            
Select ProductName, UnitPrice, CategoryName From Products As P
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID
Where ProductID =
(Select Top 1 ProductID from Products
Order By UnitPrice DESC)

--19. Sipariþi alan personelin adý,soyadý, sipariþ tarihi, sipariþ ID. Sýralama sipariþ tarihine göre         
Select FirstName,LastName,OrderDate,OrderID From Orders As O
INNER JOIN Employees AS E ON E.EmployeeID = O.EmployeeID
Order By OrderDate

--20. SON 5 sipariþimin ortalama fiyatý ve orderid nedir?           
Select A.OrderID, SUM(A.Quantity * A.UnitPrice) / SUM(A.Quantity) As ProductAverage From 
(Select O.OrderID, OD.Quantity,OD.UnitPrice  From Orders As O
INNER JOIN [Order Details] As OD ON O.OrderID = OD.OrderID
Where  O.OrderID In (Select Top 5 OrderID From Orders Order By OrderDate Desc)
) As A
Group By A.OrderID

--21. Ocak ayýnda satýlan ürünlerimin adý ve kategorisinin adý ve toplam satýþ miktarý nedir?
Select  ProductName, CategoryName, SUM(Quantity) As TotalQuantity From Orders As O
INNER JOIN [Order Details] As OD ON OD.OrderID = O.OrderID
INNER JOIN Products As P ON OD.ProductID = P.ProductID
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID
Where MONTH(OrderDate) = 1
Group By  ProductName, CategoryName
Order By TotalQuantity

--22. Ortalama satýþ miktarýmýn üzerindeki satýþlarým nelerdir?
Select ProductName, Quantity  From [Order Details] As OD
INNER JOIN Products As P ON P.ProductID = OD .ProductID
Where Quantity > (Select AVG(Quantity) From [Order Details])

--23. En çok satýlan ürünümün(adet bazýnda) adý, kategorisinin adý ve tedarikçisinin adý        
Select Distinct ProductName,CategoryName,CompanyName,Quantity From [Order Details] As OD
INNER JOIN Products As P ON P.ProductID = Od.ProductID
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID
INNER JOIN Suppliers As S ON S.SupplierID = P.SupplierID
Where Quantity =
(
Select MAX(Quantity) From [Order Details]
)

--24. Kaç ülkeden müþterim var
  Select COUNT(Distinct ShipCountry) As TotalCount From Orders

--25. 3 numaralý ID ye sahip çalýþan (employee) son Ocak ayýndan BUGÜNE toplamda ne kadarlýk ürün sattý?
Select SUM(OD.Quantity * OD.UnitPrice) AS TotalSales From Orders As O
JOIN [Order Details] As OD ON O.OrderID = OD.OrderID
JOIN Employees E ON O.EmployeeID = E.EmployeeID
Where E.EmployeeID = 3 AND O.OrderDate >= '1998-01-01'  AND O.OrderDate <= GETDATE()

--26. Hangi ülkeden kaç müþterimiz var
Select Country, Count(CustomerID) As [Count] From Customers
Group By Country

--27. 10 numaralý ID ye sahip ürünümden son 3 ayda ne kadarlýk ciro saðladým?         
Select SUM(UnitPrice * Quantity) As TotalPrice From [Order Details] OD
INNER JOIN Orders O ON OD.OrderID=O.OrderID
Where ProductID = 10 AND OrderDate >= '1998-03-01' AND OrderDate <= '1998-05-06'

--28. Hangi çalýþan þimdiye kadar toplam kaç sipariþ almýþ..?                           
Select E.EmployeeID, E.FirstName + E.LastName As FullName, COUNT(E.EmployeeID) TotalCount From Employees E
INNER JOIN Orders O ON O.EmployeeID=E.EmployeeID
Group By E.EmployeeID, E.FirstName + E.LastName

--29. 91 müþterim var. Sadece 89’u sipariþ vermiþ. Sipariþ vermeyen 2 kiþiyi bulun
Select CompanyName, C.CustomerID,O.OrderID From Customers As C 
FULL OUTER JOIN Orders As O ON C.CustomerID = O.CustomerID
Group By CompanyName, C.CustomerID,O.OrderID
Having O.OrderID Is Null

--30. Brazil’de bulunan müþterilerin Þirket Adý, TemsilciAdi, Adres, Þehir, Ülke bilgileri      
Select CompanyName,ContactName,Address,City, Country From Customers
Where Country = 'Brazil'

--31. Brezilya’da olmayan müþteriler   
Select CompanyName,ContactName,Address,City, Country From Customers
Where Country <> 'Brazil'

--32. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müþteriler   
Select CompanyName,ContactName,Address,City, Country From Customers
Where Country In ('Spain','France','Germany')
Order By Country

--33. Faks numarasýný bilmediðim müþteriler  
Select CompanyName, Fax From Customers
Where Fax Is Null

--34. Londra’da ya da Paris’de bulunan müþterilerim
Select CompanyName, Country, City From Customers
Where City In ('Londra','Paris')
Order By City

--35. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müþteriler   
Select * From Customers
Where City = 'México D.F.' And ContactTitle = 'owner'

--36. C ile baþlayan ürünlerimin isimleri ve fiyatlarý    
Select ProductName, UnitPrice From Products
Where ProductName LIKE 'C%'
Order By UnitPrice Desc

--37. Adý (FirstName) ‘A’ harfiyle baþlayan çalýþanlarýn (Employees); Ad, Soyad ve Doðum Tarihleri  
Select FirstName, LastName, BirthDate From Employees
Where FirstName LIKE 'A%'

--38. Ýsminde ‘RESTAURANT’ geçen müþterilerimin þirket adlarý        
Select CompanyName From Customers
Where CompanyName LIKE '%RESTAURANT%'

--39. 50$ ile 100$ arasýnda bulunan tüm ürünlerin adlarý ve fiyatlarý         
Select ProductName, UnitPrice From Products
Where UnitPrice Between 50 And 100

--40. 1 temmuz 1996 ile 31 Aralýk 1996 tarihleri arasýndaki sipariþlerin (Orders), SipariþID (OrderID) ve SipariþTarihi (OrderDate) bilgileri      
Select OrderID, OrderDate From Orders
Where OrderDate Between '1996-07-01' And '1996-12-31'

--41. Müþterilerimi ülkeye göre sýralýyorum:
Select CompanyName, Country From Customers
Order By Country

--42. Ürünlerimi en pahalýdan en ucuza doðru sýralama, sonuç olarak ürün adý ve fiyatýný istiyoruz
Select ProductName, UnitPrice From Products
Order By UnitPrice Desc

--43. Ürünlerimi en pahalýdan en ucuza doðru sýralasýn, ama stoklarýný küçükten-büyüðe doðru göstersin sonuç olarak ürün adý ve fiyatýný istiyoruz
Select ProductName, UnitPrice, UnitsInStock From Products
Order By UnitPrice Desc,UnitsInStock ASC

--44. 1 Numaralý kategoride kaç ürün vardýr..?
Select Count(ProductName) As Category1Products From Categories As C
INNER JOIN Products As P ON P.CategoryID = C.CategoryID
Where P.CategoryID = 1

--45. Kaç farklý ülkeye ihracat yapýyorum..?
Select COUNT(Distinct ShipCountry) As TotalCount From Orders

--46. a.Bu ülkeler hangileri..?
Select Distinct ShipCountry As TotalCount From Orders
Order By ShipCountry

--47. En Pahalý 5 ürün        
Select Top 5 ProductName, UnitPrice From Products
Order By UnitPrice DESC

--48. ALFKI CustomerID’sine sahip müþterimin sipariþ sayýsý..?
Select COUNT(*) TotalCount From Orders
Where CustomerID = 'ALFKI'

--49. Ürünlerimin toplam maliyeti
Select SUM(UnitPrice) AS TotalPrice From Products

--50.Þirketim, þimdiye kadar ne kadar ciro yapmýþ..?
Select SUM(OD.Quantity * P.UnitPrice) As TotalRevenue From ORDERS O
JOIN [Order Details] As OD ON O.OrderID = OD.OrderID
JOIN Products As P  ON OD.ProductID = P.ProductID


--51. Ortalama Ürün Fiyatým
Select AVG(UnitPrice) As AveragePrice From Products

--52. En Pahalý Ürünün Adý      
Select Top 1 ProductName From Products
Order By UnitPrice Desc

--53.En az kazandýran sipariþ
Select Top 1 P.ProductName AS MinOrder, MIN (OD.UnitPrice)  From [Order Details] OD
INNER JOIN Products P ON OD.ProductID = P.ProductID
Group By P.ProductName, OD.UnitPrice
Order By OD.UnitPrice ASC

--54. Müþterilerimin içinde en uzun isimli müþteri      
Select Top 1 CompanyName,LEN(CompanyName) As Lenght  From Customers
Order By Lenght Desc

--55. Çalýþanlarýmýn Ad, Soyad ve Yaþlarý
Select FirstName, LastName,  YEAR(GETDATE()) - YEAR(BirthDate) AS Age From Employees

--56.Hangi üründen toplam kaç adet alýnmýþ..?
Select P.ProductName, SUM(OD.Quantity) As TotalCount From [Order Details] OD
INNER JOIN Products As P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName


--57.Hangi sipariþte toplam ne kadar kazanmýþým..?
Select P.ProductName, SUM(OD.Quantity * P.UnitPrice) AS Total From [Order Details] As OD
INNER JOIN Products As P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName

--58.Hangi kategoride toplam kaç adet ürün bulunuyor..?
Select C.CategoryName, OD.Quantity ,COUNT(P.ProductID) AS TotalCount FROM Products As P
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID
INNER JOIN [Order Details] As OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName,  OD.Quantity 

--59.1000 Adetten fazla satýlan ürünler?
Select P.ProductName, SUM(OD.Quantity) AS Total From [Order Details] As OD
INNER JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
HAVING SUM(OD.Quantity) > 1000
ORDER BY TOTAL DESC

--60. Hangi Müþterilerim hiç sipariþ vermemiþ..?
Select C.CustomerID,C.CompanyName,C.ContactName From Customers As C
LEFT JOIN Orders As O ON O.CustomerID = C.CustomerID
Where  O.CustomerID Is Null