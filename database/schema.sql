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
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    school_district VARCHAR(100),
    listing_price NUMERIC(12, 2),
    bedrooms INT,
    bathrooms NUMERIC(3, 1),
    square_feet INT,
    has_pool BOOLEAN,
    listing_date DATE,
    status VARCHAR(50),
    house_image OID,
    seller_id INT,
    agent_id INT,
    FOREIGN KEY (seller_id) REFERENCES Seller(seller_id),
    FOREIGN KEY (agent_id) REFERENCES Agent(agent_id)
);

CREATE TABLE IF NOT EXISTS Sale (
    sale_id SERIAL PRIMARY KEY,
    sale_price NUMERIC(12, 2),
    sale_date DATE,
    property_id INT UNIQUE, 
    buyer_id INT,
    selling_agent_id INT,
    buyer_agent_id INT,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (buyer_id) REFERENCES Buyer(buyer_id),
    FOREIGN KEY (selling_agent_id) REFERENCES Agent(agent_id),
    FOREIGN KEY (buyer_agent_id) REFERENCES Agent(agent_id)
);