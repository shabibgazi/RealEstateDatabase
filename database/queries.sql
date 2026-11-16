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

    
-- Query (c): Agent who sold the most property in 2004 by total dollar value
SELECT a.first_name, a.last_name, SUM(s.sale_price) AS total_sales_value
FROM Agent a
JOIN Sale s ON a.agent_id = s.selling_agent_id
WHERE EXTRACT(YEAR FROM s.sale_date) = 2004
GROUP BY a.agent_id, a.first_name, a.last_name
ORDER BY total_sales_value DESC
LIMIT 1;


-- Query (d): For each agent, average selling price and average time on market in 2004
SELECT 
    a.first_name, 
    a.last_name, 
    AVG(s.sale_price) AS avg_selling_price,
    AVG(s.sale_date - p.listing_date) AS avg_days_on_market
FROM Agent a
JOIN Sale s ON a.agent_id = s.selling_agent_id
JOIN Property p ON s.property_id = p.property_id
WHERE EXTRACT(YEAR FROM s.sale_date) = 2004
GROUP BY a.agent_id, a.first_name, a.last_name;


-- Query (e): Retrieve the image reference of the most expensive house(s)

SELECT street_address, listing_price, house_image
FROM Property
WHERE listing_price = (
    SELECT MAX(listing_price)
    FROM Property
);


-- Additional query: Find the average listing price in each city

SELECT city, AVG(listing_price) AS average_price
FROM Property
GROUP BY city;


-- Additional query: Count available properties in each city

SELECT city, COUNT(*) AS total_properties
FROM Property
WHERE status = 'Available'
GROUP BY city;


-- Additional query: Find the cheapest available property

SELECT street_address, city, listing_price
FROM Property
WHERE status = 'Available'
ORDER BY listing_price ASC
LIMIT 1;