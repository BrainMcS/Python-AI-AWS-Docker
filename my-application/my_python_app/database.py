from psycopg2.pool import SimpleConnectionPool
import psycopg2
import os

# Retrieve database credentials from environment variables
db_host = os.environ.get("REDSHIFT_HOST")
db_name = os.environ.get("REDSHIFT_DB_NAME")
db_user = os.environ.get("REDSHIFT_USERNAME")
db_password = os.environ.get("REDSHIFT_PASSWORD")

# Create a connection pool
db_pool = SimpleConnectionPool(
    1,  # Minimum connections
    20, # Maximum connections
    host=db_host,
    database=db_name,
    user=db_user,
    password=db_password
)

def insert_sentiment(text, score):
    """Inserts sentiment analysis results into the database."""
    db_connection = None  # Initialize db_connection outside the try block
    try:
        db_connection = db_pool.getconn()
        cursor = db_connection.cursor()
        cursor.execute(
            "INSERT INTO sentiments (text, score) VALUES (%s, %s) RETURNING id;",
            (text, score)
        )
        id = cursor.fetchone()[0]  # Get the inserted row's ID
        db_connection.commit()      # Commit the transaction
        return id                 # Return the ID of the inserted record

    except (Exception, psycopg2.Error) as error:  # Handle exceptions
        print(f"Database error: {error}")
        return None  # Or raise the exception if you want to handle it elsewhere

    finally:
        if db_connection:
            db_pool.putconn(db_connection)  # Return the connection to the pool