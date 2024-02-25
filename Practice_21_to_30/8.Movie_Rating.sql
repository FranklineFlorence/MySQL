-- Find the movie rating

/* Table: Movies

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key (column with unique values) for this table.
title is the name of the movie.

 

Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key (column with unique values) for this table.

 

Table: MovieRating

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key (column with unique values) for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user's review date. 

 

Write a solution to:

    Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
    Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

The result format is in the following example.

 

Example 1:

Input: 
Movies table:
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
Users table:
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
MovieRating table:
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+
Explanation: 
Daniel and Monica have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.
 */

-- Solution1
# Write your MySQL query statement below
SELECT 
    (SELECT u.name 
     FROM movierating m 
     LEFT JOIN users u ON m.user_id = u.user_id 
     GROUP BY m.user_id 
     ORDER BY COUNT(*) DESC, u.name ASC 
     LIMIT 1) AS results

UNION ALL

SELECT 
    (SELECT mm.title 
     FROM movies mm 
     RIGHT JOIN movierating m ON mm.movie_id = m.movie_id 
     WHERE DATE_FORMAT(m.created_at, '%Y-%m') = '2020-02' 
     GROUP BY m.movie_id 
     ORDER BY AVG(m.rating) DESC, mm.title ASC 
     LIMIT 1) AS results;

--Solution2
#PART 1: Find the name of the user who has rated the greatest number of movie

WITH user_rating AS (
    SELECT name as results
    FROM (
        SELECT MovieRating.user_id, count(MovieRating.user_id) as cnt, Users.name as name
        FROM MovieRating
        JOIN Users ON MovieRating.user_id = Users.user_id
        GROUP BY MovieRating.user_id
        ORDER BY cnt DESC, Users.name ASC
        LIMIT 1
    ) sq
),

#Part 2:Find the movie name with the highest average rating in February 2020.
movie_avg AS (
    SELECT title as results
    FROM (
        SELECT MR.movie_id, AVG(rating) as avg_rate, title
        FROM MovieRating MR
        JOIN Movies ON MR.movie_id = Movies.movie_id
        WHERE MONTH(created_at) = 2 AND YEAR(created_at) = 2020
        GROUP BY MR.movie_id
        ORDER BY avg_rate DESC, title ASC
        LIMIT 1
    )sq2
)

SELECT * FROM user_rating
UNION ALL
SELECT * FROM movie_avg
