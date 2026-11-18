
-- Sample agents
INSERT INTO Agent (first_name, last_name, email, phone) VALUES
('Sarah', 'Jenkins', 'sarah@realty.com', '555-0101'),
('Mike', 'Ross', 'mike@realty.com', '555-0102'),
('Rachel', 'Zane', 'rachel@realty.com', '555-0103');

-- Sample sellers
INSERT INTO Seller (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john@email.com', '555-0201'),
('Jane', 'Smith', 'jane@email.com', '555-0202'),
('Bob', 'Brown', 'bob@email.com', '555-0203');

-- Sample buyers
INSERT INTO Buyer (first_name, last_name, email, phone) VALUES
('Alice', 'Johnson', 'alice@email.com', '555-0301'),
('Charlie', 'Davis', 'charlie@email.com', '555-0302'),
('Eve', 'White', 'eve@email.com', '555-0303');

-- Sample properties
INSERT INTO Property (
    street_address, city, state, zip_code,
    school_district, listing_price, bedrooms,
    bathrooms, square_feet, has_pool,
    listing_date, status, house_image,
    seller_id, agent_id
) VALUES
('123 Main St', 'Bethlehem', 'PA', '18015',
 'Bethlehem Area', 225000, 3, 2.0, 1500,
 FALSE, '2004-01-10', 'Sold', NULL, 1, 1),

('456 Oak Ave', 'Allentown', 'PA', '18101',
 'Parkland', 350000, 4, 2.5, 2200,
 FALSE, '2004-02-15', 'Sold', NULL, 2, 2),

('789 Pine Ln', 'Bethlehem', 'PA', '18018',
 'Bethlehem Area', 150000, 2, 1.0, 1000,
 FALSE, '2005-05-20', 'Available', NULL, 3, 3),

('101 Lake Dr', 'Easton', 'PA', '18042',
 'Easton Area', 500000, 5, 3.5, 3000,
 TRUE, '2004-03-01', 'Sold', NULL, 1, 1),

('202 Hill Rd', 'Allentown', 'PA', '18104',
 'Parkland', 275000, 4, 2.0, 2000,
 FALSE, '2004-06-15', 'Available', NULL, 2, 2),

('303 Maple St', 'Bethlehem', 'PA', '18017',
 'Bethlehem Area', 235000, 3, 2.0, 1700,
 FALSE, '2005-03-12', 'Available', NULL, 3, 1);

-- Sample sales from 2004
INSERT INTO Sale (
    sale_price, sale_date, property_id,
    buyer_id, selling_agent_id, buyer_agent_id
) VALUES
(220000, '2004-02-20', 1, 1, 1, NULL),
(340000, '2004-04-10', 2, 2, 2, 3),
(480000, '2004-08-15', 4, 3, 1, NULL);
