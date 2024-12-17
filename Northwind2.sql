--1. Stokta bulunmayan �r�nlerin �r�n listesiyle birlikte tedarik�ilerin ismi ve ileti�im numaras�n� (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak i�in bir sorgu yaz�n.
Select ProductID, ProductName, CompanyName, Phone  From Products As P
INNER JOIN Suppliers As S ON P.SupplierID = S.SupplierID
Where UnitsInStock <= 0

--2. 1998 y�l� mart ay�ndaki sipari�lerimin adresi, sipari�i alan �al��an�n ad�, �al��an�n soyad�
Select E.EmployeeID,OrderDate, FirstName, LastName, ShipAddress From Orders As O
INNER JOIN Employees As E ON O.EmployeeID = E.EmployeeID
Where YEAR(OrderDate) = 1998 And MONTH(OrderDate) = 3
Order By E.EmployeeID, FirstName,LastName,ShipAddress

--3. 1997 y�l� �ubat ay�nda ka� sipari�im var?            
Select COUNT(*) As OrderCount From Orders 
Where YEAR(OrderDate) = 1997 And MONTH(OrderDate) = 2

--4. London �ehrinden 1998 y�l�nda ka� sipari�im var?
Select COUNT(*) OrderCount From Orders 
Where YEAR(OrderDate) = 1998 And ShipCity = 'London'

--5. 1997 y�l�nda sipari� veren m��terilerimin contactname ve telefon numaras�                
Select Distinct ContactName,Phone From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O.CustomerID
Where YEAR(OrderDate) = 1997
Order By ContactName

--6. Ta��ma �creti 40 �zeri olan sipari�lerim           
Select * From Orders
Where Freight > 40

--7. Ta��ma �creti 40 ve �zeri olan sipari�lerimin �ehri, m��terisinin ad�               
Select Distinct ShipCity, CompanyName From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O.CustomerID
Where Freight >= 40

--8. 1997 y�l�nda verilen sipari�lerin tarihi, �ehri, �al��an ad� -soyad� ( ad soyad birle�ik olacak ve b�y�k harf),
Select OrderID,OrderDate,ShipCity,UPPER(CONCAT(FirstName , ' ', LastName )) As FullName From Orders As O --UPPER(FirstName + ' '+ LastName) 
INNER JOIN Employees AS E ON E.EmployeeID = O.EmployeeID
Where YEAR(OrderDate) = 1997
Order By FullName,ShipCity

--9.. 1997 y�l�nda sipari� veren m��terilerin contactname i, ve telefon numaralar� ( telefon format� 2223322 gibi olmal� )
Select OrderDate,ContactName,REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', '') AS FormattedPhoneNumber From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O.CustomerID
Where YEAR(OrderDate) = 1997
Order By OrderDate,ContactName

--10. Sipari� tarihi, m��teri contact name, �al��an ad, �al��an soyad
Select OrderDate, ContactName,FirstName, LastName From Orders As o
INNER JOIN Customers As C ON C. CustomerID = O.CustomerID
INNER JOIN Employees As E ON E.EmployeeID = O.EmployeeID
ORDER BY OrderDate, ContactName

--11. Geciken sipari�lerim?                        
Select * From Orders
Where ShippedDate > RequiredDate

--12. Geciken sipari�lerimin tarihi, m��terisinin ad�             
Select OrderDate, CompanyName From Orders As O
INNER JOIN Customers As C ON C.CustomerID = O. CustomerID
Where ShippedDate > RequiredDate

--13. 10248 nolu sipari�te sat�lan �r�nlerin ad�, kategorisinin ad�, adedi                
Select OD.OrderID, ProductName,CategoryName, Quantity From [Order Details] As OD
INNER JOIN Products As P  ON P.ProductID = OD.ProductID
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID
Where OD.OrderID = 10248 

--14. 10248 nolu sipari�in �r�nlerinin ad� , tedarik�i ad�
Select OD.OrderID, ProductName, CompanyName From [Order Details] As OD
INNER JOIN Products As P  ON P.ProductID = OD.ProductID
INNER JOIN Suppliers As S ON P.SupplierID = S.SupplierID
Where OD.OrderID = 10248 

--15. 3 numaral� ID ye sahip �al��an�n 1997 y�l�nda satt��� �r�nlerin ad� ve adeti       
Select EmployeeID, ProductName, Quantity From Orders As O
INNER JOIN [Order Details] As OD ON O.OrderID =OD.OrderID
INNER JOIN Products As P On P.ProductID = OD.ProductID
Where EmployeeID = 3 And YEAR(OrderDate) = 1997
Order By ProductName

--16. 1997 y�l�nda bir defasinda en �ok sat�� yapan �al��an�m�n ID,Ad soyad         
Select Top 1 O.OrderID, E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice* OD.Quantity) As Total From Orders As O
INNER JOIN [Order Details] As OD ON O.OrderID =OD.OrderID
INNER JOIN Employees As E On E.EmployeeID = O.EmployeeID
Where YEAR(OrderDate) = 1997
Group By O.OrderID, E.EmployeeID, E.FirstName, E.LastName
Order By Total Desc

