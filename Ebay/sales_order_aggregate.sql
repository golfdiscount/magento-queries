# Aggregate of sales throughout the past week
SELECT DATE(created_at) AS "Date",
	COUNT(*) AS "Count",
    FORMAT(SUM(grand_total), 2) AS "Grand Total"
FROM sales_order
WHERE increment_id LIKE "5%"
AND DATE(created_at) > SUBDATE(CURDATE(), INTERVAL 1 WEEK)
GROUP BY DATE(created_at)
ORDER BY DATE(created_at) DESC;
