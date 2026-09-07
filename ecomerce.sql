create database ecomerces;
use ecomerces;
# 1. Display all records
select * from ecommerce;
# 2 Any null values?
SELECT COUNT(*) AS total_null_values
FROM ecommerce
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR customer_age IS NULL
   OR customer_gender IS NULL
   OR city IS NULL
   OR state IS NULL
   OR product_id IS NULL
   OR product_category IS NULL
   OR brand IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL
   OR discount_percent IS NULL
   OR coupon_used IS NULL
   OR payment_method IS NULL
   OR order_status IS NULL
   OR customer_rating IS NULL
   OR delivery_days IS NULL
   OR customer_tenure_months IS NULL
   OR is_repeat_customer IS NULL
   OR warehouse IS NULL
   OR sales_channel IS NULL
   OR profit_margin_percent IS NULL
   OR returned_flag IS NULL
   OR marketing_source IS NULL
   OR order_date IS NULL
   OR total_amount IS NULL;

# 3 What is the number of orders
select count(order_id) as total_orders
from  ecommerce;
#4 How many unique customers do we have?
select count(distinct customer_id) as unique_Customer
from ecommerce;
#5 What is the total revenue?
select sum(total_amount) as total_amount
from  ecommerce;
# 6  Find maximum and minimum order amounts
select max(total_amount) as maximum_amounts ,
min(total_amount) as minimum_amounts
from ecommerce;
# 7 Find  avg quantity 
Select avg(quantity) as avg_quantity
from ecommerce;
#8  What is the Average discount?
Select avg(discount_percent) as avg_quantity
from ecommerce;
#9 What is the Man and Mix profit margin?
	Select Max(profit_margin_percent) as max_Profit_mergin,
    Min(profit_margin_percent) as min_Profit_mergin
    from ecommerce;
#10 What percentage of orders were returned?
select 
round(sum(case when returned_flag=1 then 1 else 0 end)*100/count(*),2) as return_percentage
from ecommerce;
#11 How many customers are new and repeat?
select is_repeat_customer,count(*) as customer_group
from ecommerce
group by is_repeat_customer;
#12 What percentage of customer were repeat?
select round(sum(case when is_repeat_customer=1 then 1 else 0 end)*100/count(*),2) as repeat_customer_percentage
from ecommerce;
#13 Which month generated the highest revenue?
select date_format(order_date,"%Y-%m") as months,sum(total_amount)  as total_revenue
from ecommerce
group by date_format(order_date,"%Y-%m") 
order by total_revenue desc
limit 1;
#14 Which month generated the lowest revenue?
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS revenue
FROM ecommerce
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY revenue ASC
LIMIT 1;
#15 What is the MoM revenue growth?
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS revenue
    FROM ecommerce
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
sales_with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly_sales
)
SELECT
    month,
    revenue,
    previous_revenue,
    ROUND(
        (revenue - previous_revenue) * 100.0
        / previous_revenue,
        2
    ) AS mom_growth_percentage
from  sales_with_previous;
# 16 Which product category generates the most revenue?
select product_category,sum(total_amount) as most_revenue
from ecommerce
group by product_category
order by most_revenue desc
limit 1;
# 17 Which city generates the most revenue?
select  city ,sum(total_amount) as most_revenue
from ecommerce
group by city
order by most_revenue desc
limit 1;
#18 What percentage of total revenue comes from the top category?
SELECT 
    product_category,
    SUM(total_amount) AS category_revenue,
    ROUND(
        SUM(total_amount) * 100.0 /
        (SELECT SUM(total_amount) FROM ecommerce),
        2
    ) AS revenue_percentage
FROM ecommerce
GROUP BY product_category
ORDER BY category_revenue DESC
LIMIT 1;

#19  Who are the top 10 customers by revenue?
select customer_id,sum(total_amount) as top_10_customers
from ecommerce
group by customer_id
order by top_10_customers desc
limit 10;
#20 Which customers have purchased only once?
select customer_id, count(order_id) as  purchesed_only_once
from ecommerce
group by customer_id
having count(order_id)=1;
#21 Which customers are repeat customers?
select customer_id, count(order_id) as  repeated_custmer
from ecommerce
group by customer_id
having  count(order_id)>1;
# 22 Which city has the most customers?
select city , count(customer_id) as highest_customer
from ecommerce
group by city
order by highest_customer desc
limit 1;
# 23 Which age group generates the most revenue?
select 
case 
when   customer_age < 18 THEN 'Under 18'
        WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 45 THEN '36-45'
        WHEN customer_age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'end as age_group ,sum(total_amount) as total_revenue
        from ecommerce
        group by 
        case 
when   customer_age < 18 THEN 'Under 18'
        WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 45 THEN '36-45'
        WHEN customer_age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'end 
        ORDER BY total_revenue DESC;
	#24 Which product sells the most units?
    select product_category,sum(quantity) as total_quantity
    from ecommerce
    group by product_category
    order by total_quantity desc;
    #25 Which category has the highest return rate?
   select product_category,count(*) as return_rate,
 round(sum(case when returned_flag=1 then 1 else 0 end)*100/count(*),2) as highest_return_rate
 from ecommerce
 group by product_category
 order by highest_return_rate desc
 limit 1;
#26 Which category generates high revenue but low margins?
select product_category,sum(total_amount) as total_amounts,sum(profit_margin_percent) as total_profit ,
round(sum(profit_margin_percent)*100/nullif(Sum(total_amount),0),2) as profit_margin
from ecommerce
group by product_category
order by total_amounts desc , profit_margin asc;
#27 Which sales channel performs best?
SELECT
    sales_channel,
    SUM(total_amount) AS revenue,
    COUNT(*) AS orders,
    AVG(total_amount) AS avg_order_value
FROM ecommerce
GROUP BY sales_channel
ORDER BY revenue DESC;
#28 Which marketing source generates highest revenue?
SELECT
    marketing_source,
    SUM(total_amount) AS revenue
FROM ecommerce
GROUP BY marketing_source
ORDER BY revenue DESC;
#29 Does discount affect profit margin?
SELECT
    CASE
        WHEN discount_percent = 0 THEN 'No Discount'
        WHEN discount_percent <= 10 THEN '1-10%'
        WHEN discount_percent <= 20 THEN '11-20%'
        ELSE '20%+'
    END AS discount_group,
    COUNT(*) AS orders,
    SUM(total_amount) AS revenue,
    AVG(profit_margin_percent) AS avg_profit_margin
FROM ecommerce
GROUP BY
    CASE
        WHEN discount_percent = 0 THEN 'No Discount'
        WHEN discount_percent <= 10 THEN '1-10%'
        WHEN discount_percent <= 20 THEN '11-20%'
        ELSE '20%+'
    END
ORDER BY avg_profit_margin DESC;
#30 which Orders above average order value?
select *
from ecommerce
where total_amount >(select 
avg(total_amount)
from ecommerce);
