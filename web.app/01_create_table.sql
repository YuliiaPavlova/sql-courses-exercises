CREATE TABLE users (
email VARCHAR(255) NOT NULL PRIMARY KEY,
created_at TIMESTAMP NOT NULL DEFAULT NOW() 
);

-- query_exercises

# SELECT DATE_FORMAT(MIN(created_at), '%M %D %Y') AS earliest_date
# FROM users;

# SELECT *
# FROM users
# WHERE created_at = (SELECT MIN(created_at) FROM users);

# SELECT *
# FROM users
# ORDER BY created_at ASC LIMIT 1;

# SELECT MONTHNAME (created_at) AS month, COUNT(email) AS count
# FROM users
# GROUP BY month
# ORDER BY count DESC;

# SELECT COUNT(email) AS yahoo_users
# FROM users
# WHERE email LIKE '%@yahoo.com';

# SELECT CASE
#     WHEN email LIKE '%@gmail.com' THEN 'gmail'
#     WHEN email LIKE '%@yahoo.com' THEN 'yahoo'
#     WHEN email LIKE '%@hotmail.com' THEN 'hotmail'
#     ELSE 'other'
# END AS provider, 
# COUNT(*) AS total_users
# FROM users
# GROUP BY provider
# ORDER BY total_users DESC;
