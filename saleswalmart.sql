-- Create Database called salesWallMart

create database salesWallMart ;
-- -----------------------------------------------------------------------------------------
 -- Create tables in salesWallMart database 
 Create table if not exists Sales(
 invoice_id varchar(30) not null primary key,
 branch varchar(5) not null,
 city varchar(30) not null,
 customer_type varchar(30) not null,
 gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10, 2) not null,
quantity int not null,
vat float(6, 4) not null,
total decimal (12, 4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10, 2) not null,
gross_margin_pct float(11, 9) not null,
gross_income decimal(12, 4) not null,
rate float(2, 1) not null
 
 );
 
 -- now import data with csv file to database after that check if it is imported correctly
 SELECT * FROM saleswallmart.sales;
 
 -- --------------------------------------------------------------------------------------
 -- -------------------------------------Feature Engineering ------------------------------
 -- This will help use generate some new columns from existing ones.
 
-- Add a new column named `time_of_day`
 
 select 
 time,
 (case 
	when time between "00:00:00" and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
END ) as time_of_day
 from sales;
 
 alter table saleswallmart.sales add column time_of_day varchar(30);
 update sales set time_of_day =  (case 
	when time between "00:00:00" and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
END );

-- Add a new column named `day_name`

alter table sales add column day_name varchar(30);
update sales 
set day_name = dayname(date);


-- Add a new column named `month_name`

 alter table sales add column month_name varchar(30);
update sales 
set month_name = monthname(date);

-- -------------------------------------------------------------------------------------------
-- ------------------------------------Generic questions--------------------------------------
-- 1. How many unique cities does the data have?

select count(distinct( city)) as no_of_city from sales;

-- 2. In which city is each branch?

select distinct branch, city from sales;

-- -------------------------------------------------------------------------------------------------
-- ----------------------------------------Product--------------------------------------------------

-- 1. How many unique product lines does the data have?

select count(distinct product_line) as no_of_product_line from sales;

-- 2. What is the most common payment method?

select  payment_method, count(payment_method) from sales
group by payment_method;

-- 3. What is the most selling product line?

select product_line, sum(quantity) as most_selling from sales
group by product_line
order by most_selling desc;

-- 4. What is the total revenue by month?

select month_name, sum(total) as rev from sales
group by month_name
order by rev desc;

-- 5. What month had the largest COGS?
select month_name, sum(cogs) as total_cogs from sales
group by month_name
order by total_cogs desc;

-- 6. What product line had the largest revenue?

select product_line, sum(total) as total_rev from sales
group by product_line
order by total_rev desc;

-- 5. What is the city with the largest revenue?

select city, sum(total) as total_rev from sales
group by city
order by total_rev desc;
 
 -- 6. What product line had the largest VAT?
 
 select product_line, avg(vat) as avg_vat from sales
group by product_line
order by avg_vat desc;

-- 7. Which branch sold more products than average product sold?

 select branch, sum(quantity) as qty from sales
group by branch
having sum(quantity) > (select avg(quantity) as avgqty from sales);

-- -------------------------------------------------------------------------------------------------------
-- ----------------------------------------- sales -------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday ?

select time_of_day, count(total) as total_sales  from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;

-- 2. Which of the customer types brings the most revenue?

select customer_type,  sum(total) as total_revenue  from sales
group by customer_type
order by total_revenue desc;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

select city, avg(vat) as avg_vat  from sales
group by city
order by  avg_vat desc;


-- 4. Which customer type pays the most in VAT?

select customer_type, sum(vat) as sum_vat  from sales
group by customer_type
order by  sum_vat desc;

-- -------------------------------------------------------------------------------------------------------
-- ------------------------------------Customer ----------------------------------------------------------

-- 1. How many unique customer types does the data have?

select distinct customer_type  from sales;


-- 2. How many unique payment methods does the data have?

select distinct payment_method from sales;

-- 3. What is the most common customer type?

select distinct customer_type, count(customer_type) from sales
group by customer_type;

-- 4. Which customer type buys the most?

select customer_type, sum(total) as total_rev from sales
group by customer_type
order by total_rev  desc;

-- 5. What is the gender of most of the customers?

select gender, count(gender) no_gender from sales 
group by gender
order by no_gender;

-- 6. What is the gender distribution per branch?

select branch, gender, count(gender) no_gender from sales 
group by branch, gender
order by branch, no_gender;

-- 7. Which time of the day do customers give most ratings?
select time_of_day, avg(rate) as avg_rating from sales 
group by time_of_day
order by avg_rating;

-- 8. Which time of the day do customers give most ratings per branch?
select branch, time_of_day, avg(rate) as avg_rating from sales 
group by branch, time_of_day
order by avg_rating desc;

-- 9. Which day fo the week has the best avg ratings?
select day_name, avg(rate) as avg_rating from sales 
group by day_name
order by avg_rating desc;

-- 10. Which day of the week has the best average ratings per branch?


select branch, day_name, avg(rate) as avg_rating from sales 

where branch = "A"
group by branch, day_name
order by avg_rating desc;



























-- 