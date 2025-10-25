---------------------------------------------------------------------- PART TO WHOLE ----------------------------------------------------------------------------------------
----------------------------------------------------- WHICH CATEGORIES CONTRIBUTE THE MOST TO OVERALL SALES-------------------------------------------------------------------
with category_sales as 
(select category,sum(sales_amount) as total_sales from  `gold.fact_sales` as s left join `gold.dim_products`
as p on s.product_key=p.product_key group by category)
  
select category,total_sales,sum(total_sales) over () as overall_sales,
concat((total_sales/sum(total_sales) over ())*100,"%") as percentage_of_total from category_sales order by total_sales desc ;
