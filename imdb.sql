USE u8747338_base86
GO

SELECT * FROM movie

-- 1.En uzun film hangisidir? 
SELECT Top 1 id, title, duration FROM movie
ORDER BY duration DESC

-- 2.En yeni film hangisidir? 
SELECT TOP 1 id, title,date_published FROM movie
ORDER BY date_published DESC 

-- 3.Türk yapýmý filmler hangileridir? 
SELECT id, title,country FROM movie
WHERE country LIKE'%TURKEY%'

--4.En uzun Türk yapýmý film hangisidir?
SELECT TOP 1 id, title,country,duration FROM movie
WHERE country LIKE'%TURKEY%'
ORDER BY duration DESC

--5.En eski Türk yapýmý film hangisidir?
SELECT TOP 1 id, title,country,date_published FROM movie
WHERE country LIKE '%TURKEY%'
ORDER BY date_published ASC

--6.Türkçe dil içeren filmler ?
SELECT id, title, languages FROM movie
WHERE languages LIKE '%Turkish%'

--7.En çok hasýlat yapan film hangisidir?
SELECT TOP 1 id, title, country, worlwide_gross_income FROM movie
ORDER BY CAST(worlwide_gross_income AS MONEY) DESC

--8.2019 yýlýnda en çok hasýlat yapan türk filmi?
SELECT TOP 1 id, title, country, worlwide_gross_income, [year] FROM movie
WHERE country LIKE '%Turkey%' AND [year]='2019'
ORDER BY CAST(worlwide_gross_income AS MONEY) DESC

--9.En uzun 3 filmin yapýmcýsý kimdir?
SELECT TOP 3 id, title, production_company FROM movie
ORDER BY duration DESC

--10.En yüksek ratinge sahip film hangisidir?
SELECT TOP 1 M.id, M.title ,R.avg_rating , R.total_votes FROM movie AS M
INNER JOIN ratings AS R ON R.movie_id=M.id
ORDER BY R.avg_rating DESC, R.total_votes DESC

--11.En yüksek ratinge sahip Türk filmi hangisidir ?
SELECT TOP 1 M.id, M.title, M.country, R.avg_rating , R.total_votes FROM movie AS M
INNER JOIN ratings AS R ON R.movie_id=M.id
WHERE M.country LIKE '%Turkey%'
ORDER BY R.avg_rating DESC, R.total_votes DESC

--12.En düþük puana ve en yüksek oy sayýsýna sahip film hangisidir?
SELECT TOP 1 M.id, M.title ,R.avg_rating , R.total_votes FROM movie AS M
INNER JOIN ratings AS R ON R.movie_id=M.id
ORDER BY R.avg_rating ASC, R.total_votes DESC

--13.Puaný 6 dan küçük olan USA filmleri ?
SELECT M.id, M.title, M.country, R.avg_rating , R.total_votes FROM movie AS M
INNER JOIN ratings AS R ON R.movie_id=M.id
WHERE M.country LIKE '%USA%' AND R.avg_rating < 6
ORDER BY R.avg_rating DESC, R.total_votes DESC

--14.Puaný 6 dan küçük olup en çok hasýlat yapan film ?
SELECT TOP 1 M.id, M.title, M.country, R.avg_rating , R.total_votes, M.worlwide_gross_income FROM movie AS M
INNER JOIN ratings AS R ON R.movie_id=M.id
WHERE R.avg_rating < 6 
ORDER BY CAST(M.worlwide_gross_income AS MONEY) DESC

--15.Kaç adet korku filmi vardýr? 
SELECT COUNT(*) AS Film_Sayýsý FROM genre
WHERE genre='Horror' 

--16.En yüksek puana sahip korku filmi hangisidir? 
SELECT TOP 1 M.id, M.title, G.genre, R.avg_rating, R.total_votes FROM  movie AS M 
INNER JOIN ratings AS R ON R.movie_id=M.id
INNER JOIN genre AS G ON G.movie_id=M.id
WHERE G.genre='Horror'
ORDER BY R.avg_rating DESC, R.total_votes DESC

--17.Comedy filmlerinin ortalama puaný kaçtýr? 
SELECT AVG(R.avg_rating) AS Comedy_Avg FROM genre AS G
INNER JOIN ratings AS R ON R.movie_id= G.movie_id
WHERE G.genre ='Comedy'

