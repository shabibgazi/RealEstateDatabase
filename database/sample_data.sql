-- 1. Inserting Agents
INSERT INTO Agent (first_name, last_name, email, phone) VALUES
('Sarah', 'Jenkins', 'sarah@realty.com', '555-0101'), -- agent_id = 1
('Mike', 'Ross', 'mike@realty.com', '555-0102'),    -- agent_id = 2
('Rachel', 'Zane', 'rachel@realty.com', '555-0103');-- agent_id = 3

-- 2. Inserting Sellers
INSERT INTO Seller (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john@email.com', '555-0201'),   -- seller_id = 1
('Jane', 'Smith', 'jane@email.com', '555-0202'), -- seller_id = 2
('Bob', 'Brown', 'bob@email.com', '555-0203');   -- seller_id = 3

-- 3. Inserting Buyers
INSERT INTO Buyer (first_name, last_name, email, phone) VALUES
('Alice', 'Johnson', 'alice@email.com', '555-0301'), -- buyer_id = 1
('Charlie', 'Davis', 'charlie@email.com', '555-0302'),-- buyer_id = 2
('Eve', 'White', 'eve@email.com', '555-0303');      -- buyer_id = 3

-- 4. Inserting Properties
-- Note: We are setting listing_date and sale_date to make the 2004 queries work.
INSERT INTO Property (street_address, city, state, zip_code, school_district, listing_price, bedrooms, bathrooms, square_feet, has_pool, listing_date, status, house_image, seller_id, agent_id) VALUES
('123 Main St', 'Bethlehem', 'PA', '18015', 'Bethlehem Area', 225000.00, 3, 2.0, 1500, FALSE, '2004-01-10', 'Sold', NULL, 1, 1), -- property_id = 1 (Perfect for Query A)
('456 Oak Ave', 'Allentown', 'PA', '18101', 'Parkland', 350000.00, 4, 2.5, 2200, FALSE, '2004-02-15', 'Sold', NULL, 2, 2), -- property_id = 2 (Perfect for Query B)
('789 Pine Ln', 'Bethlehem', 'PA', '18018', 'Bethlehem Area', 150000.00, 2, 1.0, 1000, FALSE, '2005-05-20', 'Available', NULL, 3, 3), -- property_id = 3 (Too cheap for Query A)
('101 Lake Dr', 'Easton', 'PA', '18042', 'Easton Area', 500000.00, 5, 3.5, 3000, TRUE, '2004-03-01', 'Sold', NULL, 1, 1), -- property_id = 4 (Very expensive, but has pool so misses Query B)
('202 Hill Rd', 'Allentown', 'PA', '18104', 'Parkland', 275000.00, 4, 2.0, 2000, FALSE, '2004-06-15', 'Available', NULL, 2, 2); -- property_id = 5 (Parkland but slightly over 250k, has no pool)

-- 5. Inserting Sales (Happening in 2004 for Queries C & D)
INSERT INTO Sale (sale_price, sale_date, property_id, buyer_id, selling_agent_id, buyer_agent_id) VALUES
(220000.00, '2004-02-20', 1, 1, 1, NULL),       -- Sale 1: Agent 1 (Sarah) sold Main St. No buyer agent.
(340000.00, '2004-04-10', 2, 2, 2, 3),          -- Sale 2: Agent 2 (Mike) sold Oak Ave. Agent 3 (Rachel) was buyer's agent.
(480000.00, '2004-08-15', 4, 3, 1, NULL);       -- Sale 3: Agent 1 (Sarah) sold Lake Dr (The most expensive house).