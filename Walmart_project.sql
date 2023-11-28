-- Creating DataBase
create database if not exists WalmartSales;
use walmartsales;

-- creating table and handling null values i.e. Data Wrangling
create table if not exists sales (
invoice_Id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_percentage float(11,9),
gross_income decimal(12,4),
rating float(2,1) 
);

-- Creating new column time_of_day
select time, ( case
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening" end) as time_of_day
from sales ;	

alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day = (
case
	when time between "00:00:00" and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
end);

-- creating column day_name
select date, dayname(date)
from sales;

use walmartsales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- creating column month_name
select date, monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

-- Exploratory Data Analysis (EDA)

-- Generic Question
-- Q1. How many unique cities does the data have?
select count(distinct(city)) from sales;

-- Q2. In which city is each branch?
select distinct(branch), city from sales;

-- PRODUCT
-- Q1. How many unique product lines does the data have?
select count(distinct(product_line)) from sales;

-- Q2. What is the most common payment method?
select payment_method,count(payment_method) as count_tran from sales
group by payment_method
order by count_tran desc
limit 1;

-- Q3. What is the most selling product line?
select product_line, sum(quantity) as sm from sales
group by product_line 
order by sm desc
limit 1;

-- Q4. What is the total revenue by month?
select month_name, sum(total) as tot from sales
group by month_name;

-- Q5. What month had the largest COGS?
select month_name, sum(cogs) from sales
group by month_name
order by sum(cogs) desc
limit 1;

-- Q6. What product line had the largest revenue?
select product_line, sum(total) as maxim from sales
group by product_line
order by maxim desc
limit 1;

-- Q7. What is the city with the largest revenue?
select city, sum(total) as maxim from sales
group by city 
order by maxim desc
limit 1;

-- Q8. What product line had the largest VAT?
select city, avg(vat) as maximum_vat from sales
group by city 
order by maximum_vat desc
limit 1;

-- Q9. Fetch each product line and add a column to those product line 
-- showing "Good", "Bad". Good if its greater than average sales
select product_line, ( case
when (select avg(quantity) from sales) < avg(quantity) then "Good"
else "Bad" end) as cases
from sales
group by product_line;

-- Q10. Which branch sold more products than average product sold?
select branch, sum(quantity) from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- Q11. What is the most common product line by gender?
select gender , product_line, count(product_line) as counts from sales
group by gender,product_line
order by counts desc;

-- Q12. What is the average rating of each product line?
select product_line, round(avg(rating),2) as avgr from sales
group by product_line
order by avgr desc;

-- SALES-- 
-- Q1. Number of sales made in each time of the day per weekday-- 
select time_of_day, count(*) as total from sales
group by time_of_day
order by total desc;

-- Q2. Which of the customer types brings the most revenue? 
select customer_type, sum(total) as total from sales
group by customer_type
order by total desc
limit 1;

-- Q3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, vat from sales
order by vat desc
limit 1; 

-- Q4. Which customer type pays the most in VAT?
select customer_type, vat from sales
order by vat desc
limit 1;

-- CUSTOMER
-- Q1. How many unique customer types does the data have?
select distinct(customer_type) from sales;

-- Q2. How many unique payment methods does the data have?
select distinct(payment_method) from sales;

-- Q3. What is the most common customer type?
select customer_type, count(customer_type) as counts from sales 
group by customer_type
order by counts desc
limit 1;

-- Q4. Which customer type buys the most?
select customer_type, count(*) as sum_quant from sales
group by customer_type
order by sum_quant desc
limit 1;

-- Q5. What is the gender of most of the customers?
select gender, count(gender) as cou from sales
group by gender
order by cou desc
limit 1;

-- Q6. What is the gender distribution per branch?
select branch, gender, count(gender) as countg from sales
group by branch, gender
order by branch, countg desc;

-- Q7. Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as cr from sales
group by time_of_day
order by cr desc
limit 1;

-- Q8. Which time of the day do customers give most ratings per branch?  assaaw
select branch, time_of_day , avg(rating) as cr from sales
group by branch, time_of_day
order by  cr desc
limit 3;

-- Q9. Which day of the week has the best avg ratings?
select day_name, avg(rating) as av from sales
group by day_name
order by av desc
limit 1;

-- Q10. Which day of the week has the best average ratings per branch?
select branch, day_name, avg(rating) as av from sales
group by branch, day_name
order by av desc
limit 3;
