
# Real Estate Database Management System
CSC 4710/6710 - Database Systems

Team Members: Shabib Gazi and Pa Musa Ngom

## 1. Entity-Relationship Diagram

See RealEstate_ER_Diagram.pdf.

## 2. Relational Schema

The database contains five tables: Agent, Buyer,
Seller, Property, and Sale.

The following SQL statements were used to create
the tables, define their relationships, and add
the necessary constraints and indexes.

```sql

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

```

## 3. Table Record Counts

| Table | Records |
|-------|---------|
| Agent | 10 |
| Buyer | 30 |
| Seller | 30 |
| Property | 50 |
| Sale | 25 |

## 4. SQL Queries and Results


### Query (a): Bethlehem Houses

**Question:** Find the addresses of homes for sale in Bethlehem costing between $200,000 and $250,000.

**SQL Query:**

```sql
SELECT street_address
FROM Property
WHERE city = 'Bethlehem'
  AND listing_price BETWEEN 200000 AND 250000
  AND status = 'Available';
```

**Result:**

```text
 street_address
----------------
 303 Maple St
(1 row)
```

### Query (b): Parkland Houses

**Question:** Find the addresses of homes for sale in the Parkland school district with four or more bedrooms and no swimming pool.

**SQL Query:**

```sql
SELECT street_address
FROM Property
WHERE school_district = 'Parkland'
  AND bedrooms >= 4
  AND has_pool = FALSE
  AND status = 'Available';
```

**Result:**

```text
 street_address
--------------------
 1030 Brenda Points
 1035 Bell Ports
 202 Hill Rd
(3 rows)
```



### Query (c): Highest-Selling Agent in 2004

**Question:** Find the agent who sold the most property in 2004 by total dollar value.

**SQL Query:**

```sql
SELECT a.first_name, a.last_name,
       SUM(s.sale_price) AS total_sales
FROM Agent a
JOIN Sale s ON a.agent_id = s.selling_agent_id
WHERE EXTRACT(YEAR FROM s.sale_date) = 2004
GROUP BY a.agent_id, a.first_name, a.last_name
ORDER BY total_sales DESC
LIMIT 1;
```

**Result:**

```text
 first_name | last_name | total_sales
------------+-----------+-------------
 Mike       | Ross      | 1776039.00
(1 row)
```

### Query (d): Agent Sales Averages in 2004

**Question:** For each agent, calculate the average selling price of properties sold in 2004 and the average number of days each property was on the market.

**SQL Query:**

```sql
SELECT a.first_name, a.last_name,
       ROUND(AVG(s.sale_price), 2) AS average_selling_price,
       ROUND(AVG(s.sale_date - p.listing_date), 2)
           AS average_days_on_market
FROM Agent a
LEFT JOIN Sale s
    ON a.agent_id = s.selling_agent_id
    AND EXTRACT(YEAR FROM s.sale_date) = 2004
LEFT JOIN Property p
    ON s.property_id = p.property_id
GROUP BY a.agent_id, a.first_name, a.last_name
ORDER BY a.agent_id;
```

**Result:**

```text
Sarah Jenkins      | 302813.50 | 70.75
Mike Ross          | 355207.80 | 50.80
Rachel Zane        | 199070.00 | 71.00
Danielle Johnson   | 302351.33 | 71.00
Jeffrey Lawrence   | 142332.00 | 96.00
Teresa Gray        | NULL      | NULL
Cynthia Diaz       | 177955.00 | 88.00
Richard Jones      | 360506.00 | 70.00
Wendy Taylor       | 339221.00 | 52.00
Erin Wilson        | 421355.00 | 53.00
(10 rows)
```



### Query (e): Most Expensive House and Picture

**Question:** Show a picture of the most expensive house(s) in the database.

**SQL Query:**

```sql
SELECT property_id, street_address, listing_price, house_image
FROM Property
WHERE listing_price = (
    SELECT MAX(listing_price)
    FROM Property
);
```

**Result:**

```text
 property_id | street_address | listing_price | house_image
-------------+----------------+---------------+------------
 4           | 101 Lake Dr    | 500000.00     | 16660
(1 row)
```

**Display the image:**

```sql
SELECT lo_export(
    house_image,
    '/tmp/most_expensive_house.jpg'
)
FROM Property
WHERE listing_price = (
    SELECT MAX(listing_price)
    FROM Property
);
```

The most expensive property is 101 Lake Dr, listed at $500,000. Its picture is stored in PostgreSQL as a large object and can be retrieved using `lo_export()`.
**Picture of the most expensive house:**

![101 Lake Dr](most_expensive_house.jpg)



### Query (f): Record a Property Sale

**Question:** Record the sale of an available property, including the sale price, buyer, selling agent, buyer's agent (if any), and sale date.

**SQL Query:**

```sql
BEGIN;

INSERT INTO Sale (
    sale_price, sale_date, property_id,
    buyer_id, selling_agent_id, buyer_agent_id
)
VALUES (
    230000, '2005-04-10', 6,
    1, 1, NULL
);

UPDATE Property
SET status = 'Sold'
WHERE property_id = 6;

COMMIT;
```

**Verification Query:**

```sql
SELECT p.property_id, p.street_address,
       p.status, s.sale_price, s.sale_date
FROM Property p
JOIN Sale s ON p.property_id = s.property_id
WHERE p.property_id = 6;
```

**Result:**

```text
 property_id | street_address | status | sale_price | sale_date
-------------+----------------+--------+------------+------------
 6           | 303 Maple St   | Sold   | 230000.00  | 2005-04-10
(1 row)
```

The sale was recorded successfully, and the property's status changed from Available to Sold.

### Query (g): Add a New Agent

**Question:** Add a new agent to the database.

**SQL Query:**

```sql
INSERT INTO Agent (first_name, last_name, email, phone)
VALUES ('Emily', 'Clark', 'emily@example.com', '555-0199')
RETURNING *;
```

**Result:**

```text
 agent_id | first_name | last_name | email             | phone
----------+------------+-----------+-------------------+----------
 11       | Emily      | Clark     | emily@example.com | 555-0199
(1 row)
```

The new agent was successfully added to the database.



## 5. Additional Queries

### Additional Query 1: Average Listing Price by City

**Question:** Find the average listing price of properties in each city.

**SQL Query:**

```sql
SELECT city,
       ROUND(AVG(listing_price), 2) AS average_price
FROM Property
GROUP BY city
ORDER BY city;
```

**Result:**

| City | Average Price |
|---|---:|
| Allentown | 324285.71 |
| Bethlehem | 271578.95 |
| Easton | 307352.94 |

### Additional Query 2: Available Properties by City

**Question:** Find the number of available properties in each city.

**SQL Query:**

```sql
SELECT city, COUNT(*) AS total_properties
FROM Property
WHERE status = 'Available'
GROUP BY city
ORDER BY city;
```

**Result:**

| City | Total Properties |
|---|---:|
| Allentown | 7 |
| Bethlehem | 13 |
| Easton | 5 |

### Additional Query 3: Cheapest Available House

**Question:** Find the cheapest house currently available for sale.

**SQL Query:**

```sql
SELECT street_address, city, listing_price
FROM Property
WHERE status = 'Available'
ORDER BY listing_price ASC
LIMIT 1;
```

**Result:**

| Street Address | City | Listing Price |
|---|---|---:|
| 1036 Eric Orchard | Bethlehem | 135000.00 |


