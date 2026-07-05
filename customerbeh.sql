select * from [dbo].[customer_data] 


--total revenu by male and female customers
select gender, sum(purchase_amount)[revenue] from customer_data group by gender

--customers who used discount but still spend more than avg purchase amt
select customer_id,purchase_amount from customer_data where discount_applied='yes' and purchase_amount>=(select AVG(purchase_amount) from customer_data)


--Which are top 5 prodcts with avg review rating

select TOP 5 item_purchased,round(avg(review_rating),2)[Avg product rating]from customer_data group by item_purchased order by AVG(review_rating)desc 

--compare avg purchase amt blw standard and express shipping

select shipping_type,avg(purchase_amount) [avg purchase_amt] from customer_data where shipping_type in ('standard','express') group by shipping_type

--do subscribed cust spend more?compare avg spend and total revenue b/w subscribers and non subscribers

select subscription_status,count(customer_id)[total no of customers],avg(purchase_amount)[avg spend],sum(purchase_amount)[total amt] from customer_data group by subscription_status


--which 5 product highest percetage of purchases with discount applied

select top 5 item_purchased,round(100*sum(case when discount_applied='yes' then 1 else 0 end)/count(*),2)as discount_rate from customer_data
group by item_purchased order by discount_rate desc

--segment customers into new,returning ,loyal based on their total no of previous purchases and show countnof each segment

select case 
           when previous_purchases=1 then 'New'
           when previous_purchases  between 2 and 10 then 'Returning'
           else 'Loyal'
       end as customer_segment,
       count(*) as customer_count
       from customer_data
       group by
       case
        when previous_purchases=1 then 'New'
        when previous_purchases  between 2 and 10 then 'Returning'
        else 'Loyal'
        end


        --what are the top 3 purchased product within each category
SELECT *
FROM
(
    SELECT
        category,
        item_purchased,
        COUNT(*) AS total_purchases,
        ROW_NUMBER() OVER(
            PARTITION BY category
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM customer_data
    GROUP BY category, item_purchased
) AS t
WHERE rn <= 3;

--are customers who are repeat buyers also likely to subscribe

select subscription_status,count(customer_id) as repeat_buyers from customer_data where previous_purchases>5 group by subscription_status

--what is revenue contribution of each age grp

select age_group,sum(purchase_amount) as revenue_contribution from customer_data group by age_group order by revenue_contribution desc