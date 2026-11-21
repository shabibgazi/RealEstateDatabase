
-- House image setup for the Real Estate Database
-- Run these commands inside psql.
-- Start psql from the RealEstateDatabase folder.

-- Import three images into PostgreSQL
\lo_import 'images/house1.jpg'
\lo_import 'images/house2.jpg'
\lo_import 'images/house3.jpg'

-- PostgreSQL prints an OID after each import.
-- Replace the example numbers below with those OIDs.
-- These are the OIDs from our original test database.

UPDATE Property
SET house_image = 16492
WHERE property_id = 4;

UPDATE Property
SET house_image = 16493
WHERE property_id = 5;

UPDATE Property
SET house_image = 16494
WHERE property_id = 6;

-- Check which properties have images
SELECT property_id, street_address, house_image
FROM Property
WHERE house_image IS NOT NULL
ORDER BY property_id;

-- To display the most expensive house:
-- Export its image using the OID returned by the query above.
-- Example:
-- \lo_export 16492 'images/exported_house.jpg'
