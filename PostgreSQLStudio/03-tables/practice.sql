-- PostgreSQL Tables Practice Exercises

-- Exercise 1: Basic Table Creation
-- Create a table called "students" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- first_name (VARCHAR(50) NOT NULL)
-- last_name (VARCHAR(50) NOT NULL)
-- email (VARCHAR(100) UNIQUE NOT NULL)
-- enrollment_date (DATE DEFAULT CURRENT_DATE)
-- gpa (DECIMAL(3, 2) CHECK (gpa >= 0.0 AND gpa <= 4.0))

-- Exercise 2: Table with Foreign Keys
-- Create a table called "courses" with the following columns:
-- id (SERIAL PRIMARY KEY)
-- course_code (VARCHAR(10) UNIQUE NOT NULL)
-- course_name (VARCHAR(100) NOT NULL)
-- credits (INTEGER CHECK (credits > 0))
-- instructor (VARCHAR(100))

-- Exercise 3: Enrollments Table
-- Create a table called "enrollments" that links students and courses:
-- student_id (INTEGER REFERENCES students(id))
-- course_id (INTEGER REFERENCES courses(id))
-- enrollment_date (DATE DEFAULT CURRENT_DATE)
-- grade (VARCHAR(2) CHECK (grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'F')))
-- PRIMARY KEY (student_id, course_id)

-- Exercise 4: Adding Constraints
-- Add a column "phone" (VARCHAR(20)) to the students table
-- Add a constraint to ensure phone numbers are at least 10 characters long

-- Exercise 5: Modifying Table Structure
-- Rename the "instructor" column in the courses table to "instructor_name"
-- Add a column "department" (VARCHAR(50)) to the courses table

-- Exercise 6: Inserting Data
-- Insert at least 3 students into the students table
-- Insert at least 3 courses into the courses table
-- Enroll students in courses with some grades

-- Exercise 7: Complex Constraints
-- Add a constraint to the students table to ensure the email contains '@'
-- Add a constraint to the courses table to ensure course_code follows the pattern of 2-4 letters followed by 3-4 digits (e.g., CS101, MATH2001)

-- Exercise 8: Table with Index
-- Create a table called "library_books" with columns for id, title, author, isbn, publication_year
-- Add indexes on title and author for better search performance

-- Exercise 9: Partitioned Table
-- Design a partitioned table structure for storing sales data by year
-- Create a parent table "sales" and child tables for years 2022, 2023, and 2024
-- Include appropriate check constraints for each partition

-- Exercise 10: Table Inheritance
-- Create a base table "vehicles" with columns for id, make, model, year
-- Create child tables "cars" and "trucks" that inherit from vehicles
-- Add specific columns to each child table (e.g., car_doors for cars, truck_capacity for trucks)

-- Bonus Exercise: Comprehensive Database Design
-- Design a complete database schema for a university system including:
-- Departments, Professors, Students, Courses, Classrooms, Schedules
-- Define appropriate primary keys, foreign keys, and constraints
-- Consider indexing strategies for commonly queried fields