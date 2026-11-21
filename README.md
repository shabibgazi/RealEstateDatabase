# Real Estate Database Management System

**Course:** CSC 4710/6710 – Database Systems  
**Team Members:** Shabib Gazi and Pa Musa Ngom

## Project Overview

This project is a Real Estate Database Management System built using PostgreSQL and Python. It stores information about properties, agents, buyers, sellers, and completed sales.

The system allows users to search for available properties, view property information, add new agents, and record property sales. A Python GUI was developed using CustomTkinter to make it easier to interact with the database.

## Technologies Used

- PostgreSQL – Database management
- Python – Application development
- CustomTkinter – Graphical user interface
- psycopg2 – PostgreSQL connection
- Pillow – Displaying property images

## Database Design

The database contains five tables:

1. **Agent:** Stores real estate agent information.
2. **Buyer:** Stores buyer information.
3. **Seller:** Stores seller information.
4. **Property:** Stores property details, prices, availability, and image references.
5. **Sale:** Stores completed property transactions.

Primary keys and foreign keys are used to connect the tables and maintain data integrity.

## Features

- View all properties and their availability
- Search available properties by city and price range
- View property images stored as PostgreSQL large objects
- Add new real estate agents
- Record property sales and update property availability
- Run SQL queries to analyze property sales and agent performance

## Project Structure

```text
RealEstateDatabase/
├── app.py
├── database/
│   ├── schema.sql
│   ├── sample_data.sql
│   ├── queries.sql
│   └── load_images.py
├── images/
│   ├── house1.jpg
│   ├── house2.jpg
│   └── house3.jpg
├── docs/
│   └── query_results.txt
└── README.md
```

## How to Run

### 1. Create the database

```bash
createdb real_estate_db
psql -d real_estate_db -f database/schema.sql
psql -d real_estate_db -f database/sample_data.sql
```

Use a fresh database when loading the sample data.


### 2. Import property images

After creating the database and loading the sample data, run:

```bash
python database/load_images.py
```

This script imports three property images into PostgreSQL as large objects and updates the corresponding properties with their image OIDs.

If the images have already been imported, the script skips them.


### 3. Install Python dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install customtkinter psycopg2-binary pillow
```

Python must have working Tkinter support.

### 4. Run the GUI

```bash
python app.py
```

The application connects to the local PostgreSQL database named `real_estate_db`. PostgreSQL must be running, and the current database user must have permission to access it.

## SQL Queries

The project includes the following required database operations:

- (a) Find available houses in Bethlehem priced between $200,000 and $250,000.
- (b) Find available houses in the Parkland school district with at least four bedrooms and no pool.
- (c) Find the agent with the highest total dollar sales in 2004.
- (d) Calculate each agent's average selling price and average days on the market in 2004.
- (e) Retrieve the most expensive house and its image.
- (f) Record the sale of an available property.
- (g) Add a new agent.

Additional queries calculate average property prices by city, count available properties, and find the cheapest available house.

## Testing

The database was tested using PostgreSQL with sample records.

All five tables were created successfully, and the required SQL queries returned the expected results. The GUI was also tested for property searches, adding agents, recording sales, and viewing images.

The SQL query outputs are saved in `docs/query_results.txt`.

## Conclusion

This project demonstrates how a relational database can be used to manage real estate information. PostgreSQL handles data storage and relationships, while the Python GUI provides a simple interface for searching properties and managing transactions.