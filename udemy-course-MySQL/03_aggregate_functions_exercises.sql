-- book_shop database

SELECT COUNT(*) FROM books;
SELECT released_year, COUNT(*) FROM books GROUP BY released_year;
SELECT SUM(stock_quantity) FROM books;
SELECT author_lname, author_fname, AVG(released_year) FROM books GROUP BY 1, 2;
SELECT CONCAT(author_lname, ' ', author_fname) AS author, pages FROM books WHERE pages=(SELECT MAX(pages) FROM books);
SELECT CONCAT(author_lname, ' ', author_fname) AS author, pages FROM books ORDER BY pages DESC LIMIT 1;

SELECT
released_year AS 'year',
COUNT(*) AS '# books',
AVG(pages) AS 'avg pages'
FROM books
GROUP BY released_year;