-- Create STREAMING_PLATFORMS table

ALTER TABLE amazon_hd
ADD COLUMN IF NOT EXISTS platform VARCHAR;

UPDATE amazon_hd 
SET platform = 'amazon';


ALTER TABLE netflix_hd
ADD COLUMN IF NOT EXISTS platform VARCHAR;

UPDATE netflix_hd 
SET platform = 'netflix';

ALTER TABLE disney_hd
ADD COLUMN IF NOT EXISTS platform VARCHAR;

UPDATE disney_hd  
SET platform = 'disney';

SELECT COUNT(*)
FROM amazon_hd;
--9.668

SELECT COUNT(*)
FROM netflix_hd;
--8.807

SELECT COUNT(*)
FROM disney_hd;
--1.450

CREATE TABLE streaming_platforms AS
SELECT *
FROM amazon_hd
UNION ALL
SELECT *
FROM netflix_hd
UNION ALL
SELECT *
FROM disney_hd;

SELECT COUNT(*)
FROM streaming_platforms;
--19.925

SELECT *
FROM streaming_platforms;

______________________________________________________________


-- Create NETFLIX_COUNTRY table

CREATE TABLE netflix_country AS
SELECT *
FROM 
(SELECT TRIM(split_part),
COUNT(*)
FROM 
(SELECT split_part(country, ',', 1) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 2) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 3) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 4) FROM netflix_hd
UNION ALL
SELECT  split_part(country, ',', 5) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 6) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 7) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 8) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 9) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 10) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 11) FROM netflix_hd
UNION ALL
SELECT split_part(country, ',', 12) FROM netflix_hd) AS a
GROUP BY 1) AS b;     

--remove rows with NULL values
DELETE FROM netflix_country 
WHERE btrim IS NULL;

--remove empty rows
DELETE FROM netflix_country 
WHERE count = 85700;

--rename a column
ALTER TABLE netflix_country
RENAME COLUMN btrim TO country;

______________________________________________________________


-- Create NETFLIX_GENRE table

CREATE TABLE netflix_genre AS
SELECT  type, 
		split_part(listed_in, ',', 1) AS genre,
		COUNT (*)
FROM netflix_hd
GROUP BY 1, 2

SELECT count(*)
FROM netflix_genre

______________________________________________________________


-- Create NETFLIX_TTG (type, title, genre) table


CREATE TABLE netflix_ttg AS
SELECT  type, 
		title, 
		split_part(listed_in, ',', 1) AS genre
FROM netflix_hd

SELECT count(*)
FROM netflix_ttg

______________________________________________________________


-- Create RANKING table


CREATE TABLE rotten_tomatoes_data AS 
SELECT 	title, 
		release_year, 
		age AS viewers_age, 
		netflix, 
		prime_video AS amazon, 
		"disney+" AS disney_plus,
		CAST (split_part(rotten_tomatoes, '/', 1) AS int) AS ranking
FROM rotten_tomatoes_hd

______________________________________________________________


-- Create YEAR & MONTH ADDED table


CREATE TABLE streaming_platforms_2  AS
	SELECT *
	FROM streaming_platforms;


SELECT DATE_PART('month', date_added) AS extract_month
FROM streaming_platforms_2;

SELECT DATE_PART('year', date_added) AS extract_year	
FROM streaming_platforms_2;

SELECT COUNT (DATE_PART('year', date_added))
FROM streaming_platforms_2;

SELECT COUNT (DATE_PART('month', date_added))
FROM streaming_platforms_2;

-- YEAR

ALTER TABLE streaming_platforms_2
ADD COLUMN IF NOT EXISTS year_added INTEGER;

UPDATE streaming_platforms_2
SET year_added = EXTRACT(YEAR FROM date_added);

SELECT COUNT (year_added)
FROM streaming_platforms_2;
		
-- MONTH

ALTER TABLE streaming_platforms_2
ADD COLUMN IF NOT EXISTS month_added INTEGER;

UPDATE streaming_platforms_2
SET month_added = EXTRACT(MONTH FROM date_added);

SELECT COUNT (year_added)
FROM streaming_platforms_2;

DROP TABLE IF EXISTS streaming_platforms_23

______________________________________________________________


-- Create STREAMING_PLATFORMS_3 table


CREATE TABLE streaming_platforms_3 AS
	SELECT 
	platform,	
	show_id,
	"type",
	title,
	release_year,
	rating, 
	duration,
	split_part(country, ',', 1) AS country,
	split_part(director, ',', 1) AS director,
	split_part("cast", ',', 1) AS actor,
	split_part(listed_in, ',', 1) AS genre,
	CAST (EXTRACT(YEAR FROM date_added) AS int) AS year_added,
	CAST (EXTRACT(MONTH FROM date_added) AS int) AS month_added
FROM streaming_platforms;


SELECT COUNT (month_added)
FROM streaming_platforms_3

______________________________________________________________


-- Adjust DATA: GENRE


UPDATE streaming_platforms_3 
SET genre = 'Dramas'
WHERE genre = 'Drama';


UPDATE streaming_platforms_3 
SET genre = 'Comedies'
WHERE genre = 'Comedy';

UPDATE streaming_platforms_3 
SET genre = 'Action & Adventure'
WHERE genre = 'Action-Adventure';


UPDATE streaming_platforms_3 
SET genre = 'Documentaries'
WHERE genre = 'Documentary';

