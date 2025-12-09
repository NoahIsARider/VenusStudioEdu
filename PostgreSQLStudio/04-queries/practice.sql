-- PostgreSQL Queries Practice Exercises
-- Complete the following exercises to practice various query techniques in PostgreSQL

-- Exercise 1: Basic SELECT Queries
-- Create a table called products with columns: id, name, category, price, stock_quantity
-- Insert at least 5 sample products
-- Write queries to:
-- a) Retrieve all products
-- b) Retrieve only product names and prices
-- c) Retrieve products with price greater than 50
-- d) Retrieve products ordered by price (highest first)
-- e) Retrieve the top 3 most expensive products

-- Exercise 2: Filtering and Sorting
-- Using the products table from Exercise 1:
-- a) Find products in a specific category (e.g., 'Electronics')
-- b) Find products with stock quantity less than 10
-- c) Find products with names containing 'phone' (case-insensitive)
-- d) Find products priced between 20 and 100
-- e) Sort products by category first, then by price within each category

-- Exercise 3: JOIN Operations
-- Create a customers table with columns: id, name, email, city
-- Create an orders table with columns: id, customer_id, product_id, quantity, order_date
-- Insert sample data into both tables
-- Write queries to:
-- a) Show all orders with customer names (INNER JOIN)
-- b) Show all customers and their orders, including customers with no orders (LEFT JOIN)
-- c) Count how many orders each customer has made
-- d) Find the total quantity ordered for each product
-- e) Show customer names, product names, and quantities for all orders

-- Exercise 4: Aggregate Functions
-- Using the products table:
-- a) Calculate the average price of all products
-- b) Find the maximum and minimum prices
-- c) Count the number of products in each category
-- d) Calculate the total value of inventory (price * stock_quantity) for each category
-- e) Find categories where the average product price is above 75

-- Exercise 5: GROUP BY and HAVING
-- Using the orders and products tables:
-- a) Group orders by product_id and count the number of orders for each product
-- b) Find products that have been ordered more than 5 times
-- c) Calculate the total revenue (quantity * price) for each product
-- d) Find products with total revenue greater than 1000
-- e) Show the average order quantity for each product, but only for products with more than 2 orders

-- Exercise 6: Subqueries
-- a) Find products with prices higher than the average price of all products
-- b) Find customers who have placed at least one order (use subquery)
-- c) List products that have never been ordered (use subquery)
-- d) Find the most expensive product in each category
-- e) Identify customers who have ordered products worth more than 200 in total

-- Exercise 7: UNION and Set Operations
-- Create another table called archived_products with the same structure as products
-- Insert some sample data
-- a) Combine active and archived products into one list (UNION)
-- b) Find products that exist in both active and archived tables (INTERSECT)
-- c) Find products that are in active table but not in archived (EXCEPT)
-- d) Show a combined list of all products, indicating whether they are active or archived
-- e) Find categories that exist in either active or archived products

-- Exercise 8: Window Functions
-- Using the orders table:
-- a) Assign row numbers to orders based on order date
-- b) Calculate the running total of quantities ordered over time
-- c) Rank customers by the number of orders they've placed
-- d) Show the previous order quantity for each customer
-- e) Calculate the difference between each order quantity and the average quantity

-- Exercise 9: Common Table Expressions (CTEs)
-- a) Create a CTE to calculate monthly sales totals, then select from it
-- b) Use a CTE to identify high-value customers (those with orders > average)
-- c) Create a recursive CTE to show organizational hierarchy (if applicable)
-- d) Use multiple CTEs to break down a complex query into simpler parts
-- e) Create a CTE that combines data from products, orders, and customers

-- Exercise 10: Advanced Filtering and CASE
-- a) Classify products as 'Cheap', 'Moderate', or 'Expensive' based on price ranges
-- b) Show customer segments based on number of orders (New, Regular, VIP)
-- c) Calculate discounts: 10% for Electronics, 5% for Clothing, 0% for others
-- d) Create a report showing order status: 'Pending', 'Shipped', 'Delivered' based on shipping dates
-- e) Use COALESCE to handle NULL values in a meaningful way

-- Bonus Exercise:
-- Design a comprehensive query that joins at least 4 tables, uses aggregate functions, 
-- window functions, and filtering conditions to generate a detailed sales report.
-- Include product information, customer details, order quantities, and calculated metrics.