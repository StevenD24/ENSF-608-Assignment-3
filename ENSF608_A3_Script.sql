-- ENSF 608 Assignment 3
-- Steven Duong (30022492)
-- Assignment done in PostgreSQL.

-- Uncomment the line below if using MYSQL.
-- USE OLYMPICARCHERY;

-- 1. Write a query to list all coach names (first and last), name of the country that they represent
-- and the number of gold, silver and bronze medals won by that country.
SELECT P.FName, P.LName, P.Country, CY.AllTimeGold, CY.AllTimeSilver, CY.AllTimeBronze
FROM PARTICIPANT AS P
JOIN COACH AS C ON P.OlympicID = C.OlympicID
JOIN COUNTRY AS CY ON P.Country = CY.CName;

-- 2. Write a query to list the names of all countries that have won at least three medals in archery overall.
SELECT CY.CName, (CY.AllTimeGold + CY.AllTimeSilver + CY.AllTimeBronze) AS TotalMedals
FROM COUNTRY AS CY
WHERE (CY.AllTimeGold + CY.AllTimeSilver + CY.AllTimeBronze) >= 3;

-- 3. Write a query to count how many coaches belong to each country. Order your list with alphabetical 
-- order of country names.
SELECT P.Country, COUNT(*) 
FROM PARTICIPANT AS P
JOIN COACH AS C ON P.OlympicID = C.OlympicID
GROUP BY P.Country
ORDER BY P.Country;

-- 4. Write a query to list the Olympic ID number, name (first and last), and birth year of all athletes,
-- Order your list from youngest to oldest.
SELECT P.OlympicID, P.FName, P.LName, A.BirthYear
FROM PARTICIPANT AS P, ATHLETE AS A
WHERE P.OlympicID = A.OlympicID
ORDER BY A.BirthYear DESC;

-- 5. Write a query to list all athlete names (first and last).
SELECT P.Fname, P.LName
FROM PARTICIPANT AS P, ATHLETE AS A
WHERE P.OlympicID = A.OlympicID;

-- 6. Write a query to retrieve the first games in which the individual bronze medalists competed.
SELECT A.FirstGames
FROM ATHLETE AS A
JOIN INDIVIDUAL_RESULTS AS IR ON A.OlympicID = IR.Olympian
WHERE IR.Medal = 'Bronze';

-- 7. Write a query to list the team IDs of all teams that have at least one member who is
-- participating in the Olympic Games for the first time.
SELECT DISTINCT T.TeamID
FROM PARTICIPANT AS P, ATHLETE AS A, TEAM AS T
WHERE P.OlympicID = A.OlympicID AND A.FirstGames = 'Tokyo 2020';

-- 8. Write a query to list the names of all countries that have more than two athletes
-- and more than one coach from the same country listed in the database.
WITH ParticipantCount AS (
    SELECT P.Country,
           SUM(CASE WHEN A.OlympicID IS NOT NULL THEN 1 ELSE 0 END) AS AthleteCount,
           SUM(CASE WHEN C.OlympicID IS NOT NULL THEN 1 ELSE 0 END) AS CoachCount
    FROM PARTICIPANT AS P
    LEFT JOIN ATHLETE AS A ON P.OlympicID = A.OlympicID
    LEFT JOIN COACH AS C ON P.OlympicID = C.OlympicID
    GROUP BY P.Country
)
SELECT Country, AthleteCount, CoachCount
FROM ParticipantCount
WHERE AthleteCount > 2 AND CoachCount > 1;

select * from participant as p, coach as c
where c.olympicid = p.olympicid;

-- 9. Write a query to list the names (first and last) and countries of any coaches who have not yet
-- completed their orientation shop.
SELECT P.FName, P.LName, P.Country
FROM PARTICIPANT AS P, COACH AS C
WHERE P.OlympicID = C.OlympicID AND C.Orientation = 'Pending';

-- 10. Write a query to retrieve a list of the countries that did not win any gold medals
-- in this Olympics.
SELECT DISTINCT COUNTRY
FROM PARTICIPANT
WHERE COUNTRY NOT IN (
    SELECT DISTINCT P.Country
    FROM PARTICIPANT AS P
    INNER JOIN INDIVIDUAL_RESULTS AS IR ON P.OlympicID = IR.Olympian
    WHERE IR.Medal = 'Gold'
);













