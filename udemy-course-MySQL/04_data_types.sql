-- training database

DROP TABLE IF EXISTS dt;

CREATE TABLE dt(
id INT,
ts TIMESTAMP DEFAULT NOW(), 
c_date DATE AS (DATE(ts)),
c_time TIME AS (TIME(ts))
);

INSERT INTO dt (id) VALUES (1);

SELECT * FROM dt;
SELECT CONCAT(MONTHNAME(c_date), ' ', DAY(c_date), ', ', YEAR(c_date), ', ', DAYNAME(c_date)) AS today FROM dt;
SELECT DATE_FORMAT (c_date, '%M %d, %Y, %W') AS today FROM dt;

DROP TABLE IF EXISTS inventory;

CREATE TABLE inventory(
item_name VARCHAR(150),
price DECIMAL(8, 2),
quantity INT 
);

SELECT CURTIME();
SELECT CURDATE();
SELECT DAYOFWEEK(CURDATE());
SELECT DAYNAME(CURDATE());
SELECT DATE_FORMAT(CURDATE(), '%m/%d/%Y') AS today;
SELECT DATE_FORMAT(NOW(), '%M %D at %h:%i');

DROP TABLE IF EXISTS tweets;

CREATE TABLE tweets(
content VARCHAR(140),
username VARCHAR(20),
created_at TIMESTAMP DEFAULT NOW());