SELECT sales_order.entity_id AS 'id',
	state,
	`status`,
	shipping_description AS 'shipping',
	customer_id,
	billing_address_id,
	FORMAT(sales_order.base_grand_total, 2) AS 'total',
	FORMAT(sales_order.base_shipping_amount, 2) AS 'ship_cost',
	created_at,
	updated_at,
	increment_id AS 'order_number',
	payment.method
FROM sales_order
INNER JOIN m2epro_order ON magento_order_id = sales_order.entity_id
INNER JOIN m2epro_ebay_order ON order_id = m2epro_order.id
JOIN sales_order_payment AS payment ON payment.parent_id = sales_order.entity_id;
