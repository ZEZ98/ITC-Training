import sqlalchemy as db
import pandas as pd

# Create the database engine
engine = db.create_engine("mysql://root:root@localhost/mydatabase1")

# Connect to the database
with engine.connect() as conn:
    # Insert a row into the "customers" table
    insert_query = db.text("INSERT INTO customers (name, address) VALUES (:name, :address)")
    conn.execute(insert_query, name='TestName', address='TestAddress')
    
    # Retrieve all data from the "customers" table
    select_query = db.text("SELECT * FROM customers")
    result = conn.execute(select_query)
    data = pd.DataFrame(result.fetchall(), columns=result.keys())

# Print the DataFrame
print(data)
