-- Asces Sound Product Analytics — source query
-- Joins Product_data + Product_sales, computes revenue/cost,
-- then joins discount_data to derive discounted revenue and profit.

WITH cte AS (
    SELECT
        a.Product,
        a.Category,
        a.Brand,
        a.Cost_Price,
        a.Sale_Price,
        a.Description,
        a.Image_url,
        DATEFROMPARTS(YEAR(b.Date), MONTH(b.Date), DAY(b.Date)) AS CorrectDate,
        b.country,
        b.customer_type,
        b.discount_band,
        b.Units_sold,
        (Sale_Price * Units_Sold)          AS revenue,
        (Cost_Price * Units_Sold)          AS Total_cost,
        FORMAT(b.Date, 'MMMM')             AS month,
        FORMAT(b.Date, 'yyyy')             AS Year
    FROM Product_data a
    JOIN Product_sales b
        ON a.Product_ID = b.Product
)
SELECT *,
    (1 - Discount * 1.0 / 100) * revenue                               AS discount_revenue,
    ((1 - Discount * 1.0 / 100) * revenue) - Total_cost                AS Profit
FROM cte c
JOIN discount_data d
    ON c.discount_band = d.discount_band
   AND c.month = d.month;
