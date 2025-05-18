
# 🍿📺 Netflix Data Analysis using SQL – Project P2 Part 2 🎉🎯

![Netflix Banner](https://upload.wikimedia.org/wikipedia/commons/6/69/Netflix_logo.svg)

## 📖 Project Overview
This project demonstrates how to perform advanced SQL-based exploratory data analysis using a real-world Netflix dataset. The goal is to uncover trends, identify content patterns, and gain actionable insights by writing efficient and meaningful SQL queries.

---

## 🎯 Objectives
- 🔍 Analyze content trends based on type, rating, and genre.
- 🌍 Discover top countries producing content.
- 📆 Track recent additions and historical trends.
- 👨‍🎤 Explore actor appearances and genre popularity.
- 🚩 Use regular expressions and array functions for text analysis.

---

## 🛠️ How to Use This Project
1. Ensure you have a PostgreSQL-compatible SQL environment.
2. Copy and execute the table creation script and insert your dataset if needed.
3. Run each query block step-by-step to observe results and trends.
4. Modify queries to further explore the dataset or solve business questions.

---

## 📂 Dataset Table Definition

```sql
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix(
  show_id     VARCHAR(6),
  type        VARCHAR(10),
  title       VARCHAR(150),
  director    VARCHAR(208),
  casts       VARCHAR(1000),
  country     VARCHAR(150),
  date_added  VARCHAR(50),
  release_year INT,
  rating      VARCHAR(10),
  duration    VARCHAR(15),
  listed_in   VARCHAR(100),
  description VARCHAR(250)
);
```

---

## ✅ Project Tasks

### 🎭 1. Count the Number of Movies vs TV Shows

```sql
SELECT type, COUNT(*) AS total 
FROM netflix 
GROUP BY type;
```

---

### 🎬 2. Most Common Rating for Each Type

```sql
SELECT type, rating, most_common_rating
FROM (
  SELECT type, rating, COUNT(*) AS most_common_rating,
         RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
  FROM netflix
  GROUP BY type, rating
) AS ranked
WHERE ranking = 1;
```

---

### 📅 3. Movies Released in 2020

```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' AND release_year = 2020;
```

---

### 🌍 4. Top 5 Countries with the Most Content

```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country, COUNT(*) 
FROM netflix 
GROUP BY new_country 
ORDER BY COUNT(*) DESC 
LIMIT 5;
```

---

### 🎥 5. Identify the Longest Movie

```sql
SELECT title, 
       SUBSTRING(duration, 1, POSITION('m' IN duration)-1)::INT AS duration_minutes
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY duration_minutes DESC
LIMIT 1;
```

---

### 🆕 6. Content Added in the Last 5 Years

```sql
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month dd, yyyy') > CURRENT_DATE - INTERVAL '5 years';
```

---

### 🎞️ 7. Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * 
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%';
```

---

### 📺 8. TV Shows with More Than 5 Seasons

```sql
SELECT * 
FROM netflix 
WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

---

### 📚 9. Count of Content in Each Genre

```sql
SELECT COUNT(*) AS total, TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre
FROM netflix 
GROUP BY genre 
ORDER BY total DESC;
```

---

### 🇮🇳 10. Average Yearly Release % for Indian Content

```sql
SELECT ROUND(COUNT(*)::NUMERIC / (
  SELECT COUNT(*)::NUMERIC 
  FROM netflix, LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS c(c_name)
  WHERE TRIM(c_name) = 'India') * 100, 2) AS average,
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month dd, yy')) AS year
FROM netflix,
  LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS c(c_name)
WHERE TRIM(c_name) = 'India'
GROUP BY year 
ORDER BY year;
```

---

### 📽️ 11. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix,
     LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS doc
WHERE type = 'Movie' AND TRIM(doc) = 'Documentaries';
```

---

### 👑 13. Salman Khan Movies in Last 10 Years

```sql
SELECT * 
FROM netflix 
WHERE casts ILIKE '%Salman Khan%' 
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

---

### 🌟 14. Top 10 Actors in Indian Movies

```sql
SELECT COUNT(*) AS appearances, TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor
FROM netflix  
WHERE country ILIKE '%India%' 
GROUP BY actor 
ORDER BY appearances DESC 
LIMIT 10;
```

---

### 🔪 15. Categorize Content by Keywords 'Kill' or 'Violence'

```sql
WITH categorized AS (
  SELECT 
    CASE 
      WHEN description ~* '\mkill\M' THEN 'Kill-BAD'
      WHEN description ~* '\mviolence\M' THEN 'Violence-BAD'
      ELSE 'Good'
    END AS category,
    description
  FROM netflix
)
SELECT category, COUNT(*) 
FROM categorized 
GROUP BY category;
```

---

## 🧠 Skills Demonstrated
- SQL String functions and pattern matching
- Window functions and ranking
- Regex filtering with word boundaries
- Data transformation using arrays
- Real-world text processing

---

## 📌 Notes
- Ensure your SQL engine supports `LATERAL`, regex (`~*`), and date functions.
- Dataset may need cleanup for better consistency.
- Use `EXPLAIN` to optimize heavy queries if required.

---

✨ Inspired by real-world streaming data challenges and crafted for hands-on SQL practice.
