# Aggregate of sales orders throughout the past week for all sales channels
SELECT DATE(created_at) AS "Date",
	COUNT(*) AS "Count",
    FORMAT(SUM(grand_total), 2) AS "Grand Total"
FROM sales_order
WHERE DATE(created_at) > SUBDATE(CURDATE(), INTERVAL 1 WEEK)
GROUP BY DATE(created_at)
ORDER BY DATE(created_at) DESC;
