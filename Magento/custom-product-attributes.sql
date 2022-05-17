# Query to pull all custom iron sets and their associated attribute titles

SELECT product.sku AS 'SKU',
	product_varchar.value AS 'Product Name',
    option_title.title AS 'Option Title'
FROM golfdi_mage2.catalog_product_entity AS product
JOIN catalog_product_entity_varchar AS product_varchar ON product_varchar.entity_id = product.entity_id
JOIN catalog_product_option AS product_option ON product_option.product_id = product.entity_id
JOIN catalog_product_option_title AS option_title ON option_title.option_id = product_option.option_id
WHERE product.sku LIKE 'CUSTOM%'
AND product_varchar.attribute_id = ( # Get correct attribute ID for frontend product name
	SELECT attribute_id
	FROM golfdi_mage2.eav_attribute
	WHERE entity_type_id = ( # Get entity type ID for correct attribute matching
		SELECT entity_type_id
        FROM eav_entity_type
        WHERE entity_type_code = 'catalog_product'
    )
	AND frontend_label = 'Product Name'
)
AND product_varchar.value LIKE '%Irons';
