
-- Query (a): Available houses in Bethlehem priced between $200,000 and $250,000

SELECT street_address
FROM Property
WHERE city = 'Bethlehem'
    AND listing_price BETWEEN 200000 AND 250000
    AND status = 'Available';


-- Query (b): Available houses in Parkland with at least 4 bedrooms and no pool

SELECT street_address
FROM Property
WHERE school_district = 'Parkland'
    AND bedrooms >= 4
    AND has_pool = FALSE
    AND status = 'Available';


-- Query (c): Agent with the highest total dollar sales in 2004

WITH agent_totals AS (
    SELECT a.agent_id, a.first_name, a.last_name,
           SUM(s.sale_price) AS total_sales
    FROM Agent a
    JOIN Sale s ON a.agent_id = s.selling_agent_id
    WHERE s.sale_date >= '2004-01-01'
      AND s.sale_date < '2005-01-01'
    GROUP BY a.agent_id, a.first_name, a.last_name
)
SELECT first_name, last_name, total_sales
FROM agent_totals
WHERE total_sales = (
    SELECT MAX(total_sales)
    FROM agent_totals
);


-- Query (d): Average selling price and days on market for each agent in 2004

SELECT a.first_name, a.last_name,
       ROUND(AVG(s.sale_price), 2) AS average_selling_price,
       ROUND(AVG(s.sale_date - p.listing_date), 2) AS average_days_on_market
FROM Agent a
LEFT JOIN Sale s
    ON a.agent_id = s.selling_agent_id
    AND s.sale_date >= '2004-01-01'
    AND s.sale_date < '2005-01-01'
LEFT JOIN Property p
    ON s.property_id = p.property_id
GROUP BY a.agent_id, a.first_name, a.last_name
ORDER BY a.agent_id;


-- Query (e): Most expensive house and its image reference

SELECT property_id, street_address, listing_price, house_image
FROM Property
WHERE listing_price = (
    SELECT MAX(listing_price)
    FROM Property
);



-- Query (f): Record the sale of an available property
-- Example: Property 5 is sold for $270,000

BEGIN;

DO $$
BEGIN
    -- Check whether the property is available
    PERFORM 1
    FROM Property
    WHERE property_id = 5 AND status = 'Available'
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Property is not available for sale';
    END IF;

    -- Record the sale
    INSERT INTO Sale (
        sale_price, sale_date, property_id,
        buyer_id, selling_agent_id, buyer_agent_id
    )
    VALUES (270000, '2005-09-10', 5, 1, 2, NULL);

    -- Mark the property as sold
    UPDATE Property
    SET status = 'Sold'
    WHERE property_id = 5;
END $$;

COMMIT;



-- Additional Query 1: Average listing price by city

SELECT city, AVG(listing_price) AS average_price
FROM Property
GROUP BY city;


-- Additional Query 2: Number of available properties by city

SELECT city, COUNT(*) AS total_properties
FROM Property
WHERE status = 'Available'
GROUP BY city;


-- Additional Query 3: Cheapest available property

SELECT street_address, city, listing_price
FROM Property
WHERE status = 'Available'
ORDER BY listing_price
LIMIT 1;


-- Count records in each table

SELECT 'Agent' AS table_name, COUNT(*) FROM Agent
UNION ALL
SELECT 'Buyer', COUNT(*) FROM Buyer
UNION ALL
SELECT 'Seller', COUNT(*) FROM Seller
UNION ALL
SELECT 'Property', COUNT(*) FROM Property
UNION ALL
SELECT 'Sale', COUNT(*) FROM Sale;
