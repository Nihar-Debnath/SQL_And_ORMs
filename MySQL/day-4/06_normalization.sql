-- First, Second, and Third Normal Forms using a bookstore database example.

-- Create and use bookstore database
CREATE DATABASE bookstore;
USE bookstore;

-- Original denormalized table
CREATE TABLE book_orders (
    order_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_address VARCHAR(255),
    book_isbn VARCHAR(20),
    book_title VARCHAR(200),
    book_author VARCHAR(100),
    book_price DECIMAL(10, 2),
    order_date DATE,
    quantity INT,
    total_price DECIMAL(10, 2)
);

-- Sample data for denormalized table
INSERT INTO book_orders VALUES
(1, 'John Smith', 'john@example.com', '123 Main St, Anytown', '978-0141439518', 'Pride and Prejudice', 'Jane Austen', 9.99, '2023-01-15', 1, 9.99),
(2, 'John Smith', 'john@example.com', '123 Main St, Anytown', '978-0451524935', '1984', 'George Orwell', 12.99, '2023-01-15', 2, 25.98),
(3, 'Mary Johnson', 'mary@example.com', '456 Oak Ave, Somewhere', '978-0061120084', 'To Kill a Mockingbird', 'Harper Lee', 14.99, '2023-01-20', 1, 14.99),
(4, 'Robert Brown', 'robert@example.com', '789 Pine Rd, Nowhere', '978-0141439518', 'Pride and Prejudice', 'Jane Austen', 9.99, '2023-01-25', 1, 9.99);

-- View the denormalized data
SELECT * FROM book_orders;

-- FIRST NORMAL FORM (1NF)
-- Requirements:
-- 1. Each column contains atomic (indivisible) values
-- 2. Each column contains values of the same type
-- 3. Each row is unique (typically ensured by a primary key)
-- 4. No repeating groups of columns

CREATE TABLE book_orders_1nf (
    order_id INT,
    book_isbn VARCHAR(20),
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_address VARCHAR(255),
    book_title VARCHAR(200),
    book_author VARCHAR(100),
    book_price DECIMAL(10, 2),
    order_date DATE,
    quantity INT,
    total_price DECIMAL(10, 2),
    PRIMARY KEY (order_id, book_isbn)
);

-- SECOND NORMAL FORM (2NF)
-- Requirements:
-- 1. Must be in 1NF
-- 2. All non-key attributes must be fully functionally dependent on the entire primary key
--    (No non-key column should depend on only part of the primary key)
--    (No partial dependencies on primary key)

CREATE TABLE orders_2nf (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_address VARCHAR(255),
    order_date DATE
);

CREATE TABLE books_2nf (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(200),
    author VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE order_items_2nf (
    order_id INT,
    book_isbn VARCHAR(20),
    quantity INT,
    total_price DECIMAL(10, 2),
    PRIMARY KEY (order_id, book_isbn),
    FOREIGN KEY (order_id) REFERENCES orders_2nf(order_id),
    FOREIGN KEY (book_isbn) REFERENCES books_2nf(isbn)
);

-- Sample data for 2NF tables
INSERT INTO orders_2nf VALUES
(1, 'John Smith', 'john@example.com', '123 Main St, Anytown', '2023-01-15'),
(2, 'Mary Johnson', 'mary@example.com', '456 Oak Ave, Somewhere', '2023-01-20'),
(3, 'Robert Brown', 'robert@example.com', '789 Pine Rd, Nowhere', '2023-01-25');

INSERT INTO books_2nf VALUES
('978-0141439518', 'Pride and Prejudice', 'Jane Austen', 9.99),
('978-0451524935', '1984', 'George Orwell', 12.99),
('978-0061120084', 'To Kill a Mockingbird', 'Harper Lee', 14.99);

INSERT INTO order_items_2nf VALUES
(1, '978-0141439518', 1, 9.99),
(1, '978-0451524935', 2, 25.98),
(2, '978-0061120084', 1, 14.99),
(3, '978-0141439518', 1, 9.99);

-- THIRD NORMAL FORM (3NF)
-- Requirements:
-- 1. Must be in 2NF
-- 2. Must not have transitive dependencies
--    (A non-key attribute cannot depend on another non-key attribute;
--     it must depend directly on the primary key)

CREATE TABLE customers_3nf (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE orders_3nf (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers_3nf(customer_id)
);

CREATE TABLE books_3nf (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(200),
    author VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE order_items_3nf (
    order_id INT,
    book_isbn VARCHAR(20),
    quantity INT,
    PRIMARY KEY (order_id, book_isbn),
    FOREIGN KEY (order_id) REFERENCES orders_3nf(order_id),
    FOREIGN KEY (book_isbn) REFERENCES books_3nf(isbn)
);

-- Note: The 3NF design removes the derived column total_price from order_items
-- as it can be calculated from quantity * price