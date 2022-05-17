SELECT product.sku,
	FORMAT(inventory.qty, 0) AS "quantity",
    reservation.reserved
FROM catalog_product_entity AS product
JOIN cataloginventory_stock_status AS inventory ON inventory.product_id = product.entity_id
RIGHT JOIN (
	SELECT product.sku,
		SUM(FORMAT(reservation.quantity, 0) * -1) AS "reserved"
	FROM catalog_product_entity AS product
	JOIN inventory_reservation AS reservation ON reservation.sku = product.sku
	GROUP BY product.sku
) AS reservation ON reservation.sku = product.sku;