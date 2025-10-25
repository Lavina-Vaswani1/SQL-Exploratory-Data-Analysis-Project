--------------------------------------------------------------- PERFORMANCE ANALYSIS------------------------------------------------------------------------------------------------------------
---- ANALYSE THE YEARLY PERFORMANCE OF PRODUCTS BY COMPARING EACH PRODUCTS SALES OF BOTH ITS AVERAGE SALES PERFORMANCE AND PREVIOUS YEAR'S SALES----------------------------------
With yearly_product_sales as 
  
(Select p.product_name,year(f.order_date) as order_date,sum(f.sales_amount) as sales_amount from `gold.fact_sales` as f left join `gold.dim_products` as p 
on f.product_key=p.product_key where year(f.order_date) is not null group by p.product_name,year(f.order_date))
  
select product_name,order_date,sales_amount,avg(sales_amount) over(partition by product_name) as avg_sales,
(sales_amount-avg(sales_amount) over(partition by product_name))as difference,lag(sales_amount) over(partition by product_name order by order_date) as py_sales,
case 
when (sales_amount-avg(sales_amount) over(partition by product_name))<0 then "Below Average" 
when (sales_amount-avg(sales_amount) over(partition by product_name))>0 then "Above Average"
else "n/a" 
end as average_change,
sales_amount-lag(sales_amount) over(partition by product_name order by order_date) as diff_py,
case 
when sales_amount-lag(sales_amount) over(partition by product_name order by order_date) >0 then "Increase"
when sales_amount-lag(sales_amount) over(partition by product_name order by order_date) <0 then "Decrease"
else "No change"
end py_change 
from  yearly_product_sales order by product_name,order_date;
