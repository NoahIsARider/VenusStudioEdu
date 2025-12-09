-- PostgreSQL Joins Practice Exercises
-- Complete the following exercises to practice various JOIN operations in PostgreSQL

-- Exercise 1: Basic INNER JOIN
-- Create tables: authors (id, name, birth_year) and books (id, title, author_id, publication_year)
-- Insert sample data into both tables
-- Write a query to show all books with their author names

-- Exercise 2: LEFT JOIN
-- Using the authors and books tables from Exercise 1:
-- Write a query to show all authors and their books, including authors who haven't written any books

-- Exercise 3: RIGHT JOIN
-- Using the same tables:
-- Write a query to show all books and their authors, including books with unknown authors (author_id is NULL)

-- Exercise 4: FULL OUTER JOIN
-- Write a query to show all authors and books, regardless of whether they have matches in the other table

-- Exercise 5: Multiple JOINs
-- Create additional tables: publishers (id, name, country) and book_publishers (book_id, publisher_id)
-- Insert sample data
-- Write a query to show books with their authors and publishers

-- Exercise 6: Self JOIN
-- Add a mentor_id column to the authors table
-- Insert data to establish mentor-mentee relationships
-- Write a query to show each author with their mentor's name

-- Exercise 7: CROSS JOIN
-- Create a genres table (id, name)
-- Insert sample genres
-- Write a query to show all possible combinations of books and genres

-- Exercise 8: JOIN with Aggregation
-- Using the books and authors tables:
-- Write a query to count how many books each author has written
-- Write a query to find the average publication year of books for each author

-- Exercise 9: JOIN with Conditions
-- Write a query to find books published after 2000 with their authors
-- Write a query to find authors born before 1950 and their books

-- Exercise 10: Complex JOIN Operations
-- Create a reviews table (id, book_id, reviewer_name, rating, review_text)
-- Insert sample data
-- Write a query to show books with their average ratings
-- Write a query to show authors with the average rating of their books

-- Exercise 11: LATERAL JOIN (PostgreSQL specific)
-- For each author, find their most recently published book
-- Hint: Use LATERAL JOIN with a subquery that limits to 1 result

-- Exercise 12: JOIN with Subqueries
-- Find authors who have written books in multiple genres
-- Find books that have higher ratings than the average rating of books by the same author

-- Exercise 13: Performance Optimization
-- Add appropriate indexes to improve JOIN performance
-- Analyze query plans for your JOIN queries
-- Compare performance with and without indexes

-- Exercise 14: Data Integrity with JOINs
-- Implement foreign key constraints to maintain referential integrity
-- Handle NULL values appropriately in JOIN operations
-- Write queries that safely handle missing data

-- Exercise 15: Advanced JOIN Scenarios
-- Create a library system with tables: members, loans, books, authors
-- Implement queries for:
--   - Books currently on loan
--   - Members with overdue books
--   - Most popular authors in the library
--   - Books borrowed by the same member

-- Bonus Exercise:
-- Design a comprehensive database schema for an online store with at least 6 related tables
-- Implement complex JOIN queries to generate business reports like:
--   - Top selling products by category
--   - Customer purchase history
--   - Inventory status across warehouses
--   - Supplier performance metrics