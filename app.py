from PIL import Image
from io import BytesIO
import customtkinter as ctk
import psycopg2
from tkinter import messagebox

ctk.set_appearance_mode("light")
ctk.set_default_color_theme("blue")


def connect_db():
    return psycopg2.connect(
        dbname="real_estate_db"
    )


class RealEstateApp(ctk.CTk):
    def __init__(self):
        super().__init__()

        self.title("Real Estate Management System")
        self.geometry("950x650")

        title = ctk.CTkLabel(
            self,
            text="Real Estate Management System",
            font=("Arial", 26, "bold")
        )
        title.pack(pady=20)

        buttons = ctk.CTkFrame(self)
        buttons.pack(pady=10)

        ctk.CTkButton(
            buttons, text="View Properties",
            command=self.view_properties
        ).pack(side="left", padx=5)

        ctk.CTkButton(
            buttons, text="Search Houses",
            command=self.search_properties
        ).pack(side="left", padx=5)

        ctk.CTkButton(
            buttons, text="Add Agent",
            command=self.add_agent
        ).pack(side="left", padx=5)

        ctk.CTkButton(
            buttons, text="Record Sale",
            command=self.record_sale
        ).pack(side="left", padx=5)

        self.content = ctk.CTkScrollableFrame(
            self, width=850, height=450
        )
        self.content.pack(pady=15, fill="both", expand=True)

        self.view_properties()

    def clear_content(self):
        for widget in self.content.winfo_children():
            widget.destroy()

    def show_properties(self, rows):
        if not rows:
            ctk.CTkLabel(
                self.content, text="No properties found."
            ).pack(pady=15)
            return

        for row in rows:
            property_id, address, city, price, beds, status = row

            frame = ctk.CTkFrame(self.content)
            frame.pack(fill="x", padx=15, pady=8)

            text = (
                f"ID: {property_id} | {address}, {city}\n"
                f"Price: ${price:,.2f} | "
                f"Bedrooms: {beds} | Status: {status}"
            )

            ctk.CTkLabel(
                frame,
                text=text,
                font=("Arial", 14),
                justify="left"
            ).pack(side="left", padx=15, pady=10)

            ctk.CTkButton(
                frame,
                text="View Image",
                width=110,
                command=lambda pid=property_id: self.view_image(pid)
            ).pack(side="right", padx=15)

    def view_image(self, property_id):
        try:
            with connect_db() as conn:
                with conn.cursor() as cur:
                    cur.execute("""
                        SELECT street_address, house_image
                        FROM Property
                        WHERE property_id = %s
                    """, (property_id,))

                    row = cur.fetchone()

                    if not row or row[1] is None:
                        messagebox.showinfo(
                            "No Image",
                            "No image is available for this property."
                        )
                        return

                    address, image_oid = row

                    image_data = conn.lobject(image_oid, "rb").read()

            image = Image.open(BytesIO(image_data))
            image.thumbnail((650, 450))

            window = ctk.CTkToplevel(self)
            window.title(address)
            window.geometry("700x550")

            photo = ctk.CTkImage(
                light_image=image,
                dark_image=image,
                size=image.size
            )

            label = ctk.CTkLabel(
                window,
                text=address,
                image=photo,
                compound="top",
                font=("Arial", 18, "bold")
            )
            label.pack(pady=20)

            window.image = photo

        except Exception as e:
            messagebox.showerror("Image Error", str(e))



    def view_properties(self):
        self.clear_content()

        try:
            with connect_db() as conn:
                with conn.cursor() as cur:
                    cur.execute("""
                        SELECT property_id, street_address, city,
                               listing_price, bedrooms, status
                        FROM Property
                        ORDER BY property_id
                    """)
                    rows = cur.fetchall()

            self.show_properties(rows)

        except Exception as e:
            messagebox.showerror("Database Error", str(e))

    def search_properties(self):
        self.clear_content()

        ctk.CTkLabel(
            self.content,
            text="Search Available Houses",
            font=("Arial", 20, "bold")
        ).pack(pady=10)

        city_entry = ctk.CTkEntry(
            self.content, placeholder_text="City"
        )
        city_entry.pack(pady=5)

        min_entry = ctk.CTkEntry(
            self.content, placeholder_text="Minimum Price"
        )
        min_entry.pack(pady=5)

        max_entry = ctk.CTkEntry(
            self.content, placeholder_text="Maximum Price"
        )
        max_entry.pack(pady=5)

        results = ctk.CTkFrame(self.content)
        results.pack(pady=15, fill="x")

        def search():
            for widget in results.winfo_children():
                widget.destroy()

            try:
                city = city_entry.get().strip()
                min_price = float(min_entry.get()) if min_entry.get() else 0
                max_price = float(max_entry.get()) if max_entry.get() else 999999999

                with connect_db() as conn:
                    with conn.cursor() as cur:
                        cur.execute("""
                            SELECT property_id, street_address, city,
                                   listing_price, bedrooms, status
                            FROM Property
                            WHERE status = 'Available'
                              AND city ILIKE %s
                              AND listing_price BETWEEN %s AND %s
                            ORDER BY listing_price
                        """, (f"%{city}%", min_price, max_price))
                        rows = cur.fetchall()

                if not rows:
                    ctk.CTkLabel(
                        results, text="No properties found."
                    ).pack(pady=10)

                for row in rows:
                    pid, address, city, price, beds, status = row
                    ctk.CTkLabel(
                        results,
                        text=f"{address}, {city} - ${price:,.2f} - {beds} bedrooms",
                        anchor="w"
                    ).pack(pady=5, padx=10, fill="x")

            except ValueError:
                messagebox.showerror(
                    "Input Error", "Please enter valid prices."
                )
            except Exception as e:
                messagebox.showerror("Database Error", str(e))

        ctk.CTkButton(
            self.content, text="Search", command=search
        ).pack(pady=10)

    def add_agent(self):
        self.clear_content()

        ctk.CTkLabel(
            self.content, text="Add New Agent",
            font=("Arial", 20, "bold")
        ).pack(pady=10)

        entries = {}

        for field in ["First Name", "Last Name", "Email", "Phone"]:
            entry = ctk.CTkEntry(
                self.content, placeholder_text=field, width=300
            )
            entry.pack(pady=7)
            entries[field] = entry

        def save_agent():
            first = entries["First Name"].get().strip()
            last = entries["Last Name"].get().strip()
            email = entries["Email"].get().strip()
            phone = entries["Phone"].get().strip()

            if not first or not last:
                messagebox.showerror(
                    "Input Error", "First and last name are required."
                )
                return

            try:
                with connect_db() as conn:
                    with conn.cursor() as cur:
                        cur.execute("""
                            INSERT INTO Agent (
                                first_name, last_name, email, phone
                            )
                            VALUES (%s, %s, %s, %s)
                        """, (first, last, email or None, phone or None))

                messagebox.showinfo(
                    "Success", "Agent added successfully."
                )
                self.view_properties()

            except Exception as e:
                messagebox.showerror("Database Error", str(e))

        ctk.CTkButton(
            self.content, text="Save Agent", command=save_agent
        ).pack(pady=15)

    def record_sale(self):
        self.clear_content()

        ctk.CTkLabel(
            self.content, text="Record Property Sale",
            font=("Arial", 20, "bold")
        ).pack(pady=10)

        fields = [
            "Property ID", "Buyer ID", "Selling Agent ID",
            "Buyer Agent ID (optional)", "Sale Price",
            "Sale Date (YYYY-MM-DD)"
        ]

        entries = {}

        for field in fields:
            entry = ctk.CTkEntry(
                self.content, placeholder_text=field, width=320
            )
            entry.pack(pady=6)
            entries[field] = entry

        def save_sale():
            try:
                property_id = int(entries["Property ID"].get())
                buyer_id = int(entries["Buyer ID"].get())
                agent_id = int(entries["Selling Agent ID"].get())

                buyer_agent = entries[
                    "Buyer Agent ID (optional)"
                ].get().strip()

                buyer_agent_id = (
                    int(buyer_agent) if buyer_agent else None
                )

                price = float(entries["Sale Price"].get())
                sale_date = entries[
                    "Sale Date (YYYY-MM-DD)"
                ].get().strip()

                if price <= 0:
                    raise ValueError("Sale price must be positive.")

                with connect_db() as conn:
                    with conn.cursor() as cur:
                        cur.execute("""
                            SELECT status
                            FROM Property
                            WHERE property_id = %s
                            FOR UPDATE
                        """, (property_id,))

                        property_row = cur.fetchone()

                        if not property_row:
                            raise ValueError("Property does not exist.")

                        if property_row[0] != "Available":
                            raise ValueError("Property is not available.")

                        cur.execute("""
                            INSERT INTO Sale (
                                sale_price, sale_date, property_id,
                                buyer_id, selling_agent_id, buyer_agent_id
                            )
                            VALUES (%s, %s, %s, %s, %s, %s)
                        """, (
                            price, sale_date, property_id,
                            buyer_id, agent_id, buyer_agent_id
                        ))

                        cur.execute("""
                            UPDATE Property
                            SET status = 'Sold'
                            WHERE property_id = %s
                        """, (property_id,))

                messagebox.showinfo(
                    "Success", "Sale recorded successfully."
                )
                self.view_properties()

            except (ValueError, TypeError) as e:
                messagebox.showerror("Input Error", str(e))
            except Exception as e:
                messagebox.showerror("Database Error", str(e))

        ctk.CTkButton(
            self.content, text="Save Sale", command=save_sale
        ).pack(pady=15)


if __name__ == "__main__":
    app = RealEstateApp()
    app.mainloop()
