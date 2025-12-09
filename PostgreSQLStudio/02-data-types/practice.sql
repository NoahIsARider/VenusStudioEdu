-- PostgreSQL Data Types Practice Exercises

-- Exercise 1: Numeric Types
-- Create a table called "product_sales" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- product_name (VARCHAR(100))
-- quantity_sold (INTEGER)
-- unit_price (DECIMAL(10, 2))
-- total_revenue (NUMERIC(12, 2))
-- rating (REAL)

-- Exercise 2: Character Types
-- Create a table called "user_profiles" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- username (CHAR(20))
-- full_name (VARCHAR(100))
-- bio (TEXT)

-- Exercise 3: Date/Time Types
-- Create a table called "event_schedule" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- event_name (VARCHAR(100))
-- event_date (DATE)
-- start_time (TIME)
-- end_time (TIME)
-- created_at (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

-- Exercise 4: Boolean Type
-- Add a column called "is_published" (BOOLEAN) to the "event_schedule" table
-- Add a column called "is_featured" (BOOLEAN DEFAULT FALSE) to the "event_schedule" table

-- Exercise 5: JSON Types
-- Create a table called "product_catalog" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- product_name (VARCHAR(100))
-- attributes (JSONB)

-- Insert sample data with different product attributes:
-- 1. A book with author, pages, and publisher
-- 2. A electronic device with brand, model, and warranty_period

-- Exercise 6: Array Types
-- Add a column called "tags" (TEXT[]) to the "product_catalog" table
-- Insert sample data with tags for each product

-- Exercise 7: UUID Type
-- Create a table called "api_keys" with the following columns:
-- id (UUID PRIMARY KEY DEFAULT gen_random_uuid())
-- api_key (VARCHAR(50))
-- created_at (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

-- Exercise 8: Data Type Conversion
-- Create a table called "measurements" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- temperature_celsius (VARCHAR(10))  -- Store as string initially
-- measurement_date (DATE)

-- Insert sample data with temperature values as strings
-- Write a query to convert the temperature values to numeric and calculate the average

-- Exercise 9: Complex Data Types
-- Create a table called "employee_records" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- name (VARCHAR(100))
-- contact_info (JSONB)  -- Store phone numbers and emails
-- skills (TEXT[])       -- Store employee skills
-- employment_dates (DATERANGE)  -- Store employment period

-- Exercise 10: Data Validation
-- Add constraints to the "product_sales" table:
-- Ensure quantity_sold is >= 0
-- Ensure unit_price is > 0
-- Ensure total_revenue equals quantity_sold * unit_price (use a CHECK constraint)

-- Bonus Exercise: Create a comprehensive table
-- Design a table called "business_intelligence" that uses at least 5 different data types
-- Include appropriate constraints and defaults
-- Insert sample data and write queries to demonstrate different operations