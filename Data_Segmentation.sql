--------------------------------------------------------------------- DATA SEGMENTATION ------------------------------------------------------------------------------------------------------
------------------------------------------- SEGMENT PRODUCTS INTO COST RANGES AND COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT--------------------------------------------------
With product_segments as 

(Select  product_key,product_name,cost, 
case when cost<100  then "Below 100"
when cost between 100 and 500 then "100-500"
when cost between 500 and 1000 then "500-1000"  
else "Above 1000" 
end as cost_range
from `gold.dim_products`)
select cost_range,count(product_key) as total_products from product_segments group by cost_range order by total_products desc;


-------------------------------------------- GROUP CUSTOMERS INTO THREE SEGMENTS BASED ON THEIR SPENDING BEHAVOIR--------------------------------------------------------------
-------------------------------------------- VIP:CUSTOMERS WITH ATLEAST 12 MONTHS OF HISTORY AND SPOENDING MORE THAN 65000--------------------------------------------------------
-------------------------------------------- REGULAR:CUSTOMERS WITH AT LEAST 12 MONTHS OF HISTORY AND SPENDING 5000 OR LESS.-----------------------------------------------------
-------------------------------------------- -NEW:CUSTOMERS WITH A LIFESPAN LESS THAN 12 MONTHS.---------------------------------------------------------------------------------
-------------------------------------------- AND FIND THE TOTAL NUMBER OF CUSTOMERS BY EACH GROUP------------------------------------------------------------------------------
With customer_spending as (select c.customer_key,sum(f.sales_amount) as total_spending,
min(order_date),max(order_date),timestampdiff(month,min(order_date),max(order_date)) as lifespan
from `gold.fact_sales` as f left join `gold.dim_customers` as c on c.customer_key=f.customer_key 
group by c.customer_key) 
select customer_segment,count(customer_key) as total_customers from(select customer_key,
case when lifespan>12 and total_spending >5000 then "VIP_customers"
when lifespan>=12 and total_spending <=5000 then "Regular_Customers"
when lifespan <12 then "New_cutomers"
else "not a customer"
end as customer_segment from customer_spending) as t group by customer_segment order by total_customers desc;