--18.Korku filmlerimi daha baþarýlý yoksa komedi mi? 
SELECT TOP 1 G.genre + ' Daha Baþarýlýdýr' as Sonuc, AVG(R.avg_rating) AS Group_Avg  FROM genre AS G
INNER JOIN ratings AS R ON R.movie_id = G.movie_id
WHERE G.genre IN ('Comedy','Horror')
GROUP BY G.genre 
ORDER BY Group_Avg  DESC

--19.En yüksek puaný alan filmin yönetmeni kimdir ? 
SELECT TOP 1 M.id, M.title,R.avg_rating, R. total_votes,N.[name] AS Director_Name FROM movie AS M
INNER JOIN ratings AS R ON R.movie_id = M.id
INNER JOIN director_mapping AS D ON D.movie_id = R.movie_id
INNER JOIN names AS N ON D.name_id = N.id
ORDER BY R.avg_rating DESC, R.total_votes DESC

--20.En yaþlý yönetmen kimdir ?
SELECT TOP 1 id,[name], date_of_birth, (YEAR(GETDATE())-YEAR(date_of_birth)) AS Age_of_Director FROM names
WHERE date_of_birth IS NOT NULL
ORDER BY Age_of_Director DESC

--21.En çok filmi olan yönetmen kimdir ? 
SELECT N.id, N.[name] ,COUNT(N.[name]) AS [count]  FROM movie AS M
INNER JOIN director_mapping AS D ON M.id = D.movie_id
INNER JOIN names AS N ON N.id = D.name_id
GROUP BY N.id,N.[name] ORDER BY [count] DESC
---- ilk iki yönetmenin film sayýsý ayný SOR ??????????
 
--22.En çok filmde oynayan oyuncu kimdir ?
SELECT TOP 1 N.id, N.[name] ,COUNT(N.[name]) AS [count]  FROM movie AS M
INNER JOIN role_mapping AS R ON M.id = R.movie_id
INNER JOIN names AS N ON N.id = R.name_id
GROUP BY N.id,N.[name] ORDER BY [count] DESC

--23.En çok filmde oynayan oyuncu kimlerle ortak filmlerde oynamýþtýr?
declare @EnCokFilmdeOynayanID varchar(100);
set @EnCokFilmdeOynayanID = (SELECT TOP 1  N.id  FROM movie AS M
INNER JOIN role_mapping AS R ON M.id = R.movie_id
INNER JOIN names AS N ON N.id = R.name_id
GROUP BY N.id ORDER BY COUNT(N.[name]) DESC)

select distinct N.id,IIF(@EnCokFilmdeOynayanID = N.id,'****'+N.name+'****',N.name) as [Name] from movie M
inner join role_mapping R on R.movie_id = M.id
inner join names N on R.name_id = N.id
where M.id in 
(
-- Yoginin oynadýðý filmlerin idleri
SELECT M.id FROM movie AS M
INNER JOIN role_mapping AS R ON M.id = R.movie_id
INNER JOIN names AS N ON N.id = R.name_id
WHERE N.id = @EnCokFilmdeOynayanID
)

--24.Hangi yönetmen hangi yapým þirketi ile kaç film paylaþmýþtýr? 

--Yönetmenler + yapým þirketleri

SELECT N.id,N.[name],COUNT(M.production_company) AS [film_count],M.production_company FROM movie AS M
INNER JOIN  director_mapping AS D ON M.id=D.movie_id
INNER JOIN names AS N ON D.name_id=N.id
WHERE production_company IS NOT NULL 
GROUP BY N.id,N.[name],M.production_company ORDER BY [film_count] desc,name 



--25.Hangi oyunucu hangi yönetmenle kaç film paylaþmýþtýr ? nm0000080,Orson Welles,The Other Side of the Wind
select rm.name_id,rn.name,dm.name_id,dn.name,count(m.id) as film_count from names rn
inner join role_mapping rm on rm.name_id=rn.id
inner join movie m on m.id = rm.movie_id
inner join director_mapping dm on dm.movie_id = m.id
inner join names dn on dn.id=dm.name_id
group by rm.name_id,rn.name,dm.name_id,dn.name
order by film_count desc,rn.name,dn.name




