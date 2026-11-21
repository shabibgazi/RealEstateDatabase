import sys
from pathlib import Path
import psycopg2

db_name = sys.argv[1] if len(sys.argv) > 1 else "real_estate_db"
images_folder = Path(__file__).resolve().parent.parent / "images"

images = {
    4: "house1.jpg",
    5: "house2.jpg",
    6: "house3.jpg"
}

with psycopg2.connect(dbname=db_name) as conn:
    with conn.cursor() as cur:
        for property_id, filename in images.items():
            cur.execute(
                "SELECT house_image FROM Property WHERE property_id = %s",
                (property_id,)
            )
            row = cur.fetchone()

            if row is None:
                print("Property not found:", property_id)
                continue

            if row[0] is not None:
                print("Image already exists for property", property_id)
                continue

            image_path = images_folder / filename

            image = conn.lobject(0, "wb")
            image.write(image_path.read_bytes())
            image_oid = image.oid
            image.close()

            cur.execute(
                "UPDATE Property SET house_image = %s WHERE property_id = %s",
                (image_oid, property_id)
            )

            print("Imported", filename, "with OID", image_oid)

print("Image setup complete.")
