## 🧱 What is a Primary Key in SQL?

A **Primary Key** is a **column (or a set of columns)** that uniquely identifies each row in a table.

### ✅ Key Properties:

* **Must be unique** for every row.
* **Cannot be NULL**.
* Each table can have **only one** primary key (though it may consist of multiple columns = composite key).

---

## 📌 Why Do We Use Primary Keys?

| Purpose               | Description                                             |
| --------------------- | ------------------------------------------------------- |
| Uniqueness            | Ensures each row is identifiable and distinct.          |
| Data Integrity        | Prevents duplicate records.                             |
| Foreign Key Reference | Other tables use it to create **relationships**.        |
| Indexing              | Automatically creates a **clustered index** (in MySQL). |

---

## 🧪 Basic Example

### 📋 Create a Table with Primary Key

```sql
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
```

Here, `student_id` is the **primary key**. You can’t insert two students with the same `student_id`, and it cannot be NULL.

---

## ⚙️ Inserting Data

```sql
INSERT INTO Students (student_id, name, age)
VALUES (101, 'Alice', 20),
       (102, 'Bob', 21);
```

```sql
-- Error: Duplicate ID
INSERT INTO Students (student_id, name, age)
VALUES (101, 'Charlie', 22); -- ❌ Fails (duplicate ID)
```

```sql
-- Error: NULL Primary Key
INSERT INTO Students (student_id, name, age)
VALUES (NULL, 'Daniel', 23); -- ❌ Fails (NULL not allowed)
```

---

## 🔁 ALTER TABLE to Add Primary Key

```sql
CREATE TABLE Books (
    book_id INT,
    title VARCHAR(100)
);
```

Add a primary key later:

```sql
ALTER TABLE Books
ADD PRIMARY KEY (book_id);
```

---

## 🧮 Composite Primary Keys

Used when **a single column is not unique**, but **a combination is**.

### Example:

```sql
CREATE TABLE Enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id)
);
```

This means:

* A student can enroll in many courses.
* A course can have many students.
* But the **same student cannot enroll in the same course twice**.

---

## 🧼 Best Practices

| Practice                              | Why?                                    |
| ------------------------------------- | --------------------------------------- |
| Use `INT` or short strings            | For better indexing and performance.    |
| Use surrogate keys (auto-incr)        | Avoid relying on names or natural keys. |
| Never allow NULLs                     | Use `NOT NULL` with custom keys.        |
| Avoid composite keys unless necessary | Simpler is better when possible.        |

---

## 🌍 Real-World Example

### Customers and Orders Schema

```sql
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
```

### ✅ What this does:

* Each customer has a unique ID.
* Each order is tied to one customer.
* `customer_id` in `Orders` is a **foreign key**, referencing the **primary key** in `Customers`.

---

## 🧪 Try-It Query Block (Testing Constraints)

```sql
-- Add some customers
INSERT INTO Customers (name, city)
VALUES ('Alice', 'Kolkata'), ('Bob', 'Delhi');

-- Add an order for customer_id 1
INSERT INTO Orders (customer_id, order_date, amount)
VALUES (1, '2025-07-20', 1500.00);

-- Invalid: customer_id 5 doesn’t exist
INSERT INTO Orders (customer_id, order_date, amount)
VALUES (5, '2025-07-20', 2000.00); -- ❌ FK constraint error
```

---

## 🧠 Summary

| Term          | Meaning                                                       |
| ------------- | ------------------------------------------------------------- |
| Primary Key   | Uniquely identifies a row, can't be NULL or duplicated.       |
| Composite Key | Primary key made from multiple columns.                       |
| Surrogate Key | Auto-incremented numeric ID not derived from real-world data. |
| Foreign Key   | Refers to a primary key in another table (for relationships). |

---
---
---

Primary keys are **much more powerful** than just enforcing uniqueness. Let’s dive into the **deeper features and behaviors** of primary keys in SQL—including **performance**, **internal workings**, **interactions with foreign keys**, and **database design principles**.

---

## 🔍 1. **Primary Key = Implicit Index**

When you define a primary key, SQL automatically creates a **unique index** on that column.

### ✅ Why this matters:

* **Faster SELECT queries** using the PK.
* Efficient **JOINs** and **WHERE** filters.

```sql
EXPLAIN SELECT * FROM Students WHERE student_id = 102;
-- Uses PRIMARY key index
```

---

## 🔐 2. **Primary Key Enforces Entity Integrity**

This is a **core principle** in relational databases:

* No two rows should represent the same **entity**.
* Ensures the table truly acts like a **set of unique rows** (no duplicates).

---

## 🧮 3. **Used as Anchor for Foreign Keys**

A **foreign key** in another table must reference a column that is **unique and not null**—in most cases, a primary key.

```sql
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
```

Foreign keys **inherit the constraints** of the referenced primary key:

* You can’t insert a value that doesn’t exist in the PK.
* You can’t delete a PK row if it’s being referenced (unless using `ON DELETE` options).

---

## 🧼 4. **Helps Prevent Data Anomalies**

| Type of Anomaly  | How PK Prevents It                                   |
| ---------------- | ---------------------------------------------------- |
| Duplicate rows   | Not possible due to uniqueness                       |
| Null identifiers | Blocked (PK cannot be NULL)                          |
| Orphaned records | Avoided through proper FK constraints referencing PK |

