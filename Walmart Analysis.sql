CREATE DATABASE salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL (10, 2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_pct FLOAT(11, 9),
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT(2,1)
);

-- Dataset was improted via csv file into SQL 

-- ------------------------------------------------------------
-- --------------------------- Feauture Engineering------------------

-- time_of_day 

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
    );
    
    -- ----------------------------------------------------------------------------------
    
    -- day_name
    
SELECT date,
DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name =DAYNAME(date);

-- ----------------------------

-- month_name

Select date,
Monthname(date) AS month_name
From sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

Update sales
SET month_name =Monthname(date);


-- ------------------------------------------------
-- -------------------------------- Generic questions---------------------------------

-- How many unique cities does the data have?

SELECT 
DISTINCT city 
FROM sales;

-- In which city is each branch?

SELECT 
DISTINCT city, branch
FROM sales;




-- -------------------------------------------------
-- -------------------------------- Product-------------------------------

-- How many unique product lines does the data have?

SELECT
COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?

SELECT payment_method,
COUNT(payment_method) AS Cnt
FROM sales
GROUP BY payment_method
ORDER BY Cnt DESC;

-- ---------------------- What is most common product line--------
SELECT product_line,
COUNT(product_line) AS Cnt
FROM sales
GROUP BY product_line
ORDER BY Cnt DESC;
-- -----------------------------------------------------
-- ------------------------- What is total revenue by month ?---
SELECT 
month_name AS month,
SUM(total) AS total_revenue 
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- ---------------  What month had largest COGS?---
SELECT 
month_name AS month,
SUM(cogs) AS cogs  
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- ----------------------
-- ------------- What product line had the largest revenue?
SELECT 
product_line AS Product, 
SUM(total) as total_revenue 
FROM sales
GROUP BY product_line 
ORDER BY total_revenue DESC;

-- ----------------------
-- What is the city with the largest revenue?-------

SELECT
city AS city,
SUM(total) as total_revenue 
FROM sales
GROUP BY city 
ORDER BY total_revenue DESC;
-- ----------------------------------
-- What Branch sold more produts than average products sold 
SELECT
branch,
SUM(quantity) as qty
FROM sales
GROUP BY branch 
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- --------------------------------
-- -------- What is the most common product line by gender?-------------
SELECT
	gender,
    product_line,
    COUNT(product_line) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- ---------
-- ------------- What is the average rating of each product line-----

SELECT 
AVG(rating) AS avg_rating,
product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating desc;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
ROUND(AVG(quantity),2) AS Avg_qnty
FROM sales;

SELECT product_line,
CASE 
WHEN AVG(quantity) > 5.5 THEN "Good"
ELSE "Bad"
END AS remark
FROM sales
GROUP BY product_line;

-- ---------------------- Sales---------------------------
-- --------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday

SELECT
time_of_day,
COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- ---------------------- Customer-----------------------------
-- -------------------- which customer type brings in most revenue----

SELECT 
customer_tyoe,
ROUND(SUM(total),2) AS most_revenue 
FROM sales
GROUP BY customer_tyoe
ORDER BY most_revenue DESC;

-- How many unique customer types does the data have-----

SELECT 
DISTINCT customer_tyoe
FROM sales;

-- ------- Which customer type buys the most-------

SELECT 
customer_tyoe,
COUNT(time_of_day) AS Buys_total
FROM sales
GROUP BY customer_tyoe
ORDER BY Buys_total Desc;

-- ------- What is the gender of Most customers-----

SELECT
gender,
COUNT(gender) AS Total_Gender
FROM sales
GROUP BY gender;

-- ------ What is the gender distribution per branch-----

SELECT 
gender,
COUNT(gender) AS Gender_Distribution
FROM sales
WHERE branch = "C"
GROUP BY gender;

-- ------------ Which time of the day do customers give most ratings

SELECT 
time_of_day,
COUNT(rating) AS rating_cnt 
FROM sales
GROUP BY time_of_day
ORDER BY rating_cnt DESC;

-- ----------- Which Day of the week has best avg ratings ------

SELECT 
day_name,
AVG(rating) as avg_rtng
FROM sales
GROUP BY day_name
ORDER BY avg_rtng Desc;
