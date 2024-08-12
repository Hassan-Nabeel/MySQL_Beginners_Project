SHOW DATABASES;
CREATE DATABASE IF NOT EXISTS Walmart_Sale;
-- DROP DATABASE Walmart_Sale 
USE Walmart_Sale;
CREATE TABLE IF NOT EXISTS Sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
	branch VARCHAR(5) NOT NULL,
	city VARCHAR(30) NOT NULL,
	customer_type VARCHAR(30) NOT NULL,
	gender VARCHAR(30) NOT NULL,
	product_line VARCHAR(30) NOT NULL,
	unit_price DECIMAL(10,2) NOT NULL,
	quantity INT NOT NULL,
	tax_pct FLOAT(6,4) NOT NULL,
	total DECIMAL(12, 4) NOT NULL,
	date DATETIME NOT NULL,
	time TIME NOT NULL,
	payment VARCHAR(15) NOT NULL,
	cogs DECIMAL(10,2) NOT NULL,
	gross_margin_pct FLOAT(11,9),
	gross_income DECIMAL(12, 4),
	rating FLOAT(2, 1)
);
DESCRIBE sales;

-- checking null values -------------------------------
SELECT * FROM Sales WHERE invoice_id IS NULL 
 OR branch IS NULL
 OR city IS NULL
 OR customer_type IS NULL;
 
 -- Featuring Engineering --------------------------------------
 -- time_of_day
SELECT time,
(CASE 
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
	ELSE 'Evening'
END ) AS time_of_date
FROM Sales;

ALTER TABLE Sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE Sales
SET time_of_day = (
CASE 
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
	ELSE 'Evening'
END );

-- day_name 
SELECT date, DAYNAME(date) FROM Sales;

ALTER TABLE Sales ADD COLUMN day_name VARCHAR(10);

UPDATE Sales
SET day_name = DAYNAME(date);

-- month_name 
SELECT date, MONTHNAME(date) FROM Sales;

ALTER TABLE Sales ADD COLUMN month_name VARCHAR(10);

UPDATE Sales
SET month_name = MONTHNAME(date);

-- Analysis ---------------------------------------------------
--  How many unique cities does the data have?
SELECT DISTINCT(city) FROM Sales;

-- In which city is each branch?
SELECT DISTINCT(branch) FROM Sales;

-- Product
-- How many unique product lines does the data have?
SELECT DISTINCT(product_line) FROM Sales;

-- What is the most common payment method?
SELECT COUNT(payment) AS total, payment FROM Sales GROUP BY payment ORDER BY total DESC;

-- What is the most selling product line?
SELECT SUM(quantity) AS MSP, product_line FROM Sales GROUP BY product_line ORDER BY MSP DESC;

-- What is the total revenue by month?
SELECT SUM(total) AS total_revenue, month_name FROM Sales GROUP BY month_name ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT SUM(cogs) AS cogs, month_name FROM Sales GROUP BY month_name ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT SUM(total) AS total_revenue, product_line FROM Sales GROUP BY product_line ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT SUM(total) AS total_revenue, city, branch FROM Sales GROUP BY city, branch ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT SUM(tax_pct) AS VAT, product_line FROM Sales GROUP BY product_line ORDER BY VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT AVG(quantity) FROM sales; 

SELECT product_line,
(CASE 
	WHEN product_line > AVG(quantity) THEN 'Good'
    ELSE 'Bad'
END) AS remark
FROM Sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT AVG(quantity) FROM Sales;

SELECT branch, SUM(quantity) AS qty 
FROM Sales 
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Sales);

-- What is the most common product line by gender?
SELECT gender, product_line, COUNT(product_line) AS total FROM Sales GROUP BY gender, product_line ORDER BY total DESC;

-- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) AS avg_r FROM Sales GROUP BY product_line ORDER BY avg_r DESC;

-- Sale -------------------------------------------------------------
-- Number of sales made in each time of the day per weekday 
SELECT day_name, time_of_day, COUNT(*) AS total FROM Sales GROUP BY time_of_day, day_name ORDER BY total DESC;

SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total FROM Sales GROUP BY customer_type ORDER BY total DESC;

-- Which city has the largest tax/VAT percent?
SELECT city, ROUND(AVG(tax_pct),2) AS VAT FROM Sales GROUP BY city ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type,gender, SUM(tax_pct) AS VAT FROM Sales GROUP BY customer_type, gender ORDER BY VAT DESC;


-- Customer -------------------------------------------------------------------
-- How many unique customer types does the data have?
SELECT DISTINCT(customer_type) FROM Sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT(payment) FROM Sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS Count FROM Sales GROUP BY customer_type ORDER BY Count DESC;

-- Which customer type buys the most?
SELECT customer_type, SUM(quantity) AS buy_qnt FROM Sales GROUP BY customer_type ORDER BY buy_qnt DESC;

-- What is the gender of most of the customers?
SELECT customer_type, gender, COUNT(gender) AS total FROM Sales GROUP BY customer_type, gender ORDER BY total DESC;

-- What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS total FROM Sales GROUP BY branch, gender ORDER BY branch;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(*) AS total FROM Sales GROUP BY time_of_day ORDER BY total DESC;

SELECT time_of_day, AVG(rating) AS avg_rating FROM sales GROUP BY time_of_day ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(*) AS total FROM Sales GROUP BY branch, time_of_day ORDER BY total DESC;

SELECT branch, time_of_day, AVG(rating) AS avg_rating FROM sales GROUP BY branch, time_of_day ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating FROM sales GROUP BY day_name ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT branch, day_name, AVG(rating) AS avg_rating FROM sales GROUP BY branch, day_name ORDER BY avg_rating DESC;
