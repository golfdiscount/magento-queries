-- Gets the top 10 products by sales amount for the past 7 days
SELECT top_skus.`SKU`,
	product_varchar.`value` AS `Product Name`,
    top_skus.`total` AS `$ Total`,
    top_skus.`units` AS `Units Ordered`
FROM (SELECT sales_order_item.`sku` AS `SKU`,
		FORMAT(SUM(sales_order_item.`row_total`), 2) AS `total`,
		FORMAT(SUM(sales_order_item.`qty_ordered`), 0) AS `units`
	FROM sales_order
	JOIN sales_order_item ON sales_order_item.order_id = sales_order.entity_id
	WHERE increment_id LIKE '%%%-%'
		AND DATE(sales_order.`created_at`) >= SUBDATE(CURDATE(), INTERVAL 1 WEEK)
		AND DATE(sales_order.`created_at`) < DATE(CURDATE())
	GROUP BY sales_order_item.`sku`
	ORDER BY COUNT(*) DESC
	LIMIT 10) AS top_skus
JOIN catalog_product_entity AS product ON product.sku = top_skus.sku
JOIN catalog_product_entity_varchar AS product_varchar ON product_varchar.entity_id = product.entity_id
WHERE product_varchar.attribute_id = (SELECT attribute_id
    FROM eav_attribute
    WHERE eav_attribute.attribute_code = "name"
    	AND  eav_attribute.entity_type_id = (SELECT entity_type_id
			FROM eav_entity_type
		    WHERE entity_type_code = "catalog_product"));
