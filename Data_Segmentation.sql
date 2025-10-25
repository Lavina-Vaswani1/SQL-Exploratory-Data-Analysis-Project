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
