-- 1. Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM Movie 
WHERE director = 'Steven Spielberg';

-- 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

SELECT DISTINCT year  
FROM Movie
INNER JOIN Rating ON Movie.mID=Rating.mID
WHERE stars = 4 OR stars = 5
ORDER BY year;

SELECT DISTINCT year
FROM Movie
INNER JOIN Rating USING(mId)
WHERE stars IN (4, 5)
ORDER BY year;

-- 3. Find the titles of all movies that have no ratings.

SELECT title
FROM Movie
LEFT JOIN Rating ON Movie.mID=Rating.mID
WHERE stars IS NULL;

SELECT title
FROM Movie
WHERE mId NOT IN (SELECT mID FROM Rating);

-- 4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

SELECT name 
FROM Reviewer
INNER JOIN Rating USING (rID)
WHERE ratingDate IS NULL
ORDER BY 1;

-- 5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

SELECT name, title, stars, ratingDate
FROM Rating 
INNER JOIN Movie USING (mID)
INNER JOIN Reviewer USING (rID)
ORDER BY 1, 2, 3;

-- 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

SELECT name, title
FROM Rating R1 INNER JOIN Rating R2 USING (rID, mID)
INNER JOIN Movie USING (mID)
INNER JOIN Reviewer USING (rID)
WHERE R2.ratingDate>R1.ratingDate AND R2.stars>R1.stars;

-- 7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

SELECT title, MAX(stars) 
FROM Rating
INNER JOIN Movie USING (mID)
GROUP BY mID
ORDER BY title;

-- 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

SELECT title, MAX(stars) - MIN(stars) AS 'rating spread'
FROM Rating
INNER JOIN Movie USING (mID)
GROUP BY mID
HAVING COUNT(stars)>1
ORDER BY 2 DESC, 1;

-- 9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

SELECT AVG(before1980.avg) - AVG(after1980.avg)
FROM 
(SELECT AVG(stars) AS avg FROM Rating INNER JOIN Movie ON Rating.mID=Movie.mID WHERE year < 1980 GROUP BY title) AS before1980, 
(SELECT AVG(stars) AS avg FROM Rating INNER JOIN Movie ON Rating.mID=Movie.mID WHERE year > 1980 GROUP BY title) AS after1980;

-- EXTRAS -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. Find the names of all reviewers who rated Gone with the Wind.

SELECT DISTINCT name
FROM Rating R
INNER JOIN Movie USING (mID)
INNER JOIN Reviewer USING (rID)
WHERE title = 'Gone with the Wind';
-- this query works correctly in case names are unique 

SELECT name
FROM Rating R
INNER JOIN Reviewer USING (rID)
WHERE R.rID IN 
(SELECT DISTINCT rID
FROM Rating
INNER JOIN Movie USING (mID)
WHERE title = 'Gone with the Wind')
GROUP BY R.rID;
-- this query will find all unique reviewers despite their names are unique or not

-- 2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.

SELECT director, title, stars
FROM Rating 
INNER JOIN Movie USING (mID)
INNER JOIN Reviewer USING (rID)
WHERE director = name;

-- 3. Find the titles of all movies not reviewed by Chris Jackson.

SELECT title 
FROM Movie 
WHERE mID NOT IN (
SELECT mID 
FROM Rating
INNER JOIN Reviewer USING (rID)
WHERE name 
	= 'Chris Jackson')
ORDER BY 1;

-- 4. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.


SELECT RE1.name, RE2.name
FROM Rating RA1 
INNER JOIN Rating RA2 USING (mID)
INNER JOIN Reviewer RE1 ON RA1.rID=RE1.rID
INNER JOIN Reviewer RE2 ON RA2.rID=RE2.rID
WHERE RE1.name<RE2.name
GROUP BY 1, 2;

SELECT DISTINCT RE1.name, RE2.name
FROM Rating RA1 
INNER JOIN Rating RA2 USING (mID)
INNER JOIN Reviewer RE1 ON RA1.rID=RE1.rID
INNER JOIN Reviewer RE2 ON RA2.rID=RE2.rID
WHERE RE1.name<RE2.name
ORDER BY RE1.name, RE2.name;

SELECT DISTINCT Re1.name, Re2.name
FROM Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
WHERE R1.mID = R2.mID
AND R1.rID = Re1.rID
AND R2.rID = Re2.rID
AND Re1.name < Re2.name
ORDER BY Re1.name, Re2.name;

-- 5. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

SELECT name, title, stars
FROM Rating 
INNER JOIN Movie USING (mID)
INNER JOIN Reviewer USING (rID)
WHERE stars IN (SELECT MIN(stars) from Rating)
ORDER BY 1, 2;

-- 6. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

SELECT title, AVG(stars)
FROM Rating
INNER JOIN Movie USING (mID)
GROUP BY mID
ORDER BY 2 DESC, 1;

-- 7. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)

SELECT name
FROM Rating
INNER JOIN Reviewer USING (rID)
GROUP BY rID
HAVING COUNT(*)>=3;

SELECT name
FROM Reviewer WHERE rID IN (
SELECT rID FROM Rating 
GROUP BY rID
HAVING COUNT(*)>=3);

-- 8. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)

SELECT M1.title, director
FROM Movie M1
INNER JOIN Movie M2 USING (director)
WHERE M1.mID!=M2.mID
ORDER BY 2,1;

-- 9. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)

SELECT title, AVG(stars) AS avg_stars
FROM Rating INNER JOIN Movie USING (mID)
GROUP BY mID
HAVING avg_stars = (
	SELECT MAX(NT.A) FROM (
		SELECT AVG(stars) AS A 
		FROM Rating INNER JOIN Movie USING (mID) 
		GROUP BY mID) AS NT);

-- 10. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)

SELECT title, AVG(stars) AS avg_stars
FROM Rating INNER JOIN Movie USING (mID)
GROUP BY mID
HAVING avg_stars = (
	SELECT MIN(NT.A) FROM (
		SELECT AVG(stars) AS A 
		FROM Rating INNER JOIN Movie USING (mID) 
		GROUP BY mID) AS NT);

-- 11. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.

SELECT director, title, MAX(stars)
FROM Movie 
INNER JOIN Rating USING (mID)
WHERE director IS NOT NULL
GROUP BY director;
-- KISS 

SELECT NT.D, NT.T, MAX(NT.M)
FROM 
(SELECT director AS D, title AS T, MAX(stars) AS M
FROM Rating INNER JOIN Movie USING (mID)
WHERE director IS NOT NULL
GROUP BY mID) AS NT
GROUP BY NT.D


