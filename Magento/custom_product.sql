# This query lists any custom products that are:
# - Irons
# - Wedges
# - Have an option type of 'checkbox'
# - Have a fixed price type

SELECT product.sku AS 'SKU',
	product_varchar.value AS 'Product Name',
    option_title.title AS 'Option Title',
    option_type_title.title AS 'Option Value'
FROM golfdi_mage2.catalog_product_entity AS product
JOIN catalog_product_entity_varchar AS product_varchar ON product_varchar.entity_id = product.entity_id
JOIN catalog_product_entity_int AS product_int ON product_int.entity_id = product.entity_id
JOIN catalog_product_option AS product_option ON product_option.product_id = product.entity_id
JOIN catalog_product_option_title AS option_title ON option_title.option_id = product_option.option_id
JOIN catalog_product_option_type_value AS option_value ON option_value.option_id = product_option.option_id
JOIN catalog_product_option_type_title AS option_type_title ON option_type_title.option_type_id = option_value.option_type_id
JOIN catalog_product_option_type_price AS option_price ON option_price.option_type_id = option_value.option_type_id
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
AND product_int.attribute_id = ( # Get correct attribute ID for "status"
	SELECT attribute_id
	FROM golfdi_mage2.eav_attribute
	WHERE attribute_code = 'status'
)
AND product_int.value = 1 # Status of 1 indicates product is enabled
AND (product_varchar.value LIKE '%Irons' OR product_varchar.value LIKE'%Wedge')
AND product_option.type = 'checkbox'
AND option_price.price_type = 'fixed';
