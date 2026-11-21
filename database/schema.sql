
CREATE TABLE IF NOT EXISTS Agent (
    agent_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Buyer (
    buyer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Seller (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Property (
    property_id SERIAL PRIMARY KEY,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(20),
    school_district VARCHAR(100),
    listing_price NUMERIC(12, 2) NOT NULL CHECK (listing_price > 0),
    bedrooms INT NOT NULL CHECK (bedrooms >= 0),
    bathrooms NUMERIC(3, 1) CHECK (bathrooms >= 0),
    square_feet INT CHECK (square_feet > 0),
    has_pool BOOLEAN NOT NULL DEFAULT FALSE,
    listing_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Available'
        CHECK (status IN ('Available', 'Sold')),
    house_image OID,
    seller_id INT NOT NULL REFERENCES Seller(seller_id),
    agent_id INT NOT NULL REFERENCES Agent(agent_id)
);

CREATE TABLE IF NOT EXISTS Sale (
    sale_id SERIAL PRIMARY KEY,
    sale_price NUMERIC(12, 2) NOT NULL CHECK (sale_price > 0),
    sale_date DATE NOT NULL,
    property_id INT NOT NULL UNIQUE REFERENCES Property(property_id),
    buyer_id INT NOT NULL REFERENCES Buyer(buyer_id),
    selling_agent_id INT NOT NULL REFERENCES Agent(agent_id),
    buyer_agent_id INT REFERENCES Agent(agent_id)
);

CREATE INDEX IF NOT EXISTS idx_property_city_price_status
ON Property(city, listing_price, status);

CREATE INDEX IF NOT EXISTS idx_property_district_bedrooms
ON Property(school_district, bedrooms);

CREATE INDEX IF NOT EXISTS idx_sale_date
ON Sale(sale_date);
