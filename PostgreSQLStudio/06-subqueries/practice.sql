-- PostgreSQL Subqueries Practice Exercises
-- Complete the following exercises to practice various subquery techniques in PostgreSQL

-- Exercise 1: Scalar Subqueries
-- Create tables: products (id, name, category, price) and orders (id, product_id, quantity, order_date)
-- Insert sample data
-- Write queries using scalar subqueries to:
-- a) Find products with prices higher than the average price
-- b) Find the most expensive product
-- c) Show each product with how much its price differs from the average

-- Exercise 2: Row Subqueries
-- Using the products table:
-- a) Find products with the exact same name and category as another product
-- b) Find products that match specific name and price criteria using row constructors

-- Exercise 3: Table Subqueries
-- Create a suppliers table (id, name, country)
-- Link products to suppliers
-- Write queries using table subqueries to:
-- a) Find products from suppliers in specific countries
-- b) Find products in categories that have more than 5 products

-- Exercise 4: Correlated Subqueries
-- Using employees and departments tables:
-- a) Find employees earning more than the average in their department
-- b) Find departments with more employees than the average department size
-- c) Find employees who earn more than every employee in a specific department

-- Exercise 5: Subqueries in SELECT Clause
-- a) Show each employee with their salary and the company average salary
-- b) Show each department with its employee count and the average employee count across departments
-- c) Calculate the percentage of department budget each employee represents

-- Exercise 6: Subqueries in FROM Clause (Derived Tables)
-- a) Find the top 3 highest-spending customers using derived tables
-- b) Calculate department statistics and filter results using subqueries
-- c) Create a report showing products and their ranking within categories

-- Exercise 7: EXISTS/NOT EXISTS Subqueries
-- a) Find customers who have placed orders
-- b) Find products that have never been ordered
-- c) Find departments with no employees
-- d) Find suppliers who supply products in multiple categories

-- Exercise 8: ALL/ANY/SOME Subqueries
-- a) Find products with prices higher than ALL products in a specific category
-- b) Find employees with salaries higher than ANY employee in Engineering
-- c) Find categories where ALL products cost more than a certain amount

-- Exercise 9: Nested Subqueries
-- a) Find employees in departments with above-average budgets who also have worked on projects with above-average hours
-- b) Find products supplied by top-rated suppliers that are in high-demand categories
-- c) Find customers who have ordered products from all categories

-- Exercise 10: Subqueries with Aggregation
-- a) Find departments where the average salary is in the top 3
-- b) Find products with sales quantities above the average for their category
-- c) Identify months where sales exceeded the average monthly sales

-- Exercise 11: Subqueries for Data Modification
-- a) Update employee salaries based on department performance using subqueries
-- b) Delete orders for products that are no longer available
-- c) Insert summary records based on aggregated data from detail tables

-- Exercise 12: Performance Optimization
-- a) Compare performance of correlated vs. non-correlated subqueries
-- b) Rewrite inefficient subqueries using JOINs where appropriate
-- c) Use EXPLAIN ANALYZE to examine query execution plans

-- Exercise 13: Complex Business Logic
-- a) Find the top-selling product in each category using subqueries
-- b) Identify employees who earn more than the average of their direct reports
-- c) Find customers who have purchased products in all categories

-- Exercise 14: Data Validation with Subqueries
-- a) Find inconsistent data using subqueries (e.g., employees with salaries outside expected ranges for their roles)
-- b) Validate referential integrity using NOT EXISTS
-- c) Identify duplicate records using subqueries

-- Exercise 15: Advanced Subquery Patterns
-- a) Implement a recursive subquery to traverse organizational hierarchies
-- b) Use subqueries to implement complex ranking systems
-- c) Create dynamic filters using subqueries that adapt to data characteristics

-- Bonus Exercise:
-- Design a comprehensive analytics system for an e-commerce platform using subqueries to generate:
--   - Customer lifetime value calculations
--   - Product recommendation engines
--   - Inventory optimization reports
--   - Market basket analysis
--   - Seasonal trend identification