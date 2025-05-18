-- NetFlix Project
drop table if exists netflix;
create table netflix(
						show_id	varchar(6),
						type	varchar(10),
						title	varchar(150),
						director	varchar(208),
						casts	varchar(1000),
						country	varchar(150),
						date_added	varchar(50),
						release_year	int,
						rating	varchar(10),
						duration	varchar(15),
						listed_in	varchar(100),
						description varchar(250)
)
select * from netflix;


select count(*) from netflix;

select distinct type from netflix;



-- 1. Count the Number of Movies vs TV Shows
	select * from netflix;
	select distinct type from netflix;
	
	select type,count(*) as total from netflix  group by type;


-- 2. Find the Most Common Rating for Movies and TV Shows

select * from netflix;

select type , rating , most_common_rating from 
(
select  
	type , 
	rating  ,
	count(rating) as most_common_rating , 
	rank() over(partition by type order by count(rating) desc) as ranking
from netflix 
group by 1,2
)
as new_netflix
where ranking =1;
	   
-- 3. List All Movies Released in a Specific Year (e.g., 2020)

select 
	*
from netflix
where type='Movie' and release_year = 2020;


-- 4. Find the Top 5 Countries with the Most Content on Netflix

select * from netflix;


select trim(unnest(string_to_array(country,','))) as new_country , count(*) from netflix group by 1 order by 2 desc limit 5;


-- 5. Identify the Longest Movie
select title,  substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where type = 'Movie' and duration is not null



-- 6. Find Content Added in the Last 5 Years

select to_date(date_added,'Month dd,yyy'),date_added
from netflix;

select date_added,* from netflix where to_date(date_added,'Month dd,yyy') > current_date - interval '5 years'


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select * from netflix where director ilike '%Rajiv Chilaka%';


--  8. List All TV Shows with More Than 5 Seasons
select split_part(duration,' ' ,1) from netflix;


select duration,* from netflix where type = 'TV Show' and split_part(duration,' ' ,1)::int > 5


-- 9. Count the Number of Content Items in Each Genre
select listed_in from netflix;

select count(*) as total,trim(unnest(string_to_array(listed_in,','))) as genre from netflix group by 2 order  by 1;


-- 10.Find each year and the average numbers of content release in India on netflix.

select 	
		round(count(*)::numeric/(
									select count(*)::numeric from netflix , LATERAL unnest(string_to_array(country, ',')) AS c(c_name)
										WHERE TRIM(c_name) = 'India') * 100,2
								) as average , 
		extract(year from to_date(date_added,'month dd,yy')) 
from netflix ,
LATERAL unnest(string_to_array(country, ',')) AS c(c_name)
WHERE TRIM(c_name) = 'India'
group by 2 order by 2;



--  11. List All Movies that are Documentaries

select * from netflix, Lateral unnest(string_to_array(listed_in,',')) as doc 
where type = 'Movie' and trim(doc) = 'Documentaries';


select * from netflx where listed_in ilike 'documentaries'

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select * from netflix where casts ilike '%Salman Khan%' and release_year > extract(year from current_date - interval '10 years');

select * from netflix where casts ilike '%Salman Khan%' and release_year > extract(year from current_date) -10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


select 
	count(*),unnest(string_to_array(casts,','))
from netflix  where country ilike '%india%' group by 2 order by 1 desc limit 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
-- Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. 
-- Count the number of items in each category.

with new as (
select  case
			when description ~* '\mkill\M' then 'Kill-BAD'
			when description ~* '\mviolence\M' then 'Violence-BAD '
			else 'Good'
		end category,
		description
from netflix ) 
select count(*) , category from new group by category;
;

















