-- 1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.

DELETE FROM Highschooler
WHERE grade=12;

-- 2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.

