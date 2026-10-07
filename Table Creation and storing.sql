---Table Basic Structure Creation

CREATE TABLE pizza_sales (
    pizza_id FLOAT,
    order_id FLOAT,
    pizza_name_id TEXT,
    quantity FLOAT,
    order_date TEXT,
    order_time TEXT,
    unit_price FLOAT,
    total_price FLOAT,
    pizza_size TEXT,
    pizza_category TEXT,
    pizza_ingredients TEXT,
    pizza_name TEXT
);

---Checking Table after inserting data by Importing CSV directly from Source
SELECT * FROM pizza_sales
