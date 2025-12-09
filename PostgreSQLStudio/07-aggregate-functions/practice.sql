-- PostgreSQL Aggregate Functions Practice Exercises
-- Complete the following exercises to practice various aggregate functions in PostgreSQL

-- Exercise 1: Basic Aggregates
-- Create tables: orders (id, customer_id, product_id, quantity, price, order_date)
-- Insert sample data
-- Write queries to calculate:
-- a) Total number of orders
-- b) Total revenue (sum of quantity * price)
-- c) Average order value
-- d) Highest and lowest order values
-- e) Number of unique customers

-- Exercise 2: GROUP BY Aggregates
-- Using the orders table:
-- a) Calculate total revenue by customer
-- b) Calculate average order value by product
-- c) Count orders by month
-- d) Find the best-selling product (by quantity)
-- e) Calculate total revenue by quarter

-- Exercise 3: HAVING Clauses
-- a) Find customers with more than 5 orders
-- b) Find products with total revenue above $1000
-- c) Find months with more than 10 orders
-- d) Find customers whose average order value is above $100
-- e) Find products ordered by more than 3 different customers

-- Exercise 4: String Aggregates
-- Create a tags table (product_id, tag)
-- Insert sample data
-- Write queries to:
-- a) Concatenate all tags for each product
-- b) Create a comma-separated list of products for each tag
-- c) Find products that share the same set of tags

-- Exercise 5: Array Aggregates
-- Using the tags table:
-- a) Collect all tags for each product into an array
-- b) Find products with identical tag arrays
-- c) Calculate the overlap of tags between products

-- Exercise 6: Boolean Aggregates
-- Add a boolean column to the orders table (is_returned)
-- Insert sample data
-- Write queries to:
-- a) Find customers where all orders were returned
-- b) Find products where at least one order was returned
-- c) Calculate the percentage of returned orders by product

-- Exercise 7: Statistical Aggregates
-- Using the orders table:
-- a) Calculate the standard deviation of order values
-- b) Calculate the variance of quantities ordered
-- c) Find the correlation between order quantity and price
-- d) Calculate quartiles for order values
-- e) Identify outliers in order values

-- Exercise 8: Window Functions with Aggregates
-- a) Calculate running totals of revenue by date
-- b) Calculate 7-day moving averages of order counts
-- c) Rank customers by total spending
-- d) Calculate percentiles for customer spending
-- e) Show each order with the customer's average order value

-- Exercise 9: Conditional Aggregates
-- Using the orders table:
-- a) Count orders with value above average
-- b) Calculate average order value for premium customers only
-- c) Sum revenue from orders placed in the last 30 days
-- d) Count distinct products ordered by VIP customers
-- e) Calculate the percentage of revenue from repeat customers

-- Exercise 10: Advanced Grouping
-- Create a sales table with region, product_category, salesperson, month, amount
-- Insert sample data
-- Write queries using:
-- a) GROUPING SETS to calculate totals by different dimensions
-- b) ROLLUP to create hierarchical summaries
-- c) CUBE to generate all possible combinations
-- d) Compare results from different grouping methods

-- Exercise 11: DISTINCT Aggregates
-- a) Calculate average order value using DISTINCT prices
-- b) Count unique customer-product combinations
-- c) Find the median order value using DISTINCT values
-- d) Calculate the ratio of unique to total orders

-- Exercise 12: NULL Handling in Aggregates
-- Add some NULL values to the orders table
-- Write queries to:
-- a) Demonstrate how COUNT handles NULLs differently than other aggregates
-- b) Calculate averages excluding NULL values
-- c) Identify rows contributing NULLs to aggregates
-- d) Implement custom NULL handling for business logic

-- Exercise 13: Performance Optimization
-- a) Analyze query plans for aggregate operations
-- b) Add indexes to optimize GROUP BY queries
-- c) Compare performance of different aggregate implementations
-- d) Optimize memory usage for large aggregations

-- Exercise 14: Complex Business Metrics
-- a) Calculate customer lifetime value
-- b) Determine inventory turnover rates
-- c) Compute sales growth rates by period
-- d) Identify seasonal trends in sales
-- e) Calculate cohort retention rates

-- Exercise 15: Custom Aggregates
-- a) Implement a custom aggregate function for geometric mean
-- b) Create an aggregate for calculating weighted averages
-- c) Develop a custom aggregate for finding medians
-- d) Build an aggregate for concatenating values with custom separators

-- Bonus Exercise:
-- Design a comprehensive business intelligence dashboard using aggregates to show:
--   - Key performance indicators (KPIs)
--   - Trend analysis over time
--   - Comparative metrics across dimensions
--   - Predictive analytics based on historical aggregates