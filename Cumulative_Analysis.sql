------------------------------------------------------------- CUMULATIVE ANALYSIS-------------------------------------------------------------------------------------
------------------------------------- CALCULATE THE TOTAL SALES FOR EACH MONTH AND RUNNING TOTAL OF SALES OVER TIME--------------------------------------------------

select order_date,total_sales,sum(total_sales) over(order by order_date) from 
(select date_format(order_date,"%Y")  as order_date,
sum(sales_amount) as total_sales from 
`gold.fact_sales`where date_format(order_date,"%Y") is not null group by
date_format(order_date,"%Y")) as t;

--------------------------------------- CALCULATE THE TOTAL SALES FOR EACH MONTH AND Average_price OF SALES OVER TIME------------------------------------------------
select order_date,total_sales,sum(total_sales) over(order by order_date),avg(average_price) over(order by order_date)
as average_price from 
(select date_format(order_date,"%Y")  as order_date,
sum(sales_amount) as total_sales,avg(price) as average_price from 
`gold.fact_sales`where date_format(order_date,"%Y") is not null group by
date_format(order_date,"%Y")) as t;
