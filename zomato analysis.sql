
-- zomato analytic


-- how much each customer spend on zomato?

-- select user_id,sum(price) from product
-- join sales on sales.product_id = product.product_id
-- group by user_id

-- how many days has each customer visited zomato?

-- select user_id,count(created_at) as visited_day from sales
-- group by user_id

-- first product purchased by each customer?
-- select * from
-- (select *, rank() over(partition by user_id order by created_at) as rnk from sales)sales where rnk = 1

-- what is the most purchased item and how many time was it purchased by all customers?

-- select user_id,count(product_id) as no_of_times from sales where product_id =
-- (select product_id from sales
-- group by product_id
-- order by count(product_id) desc
-- limit 1)
-- group by user_id
-- order by user_id

-- which is the most popular item among each customer

-- select * from
-- (select *, rank() over(partition by user_id order by no_of_times desc) rnk from
-- (select user_id,product_id,count(product_id) no_of_times from sales
-- group by user_id,product_id) sales) sales
-- where rnk = 1

-- which item was purchased first by customer after they become a gold member

-- select * from
-- (select *, rank() over(partition by user_id order by created_at) rnk from 
-- (select goldusers_signup.user_id,created_at,product_id,golduser_signup_date from goldusers_signup
-- inner join sales on goldusers_signup.user_id = sales.user_id
-- where created_at >= golduser_signup_date
-- ) sales) sales 
-- where rnk = 1

-- which item was purchased just before becoming the gold member

-- select * from 
-- (select *, rank() over(partition by user_id order by created_at desc) rnk from
-- (select sales.user_id,sales.created_at,sales.product_id,golduser_signup_date from sales
-- inner join goldusers_signup on sales.user_id = goldusers_signup.user_id
-- where golduser_signup_date >= created_at) sales ) sales
-- where rnk = 1

-- what is the total order and amount spent by each customer before becoming the gold member

-- select user_id,count(user_id) as purchased_item, sum(price) as money_spent from
-- (select sales.user_id,created_at,product.product_id,price,golduser_signup_date from sales
-- join goldusers_signup on sales.user_id = goldusers_signup.user_id
-- join product on product.product_id= sales.product_id
-- where created_at <= golduser_signup_date) sales
-- group by user_id


-- if buying each products generates points eg 5rs = 2points  that means 1 point = 2.5rs zomato points and each products has different purchasing points for eg for p1 5rs = 1 poinrs 
-- for p2 10 rs = 5 that means one ppint carring 2rs for p3 5rs = 1 points

-- calculate points collected by each customers and for which product most points have been collected till now

-- select user_id,round(sum(points) * 2.5,0) as total_point_earned from
-- (select user_id,product.product_id,sum(price) as amount,
-- case when product_name = 'p1' then sum(price)/5
-- when product_name = 'p2' then sum(price)/2
-- when product_name = 'p3' then sum(price)/5
-- else 0 
-- end as points
-- from product
-- join sales on sales.product_id = product.product_id
-- group by user_id,product_id
-- order by user_id
-- ) sales
-- group by user_id;

-- -- second part
-- select product_id,round(sum(points),0) as most_point_earned from
-- (select user_id,product.product_id,sum(price) as amount,
-- case when product_name = 'p1' then sum(price)/5
-- when product_name = 'p2' then sum(price)/2
-- when product_name = 'p3' then sum(price)/5
-- else 0 
-- end as points
-- from product
-- join sales on sales.product_id = product.product_id
-- group by user_id,product_id
-- order by user_id
-- ) sales
-- group by product_id
-- order by most_point_earned desc limit 1

-- in the first one year after the customer joining the gold member(including their join date) irrespective of what the customer has puchased they earned 5 zomato points 
-- for every 10rs spent so 1 zomato point = 2rs. show who earned more 1 or 3? and what was their point earning in the first year??

-- select sales.user_id,sales.product_id, order_placed,golduser_signup_date,price,round(price/2,0) as zomato_points from sales
-- join goldusers_signup on sales.user_id = goldusers_signup.user_id
-- join product on sales.product_id = product.product_id
-- where golduser_signup_date <= order_placed and order_placed <= date_add(golduser_signup_date,interval 1 year)

-- rank all the transaction of the customers

-- select *,rank() over(partition by user_id order by order_placed) rnk from sales

-- rank all the transation for each customer if they are a gold member else print na

-- select *,rank() over(partition by user_id order by order_placed) as rnk,
-- case when user_id is null then 'NA'
-- else rank() over(partition by user_id order by order_placed)
-- end as rnk
-- from
-- (select sales.user_id,product_id,order_placed,golduser_signup_date,
-- case when golduser_signup_date is null then 'NA'
-- else rank() over(partition by user_id order by order_placed)
-- end as rnk
--  from sales
-- left join goldusers_signup on sales.user_id = goldusers_signup.user_id and order_placed >= golduser_signup_date order by golduser_signup_date desc) sales


