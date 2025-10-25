/*==============================================================================================================================================================================
CUSTOMER REPORT
================================================================================================================================================================================
PURPOSE:
   -THIS REPORT CONSOLIDATES KEY CUSTOMER METRICS AND BEHAVIORS

HUGHLIGHTS:_
1.GATHERS ESSENTIAL FIELDS SUCH AS NAMES,AGES AND TRANSCATION DETAILS
2.SEGMENTS CUSTOMERS INTO CATEGORIES (VIP,REGULAR,NEW) AND AGE GROUPS
3.AGGREGATES CUSTOMER-LEVEL METRICS:
-TOTAL ORDERS
-TOTAL SALES
-TOTAL QUANTITY PURCHASED
-TOTAL PRODUCTS
-LIFESPAN
4.CALCULATES VALUABLE KPIs:
-AVERAGE ORDER values
-AVERAGE MONTHLY SPEND
==============================================================================================================================================================================*/
Create view gold_report_customers as 
with base_query as
/*--------------------------------------------------------------------------------------------
1.BASE QUERY:RETRIVES CORE COLUMNS FROM TABLES
---------------------------------------------------------------------------------------------*/
(Select order_number,product_key,order_date,sales_amount,quantity,c.customer_key,c.customer_number,YEAR(CURDATE()) - birthdate AS age,concat(first_name," ",last_name) as customer_name
 from  `gold.fact_sales` f left join `gold.dim_customers` c on c.customer_key=f.customer_key where order_date is not null),
/*---------------------------------------------------------------------------------------------
2.CUSTOMER AGGREGATIONS:SUMMARIZES KEY METRICS AT THE CUSTOMER LEVEL
---------------------------------------------------------------------------------------*/
customer_aggregations as 
(SELECT customer_key,customer_number,customer_name,age,count(distinct order_number) as total_orders,sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,count(distinct product_key) as total_products
,max(order_date) as latest_order,timestampdiff(month,min(order_date),max(order_date)) as lifespan FROM BASE_QUERy
group by customer_key,customer_number,customer_name,age)

SELECT 
Customer_key,customer_number,customer_name,
case when age<20 then "under 20"
when age between 20 and 29 then "20-29"
when age between 30 and 39 then "30-39"
when age between 40 and 49 then "40-49" 
else "50 and above"
end as age_group ,
case when lifespan>12 and total_sales >5000 then "VIP_customers"
when lifespan>=12 and total_sales <=5000 then "Regular_Customers"
when lifespan <12 then "New_cutomers"
else "not a customer" end as customer_segment,total_orders,total_sales,
total_quantity,total_products, 
lifespan,
-------- Compute average order value(AVO)------
case when total_orders=0 then 0
 else total_sales/total_orders 
 end as avg_or ,
 ----- Average monthly spend--------------
 case when lifespan=0 then total_sales
 else total_sales/lifespan
 end as avg_monthly_spend
  fROM customer_aggregations;
  
 

