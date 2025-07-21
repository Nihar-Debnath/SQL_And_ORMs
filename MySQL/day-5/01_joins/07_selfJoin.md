## ✅ What is a SELF JOIN?

A **SELF JOIN** is a regular join where a table is joined **with itself**.

* It’s useful when **rows of a table are related to other rows** in the same table.
* You **use aliases** to treat the same table as if they are two separate tables.

---

### 🔸 Syntax:

```sql
SELECT A.column_name, B.column_name
FROM table_name A
JOIN table_name B ON A.common_field = B.common_field;
```

> You must use aliases (`A`, `B`, etc.) to distinguish between the two "instances" of the table.

---

## 📘 Common Use Case Examples

---

### 🔹 1. Employees and Their Managers

Let’s say we have a table:

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT
);
```

#### Sample Data:

| emp\_id | emp\_name | manager\_id |
| ------- | --------- | ----------- |
| 1       | Alice     | NULL        |
| 2       | Bob       | 1           |
| 3       | Carol     | 1           |
| 4       | Dave      | 2           |
| 5       | Eve       | 2           |

#### Query to get employees and their managers' names:

```sql
SELECT 
    E.emp_name AS Employee,
    M.emp_name AS Manager
FROM 
    employees E
LEFT JOIN 
    employees M ON E.manager_id = M.emp_id;
```

#### Output:

| Employee | Manager |
| -------- | ------- |
| Alice    | NULL    |
| Bob      | Alice   |
| Carol    | Alice   |
| Dave     | Bob     |
| Eve      | Bob     |

---

### 🔹 2. Finding Pairs of Products in the Same Category

```sql
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(50)
);
```

#### Sample Data:

| product\_id | product\_name | category    |
| ----------- | ------------- | ----------- |
| 1           | T-shirt       | Clothing    |
| 2           | Jeans         | Clothing    |
| 3           | Laptop        | Electronics |
| 4           | Mouse         | Electronics |

#### Query: Get pairs of products in the same category (but not same product):

```sql
SELECT 
    A.product_name AS Product1,
    B.product_name AS Product2,
    A.category
FROM 
    products A
JOIN 
    products B ON A.category = B.category AND A.product_id < B.product_id;
```

#### Output:

| Product1 | Product2 | Category    |
| -------- | -------- | ----------- |
| T-shirt  | Jeans    | Clothing    |
| Laptop   | Mouse    | Electronics |

> `A.product_id < B.product_id` avoids duplicates like (T-shirt, Jeans) and (Jeans, T-shirt)

---

### 🔹 3. Comparing Students' Marks with Their Peers

```sql
CREATE TABLE students (
    student_id INT,
    student_name VARCHAR(50),
    marks INT
);
```

You can self-join to compare marks between students, find who scored higher than whom, etc.

---

## 🔍 Visualization

Imagine the table `employees` as:

```
employees (alias: E)
-----------------------
emp_id | emp_name | manager_id
  2    | Bob      | 1

employees (alias: M)
-----------------------
emp_id | emp_name | manager_id
  1    | Alice    | NULL
```

By doing:

```sql
E.manager_id = M.emp_id
```

You're mapping employee Bob to their manager Alice.

---

## 📌 Types of Self Joins

| Type         | Use Case Example                                                           |
| ------------ | -------------------------------------------------------------------------- |
| `INNER JOIN` | Match where condition is true (e.g., emp-manager)                          |
| `LEFT JOIN`  | Keep all rows from left side, even if no match (e.g., CEO with no manager) |

---

## 🧠 Summary Table

| Concept              | Description                                          |
| -------------------- | ---------------------------------------------------- |
| **Self Join**        | A join where a table joins with itself               |
| **Why Needed?**      | To find relationships among rows in the same table   |
| **Alias Use**        | Required to distinguish table instances              |
| **Common Use Cases** | Employees-managers, product pairings, comparing rows |
