-- PostgreSQL Data Types Examples

-- Connect to the database (this would be done in psql command line)
-- \c bookstore;

-- 1. Numeric Types
CREATE TABLE numeric_examples (
    small_int_col SMALLINT,           -- 2 bytes, range -32768 to 32767
    int_col INTEGER,                  -- 4 bytes, range -2147483648 to 2147483647
    big_int_col BIGINT,               -- 8 bytes, range -9223372036854775808 to 9223372036854775807
    decimal_col DECIMAL(10, 2),       -- Exact decimal with 10 digits, 2 after decimal point
    numeric_col NUMERIC(8, 3),        -- Same as DECIMAL
    real_col REAL,                    -- 4-byte floating point
    double_col DOUBLE PRECISION,      -- 8-byte floating point
    serial_col SERIAL                 -- Auto-incrementing integer
);

-- Insert examples
INSERT INTO numeric_examples (small_int_col, int_col, big_int_col, decimal_col, numeric_col, real_col, double_col) VALUES
(100, 100000, 10000000000, 99999999.99, 12345.678, 3.14159, 2.718281828459045),
(32767, 2147483647, 9223372036854775807, 12345678.12, 98765.432, 1.41421, 1.7320508075688772);

-- View the data
SELECT * FROM numeric_examples;

-- 2. Character Types
CREATE TABLE character_examples (
    char_col CHAR(10),                -- Fixed-length string, padded with spaces
    varchar_col VARCHAR(50),          -- Variable-length string, up to 50 characters
    text_col TEXT                     -- Variable-length string, unlimited length
);

-- Insert examples
INSERT INTO character_examples VALUES
('Hello', 'This is a variable-length string', 'This is a very long text that can be much longer than varchar'),
('Fixed', 'Short', 'Another example of text data');

-- View the data
SELECT *, LENGTH(char_col) as char_length, LENGTH(varchar_col) as varchar_length, LENGTH(text_col) as text_length 
FROM character_examples;

-- 3. Date/Time Types
CREATE TABLE datetime_examples (
    date_col DATE,                           -- Date (year, month, day)
    time_col TIME,                           -- Time of day (hours, minutes, seconds)
    timestamp_col TIMESTAMP,                 -- Date and time
    timestamptz_col TIMESTAMPTZ,             -- Timestamp with timezone
    interval_col INTERVAL                    -- Time interval
);

-- Insert examples
INSERT INTO datetime_examples VALUES
('2023-06-15', '14:30:00', '2023-06-15 14:30:00', '2023-06-15 14:30:00+00', '5 days'),
('2023-12-25', '09:15:30', '2023-12-25 09:15:30', '2023-12-25 09:15:30+05', '3 hours 30 minutes');

-- View the data
SELECT *, 
       EXTRACT(YEAR FROM date_col) as year,
       EXTRACT(MONTH FROM date_col) as month,
       EXTRACT(DAY FROM date_col) as day
FROM datetime_examples;

-- 4. Boolean Type
CREATE TABLE boolean_examples (
    id SERIAL PRIMARY KEY,
    is_active BOOLEAN,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Insert examples
INSERT INTO boolean_examples (is_active) VALUES
(TRUE),
(FALSE),
(NULL);  -- NULL is also a valid value

-- View the data
SELECT *, 
       CASE WHEN is_active IS TRUE THEN 'Yes' 
            WHEN is_active IS FALSE THEN 'No' 
            ELSE 'Unknown' END as is_active_text
FROM boolean_examples;

-- 5. JSON Types
CREATE TABLE json_examples (
    json_col JSON,                   -- JSON data (text format)
    jsonb_col JSONB                  -- Binary JSON (more efficient)
);

-- Insert examples
INSERT INTO json_examples VALUES
('{"name": "John", "age": 30, "city": "New York"}', '{"name": "John", "age": 30, "city": "New York"}'),
('{"products": ["apple", "banana"], "total": 2}', '{"products": ["apple", "banana"], "total": 2}');

-- Query JSON data
SELECT 
    json_col->>'name' as json_name,
    jsonb_col->>'name' as jsonb_name,
    jsonb_col->'products' as products
FROM json_examples;

-- 6. Array Types
CREATE TABLE array_examples (
    id SERIAL PRIMARY KEY,
    numbers INTEGER[],               -- Integer array
    names TEXT[]                     -- Text array
);

-- Insert examples
INSERT INTO array_examples (numbers, names) VALUES
('{1, 2, 3, 4, 5}', '{"Alice", "Bob", "Charlie"}'),
('{{1, 2}, {3, 4}}', '{{"Product A", "Product B"}, {"Product C", "Product D"}}');  -- Multidimensional

-- Query array data
SELECT 
    numbers,
    names,
    numbers[1] as first_number,
    names[2] as second_name,
    array_length(numbers, 1) as numbers_length
FROM array_examples;

-- 7. UUID Type
CREATE TABLE uuid_examples (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- Generate random UUID
    name VARCHAR(100)
);

-- Insert examples
INSERT INTO uuid_examples (name) VALUES
('First Item'),
('Second Item');

-- View the data
SELECT * FROM uuid_examples;

-- 8. Network Address Types
CREATE TABLE network_examples (
    ip4 INET,                        -- IPv4 address
    ip6 INET,                        -- IPv6 address
    cidr_block CIDR                  -- Network CIDR block
);

-- Insert examples
INSERT INTO network_examples VALUES
('192.168.1.1', '::1', '192.168.0.0/24'),
('10.0.0.1', '2001:db8::1', '2001:db8::/32');

-- View the data
SELECT *, 
       host(ip4) as ip4_host,
       netmask(cidr_block) as cidr_netmask
FROM network_examples;

-- Clean up (optional - uncomment to delete created tables)
-- DROP TABLE numeric_examples;
-- DROP TABLE character_examples;
-- DROP TABLE datetime_examples;
-- DROP TABLE boolean_examples;
-- DROP TABLE json_examples;
-- DROP TABLE array_examples;
-- DROP TABLE uuid_examples;
-- DROP TABLE network_examples;