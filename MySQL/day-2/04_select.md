### 🔷 What is `SELECT`?

The `SELECT` statement is used to **retrieve data** from one or more tables in a database.
It can return:

* All rows
* Filtered rows
* Specific columns
* Aggregated values
* Data joined from multiple tables

---

## 🔹 1. Basic `SELECT` Syntax

```sql
SELECT column1, column2, ...
FROM table_name;
```

### 🧪 Example:

```sql
SELECT name, email FROM users;
```

---

## 🔹 2. Select All Columns (`*`)

```sql
SELECT * FROM users;
```

* Returns **all columns** of the table.

---

## 🔹 3. Select With WHERE (Filtering Rows)

```sql
SELECT * FROM users
WHERE age > 25;
```

* Retrieves only rows where `age` is greater than 25.

### ✅ Operators You Can Use in WHERE:

| Type             | Examples                        |
| ---------------- | ------------------------------- |
| Comparison       | `=`, `!=`, `<`, `>`, `<=`, `>=` |
| Logical          | `AND`, `OR`, `NOT`              |
| Pattern Matching | `LIKE`, `NOT LIKE`              |
| Range Matching   | `BETWEEN`, `NOT BETWEEN`        |
| List Matching    | `IN`, `NOT IN`                  |
| NULL check       | `IS NULL`, `IS NOT NULL`        |

---

## 🔹 4. Using `AS` for Aliases

```sql
SELECT name AS full_name FROM users;
```

* Temporarily renames the column `name` to `full_name` in output only.

---

## 🔹 5. ORDER BY (Sorting)

```sql
SELECT name, age FROM users
ORDER BY age DESC;
```

* Sorts result by `age` in **descending** order.

### ✅ You can sort by:

* One column: `ORDER BY name`
* Multiple: `ORDER BY age DESC, name ASC`

---

## 🔹 6. LIMIT (Restrict number of rows)

```sql
SELECT * FROM users
LIMIT 5;
```

* Returns only the **first 5 rows**.

```sql
SELECT * FROM users
LIMIT 5 OFFSET 10;
```

* Skips first 10, then shows next 5 rows.

---

## 🔹 7. DISTINCT (No duplicates)

```sql
SELECT DISTINCT country FROM users;
```

* Returns **unique** values only.

---

## 🔹 8. Aggregates (SUM, COUNT, AVG, MIN, MAX)

| Function          | Purpose            |
| ----------------- | ------------------ |
| `COUNT()`         | Count rows         |
| `SUM()`           | Add numeric column |
| `AVG()`           | Average            |
| `MIN()` / `MAX()` | Minimum / Maximum  |

### 🧪 Example:

```sql
SELECT COUNT(*) FROM users;
SELECT AVG(age) FROM users;
```

---

## 🔹 9. GROUP BY

```sql
SELECT country, COUNT(*) FROM users
GROUP BY country;
```

* Groups rows by country and counts users in each.

---

## 🔹 10. HAVING (Filter After Grouping)

```sql
SELECT country, COUNT(*) as total FROM users
GROUP BY country
HAVING total > 5;
```

* Filters **grouped** results.

🧠 Use `HAVING` **after** `GROUP BY`
Use `WHERE` **before** grouping.

---

## 🔹 11. Joins (Combine Data from Multiple Tables)

```sql
SELECT u.name, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id;
```

| Type              | Description                           |
| ----------------- | ------------------------------------- |
| `INNER JOIN`      | Matches from both tables only         |
| `LEFT JOIN`       | All from left + matched from right    |
| `RIGHT JOIN`      | All from right + matched from left    |
| `FULL OUTER JOIN` | All from both (not in MySQL natively) |

---

## 🔹 12. Subqueries (Nested SELECT)

```sql
SELECT name FROM users
WHERE id IN (
  SELECT user_id FROM orders WHERE total_amount > 1000
);
```

* Inner `SELECT` returns list used in outer query.

---

## 🔹 13. CASE (IF/ELSE Conditions)

```sql
SELECT name,
  CASE
    WHEN age >= 18 THEN 'Adult'
    ELSE 'Minor'
  END AS age_group
FROM users;
```

* ✅ Adds conditional logic into results.

---

## 🔹 14. UNION / UNION ALL

```sql
SELECT name FROM customers
UNION
SELECT name FROM suppliers;
```

* Combines two result sets (removes duplicates by default).

```sql
UNION ALL → keeps duplicates
```

---

## 🔹 15. EXISTS / NOT EXISTS

