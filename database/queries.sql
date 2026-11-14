-- Query 1: Available houses in Bethlehem priced between $200,000 and $250,000

SELECT street_address
FROM Property
WHERE city = 'Bethlehem'
    AND listing_price BETWEEN 200000 AND 250000
    AND status = 'Available';


-- Query 2: Available houses in Parkland with at least 4 bedrooms and no pool

SELECT *
FROM Property
WHERE school_district = 'Parkland'
    AND bedrooms >= 4
    AND has_pool = FALSE
    AND status = 'Available';


-- Query 3: Retrieve the image reference of the most expensive house(s)

SELECT street_address, listing_price, house_image
FROM Property
WHERE listing_price = (
    SELECT MAX(listing_price)
    FROM Property
);