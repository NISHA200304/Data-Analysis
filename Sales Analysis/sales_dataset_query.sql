

create database sales_dataset
use sales_dataset


select top 1 * from orders

-- fact table orders --
select top 1 * from customers
select top 1 * from employees
select top 1 * from order_items
select top 1 * from payments
select top 1 * from promotions
select top 1 * from shipments
select top 1 * from stores

select top 1 * from order_items
-- fact table order items -- 
select top 1 * from products
select top 1 * from returns

select top 1 * from products
-- fact table prdocuts -- 
select top 1 * from categories
select top 1 * from suppliers

-- sales analysis --
-- 1. total sales by store, product by category, and month --

-- total sales by store -- 

create view total_sales_by_store as
select s.store_id, sum(oi.qty * oi.price) as total_sales
from orders o
join stores s on o.store_id = s.store_id
join order_items oi on o.order_id = oi.order_id
group by s.store_id

select * from total_sales_by_store

-- total sales product by category --

create view product_by_category as
select c.category_name, sum(oi.qty * oi.price) as total_sales_pCategory
from products p
join categories c on p.category_id = c.category_id
join order_items oi on p.product_id = oi.product_id
group by c.category_name

select * from product_by_category

-- total sales by month --

alter table orders
add order_month int

update orders
set order_month = month(order_date)

create view total_by_month as
select o.order_month, sum(oi.qty * oi.price) as monthly_sales
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_month

select * from total_by_month

-- first 2. identify top 10 selling products and underperforming products --

create view top_selling_products as
select top 10 * from product_by_category
order by total_sales_pCategory asc

create view underperforming_products as
select top 10 * from product_by_category
order by total_sales_pCategory desc

select * from top_selling_products

-- 2. customer insights --
-- count total customers --

create view total_customers as
select count(customer_id) as customer_count from customers 

-- new vs returning customers -- 

create view new_vs_returning_customer as
select o.customer_id,count(o.order_id) as total_orders,
case 
when count(o.order_id) = 1 then 'New Customer'
else 'existing customer'
end as customer_type
from orders o
group by o.customer_id

-- active customers --

create view active_customers as 
select o.order_month, count(distinct o.customer_id) as active_customers
from orders o
group by o.order_month

-- customer purchase frequency and average_order_value -- 

create view customer_purchase as
select o.customer_id, count(o.order_id) as total_orders, sum(oi.qty * oi.price) as total_spent, sum(oi.qty * oi.price)  / count(distinct o.order_id) as avg_order_value
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.customer_id

select * from customer_purchase

-- loyal customers -- 

create view loyal_customers as
select o.customer_id, count(distinct o.order_id) as total_orders
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.customer_id
having count(o.order_id) > 1

select * from loyal_customers

-- 3. product & supplier performance analysis --

-- product demand analysis top 10 --

create view top_product_demand as
select top 10 product_id, sum(cast(qty as int)) as total_qty_sold
from order_items 
group by product_id
order by total_qty_sold desc

-- product demand analysis least 10 --

create view least_product_demand as
select top 10 product_id, sum(cast(qty as int)) as total_qty_sold
from order_items 
group by product_id
order by total_qty_sold asc

-- product sales contribution --

create view product_sales_contribution as
select product_id, sum(cast(qty as decimal(18,2)) * price) as total_sales, sum(cast(qty as decimal(18,2)) * price) * 100.0 / (select sum(cast(qty as decimal(18,2)) * price) from order_items) as contribution 
from order_items
group by product_id

-- supplier performance --

create view supplier_performace as
select p.supplier_id,s.status, count(distinct s.shipment_id) as total_shipments
from shipments s
join order_items oi on s.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by p.supplier_id,s.status

-- top selling suppliers -- 

create view top_selling_suppliers as
select top 10 s.supplier_id, s.country, sum(cast(oi.qty as int) * oi.price) as total_sales
from suppliers s
join products p on s.supplier_id = p.supplier_id
join order_items oi on p.product_id = oi.product_id
group by s.supplier_id, s.country
order by total_sales desc

-- 4. orders and shipping -- 
-- total orders and order status -- 

create view total_order_status as
select status, count(distinct order_id) as total_orders
from shipments
group by status

-- orders per store -- 

create view orders_per_store as
select o.store_id, s.city, count(o.order_id) as total_orders
from orders o
join stores s on o.store_id = s.store_id 
group by o.store_id,s.city

-- regions with highest returns -- 

CREATE VIEW returns_by_region AS
SELECT st.city, COUNT(r.return_id) AS total_returns
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN orders o ON oi.order_id = o.order_id
JOIN stores st ON o.store_id = st.store_id
GROUP BY st.city;

select * from returns_by_region

-- revenue analysis -- 

create view revenue_analysis as 
select order_id, sum(amount) as total_amount
from payments
group by order_id

-- high value transactions -- 

create view high_transactions as
select order_id, sum(amount) as total_amount
from payments
group by order_id
order by sum(amount) desc

-- monthly revenue trends -- 

alter table orders
add order_year int

update orders
set order_year = year(order_date)

create view monthly_revenue as
select o.order_year, o.order_month, sum(p.amount) as total_revenue
from orders o 
join payments p on o.order_id = p.order_id
group by o.order_year, o.order_month
order by o.order_year, o.order_month asc 

-- revenue by store -- 

create view revenue_by_store as 
select o.store_id, sum(p.amount) as total_revenue 
from orders o 
join payments p on o.order_id = p.order_id
group by o.store_id





































