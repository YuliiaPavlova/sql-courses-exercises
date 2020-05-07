-- 1. Finding 5 the oldest users; 

SELECT *
FROM users
ORDER BY created_at
LIMIT 5;

-- 2. Most popular registration date; 

SELECT DAYNAME(created_at) AS day
FROM users
GROUP BY day
ORDER BY COUNT(day) DESC;

-- 3. Identify inactive users (users without photos)

SELECT username 
FROM users
LEFT JOIN photos ON users.id=photos.user_id
WHERE photos.id IS NULL;

-- 4. Identify users who have the most popular photos

SELECT username, image_url, COUNT(likes.photo_id) AS total_likes
FROM photos
JOIN likes ON photos.id=likes.photo_id
JOIN users ON users.id=photos.user_id
GROUP BY photo_id
ORDER BY total_likes DESC
LIMIT 5;

-- 5. How many times does the average user posts (avg number of photos per user)? 

SELECT (SELECT COUNT(photos.id) FROM photos) / (SELECT COUNT(users.id) FROM users) AS avg_user_posts;

-- 6. Five most popular hashtags

SELECT tag_name, COUNT(tag_id) AS total
FROM tags
JOIN photo_tags ON tags.id=photo_tags.tag_id
GROUP BY tag_id
ORDER BY total DESC
LIMIT 5;

-- 7. Finding bots (users who liked every single photo)

SELECT users.id, username, COUNT(users.id) AS total_like
FROM users
JOIN likes ON users.id=likes.user_id
GROUP BY users.id
HAVING total_like=(SELECT COUNT(id) FROM photos);