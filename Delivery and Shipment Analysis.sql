-- "How do different factors such as shipment mode, product discounts, warehouse performane and customer interactions 
-- impact delivery efficiency and customer satisfaction in an e-commerce business?"


-- Question1. which brands have the highest number of products listed?

SELECT 
    b.brand_name ,
    b.brand_id,
    COUNT(p.product_id) AS total_products
FROM
    products AS p
        JOIN
    brands AS b ON b.brand_id = p.brand_id
GROUP BY b.brand_id , b.brand_name
order by total_products desc;


-- Question2. Is there a relationship between the discount offered on a product and whether it reached the customer on time?

SELECT 
    p.discount,
    ROUND(AVG(s.reached_on_time) * 100, 2) AS on_time_delivery_percentage,
    COUNT(shipment_id) AS shipment_count
FROM
    products AS p
        JOIN
    shipments AS s ON s.product_id = p.product_id
GROUP BY p.discount
ORDER BY p.discount;

-- The data suggests a relationship between discount levels and on-time delivery.
-- Orders with discounts above 10% consistently show 100% on-time delivery,
-- while lower discount levels have noticeably lower on-time percentages. 


-- Question3. which mode of shipment has the highest on-time delivery percentage

SELECT 
    mode_of_shipment,
    ROUND(AVG(reached_on_time) * 100, 2) AS on_time_shipment_percentage
FROM
    shipments
GROUP BY mode_of_shipment
ORDER BY on_time_shipment_percentage DESC;

-- Question4. which brand has the highest cancellation rate 
		 -- assuming that the late delivery (reached_on_time=0) means the order was cancelled

SELECT 
    b.brand_name,
    ROUND((1 - AVG(s.reached_on_time)) * 100, 2) AS highest_cancellation_rate
FROM
    shipments AS s
        JOIN
    products AS p ON p.product_id = s.product_id
        JOIN
    brands AS b ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY highest_cancellation_rate DESC;

-- Question5. which warehouse block is the most efficient in terms of on time deliveries

SELECT 
    warehouse_block,
    ROUND((1 - AVG(reached_on_time)) * 100, 2) AS on_time_delivery_percentage
FROM
    shipments
GROUP BY warehouse_block
ORDER BY on_time_delivery_percentage DESC;

-- Question6. Is there any relationship between product importance and on-time delivery

SELECT 
    p.importance,
    ROUND((AVG(s.reached_on_time)) * 100, 2) AS on_time_delivery_percentage
FROM
    products AS p
        JOIN
    shipments AS s ON s.product_id = p.product_id
GROUP BY p.importance;

--  Question7. Does higher number of customer care calls correlate with late deliveries?

SELECT 
    customer_care_calls,
    ROUND((1 - AVG(reached_on_time)) * 100, 2) AS late_delivery_percentage
FROM
    shipments
GROUP BY customer_care_calls
ORDER BY customer_care_calls DESC;

-- Yes, there is a positive relationship between the number of customer care calls and late delivery.
-- As customer care calls increase, the late delivery percentage also rises, indicating customer complaints may be triggered by shipment delays.

-- Question8. which warehouse block generates the most customer care calls?

SELECT 
    warehouse_block, COUNT(customer_care_calls) AS total_calls
FROM
    shipments
GROUP BY warehouse_block
ORDER BY total_calls DESC;

-- Question9. do customers give lower ratings when deliverirs are late?

SELECT 
    customer_rating,
    ROUND((1 - AVG(reached_on_time)) * 100, 2) AS late_delivery_percentage
FROM
    shipments
GROUP BY customer_rating
ORDER BY late_delivery_percentage DESC;

-- Yes, customers who rated 1 or 2 experienced slightly higher late delivery percentages than those who rated 4 or 5.
-- This suggests that delivery performance may influence customer satisfaction, though the differences are not very large.


-- Question10. Which brand gets the most low customer ratings?

SELECT 
    b.brand_id,
    b.brand_name,
    COUNT(customer_rating) AS lowrating_count
FROM
    shipments AS s
        JOIN
    products AS p ON p.product_id = s.product_id
        JOIN
    brands AS b ON b.brand_id = p.brand_id
WHERE
    s.customer_rating <= 2
GROUP BY b.brand_id , b.brand_name
ORDER BY lowrating_count ASC
LIMIT 1;