-- 1) Total number of orders placed
SELECT COUNT(DISTINCT order_id) AS total_orders

FROM pizza_sales;

-- 2) Total revenue generated from pizza sales (JOIN simulation)
SELECT SUM(ps.quantity * ps.unit_price) AS total_revenue
FROM pizza_sales ps

JOIN pizza_sales ps2 ON ps.pizza_id = ps2.pizza_id;

-- 3) Highest priced pizzas (descending order)
SELECT DISTINCT pizza_name, unit_price
FROM pizza_sales

ORDER BY unit_price DESC
LIMIT 10;

-- 4) Most common pizza size ordered
SELECT ps.pizza_size, COUNT(*) AS order_count
FROM pizza_sales ps
JOIN pizza_sales ps2 ON ps.pizza_id = ps2.pizza_id

GROUP BY ps.pizza_size
ORDER BY order_count DESC;

-- 5) Top 5 most ordered pizza types by quantity
SELECT ps.pizza_name, SUM(ps.quantity) AS total_quantity
FROM pizza_sales ps

JOIN pizza_sales ps2 ON ps.pizza_id = ps2.pizza_id
JOIN pizza_sales ps3 ON ps.pizza_id = ps3.pizza_id

GROUP BY ps.pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

-- 6) Order distribution by hour of the day
SELECT 
    EXTRACT(HOUR FROM order_time::time) AS order_hour,
    COUNT(*) AS total_orders
FROM pizza_sales

WHERE order_time IS NOT NULL

GROUP BY order_hour
ORDER BY order_hour;

-- 7) Category-wise pizza distribution (count)
SELECT pizza_category, COUNT(*) AS pizza_count
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pizza_count DESC;

-- 8) Average number of pizzas ordered per day
SELECT AVG(daily_total) AS overall_avg_pizzas_per_day
FROM (
    SELECT order_date, SUM(quantity) AS daily_total
    FROM pizza_sales
    GROUP BY order_date
) AS daily_sales;

-- 9) Top 3 pizzas by revenue
SELECT ps.pizza_name, SUM(ps.quantity * ps.unit_price) AS total_revenue
FROM pizza_sales ps
JOIN pizza_sales ps2 ON ps.pizza_id = ps2.pizza_id
JOIN pizza_sales ps3 ON ps.pizza_id = ps3.pizza_id
GROUP BY ps.pizza_name
ORDER BY total_revenue DESC
LIMIT 3;

-- 10) Revenue % contribution by category
SELECT 
    pizza_category,
    ROUND(SUM(quantity * unit_price)::numeric, 2) AS total_revenue,
    ROUND(
        (100.0 * SUM(quantity * unit_price) / 
         SUM(SUM(quantity * unit_price)) OVER ())::numeric, 
        2
    ) AS percentage_contribution
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;


-- 11) Top 3 pizzas by revenue for each category
SELECT pizza_name, revenue
FROM (
    SELECT 
        pizza_name, 
        ROUND(SUM(quantity * unit_price)::numeric, 2) AS revenue,
        RANK() OVER (
            PARTITION BY pizza_category 
            ORDER BY SUM(quantity * unit_price) DESC
        ) AS r
    FROM pizza_sales
    GROUP BY pizza_category, pizza_name
)
WHERE r <= 3
ORDER BY revenue DESC;
