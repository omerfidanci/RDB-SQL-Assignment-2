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

SELECT 

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
CREATE TABLE sale.ECommerce ( Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY, Adv_Type VARCHAR (255) NOT NULL, Action1 VARCHAR (255) NOT NULL);