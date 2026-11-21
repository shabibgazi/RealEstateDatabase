import sys
import random
from datetime import date, timedelta

import psycopg2
from faker import Faker

random.seed(42)
Faker.seed(42)
fake = Faker("en_US")

# Additional records needed after our original sample data
TARGETS = {
    "Agent": 10,
    "Buyer": 30,
    "Seller": 30,
    "Property": 50,
    "Sale": 25
}

cities = [
    ("Bethlehem", "18017", "Bethlehem Area"),
    ("Allentown", "18104", "Parkland"),
    ("Easton", "18042", "Easton Area")
]

db_name = sys.argv[1] if len(sys.argv) > 1 else "real_estate_db"

with psycopg2.connect(dbname=db_name) as conn:
    with conn.cursor() as cur:

        # Prevent a second run from inserting duplicates.
        cur.execute("""
            SELECT
                (SELECT COUNT(*) FROM Agent),
                (SELECT COUNT(*) FROM Buyer),
                (SELECT COUNT(*) FROM Seller),
                (SELECT COUNT(*) FROM Property),
                (SELECT COUNT(*) FROM Sale)
        """)
        counts = cur.fetchone()

        if counts != (3, 3, 3, 6, 3):
            print("Database is not in its original state.")
            print("No new data was inserted.")
        else:
            # Add agents, buyers, and sellers
            for table, extra in [
                ("Agent", 7),
                ("Buyer", 27),
                ("Seller", 27)
            ]:
                for _ in range(extra):
                    cur.execute(f"""
                        INSERT INTO {table}
                        (first_name, last_name, email, phone)
                        VALUES (%s, %s, %s, %s)
                    """, (
                        fake.first_name(),
                        fake.last_name(),
                        fake.email(),
                        fake.phone_number()[:20]
                    ))

            # Add 44 properties
            for i in range(44):
                city, zipcode, district = random.choice(cities)
                price = random.randrange(120000, 450001, 5000)
                bedrooms = random.randint(2, 5)
                listing_date = date(2004, 1, 1) + timedelta(
                    days=random.randint(0, 350)
                )

                # First 22 generated properties will be sold
                sold = i < 22
                status = "Sold" if sold else "Available"

                cur.execute("""
                    INSERT INTO Property (
                        street_address, city, state, zip_code,
                        school_district, listing_price, bedrooms,
                        bathrooms, square_feet, has_pool,
                        listing_date, status, seller_id, agent_id
                    )
                    VALUES (
                        %s, %s, %s, %s, %s, %s, %s,
                        %s, %s, %s, %s, %s, %s, %s
                    )
                    RETURNING property_id
                """, (
                    f"{1000 + i} {fake.street_name()}",
                    city, "PA", zipcode, district,
                    price, bedrooms,
                    random.choice([1.0, 1.5, 2.0, 2.5, 3.0]),
                    random.randint(1000, 3500),
                    random.choice([True, False]),
                    listing_date, status,
                    random.randint(1, 30),
                    random.randint(1, 10)
                ))

                property_id = cur.fetchone()[0]

                if sold:
                    sale_date = listing_date + timedelta(
                        days=random.randint(20, 120)
                    )
                    sale_price = price - random.randint(0, 15000)

                    cur.execute("""
                        INSERT INTO Sale (
                            sale_price, sale_date, property_id,
                            buyer_id, selling_agent_id, buyer_agent_id
                        )
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (
                        sale_price, sale_date, property_id,
                        random.randint(1, 30),
                        random.randint(1, 10),
                        random.choice([None, 1, 2, 3])
                    ))

            print("Sample data generated successfully!")

            for table in TARGETS:
                cur.execute(f"SELECT COUNT(*) FROM {table}")
                print(f"{table}: {cur.fetchone()[0]}")
