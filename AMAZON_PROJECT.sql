drop table if exists retail;
Create table Retail(
transaction_id INT Primary key,
Sale_date DATE,
Sale_time TIME,
customer_id INT,
gender Char(10),
age INT,
Category VARCHAR(20), 
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sales FLOAT
);

select * from retail;

SELECT COUNT(*) FROM retail;
SELECT COUNT(DISTINCT customer_id) FROM retail;
SELECT DISTINCT category FROM retail;

SELECT * FROM retail
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail

WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

---Data Exploration----
---How many sales we have---
select SUM(total_sales) from retail;

--retreive all columns for sales made on '2022-11-05'
select * from retail 
where sale_date='2022-11-05';

--retrieve all transactions where the category is 'clothing' and the quantity sold is more tahn 4 in the month of Nov-2022
select transaction_id,category,quantity from retail
where category='Clothing' AND quantity>4 AND To_char(sale_date, 'yyyy-mm')='2022-11';

--Write a SQL query to calculate the total sales (total_sale) for each category.:
select

drop table if exists amazon;

create table amazon(
"index" TEXT,
"Order ID" TEXT,
"Date" TEXT,
"Status" TEXT,
"Fulfilment" TEXT,
"Sales Channel" TEXT,
"ship-service-level" TEXT,
"Style" TEXT,
"SKU" TEXT,
"Category" TEXT,
"Size" TEXT,
"ASIN" TEXT,
"Courier Status" TEXT,
"Qty" TEXT,
"currency" TEXT,
"Amount" TEXT,
"ship-city" TEXT,
"ship-state" TEXT,
"ship-postal-code" TEXT,
"ship-country" TEXT,
"promotion-ids" TEXT,
"B2B" TEXT,
"fulfilled-by" TEXT,
"total amount paid" TEXT,
"Month Name" TEXT,
"Day Name" TEXT,
"Year" TEXT
);

drop table if exists amazon;

SELECT * FROM AMAZON;

ALTER TABLE amazon
ALTER COLUMN "index" TYPE INT
USING NULLIF("index", '')::INT;

SELECT 'INDEX' TYPE FROM AMAZON;

ALTER TABLE AMAZON
ALTER COLUMN "index" TYPE INT;

ALTER TABLE amazon
ALTER COLUMN "Date" TYPE DATE
USING TO_DATE(NULLIF("Date", ''), 'DD-Mon-YY');

ALTER TABLE amazon
ALTER COLUMN "Amount" TYPE DECIMAL(12,2)
USING NULLIF("Amount", '')::DECIMAL(12,2);

ALTER TABLE amazon
ALTER COLUMN "total amount paid" TYPE DECIMAL(12,2)
USING NULLIF("total amount paid", '')::DECIMAL(12,2);

ALTER TABLE amazon
ALTER COLUMN "B2B" TYPE BOOLEAN
USING NULLIF("B2B", '')::BOOLEAN;

ALTER TABLE amazon
ALTER COLUMN "ship-postal-code" TYPE VARCHAR(20);


select * from amazon;

--NET REVENUE--
select Sum("Amount") as Net_revenue 
from amazon;

--TOTAL QUANTITY ORDERED--
select COUNT("Qty") as Total_quantity_sold from amazon;

--ALTER DATA TYPE OF COLUMN QTY--
ALTER TABLE amazon
ALTER COLUMN "Qty" TYPE INT
USING NULLIF("Qty", '')::INT;

--AVERAGE ORDER VALUE--
select ("Amount"/"Qty") as Average_order_value from amazon;

--SALES BY MONTHS--
select "Month Name",sum("Amount") as sales from amazon
group by "Month Name" order by sales DESC;

--MAX SALES IN MONTH--
select MAX("Amount") as Max_sales from amazon
group by "Month Name";

--SALES BY CATEGORY--
select "Category",Sum("Amount") as Sales from amazon
group by "Category" order by Sales DESC;

--sales by product--
SELECT
    "Style",
    "SKU",
    SUM("Amount") AS product_sales
FROM amazon
GROUP BY "Style", "SKU"
ORDER BY product_sales DESC
LIMIT 1;

select "Order ID", "Courier Status" from amazon
where "Courier Status"='Cancelled';

--total cancelled orders--
select COUNT(DISTINCT "Order ID") from amazon
where "Courier Status"='Cancelled';

--cancelled order percentage--
SELECT
    ROUND(
        COUNT(DISTINCT CASE
            WHEN "Courier Status" = 'Cancelled' THEN "Order ID"
        END) * 100.0
        / COUNT(DISTINCT "Order ID"),
        2
    ) AS cancellation_percentage
FROM amazon;

--•	Which fulfilment method has the highest sales? 
select "Fulfilment", Sum("Amount") as valuess
from amazon
group by "Fulfilment"
order by valuess DESC
limit 1;

--•	How does Easy Ship compare with other fulfilment methods? 
select "Fulfilment", Sum("Amount") as valuess
from amazon
group by "Fulfilment";

--•	What is the distribution of order statuses? 
SELECT
    "Status",COUNT("Status") AS total_orders
FROM amazon
GROUP BY "Status"
ORDER BY total_orders DESC;

--•	Which states generate the most revenue? 
select "ship-state", Sum("Amount") as Total_revenue from amazon
group by "ship-state"
order by Total_revenue DESC
limit 10;

--•	Which cities have the highest order volume?
select "ship-city", Count("Order ID") as Total_orders
from amazon
group by "ship-city"
order by Total_orders DESC
limit 10;

--•	Which regions have the highest sales? 

--•	How does B2B sales compare with non-B2B? 
select "B2B", SUM("Amount") as Total_Sales
from amazon
group by "B2B"
order by Total_sales;

--•	Which sizes sell the most? 
select "Size", count(DISTInCT "Order ID") as total_Sales
from amazon
group by "Size"
order by total_Sales DESC
limit 5;

--•	Which categories have the highest average order value? 
select "Category" , Sum("Amount") as order_value
from amazon
group by "Category";

SELECT
    "Category",
    SUM("Amount") / COUNT(DISTINCT "Order ID") AS average_order_value
FROM amazon
GROUP BY "Category"
ORDER BY average_order_value DESC;

SELECT
    "Category",
    ROUND(
        SUM("Amount") / COUNT(DISTINCT "Order ID"),
        2
    ) AS average_order_value
FROM amazon
GROUP BY "Category"
ORDER BY average_order_value DESC;

--•	Which products have high quantity but relatively low revenue? 
SELECT
    "SKU",
    SUM("Qty") AS total_quantity,
    SUM("Amount") AS total_revenue,
    ROUND(
        SUM("Amount") / NULLIF(SUM("Qty"), 0),
        2
    ) AS revenue_per_unit
FROM amazon
GROUP BY "SKU"
ORDER BY total_quantity DESC
limit 10;

--•	How many orders use promotions? 
select COUNT("Order ID"), "promotion-ids" from amazon
group by "promotion-ids";



SELECT
    COUNT(DISTINCT "Order ID") AS promotion_orders
FROM amazon
WHERE "promotion-ids" <> 'No Promotion';

--•	Do promoted orders generate more/less revenue? 