```sql
SELECT name FROM users u
WHERE EXISTS (
  SELECT 1 FROM orders o WHERE o.user_id = u.id
);
```

* ✅ Checks if a subquery returns any row.

---

## 🔹 16. SELECT with Math or Expressions

```sql
SELECT name, salary, salary * 0.1 AS bonus FROM employees;
```

* Performs calculations inside `SELECT`.

---

## ✅ SELECT Query Order (Behind the Scenes)

```sql
SELECT         -- 5
FROM           -- 1
JOIN           -- 2
WHERE          -- 3
GROUP BY       -- 4
HAVING         -- 6
ORDER BY       -- 7
LIMIT          -- 8
```

---

## 🧠 Tips and Best Practices

* Use `SELECT *` only during testing; prefer specific columns
* Index columns used in `WHERE`, `JOIN`, `ORDER BY` for speed
* Use aliases (`AS`) to make results readable
* Always sanitize dynamic values in production to avoid SQL injection

---

## ✅ Sample Practice Query

```sql
SELECT u.name, u.email, COUNT(o.id) AS orders_placed
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.status = 'active'
GROUP BY u.id
HAVING orders_placed >= 2
ORDER BY orders_placed DESC
LIMIT 10;
```

---
---
---



### 🎯 Sample Tables:

**Table: `employees`**

| emp\_id | name    | dept\_id | salary | age |
| ------- | ------- | -------- | ------ | --- |
| 1       | Alice   | 1        | 60000  | 30  |
| 2       | Bob     | 2        | 55000  | 28  |
| 3       | Charlie | 1        | 70000  | 40  |
| 4       | David   | 3        | 45000  | 25  |

**Table: `departments`**

| dept\_id | dept\_name  |
| -------- | ----------- |
| 1        | HR          |
| 2        | Engineering |
| 3        | Sales       |
| 4        | Marketing   |

---

## ✅ 1. `CONCAT()` – Combine Strings

```sql
SELECT CONCAT(name, ' works in department ', dept_id) AS info
FROM employees;
```

**Result:**

| info                        |
| --------------------------- |
| Alice works in department 1 |
| Bob works in department 2   |

---

## ✅ 2. **Nested Queries (Subqueries)**

📌 **Example: Get employees who earn more than the average salary**

```sql
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);
```

👉 Inner query (`SELECT AVG(...)`) returns `avg_salary`, outer query filters using it.

---

## ✅ 3. **Aggregation (GROUP BY + Aggregate Functions)**

📌 **Example: Average salary by department**

```sql
SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;
```

Common aggregate functions: `SUM()`, `COUNT()`, `MAX()`, `MIN()`, `AVG()`

---

## ✅ 4. **CASE – Conditional Logic in SQL**

📌 **Example: Salary category**

```sql
SELECT name, salary,
  CASE
    WHEN salary >= 65000 THEN 'High'
    WHEN salary >= 50000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_level
FROM employees;
```

---

## ✅ 5. **All Types of JOINS**

---

### 🔸 INNER JOIN

Return only matching rows from both tables.

```sql
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

---

### 🔸 LEFT JOIN

Returns all rows from the left table and matching rows from the right.

```sql
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
```

If a department doesn't match, `dept_name` will be NULL.

---

### 🔸 RIGHT JOIN

Returns all from the right table and matching from the left.

```sql
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

This will show all departments, even if no employees belong to them.

---

### 🔸 FULL OUTER JOIN (Not supported in MySQL directly – use `UNION` workaround)

```sql
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

---

## ✅ 6. `EXISTS` and `NOT EXISTS`

These check **if a subquery returns any rows**.

📌 **Get employees who belong to a valid department (EXISTS)**

```sql
SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM departments d
    WHERE e.dept_id = d.dept_id
);
```

📌 **Get employees whose dept doesn't exist in `departments` (NOT EXISTS)**

```sql
SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM departments d
    WHERE e.dept_id = d.dept_id
);
```

---

## ✅ 7. SELECT with Math Expressions

📌 **Example: Bonus calculation (10% of salary)**

```sql
SELECT name, salary, salary * 0.10 AS bonus
FROM employees;
```

📌 **Another Example: Age next year**

```sql
SELECT name, age, age + 1 AS age_next_year
FROM employees;
```

---

## ✅ BONUS: Combine concepts

📌 **Get each employee’s name, their department name, bonus (15% of salary), and label them based on salary**

```sql
SELECT e.name, d.dept_name,
       salary * 0.15 AS bonus,
       CASE
         WHEN salary > 65000 THEN 'Top Earner'
         ELSE 'Regular'
       END AS status
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
```
