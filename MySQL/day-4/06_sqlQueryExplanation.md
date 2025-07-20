## 🧩 Original Table (Unnormalized)

```sql
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
```

### ❌ Problems:

* Repetition of **customer** info if they buy multiple books.
* Repetition of **book** info (like title, author, price).
* **Redundancy** and **update anomalies**.
* **total\_price** is a derived field (can be calculated from quantity × price).

---

## ✅ 1NF: First Normal Form

### 🧠 Rules:

1. **Atomic values only** (no multiple values in a single column).
2. All entries in a column must be of the **same type**.
3. Each **row must be unique**.
4. No **repeating groups**.

### ✅ Solution:

```sql
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
```

### 🔍 Observation:

* Now, each book in an order has its **own row**.
* But still there is **repetition** in book and customer info.

---

## ✅ 2NF: Second Normal Form

### 🧠 Rules:

1. Must be in **1NF**.
2. **No partial dependencies**: Every non-key column must depend on the **whole composite key**, not just a part of it.

### ❓ What is Partial Dependency?

* When a non-key column depends on **only part** of the primary key.
* In the previous table, `book_title`, `book_author`, `book_price` only depend on `book_isbn`, not the whole `(order_id, book_isbn)` composite key — this is **partial dependency**.

### ✅ Solution: Break the table into smaller tables:

```sql
-- Orders Table
CREATE TABLE orders_2nf (
  order_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  customer_email VARCHAR(100),
  customer_address VARCHAR(255),
  order_date DATE
);

-- Books Table
CREATE TABLE books_2nf (
  isbn VARCHAR(20) PRIMARY KEY,
  title VARCHAR(200),
  author VARCHAR(100),
  price DECIMAL(10, 2)
);

-- Junction Table
CREATE TABLE order_items_2nf (
  order_id INT,
  book_isbn VARCHAR(20),
  quantity INT,
  total_price DECIMAL(10, 2),
  PRIMARY KEY (order_id, book_isbn),
  FOREIGN KEY (order_id) REFERENCES orders_2nf(order_id),
  FOREIGN KEY (book_isbn) REFERENCES books_2nf(isbn)
);
```

### 🔍 Observation:

* Each table handles a **distinct entity**: orders, books, and the relationship.
* **No partial dependency**.

---

## ✅ 3NF: Third Normal Form

### 🧠 Rules:

1. Must be in **2NF**.
2. **No transitive dependency**: Non-key columns should not depend on **other non-key columns**.

### ❓ What is Transitive Dependency?

* When A → B and B → C, then A → C indirectly.
* Example: `customer_email` depends on `customer_name`, but `customer_name` is not a key → this is **transitive**.

### ✅ Solution:

Separate **customers** into their own table:

```sql
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
```

### 🔍 Final Design Summary:

| Table             | Description                           |
| ----------------- | ------------------------------------- |
| `customers_3nf`   | One row per customer                  |
| `orders_3nf`      | One row per order, refers to customer |
| `books_3nf`       | One row per book                      |
| `order_items_3nf` | One row per book in an order          |

---

## 💡 Why is Normalization Important?

| Problem Without Normalization | How Normalization Helps         |
| ----------------------------- | ------------------------------- |
| Redundant Data                | Minimized                       |
| Inconsistent Data             | Reduced                         |
| Insertion Anomaly             | Solved                          |
| Deletion Anomaly              | Solved                          |
| Update Anomaly                | Solved                          |
| Poor Query Performance        | Better with indexes + structure |

---

## 🧠 Summary Cheat Sheet

| Normal Form | What it Solves                              | How to Achieve It                              |
| ----------- | ------------------------------------------- | ---------------------------------------------- |
| **1NF**     | No repeating groups                         | Keep atomic values, one value per cell         |
| **2NF**     | No partial dependencies (for composite PKs) | Break into smaller tables                      |
| **3NF**     | No transitive dependencies                  | Separate indirect dependencies into own tables |
