-- book_shop database

SELECT title, stock_quantity,
CASE
WHEN stock_quantity < 50 THEN '*' 
WHEN stock_quantity BETWEEN 50 AND 99 THEN '**'
ELSE '***'
END AS stock
FROM books;

SELECT title, released_year FROM books WHERE released_year < 1980;
SELECT title, author_lname FROM books WHERE author_lname IN ('Eggers', 'Chabon');
SELECT title, author_lname, released_year FROM books WHERE author_lname = 'Lahiri' AND released_year > 2000;

SELECT title, pages FROM books WHERE pages BETWEEN 100 AND 200;
SELECT title, pages FROM books WHERE pages >99 AND pages <201;

SELECT title, author_lname FROM books WHERE author_lname LIKE 'C%' OR author_lname LIKE 'S%' ORDER BY author_lname;
SELECT title, author_lname FROM books WHERE SUBSTR(author_lname,1,1) = 'c' OR SUBSTR(author_lname,1,1) = 's' ORDER BY author_lname;
SELECT title, author_lname FROM books WHERE SUBSTR(author_lname,1,1) IN ('c', 's') ORDER BY author_lname;

SELECT title, author_lname,
CASE 
WHEN title LIKE '%stories%' THEN 'Short Stories' 
WHEN title = 'Just kids' OR title = 'A Heartbreaking Word' THEN 'Memoir' 
ELSE 'Novel' 
END AS TYPE 
FROM books;

SELECT title, author_lname, CASE WHEN COUNT(*) = 1 THEN '1 book' ELSE CONCAT(COUNT(*), ' books') END AS 'COUNT' FROM books GROUP BY author_lname, author_fname;