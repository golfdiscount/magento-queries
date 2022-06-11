-- Gets the top 10 products by quantity ordered in the past 7 days
SELECT top_skus.sku AS "SKU",
	product_varchar.`value` AS "Product Name",
	top_skus.`units` AS "Units Ordered"
FROM (SELECT sku, FORMAT(SUM(qty_ordered), 0) AS "units"
	FROM sales_order_item
	WHERE DATE(created_at) >= SUBDATE(DATE(CURDATE()), INTERVAL 1 WEEK)
		AND DATE(created_at) < DATE(CURDATE())
	GROUP BY sku
	ORDER BY SUM(qty_ordered) DESC
	LIMIT 10) AS top_skus
JOIN catalog_product_entity AS product ON product.sku = top_skus.sku
JOIN catalog_product_entity_varchar AS product_varchar ON product_varchar.entity_id = product.entity_id
WHERE product_varchar.attribute_id = (SELECT attribute_id
    FROM eav_attribute
    WHERE eav_attribute.attribute_code = "name"
    AND  eav_attribute.entity_type_id = (SELECT entity_type_id
	FROM eav_entity_type
    WHERE entity_type_code = "catalog_product"));
