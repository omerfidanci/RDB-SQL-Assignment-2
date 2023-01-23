use SampleRetail;
/*
	RDB&SQL Assignment-2 (DS 13/22 EU)
*/

/*

1. Product Sales
You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.
1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)
To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge.
*/

--Method 1:

select distinct c.customer_id, c.first_name, c.last_name, 
	case when exists(
				select *
				from sale.customer cc, sale.orders co, sale.order_item coi, product.product cp
				where cc.customer_id = c.customer_id and 
					cc.customer_id = co.customer_id and
					co.order_id = coi.order_id and
					coi.product_id = cp.product_id and
					cp.product_name = 'Polk Audio - 50 W Woofer - Black')
		then 'Yes' else 'No' end as other_product
	from sale.customer c, sale.orders o, sale.order_item oi, product.product p
	where c.customer_id = o.customer_id and
		o.order_id = oi.order_id and
		oi.product_id = p.product_id and
		p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
-- ----------------------------------------
-- Method 2:

SELECT     distinct c.customer_id,     c.first_name,     c.last_name,    CASE        WHEN EXISTS(            SELECT DISTINCT product_id            FROM sale.order_item oi             JOIN sale.orders o ON oi.order_id = o.order_id            WHERE product_id IN (                SELECT p.product_id                 FROM product.product p                WHERE p.product_name = 'Polk Audio - 50 W Woofer - Black'            )            AND o.customer_id = c.customer_id        ) THEN 'Yes'        ELSE 'No'    END AS other_productFROM sale.orders o, sale.customer c, sale.order_item oi, product.product pWHERE p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' and    o.customer_id = c.customer_id and    o.order_id = oi.order_id and    oi.product_id = p.product_idORDER BY c.customer_id

-- ----------------------------------------
-- method 3:

with p1 as (
		select c.customer_id
		from sale.customer c, sale.orders o, sale.order_item oi, product.product p
		where c.customer_id = o.customer_id and
			o.order_id = oi.order_id and
			oi.product_id = p.product_id and
			p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'),

	p2 as (
		select c.customer_id
		from sale.customer c, sale.orders o, sale.order_item oi, product.product p
		where c.customer_id = o.customer_id and
			o.order_id = oi.order_id and
			oi.product_id = p.product_id and
			p.product_name = 'Polk Audio - 50 W Woofer - Black')

select distinct c.customer_id, c.first_name, c.last_name, 
	case 
		when c.customer_id in 
			(select p1.customer_id
			from p1
			inner join p2
				on p1.customer_id = p2.customer_id) then 'Yes'
		else 'No'
	end as other_product
from sale.customer c, sale.orders o, sale.order_item oi, product.product p
where c.customer_id = o.customer_id and
	o.order_id = oi.order_id and
	oi.product_id = p.product_id and
	p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

-------------------------------------------------------------------------------------

/*
2. Conversion Rate

Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company.
Write a query to return the conversion rate for each Advertisement type.
 
a.    Create above table (Actions) and insert values,
b.    Retrieve count of total Actions and Orders for each Advertisement Type,
c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0. 
*/

-- a.
CREATE TABLE sale.ECommerce ( Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY, Adv_Type VARCHAR (255) NOT NULL, Action1 VARCHAR (255) NOT NULL);INSERT INTO sale.ECommerce (Adv_Type, Action1)VALUES ('A', 'Left'),('A', 'Order'),('B', 'Left'),('A', 'Order'),('A', 'Review'),('A', 'Left'),('B', 'Left'),('B', 'Order'),('B', 'Review'),('A', 'Review');-- b.WITH cte AS (	SELECT Adv_Type, COUNT(*) as total_actions	FROM sale.ECommerce	GROUP BY Adv_type)SELECT a.Adv_type, cte.total_actions, COUNT(Action1) as total_ordersFROM cte JOIN sale.ECommerce AS a  ON cte.Adv_type = a.Adv_typeWHERE Action1 = 'Order'GROUP BY a.Adv_type, cte.total_actions-- c.SELECT Adv_type, CAST(1.0 * SUM(CASE WHEN Action1 = 'Order' THEN 1 ELSE 0 END)/COUNT(Adv_type) AS decimal(3,2)) as 'Conversion_rate'FROM sale.ECommerceGROUP BY Adv_type;------------------------------------------------------------