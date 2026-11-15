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