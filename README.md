
## How to Run

### 1. Install Python dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install customtkinter psycopg2-binary pillow faker
```

Python must have working Tkinter support.

### 2. Create the database

```bash
createdb real_estate_db
psql -d real_estate_db -f database/schema.sql
```

### 3. Load sample data

```bash
psql -d real_estate_db -f database/sample_data.sql
python database/generate_data.py real_estate_db
```

The data generator uses a fixed random seed, so it produces the same dataset when run on a fresh database.

### 4. Import house images

```bash
python database/load_images.py real_estate_db
```

This imports images for three properties into PostgreSQL as large objects.

### 5. Run SQL queries

```bash
psql -d real_estate_db -f database/queries.sql
```

### 6. Run the GUI

```bash
python app.py
```

PostgreSQL must be running, and your database user must have permission to access the database.
