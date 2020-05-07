-- many_to_many database

USE many_to_many;

SELECT title, rating
FROM series JOIN reviews ON series.id=reviews.series_id
ORDER BY title;

SELECT title, AVG(rating) AS avg_rating
FROM series JOIN reviews ON series.id=reviews.series_id
GROUP BY series.id
ORDER BY avg_rating;

SELECT first_name, last_name, rating
FROM reviewers JOIN reviews ON reviewers.id=reviews.reviewer_id;

SELECT title AS unreviewed_series
FROM series LEFT JOIN reviews ON series.id=reviews.series_id
WHERE rating IS NULL;

SELECT genre, ROUND(AVG(rating), 1) AS avg_rating
FROM series JOIN reviews ON series.id=reviews.series_id
GROUP BY genre;

SELECT first_name, last_name, 
	COUNT(rating) AS COUNT,
	IFNULL(MIN(rating), 0) AS MIN,
	IFNULL(MAX(rating), 0) AS MAX,
	IFNULL(ROUND(AVG(rating), 1), 0) AS AVG,
	CASE 
	WHEN COUNT(rating)=0 THEN 'INACTIVE'
	ELSE 'ACTIVE' END AS STATUS,
	CASE 
	WHEN COUNT(rating)>=10 THEN 'Power User'
	WHEN COUNT(rating)>0 THEN 'Active User'
	ELSE 'Looser' END AS STATUS2
FROM reviewers LEFT JOIN reviews ON reviewers.id=reviews.reviewer_id
GROUP BY reviewers.id;

-- !ALTERNATIVE SOLUTION FOR CASE STATEMENT!
-- IF(COUNT(rating) > 0, 'ACTIVE', 'INACTIVE') AS STATUS 

SELECT title, rating, CONCAT(first_name, ' ', last_name) AS reviewer
FROM reviewers 
JOIN reviews ON reviewers.id=reviews.reviewer_id 
JOIN series ON series.id=reviews.series_id
ORDER BY title;
