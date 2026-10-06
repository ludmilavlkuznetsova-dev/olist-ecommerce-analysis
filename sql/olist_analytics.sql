/*кол-во строк order_items*/
SELECT COUNT(*)
FROM olist.order_items;

/*кол-во строк dataset*/
SELECT COUNT(*) 
FROM (
	WITH avg_score AS (
	SELECT
		order_id,
		ROUND(AVG(review_score),2) AS avg_review_score
	FROM olist.order_reviews
	GROUP BY order_id
)
SELECT
	oi.order_id,
    oi.product_id,
    ct.product_category_name_english,
    oi.seller_id,
    REPLACE(s.seller_state, '\r', '') AS seller_state,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    oi.price,
    oi.freight_value,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    avg_review_score
FROM olist.order_items oi
LEFT JOIN olist.orders o 
	ON oi.order_id = o.order_id
LEFT JOIN olist.products p
	ON p.product_id = oi.product_id
LEFT JOIN olist.category_translation ct
	ON p.product_category_name = ct.product_category_name
LEFT JOIN olist.sellers s
	ON s.seller_id = oi.seller_id
LEFT JOIN olist.customers c
	ON c.customer_id = o.customer_id
LEFT JOIN avg_score
	ON avg_score.order_id = oi.order_id
) AS dataset;
    
/*проверка на NULL (все ли соответствия найдены в присоед-х таблицах*/
WITH avg_score AS (
	SELECT
		order_id,
		ROUND(AVG(review_score),2) AS avg_review_score
	FROM olist.order_reviews
	GROUP BY order_id
)
SELECT
	COUNT(*) AS total_rows,
    SUM(o.order_id IS NULL) AS missing_orders,
    SUM(p.product_id IS NULL) AS missing_products,
    SUM(s.seller_id IS NULL) AS missing_sellers,
    SUM(c.customer_id IS NULL) AS missing_customers,
    SUM(avg_score.order_id IS NULL) AS missing_scores
FROM olist.order_items oi
LEFT JOIN olist.orders o 
	ON oi.order_id = o.order_id
LEFT JOIN olist.products p
	ON p.product_id = oi.product_id
LEFT JOIN olist.sellers s
	ON s.seller_id = oi.seller_id
LEFT JOIN olist.customers c
	ON c.customer_id = o.customer_id
LEFT JOIN avg_score
	ON avg_score.order_id = oi.order_id;

/*собираем dataset*/
WITH avg_score AS (
	SELECT
		order_id,
		ROUND(AVG(review_score),2) AS avg_review_score
	FROM olist.order_reviews
	GROUP BY order_id
)
SELECT
	oi.order_id,
    oi.product_id,
    ct.product_category_name_english,
    oi.seller_id,
    REPLACE(s.seller_state, '\r', '') AS seller_state,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    oi.price,
    oi.freight_value,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    avg_review_score
FROM olist.order_items oi
LEFT JOIN olist.orders o 
	ON oi.order_id = o.order_id
LEFT JOIN olist.products p
	ON p.product_id = oi.product_id
LEFT JOIN olist.category_translation ct
	ON p.product_category_name = ct.product_category_name
LEFT JOIN olist.sellers s
	ON s.seller_id = oi.seller_id
LEFT JOIN olist.customers c
	ON c.customer_id = o.customer_id
LEFT JOIN avg_score
	ON avg_score.order_id = oi.order_id;