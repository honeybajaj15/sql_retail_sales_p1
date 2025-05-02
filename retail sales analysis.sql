-- SQL retail sales analysis
CREATE DATABASE retail_data;
use retail_data;

CREATE TABLE retail_sales(
transactions_id INT PRIMARY KEY,
sale_date date,
sale_time time,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT);

SELECT * FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;

select * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
or
sale_date is null
or 
sale_time is null
or 
customer_id is null
or
gender is null
or
age is null
or
category is null
or 
quantity is null
or
price_per_unit is null
or 
cogs is null
or
total_sale is null;

-- --DATA EXPLORATION 

-- How many sales we have?
SELECT count(total_sale) from retail_sales;

-- How many customers do we have?
Select count(DISTINCT(customer_id)) from retail_sales;

-- How many unique category we have?
Select distinct(category) as category from retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS
-- que 1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales
where sale_date = '2022-11-05';

-- que 2 Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 10 

SELECT * FROM retail_sales
where category = 'Clothing' AND quantity >'10';

SELECT category, 
count(quantity) 
from retail_sales
where category = 'Clothing'
AND 
quantity>=4;

-- que 3 Write a SQL query to calcuate the total sales (total_sale) for each category.

Select category,
 sum(total_sale) as net_sales,
 count(*) as total_sale
 from retail_sales
group by category;

-- que 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select round(AVG(age),0), category
from retail_sales
where category = 'Beauty';

-- que 5. Write a SQL query to find all transactions where total_sale is greater than 1000.

SELECT customer_id, total_sale
from retail_sales
where total_sale >1000;

-- que 6. Write a SQL query to find the total number of transactions_id made by each gender in each category.
select count(transactions_id), gender, category
from retail_sales
group by gender,category
order by 3;

-- que 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select * from
(SELECT EXTRACT(year from sale_date) as year, 
extract(month from sale_date) as month,
ROUND(AVG(total_sale),2) as avg_sale,
(RANK() OVER(partition by EXTRACT(YEAR FROM sale_date) order by avg(total_sale) desc)) as rn 
from retail_sales
group by 1,2
order by 1,avg_sale desc, 2) as t1
where rn = 1;


-- que 8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,
sum(total_sale) as sales
from retail_sales
group by customer_id
order by sales desc
limit 5;

-- que 9. Write a SQL query to find the number of unique customers who purchased items from each category.

Select count(DISTINCT(customer_id)), category
from retail_sales
group by category;

-- que 10. Write a SQL query to create each shift and number of orders (Example Morning<12, Afternoon betweem 12 & 17, Evening> 17).

WITH hourly_sale
as 
(
select *,
case 
		WHEN EXTRACT(hour from sale_time) < 12 THEN 'Morning'
        When EXTRACT(hour from sale_time) Between 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
        End as Shift
	From retail_sales
 )
 SELECT shift, 
 count(*) as total_orders
 from hourly_sale
 group by shift;
 
 -- End of project