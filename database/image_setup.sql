
-- Import images using PostgreSQL large objects.
-- Run these commands in psql after placing images on your computer.

-- Replace the paths with the actual locations of your images.

-- \lo_import '/absolute/path/to/most_expensive.jpg'
-- \lo_import '/absolute/path/to/house2.jpg'
-- \lo_import '/absolute/path/to/house3.jpg'

-- PostgreSQL will return an OID for each imported image.
-- Replace the example OIDs below with the actual values.

-- UPDATE Property
-- SET house_image = 11111
-- WHERE property_id = 4;

-- UPDATE Property
-- SET house_image = 22222
-- WHERE property_id = 5;

-- UPDATE Property
-- SET house_image = 33333
-- WHERE property_id = 6;

-- Export the most expensive house image to display it.

-- \lo_export 11111 '/absolute/path/to/exported_house.jpg'
