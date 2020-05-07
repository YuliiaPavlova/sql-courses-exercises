-- 1.  Find the names of all students who are friends with someone named Gabriel.

SELECT name
FROM Highschooler
WHERE ID IN (SELECT ID2 
FROM Highschooler
INNER JOIN Friend ON ID=ID1
WHERE name='Gabriel')
ORDER BY 1;

SELECT name
FROM Highschooler 
INNER JOIN Friend ON ID=ID2
WHERE ID1 IN (SELECT ID FROM Highschooler WHERE name = 'Gabriel')
ORDER BY 1;

SELECT H2.name
FROM Highschooler H1
INNER JOIN Friend F ON H1.ID=F.ID1
INNER JOIN Highschooler H2 ON H2.ID=F.ID2
WHERE H1.name='Gabriel'
ORDER BY 1;

-- 2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID=ID1
INNER JOIN Highschooler H2 ON H2.ID=ID2
WHERE H1.grade>=(H2.grade+2);

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID = Likes.ID1
INNER JOIN Highschooler H2 ON H2.ID = Likes.ID2
WHERE (H1.grade - H2.grade) >= 2;

-- 3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

SELECT h1.name, h1.grade, h2.name, h2.grade 
FROM Likes L1 
INNER JOIN Likes L2 
ON L1.id1 = L2.id2
AND L1.id2 = L2.id1
INNER JOIN Highschooler h1 ON L1.id1 = h1.id
INNER JOIN Highschooler h2 ON L1.id2 = h2.id
WHERE h1.name  < h2.name;

-- 4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

SELECT name, grade
FROM Highschooler 
LEFT JOIN Likes L1 ON ID=L1.ID1
LEFT JOIN Likes L2 ON ID=L2.ID2
WHERE L1.ID1 IS NULL AND L1.ID2 IS NULL AND L2.ID1 IS NULL AND L2.ID2 IS NULL
ORDER BY grade, name;

SELECT name, grade
FROM Highschooler
WHERE ID NOT IN (
  SELECT ID1 FROM Likes
  UNION
  SELECT ID2 FROM Likes)
ORDER BY grade, name;

-- 5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Likes
INNER JOIN Highschooler H1 ON ID1=H1.ID
INNER JOIN Highschooler H2 ON ID2=H2.ID
WHERE ID2 NOT IN (SELECT ID1 FROM Likes)
ORDER BY H1.name;

-- 6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

SELECT name, grade FROM Highschooler WHERE NOT EXISTS (
    SELECT *
    FROM Highschooler H1
    INNER JOIN Friend F ON H1.ID = F.ID1 
    WHERE F.ID2 = Highschooler.ID 
    AND H1.grade != Highschooler.grade)
ORDER BY grade, name;

-- 7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

-- 8. Find the difference between the number of students in the school and the number of different first names.

SELECT COUNT(*) - COUNT(DISTINCT name) AS dif
FROM Highschooler;

-- 9. Find the name and grade of all students who are liked by more than one other student.

SELECT name, grade
FROM Likes 
INNER JOIN Highschooler ON ID=ID2
GROUP BY ID2
HAVING COUNT(ID2)>1;

SELECT name, grade
FROM Highschooler WHERE ID IN (
SELECT ID2 FROM Likes 
GROUP BY ID2
HAVING COUNT(ID1)>1);

-- EXTRAS -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.

-- 2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.

SELECT name, grade FROM Highschooler WHERE NOT EXISTS (
    SELECT *
    FROM Highschooler H1
    INNER JOIN Friend F ON H1.ID = F.ID1 
    WHERE F.ID2 = Highschooler.ID 
    AND H1.grade = Highschooler.grade)
ORDER BY grade, name;

-- 3. What is the average number of friends per student? (Your result should be just one number.)

SELECT AVG(friends) FROM 
(SELECT COUNT(ID2) AS friends
FROM Friend
GROUP BY ID1);

-- 4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.

-- 5. Find the name and grade of the student(s) with the greatest number of friends.

SELECT name, grade
FROM Highschooler
WHERE ID IN (
	SELECT ID1 
	FROM Friend 
	GROUP BY ID1
	HAVING COUNT(ID2) IN 
		(SELECT MAX(NT.total) 
		FROM 
			(SELECT COUNT(ID2) as total
			FROM Friend
			GROUP BY ID1) AS NT));