---

## ⚙️ 5. **Clustered Index (in MySQL/InnoDB)**

In MySQL (InnoDB), the **primary key is also the clustered index**. This means:

* The data is **physically sorted** on disk based on the primary key.
* Faster access if you're using **range queries** on PKs.

```sql
SELECT * FROM Orders WHERE order_id BETWEEN 100 AND 200;
-- Highly efficient if order_id is the PK
```

---

## 🧩 6. **Composite Primary Key Use Cases**

While single-column PKs are common, **composite keys** are used when:

* No single column uniquely identifies a row.
* You want to enforce **multi-attribute uniqueness**.

### Example:

```sql
PRIMARY KEY (student_id, course_id)
```

This prevents:

* A student from enrolling in the **same course twice**.
* Still allows the same student to enroll in **different courses**.

---

## 🔀 7. **Works with `AUTO_INCREMENT`**

Primary keys are commonly paired with `AUTO_INCREMENT` to **automatically assign unique values**.

```sql
CREATE TABLE Users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50)
);
```

Every insert gives a new `user_id` without manual assignment.

---

## 🔄 8. **ON UPDATE CASCADE / ON DELETE CASCADE with FKs**

When your PK is referenced by a foreign key, you can define **what happens to the FK** when the PK is changed or deleted.

```sql
FOREIGN KEY (user_id) REFERENCES Users(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE
```

* `ON DELETE CASCADE`: Deleting the parent also deletes all child rows.
* `ON UPDATE CASCADE`: Changing the PK in parent updates the child rows automatically.

---

## 🔧 9. **Unique Constraints ≠ Primary Key**

They are similar (both enforce uniqueness), but:

* You can have **multiple unique constraints**, only **one primary key**.
* Unique allows **NULLs** (unless specified otherwise), PK **never allows NULL**.

```sql
-- Valid: Two NULLs
CREATE TABLE Emails (
  email_id INT PRIMARY KEY,
  email VARCHAR(255) UNIQUE
);
```

---

## 📘 10. **Surrogate Keys vs Natural Keys**

| Type          | Description                                          | Example              |
| ------------- | ---------------------------------------------------- | -------------------- |
| Surrogate Key | Artificial key not derived from data (e.g., auto ID) | `user_id INT`        |
| Natural Key   | Real-world data used as key                          | `email VARCHAR(255)` |

💡 **Best practice:** Use **surrogate keys** in most cases. They’re stable and short.

---

## 🧠 Summary Table

| Feature               | Description                                                  |
| --------------------- | ------------------------------------------------------------ |
| Implicit Index        | Speeds up queries on PK columns                              |
| Entity Integrity      | Guarantees uniqueness and non-null                           |
| Foreign Key Anchor    | Other tables link to the PK                                  |
| Clustered Index       | Data is physically ordered on PK (InnoDB)                    |
| Data Integrity        | Prevents duplicates and nulls                                |
| Composite Keys        | Combine multiple fields to ensure uniqueness                 |
| Surrogate/Natural Key | Use artificial or real-world keys based on your schema needs |
| Constraints on FKs    | Use `ON DELETE/UPDATE` for maintaining referential integrity |

---
---
---
---


## ⚙️ What is a **Clustered Index** in MySQL (InnoDB)?

### ✅ Basic Idea:

In **MySQL using InnoDB**, when you define a **primary key**, the database engine **stores the entire row's data** *physically in order* by that key.

That makes the primary key act as a **clustered index**.

---

### 📦 What is a clustered index?

> A **clustered index** means that the **actual data rows are stored in the index itself**, and they're **sorted by the index key**.

So when you say:

```sql
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_name VARCHAR(50)
);
```

The rows are **physically arranged** on disk like this (in order of `order_id`):

| order\_id | customer\_name |
| --------- | -------------- |
| 100       | Alice          |
| 101       | Bob            |
| 102       | Charlie        |
| 200       | David          |

---

### 🚀 Why is it faster?

Let’s say you run this query:

```sql
SELECT * FROM Orders WHERE order_id BETWEEN 100 AND 200;
```

Since the rows are already **stored in sorted order** of `order_id`, MySQL doesn't have to scan the whole table.

🔎 It quickly finds 100, then reads **sequentially from disk** up to 200 — just like reading a sorted book.

---

### ❌ Without clustered index (in other engines):

If the data was not stored by primary key order, it would have to:

1. First find the `order_id` values from a separate index.
2. Then **jump around** on disk to fetch the full rows — much slower.

---

### 📌 Key Points:

| Feature               | Clustered Index (InnoDB PK)               |
| --------------------- | ----------------------------------------- |
| Sorting               | Rows sorted by primary key                |
| Speed                 | Fast for `BETWEEN`, `ORDER BY`, `=`, etc. |
| Storage               | Data is physically stored in order        |
| Only one per table    | Only one clustered index allowed          |
| Created automatically | Automatically when you set a PRIMARY KEY  |

---

### 🧠 Analogy:

Imagine a **library**:

* All books are **stacked alphabetically** by title (like a clustered index).
* So if you want books from **A to C**, the librarian can pick them **in one go**.
* No jumping shelf to shelf (no random access).