--17. 1997 y�l�nda en �ok sat�� yapan �al��an�m�n ID,Ad soyad ****
Select Top 1 E.EmployeeID As EmployeeId,E.FirstName  As FirstName,E.LastName As LastName ,OD.Quantity From Orders O 
JOIN Employees E on O.EmployeeID = E.EmployeeID
JOIN [Order Details] od on O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997
ORDER BY od.quantity DESC

--18. En pahal� �r�n�m�n ad�,fiyat� ve kategorisin ad� nedir?            
Select ProductName, UnitPrice, CategoryName From Products As P
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID
Where ProductID =
(Select Top 1 ProductID from Products
Order By UnitPrice DESC)

--19. Sipari�i alan personelin ad�,soyad�, sipari� tarihi, sipari� ID. S�ralama sipari� tarihine g�re         
Select FirstName,LastName,OrderDate,OrderID From Orders As O
INNER JOIN Employees AS E ON E.EmployeeID = O.EmployeeID
Order By OrderDate

--20. SON 5 sipari�imin ortalama fiyat� ve orderid nedir?           
Select A.OrderID, SUM(A.Quantity * A.UnitPrice) / SUM(A.Quantity) As ProductAverage From 
(Select O.OrderID, OD.Quantity,OD.UnitPrice  From Orders As O
INNER JOIN [Order Details] As OD ON O.OrderID = OD.OrderID
Where  O.OrderID In (Select Top 5 OrderID From Orders Order By OrderDate Desc)
) As A
Group By A.OrderID

--21. Ocak ay�nda sat�lan �r�nlerimin ad� ve kategorisinin ad� ve toplam sat�� miktar� nedir?
Select  ProductName, CategoryName, SUM(Quantity) As TotalQuantity From Orders As O
INNER JOIN [Order Details] As OD ON OD.OrderID = O.OrderID
INNER JOIN Products As P ON OD.ProductID = P.ProductID
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID
Where MONTH(OrderDate) = 1
Group By  ProductName, CategoryName
Order By TotalQuantity

--22. Ortalama sat�� miktar�m�n �zerindeki sat��lar�m nelerdir?
Select ProductName, Quantity  From [Order Details] As OD
INNER JOIN Products As P ON P.ProductID = OD .ProductID
Where Quantity > (Select AVG(Quantity) From [Order Details])

--23. En �ok sat�lan �r�n�m�n(adet baz�nda) ad�, kategorisinin ad� ve tedarik�isinin ad�        
Select Distinct ProductName,CategoryName,CompanyName,Quantity From [Order Details] As OD
INNER JOIN Products As P ON P.ProductID = Od.ProductID
INNER JOIN Categories As C ON C.CategoryID = P.CategoryID
INNER JOIN Suppliers As S ON S.SupplierID = P.SupplierID
Where Quantity =
(
Select MAX(Quantity) From [Order Details]
)

--24. Ka� �lkeden m��terim var
  Select COUNT(Distinct ShipCountry) As TotalCount From Orders

