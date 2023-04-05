USE supply_chain
/*1.Company sells the product at different discounted rates. Refer actual product price in product table and selling price in the order item table.
 Write a query to find out total amount saved in each order then display the orders from highest to lowest amount saved.*/ 
with cte as (
select orderId,p.unitprice as p_unitprice,oi.unitprice as o_unitprice
from OrderItem oi inner join Product p 
on oi.ProductId=p.ID)
select orderID, sum(p_unitprice-o_unitprice) as amount_saved 
from cte 
group by orderId
order by 2 desc;

/* 2.Mr. Kavin want to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
a. List few products that he should choose based on demand.
b. Who will be the competitors for him for the products suggested in above questions.*/

-- a)
Select productname, count(*) as demand 
from Product p inner join OrderItem oi 
on p.id=oi.productId 
group by productid 
order by 2 desc 
limit 10;

-- b)
With cte as 
(Select supplierid,productname, count(*) as demand 
from Product p inner join OrderItem oi 
on p.id=oi.productId 
group by productid 
order by 3 desc 
limit 10)
select cte.productName,s.* 
from cte inner join Supplier s 
on cte.supplierid=s.id ;

/* 3.Create a combined list to display customers and suppliers details considering the following criteria 
a) Both customer and supplier belong to the same country
b) Customer who does not have supplier in their country
c) Supplier who does not have customer in their country */

-- a)
SELECT *
FROM supplier s INNER JOIN 
product p ON 
s.id = p.supplierid INNER JOIN
orderitem oi ON p.id = oi.productid 
INNER JOIN orders o ON 
o.id = oi.orderid INNER JOIN customer c
ON o.customerid = c.id
WHERE s.country = c.country
GROUP BY s.companyname

-- b)
SELECT *
FROM supplier s INNER JOIN 
product p ON 
s.id = p.supplierid INNER JOIN
orderitem oi ON p.id = oi.productid 
INNER JOIN orders o ON 
o.id = oi.orderid INNER JOIN customer c
ON o.customerid = c.id
WHERE s.country != c.country
GROUP BY s.companyname

-- c)
SELECT *
FROM supplier s INNER JOIN 
product p ON 
s.id = p.supplierid INNER JOIN
orderitem oi ON p.id = oi.productid 
INNER JOIN orders o ON 
o.id = oi.orderid INNER JOIN customer c
ON o.customerid = c.id
WHERE s.country != c.country
GROUP BY c.firstname

/* 4.Every supplier supplies specific products to the customers. Create a view of suppliers and total sales made by their products 
and write a query on this view to find out top 2 suppliers (using windows function) in each country by total sales done by the products.*/

create or replace view supp_total_sales
as (
select p.supplierID, s.CompanyName as Supplier_Company_name, s.country as supplier_country, p.ID as ProductID, p.ProductName,count(*) as total_sales 
from Product p inner join Supplier s 
on p.SupplierId=s.ID inner join OrderItem oi 
on p.ID=oi.ProductID 
group by p.ID
);

select * 
from (select Supplier_Company_Name, Supplier_Country,
	 rank() over(partition by supplier_country order by total_sales) as rn 
     from supp_total_sales) a 
where rn <= 2;

/* 5.Find out for which products, UK is dependent on other countries for the supply.
 List the countries which are supplying these products in the same list.*/
 
 select distinct p.ProductName,s.Country 
 from Customer c inner join Orders o 
 on c.ID=o.customerId and c.Country = 'UK'  
 inner join OrderItem oi 
 on o.id=oi.OrderId 
 inner join Product p 
 on oi.ProductId = p.ID 
 inner join Supplier s 
 on p.SupplierId = s.ID and s.Country != 'UK';
 
 /*6.Create two tables as ‘customer’ and ‘customer_backup’ as follow - 
‘customer’ table attributes -
Id, FirstName,LastName,Phone
‘customer_backup’ table attributes - 
Id, FirstName,LastName,Phone

Create a trigger in such a way that It should insert the details into the  ‘customer_backup’ table when you delete the record 
from the ‘customer’ table automatically.*/

-- 1.
create table customer as 
(select id,firstname,lastname,phone from Supply_chain.Customer);
-- 2. 
create table customer_backup as 
(select * from customer where 1!=1);
-- creating trigger
-- 3.
DELIMITER $$
CREATE TRIGGER ins_backup 
AFTER DELETE ON customer
FOR EACH ROW