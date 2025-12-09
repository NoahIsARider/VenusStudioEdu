-- PostgreSQL Basics Examples

-- 1. Creating a sample database
CREATE DATABASE bookstore;

-- Connect to the database (this would be done in psql command line)
-- \c bookstore;

-- 2. Creating tables
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50)
);

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INTEGER REFERENCES authors(id),
    publication_date DATE,
    price DECIMAL(10, 2),
    isbn VARCHAR(13) UNIQUE
);

-- 3. Inserting data
INSERT INTO authors (name, birth_date, nationality) VALUES
('George Orwell', '1903-06-25', 'British'),
('Jane Austen', '1775-12-16', 'British'),
('Mark Twain', '1835-11-30', 'American');

INSERT INTO books (title, author_id, publication_date, price, isbn) VALUES
('1984', 1, '1949-06-08', 12.99, '9780451524935'),
('Animal Farm', 1, '1945-08-17', 9.99, '9780451526342'),
('Pride and Prejudice', 2, '1813-01-28', 10.99, '9780141439518'),
('The Adventures of Tom Sawyer', 3, '1876-12-01', 8.99, '9780486400778');

-- 4. Basic queries
-- Select all authors
SELECT * FROM authors;

-- Select books with their authors
SELECT b.title, a.name AS author, b.publication_date, b.price
FROM books b
JOIN authors a ON b.author_id = a.id;

-- Find books cheaper than $11
SELECT title, price FROM books WHERE price < 11.00;

-- 5. Updating data
UPDATE books SET price = 11.99 WHERE id = 2;

-- 6. Deleting data
-- DELETE FROM books WHERE id = 4;

-- 7. Aggregation
SELECT a.name, COUNT(b.id) AS book_count
FROM authors a
LEFT JOIN books b ON a.id = b.author_id
GROUP BY a.id, a.name;

-- 8. Sorting
SELECT title, price FROM books ORDER BY price DESC;

-- 9. Limiting results
SELECT title, price FROM books ORDER BY price DESC LIMIT 3;

-- Clean up (optional - uncomment to delete created tables)
-- DROP TABLE books;
-- DROP TABLE authors;