--25. 3 numaral� ID ye sahip �al��an (employee) son Ocak ay�ndan BUG�NE toplamda ne kadarl�k �r�n satt�?
Select SUM(OD.Quantity * OD.UnitPrice) AS TotalSales From Orders As O
JOIN [Order Details] As OD ON O.OrderID = OD.OrderID
JOIN Employees E ON O.EmployeeID = E.EmployeeID
Where E.EmployeeID = 3 AND O.OrderDate >= '1998-01-01'  AND O.OrderDate <= GETDATE()

--26. Hangi �lkeden ka� m��terimiz var
Select Country, Count(CustomerID) As [Count] From Customers
Group By Country

--27. 10 numaral� ID ye sahip �r�n�mden son 3 ayda ne kadarl�k ciro sa�lad�m?         
Select SUM(UnitPrice * Quantity) As TotalPrice From [Order Details] OD
INNER JOIN Orders O ON OD.OrderID=O.OrderID
Where ProductID = 10 AND OrderDate >= '1998-03-01' AND OrderDate <= '1998-05-06'

--28. Hangi �al��an �imdiye kadar toplam ka� sipari� alm��..?                           
Select E.EmployeeID, E.FirstName + E.LastName As FullName, COUNT(E.EmployeeID) TotalCount From Employees E
INNER JOIN Orders O ON O.EmployeeID=E.EmployeeID
Group By E.EmployeeID, E.FirstName + E.LastName

--29. 91 m��terim var. Sadece 89�u sipari� vermi�. Sipari� vermeyen 2 ki�iyi bulun
Select CompanyName, C.CustomerID,O.OrderID From Customers As C 
FULL OUTER JOIN Orders As O ON C.CustomerID = O.CustomerID
Group By CompanyName, C.CustomerID,O.OrderID
Having O.OrderID Is Null

--30. Brazil�de bulunan m��terilerin �irket Ad�, TemsilciAdi, Adres, �ehir, �lke bilgileri      
Select CompanyName,ContactName,Address,City, Country From Customers
Where Country = 'Brazil'

--31. Brezilya�da olmayan m��teriler   
Select CompanyName,ContactName,Address,City, Country From Customers
Where Country <> 'Brazil'

--32. �lkesi (Country) YA Spain, Ya France, Ya da Germany olan m��teriler   
Select CompanyName,ContactName,Address,City, Country From Customers
Where Country In ('Spain','France','Germany')
Order By Country

--33. Faks numaras�n� bilmedi�im m��teriler  
Select CompanyName, Fax From Customers
Where Fax Is Null

--34. Londra�da ya da Paris�de bulunan m��terilerim
Select CompanyName, Country, City From Customers
Where City In ('Londra','Paris')
Order By City

--35. Hem Mexico D.F�da ikamet eden HEM DE ContactTitle bilgisi �owner� olan m��teriler   
Select * From Customers
Where City = 'M�xico D.F.' And ContactTitle = 'owner'

--36. C ile ba�layan �r�nlerimin isimleri ve fiyatlar�    
Select ProductName, UnitPrice From Products
Where ProductName LIKE 'C%'
Order By UnitPrice Desc

--37. Ad� (FirstName) �A� harfiyle ba�layan �al��anlar�n (Employees); Ad, Soyad ve Do�um Tarihleri  
Select FirstName, LastName, BirthDate From Employees
Where FirstName LIKE 'A%'

--38. �sminde �RESTAURANT� ge�en m��terilerimin �irket adlar�        
Select CompanyName From Customers
Where CompanyName LIKE '%RESTAURANT%'

--39. 50$ ile 100$ aras�nda bulunan t�m �r�nlerin adlar� ve fiyatlar�         
Select ProductName, UnitPrice From Products
Where UnitPrice Between 50 And 100

--40. 1 temmuz 1996 ile 31 Aral�k 1996 tarihleri aras�ndaki sipari�lerin (Orders), Sipari�ID (OrderID) ve Sipari�Tarihi (OrderDate) bilgileri      
Select OrderID, OrderDate From Orders
Where OrderDate Between '1996-07-01' And '1996-12-31'

--41. M��terilerimi �lkeye g�re s�ral�yorum:
Select CompanyName, Country From Customers
Order By Country

--42. �r�nlerimi en pahal�dan en ucuza do�ru s�ralama, sonu� olarak �r�n ad� ve fiyat�n� istiyoruz
Select ProductName, UnitPrice From Products
Order By UnitPrice Desc

--43. �r�nlerimi en pahal�dan en ucuza do�ru s�ralas�n, ama stoklar�n� k���kten-b�y��e do�ru g�stersin sonu� olarak �r�n ad� ve fiyat�n� istiyoruz
Select ProductName, UnitPrice, UnitsInStock From Products
Order By UnitPrice Desc,UnitsInStock ASC

--44. 1 Numaral� kategoride ka� �r�n vard�r..?
Select Count(ProductName) As Category1Products From Categories As C
INNER JOIN Products As P ON P.CategoryID = C.CategoryID
Where P.CategoryID = 1

--45. Ka� farkl� �lkeye ihracat yap�yorum..?
Select COUNT(Distinct ShipCountry) As TotalCount From Orders

--46. a.Bu �lkeler hangileri..?
Select Distinct ShipCountry As TotalCount From Orders
Order By ShipCountry

--47. En Pahal� 5 �r�n        
Select Top 5 ProductName, UnitPrice From Products
Order By UnitPrice DESC

--48. ALFKI CustomerID�sine sahip m��terimin sipari� say�s�..?
Select COUNT(*) TotalCount From Orders
Where CustomerID = 'ALFKI'

--49. �r�nlerimin toplam maliyeti
Select SUM(UnitPrice) AS TotalPrice From Products

--50.�irketim, �imdiye kadar ne kadar ciro yapm��..?
Select SUM(OD.Quantity * P.UnitPrice) As TotalRevenue From ORDERS O
JOIN [Order Details] As OD ON O.OrderID = OD.OrderID
JOIN Products As P  ON OD.ProductID = P.ProductID


--51. Ortalama �r�n Fiyat�m
Select AVG(UnitPrice) As AveragePrice From Products

--52. En Pahal� �r�n�n Ad�      
Select Top 1 ProductName From Products
Order By UnitPrice Desc

--53.En az kazand�ran sipari�
Select Top 1 P.ProductName AS MinOrder, MIN (OD.UnitPrice)  From [Order Details] OD
INNER JOIN Products P ON OD.ProductID = P.ProductID
Group By P.ProductName, OD.UnitPrice
Order By OD.UnitPrice ASC

--54. M��terilerimin i�inde en uzun isimli m��teri      
Select Top 1 CompanyName,LEN(CompanyName) As Lenght  From Customers
Order By Lenght Desc

--55. �al��anlar�m�n Ad, Soyad ve Ya�lar�
Select FirstName, LastName,  YEAR(GETDATE()) - YEAR(BirthDate) AS Age From Employees

--56.Hangi �r�nden toplam ka� adet al�nm��..?
Select P.ProductName, SUM(OD.Quantity) As TotalCount From [Order Details] OD
INNER JOIN Products As P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName


--57.Hangi sipari�te toplam ne kadar kazanm���m..?
Select P.ProductName, SUM(OD.Quantity * P.UnitPrice) AS Total From [Order Details] As OD
INNER JOIN Products As P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName

--58.Hangi kategoride toplam ka� adet �r�n bulunuyor..?
Select C.CategoryName, OD.Quantity ,COUNT(P.ProductID) AS TotalCount FROM Products As P
INNER JOIN Categories As C ON P.CategoryID = C.CategoryID
INNER JOIN [Order Details] As OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName,  OD.Quantity 

--59.1000 Adetten fazla sat�lan �r�nler?
Select P.ProductName, SUM(OD.Quantity) AS Total From [Order Details] As OD
INNER JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
HAVING SUM(OD.Quantity) > 1000
ORDER BY TOTAL DESC

--60. Hangi M��terilerim hi� sipari� vermemi�..?
Select C.CustomerID,C.CompanyName,C.ContactName From Customers As C
LEFT JOIN Orders As O ON O.CustomerID = C.CustomerID
Where  O.CustomerID Is Null