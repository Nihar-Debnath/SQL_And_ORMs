## 🔵 1. **What is a Subquery?**

A **subquery** is a query **inside another query**.

### 📌 Think like this:

You want to ask:

> “Give me names of students **who scored above average**.”

Here, **"average marks"** is itself a result — you need to **calculate that first**.

So:

```sql
SELECT name FROM students
WHERE marks > (SELECT AVG(marks) FROM students);
```

* The part in `(SELECT AVG(marks)...)` is the **subquery**.
* The outer `SELECT name FROM students...` is the **main query**.
* Subquery result is used inside the main query.

---

## 🔵 2. **Types of Subqueries**

Let’s understand each **type**, with clear use cases.

---

### ✅ A. **Single Row Subquery**

**Returns one value only** (like AVG, MAX, etc.)

📌 **Example:**

```sql
SELECT name, marks
FROM students
WHERE marks > (SELECT AVG(marks) FROM students);
```

* Inner query: `SELECT AVG(marks)` → gives 1 value (e.g. 72)
* Outer query compares all students' marks with 72

---

### ✅ B. **Multiple Row Subquery**

**Returns multiple values**, used with `IN`, `ANY`, `ALL`.

📌 **Example:**

```sql
SELECT name
FROM students
WHERE id IN (SELECT student_id FROM toppers);
```

* `IN` compares each `id` in outer query with a **list** returned by subquery.

#### 🎯 Tip:

Use when the subquery returns a **column of multiple rows**.

---

### ✅ C. **Multiple Column Subquery**

Returns **more than one column**, used in **tuple matching**.

📌 **Example:**

```sql
SELECT name, marks, subject
FROM students
WHERE (marks, subject) IN (
  SELECT max_marks, subject FROM subject_toppers
);
```

* Here, `(marks, subject)` pair is matched against result pairs.

---

### ✅ D. **Correlated Subquery** (🔥 Important)

This subquery is **linked to the outer query** — it runs **once for each row** of the outer query.

📌 **Example:**

```sql
SELECT name
FROM students s1
WHERE marks > (
    SELECT AVG(marks)
    FROM students s2
    WHERE s1.subject = s2.subject
);
```

* This checks: "Is this student’s mark higher than the average **in the same subject**?"
* Subquery depends on outer row (`s1.subject`).

#### ⚠️ Slower but very powerful.

---

### ✅ E. **Subquery in FROM Clause (Derived Table)**

You can write a subquery in the FROM clause to **create a temporary table**.

📌 **Example:**

```sql
SELECT subject, AVG(marks) AS avg_marks
FROM (
    SELECT subject, marks FROM students
) AS temp
GROUP BY subject;
```

* The subquery becomes a temporary table called `temp`.

---

### ✅ F. **Subquery in SELECT Clause**

Returns a **single value per row**, often constant.

📌 **Example:**

```sql
SELECT name, marks,
    (SELECT MAX(marks) FROM students) AS top_score
FROM students;
```

* Adds the **top score of the class** beside every student.

---

## 🔵 3. Subquery with Operators

| Operator      | Description                              |
| ------------- | ---------------------------------------- |
| `IN`          | Match with multiple values               |
| `=`, `>`, `<` | For single-value subquery                |
| `ANY`         | Compare if true for **any** result       |
| `ALL`         | Compare if true for **all** results      |
| `EXISTS`      | Returns true if subquery returns any row |
| `NOT EXISTS`  | True if subquery returns nothing         |

---

### ✅ `EXISTS` Example

📌 Find students who have **submitted** the exam:

```sql
SELECT name
FROM students s
WHERE EXISTS (
    SELECT 1 FROM exam_submissions es
    WHERE s.id = es.student_id
);
```

* Checks: for each student, does there **exist** a submission?

---

## 🔵 4. Real-World Visualization

Imagine this `students` table:

| id | name  | subject | marks |
| -- | ----- | ------- | ----- |
| 1  | Riya  | Math    | 89    |
| 2  | Arjun | Math    | 76    |
| 3  | Priya | Physics | 91    |
| 4  | Rahul | Physics | 68    |

---

### ✅ A: Who scored more than average?

```sql
SELECT name
FROM students
WHERE marks > (SELECT AVG(marks) FROM students);
```

* AVG(marks) = (89+76+91+68)/4 = 81
* Result: Riya, Priya

---

### ✅ B: Who topped in their own subject?

```sql
SELECT name
FROM students s1
WHERE marks = (
    SELECT MAX(marks)
    FROM students s2
    WHERE s1.subject = s2.subject
);
```

* Riya (89 in Math), Priya (91 in Physics)

---

## 🔵 5. JOIN vs Subquery (Clear difference)

Let’s say you want **employee name** and their **department name**.

With JOIN:

```sql
SELECT e.name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.id;
```

With Subquery:

```sql
SELECT name,
    (SELECT dept_name FROM departments WHERE id = e.dept_id)
FROM employees e;
```

✅ **JOIN is faster for multi-row joins**, but **subquery** is good for calculations or filters.

---

## 🔵 6. Summary Table

| Use Case                    | Use Type            | Speed  |
| --------------------------- | ------------------- | ------ |
| Filter with one value       | Single-row          | Fast   |
| Match multiple IDs          | Multi-row           | Medium |
| Per-row logic               | Correlated          | Slow   |
| Temporary table             | FROM clause         | Medium |
| Constant or computed column | SELECT clause       | Fast   |
| Presence check              | EXISTS / NOT EXISTS | Fast   |








---
---
---





### ✅ What is a Subquery in SQL?

A **subquery** (or inner query or nested query) is a **query embedded inside another query**, often within:

* `SELECT`
* `FROM`
* `WHERE`
* `HAVING` clauses

The **main query** that contains the subquery is called the **outer query**.

---

### ✅ Why are Subqueries Used?

Subqueries are used to:

* **Break down complex problems** into smaller parts
* **Retrieve intermediate results** to use in a larger query
* Make queries **dynamic**, depending on another result
* Help in **filtering**, **calculating**, or **transforming data**

---

### ✅ Types of Subqueries

#### 1. **Single-row Subquery**

Returns **only one row and one column** (scalar).

```sql
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

> This finds employees whose salary is above the average salary.

---

#### 2. **Multiple-row Subquery**

Returns **multiple rows**, usually used with `IN`, `ANY`, `ALL`.

```sql
SELECT first_name, department
FROM employees
WHERE department IN (SELECT department FROM departments WHERE location = 'New York');
```

---

#### 3. **Multiple-column Subquery**

Returns multiple columns, used in tuple comparisons.

```sql
SELECT first_name, salary, department
FROM employees
WHERE (salary, department) IN (
    SELECT salary, department FROM job_openings
);
```

---

#### 4. **Correlated Subquery**

This subquery **depends on the outer query** and is **executed once for each row** in the outer query.

```sql
SELECT e1.first_name, salary
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e1.department = e2.department
);
```

> This finds employees earning more than the **average salary of their department**.

---

#### 5. **Subquery in the `FROM` clause (Derived Table)**

You can create a **temporary table** using a subquery.

```sql
SELECT dept, AVG(salary) AS avg_salary
FROM (
    SELECT department AS dept, salary
    FROM employees
) AS dept_salaries
GROUP BY dept;
```

---

#### 6. **Subquery in the `SELECT` clause**

Use a subquery to calculate a value per row.

```sql
SELECT 
    first_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary
FROM 
    employees;
```

---

### ✅ Operators Used with Subqueries

| Operator     | Use Case Example                               |
| ------------ | ---------------------------------------------- |
| `IN`         | `WHERE id IN (SELECT id FROM ...)`             |
| `NOT IN`     | Exclude matches from subquery                  |
| `=`          | `WHERE salary = (SELECT MAX(salary) FROM ...)` |
| `>` `<`      | Comparison with a single result                |
| `ANY`        | `> ANY (SELECT salary FROM ...)`               |
| `ALL`        | `< ALL (SELECT salary FROM ...)`               |
| `EXISTS`     | `WHERE EXISTS (SELECT 1 FROM ...)`             |
| `NOT EXISTS` | Check for absence of matching rows             |

---

### ✅ `EXISTS` vs `IN`

* `EXISTS` checks if **at least one row** exists in the subquery result. Stops as soon as one match is found.
* `IN` returns **all** values from subquery and compares.

```sql
-- Find employees who have a manager
SELECT first_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM employees m WHERE e.manager_id = m.employee_id
);
```

---

### ✅ Subquery vs JOIN

| Subquery                                | JOIN                                |
| --------------------------------------- | ----------------------------------- |
| Often easier to read for isolated logic | Often faster for large datasets     |
| Good for filtering and scalar results   | Better for combining related tables |
| May run per row (correlated)            | One-pass for all rows               |

---

### ⚠️ Performance Tips

* Prefer **JOINs** over correlated subqueries for large data.
* Use **indexes** on columns involved in subqueries.
* Avoid `NOT IN` with **NULLs** (can give wrong results).



---
---
---






## 🔷 What is a Complex Subquery?

A **complex subquery** is any subquery that:

* Uses **multiple layers** (nested subqueries),
* Involves **GROUP BY**, **JOIN**, or **HAVING**
* Combines with **IN, EXISTS, CASE, ANY, ALL, etc.**
* May even return **entire tables** (used in `FROM` clause)

---

## 🔹 Structure Types of Subqueries

| Subquery Location | Example                               | Usage              |
| ----------------- | ------------------------------------- | ------------------ |
| `WHERE` clause    | `WHERE id IN (SELECT ...)`            | Filter rows        |
| `FROM` clause     | `FROM (SELECT ...) AS sub`            | Use as a table     |
| `SELECT` clause   | `SELECT (SELECT COUNT(...))`          | Return value       |
| `HAVING` clause   | `HAVING COUNT(*) > (SELECT AVG(...))` | Aggregated filters |

---

# ✅ 1. Subquery in `SELECT` Clause

> To calculate a value and show in result

### 🔍 Example:

```sql
SELECT 
  name,
  (SELECT COUNT(*) 
   FROM orders o 
   WHERE o.customer_id = c.id) AS total_orders
FROM customers c;
```

### 🔸 Use:

* Shows how many orders **each customer** made.
* Subquery returns **a value** per row (scalar subquery)

---

# ✅ 2. Subquery in `FROM` Clause

> Treated like a table → You can `JOIN`, `GROUP BY`, etc.

### 🔍 Example:

```sql
SELECT sub.customer_id, sub.total_amount
FROM (
   SELECT customer_id, SUM(amount) AS total_amount
   FROM orders
   GROUP BY customer_id
) AS sub
WHERE sub.total_amount > 1000;
```

### 🔸 Use:

* Filters customers whose **total purchase** is over 1000
* Subquery does grouping, outer query filters

---

# ✅ 3. Subquery in `HAVING` Clause

> Used with `GROUP BY` for aggregate filtering

### 🔍 Example:

```sql
SELECT department_id, AVG(salary) AS avg_sal
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

### 🔸 Use:

* Find departments where avg salary > overall avg salary

---

# ✅ 4. Nested Subqueries (Subquery inside subquery)

> One subquery **feeds into another** — very powerful

### 🔍 Example:

```sql
SELECT name 
FROM employees 
WHERE id IN (
    SELECT manager_id 
    FROM employees 
    WHERE department_id IN (
        SELECT department_id
        FROM departments
        WHERE location = 'Kolkata'
    )
);
```

### 🔸 Use:

* Find employees who manage departments in Kolkata

---

# ✅ 5. Subqueries with `ANY`, `ALL`, `SOME`

| Operator | Meaning                             |
| -------- | ----------------------------------- |
| `ANY`    | True if **any one** value matches   |
| `ALL`    | True if **all values** match        |
| `SOME`   | Same as `ANY` (alternative keyword) |

### 🔍 Example with `ALL`:

```sql
SELECT name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department_id = 2
);
```

✅ Finds employees whose salary is **higher than everyone** in department 2.

---

# ✅ 6. Subquery + `CASE` Statement

> You can embed subqueries in `CASE` for conditional values.

### 🔍 Example:

```sql
SELECT name,
  CASE 
    WHEN (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) > 10 
    THEN 'Premium'
    ELSE 'Regular'
  END AS customer_type
FROM customers c;
```

---

# ✅ 7. Combining JOIN + Subqueries

You can combine subqueries with `JOIN` for complex filtering or derived data.

```sql
SELECT c.name, o.total
FROM customers c
JOIN (
    SELECT customer_id, SUM(amount) AS total
    FROM orders
    GROUP BY customer_id
) o ON c.id = o.customer_id
WHERE o.total > 5000;
```

✅ Only customers with total purchase > ₹5000

---

## 🔴 When NOT to Use Subqueries

| Instead Use        | When                                             |
| ------------------ | ------------------------------------------------ |
| `JOIN`             | When performance matters for large datasets      |
| `CTE`              | When subqueries get too nested (for readability) |
| `Window Functions` | For ranking or row-wise calculations             |

---

## 🔷 Summary: Complex Subqueries

| Feature            | Use Case                                |
| ------------------ | --------------------------------------- |
| Subquery in SELECT | Show calculated values per row          |
| Subquery in FROM   | Grouped or filtered table used as input |
| Subquery in HAVING | Filter groups using aggregate condition |
| Nested subqueries  | Multilayer logic and filtering          |
| Subquery + CASE    | Custom conditions per row               |
| Subquery + ALL/ANY | Comparative matching                    |

---
---
---

# 🔵 CORRELATED SUBQUERIES

# 🔵 EXISTS (and NOT EXISTS)

These often **work together**. Let's start by separating them, then see how they **combine**.

---

## 🔷 1. What is a **Correlated Subquery**?

### 📌 Definition:

A **correlated subquery** is a subquery that **uses values from the outer query**. It runs **once for each row** of the outer query.

> It is “correlated” (connected) because it **depends on a column from the outer query**.

---

### 🔍 Example:

Let’s say we have a `students` table:

| id | name  | subject | marks |
| -- | ----- | ------- | ----- |
| 1  | Riya  | Math    | 89    |
| 2  | Arjun | Math    | 76    |
| 3  | Priya | Physics | 91    |
| 4  | Rahul | Physics | 68    |

### ❓Find students who have marks **more than the average in their subject**.

This requires comparing each student's marks with **average marks of the same subject**.

```sql
SELECT name, subject, marks
FROM students s1
WHERE marks > (
    SELECT AVG(marks)
    FROM students s2
    WHERE s1.subject = s2.subject
);
```

### 🔎 What's happening:

* Outer query: `s1` = one student at a time
* Inner query: `s2` = all students, filtered by same `subject`
* So for each outer row, inner subquery is executed again

| name  | subject | marks | subject avg | Result |
| ----- | ------- | ----- | ----------- | ------ |
| Riya  | Math    | 89    | 82.5        | ✅      |
| Arjun | Math    | 76    | 82.5        | ❌      |
| Priya | Physics | 91    | 79.5        | ✅      |
| Rahul | Physics | 68    | 79.5        | ❌      |

✅ Riya and Priya are selected

---

## ✅ 2. Key Points about Correlated Subqueries

| Feature            | Detail                             |
| ------------------ | ---------------------------------- |
| Executed           | Once per row of outer query        |
| Uses               | Outer query column inside subquery |
| Performance        | Slower than normal subqueries      |
| Commonly used with | `EXISTS`, `IN`, `=`, `>`, etc.     |

---

## 🔷 3. What is `EXISTS`?

### 📌 Definition:

`EXISTS` checks if **a subquery returns any row** — if yes, it returns `TRUE`.

### ✅ Syntax:

```sql
SELECT column
FROM table
WHERE EXISTS (subquery);
```

### 🔍 Example:

Suppose we have:

#### Table: `students`

| id | name  |
| -- | ----- |
| 1  | Riya  |
| 2  | Arjun |
| 3  | Priya |

#### Table: `exam_submissions`

| submission\_id | student\_id |
| -------------- | ----------- |
| 101            | 1           |
| 102            | 3           |

### ❓Find students who have submitted exams:

```sql
SELECT name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM exam_submissions es
    WHERE es.student_id = s.id
);
```

### ✅ Output: Riya, Priya

Because only their `id` exists in `exam_submissions`.

---

### ✅ Explanation of EXISTS:

* If **even one row** is returned by subquery → `EXISTS = TRUE`
* Subquery is usually **correlated** to outer query (`s.id = es.student_id`)

### ⚠️ Important:

You can write `SELECT 1` or `SELECT *` — doesn’t matter in `EXISTS`, as it only checks **existence**, not the value.

---

## 🔁 4. How `EXISTS` Uses Correlated Subquery

When you write:

```sql
WHERE EXISTS (
    SELECT 1 FROM ... WHERE inner.col = outer.col
)
```

You're using a **correlated subquery with EXISTS**. The inner subquery is run **once for each outer row**, just like in correlated subqueries.

---

## 🔷 5. What is `NOT EXISTS`?

Same as `EXISTS`, but checks that **no rows are returned**.

### 📌 Example:

❓ Find students **who didn’t** submit the exam:

```sql
SELECT name
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM exam_submissions es
    WHERE es.student_id = s.id
);
```

✅ Output: Arjun

---

## ✅ Summary Table

| Concept                 | Description                                       |
| ----------------------- | ------------------------------------------------- |
| **Correlated Subquery** | A subquery that uses a value from the outer query |
| **Executed**            | Once for each row of the outer query              |
| **EXISTS**              | TRUE if subquery returns **any rows**             |
| **NOT EXISTS**          | TRUE if subquery returns **no rows**              |
| **Used in**             | Filters, validations, presence checks             |

---

## ✅ Use Cases Comparison

| Use Case                                | Use        |
| --------------------------------------- | ---------- |
| Compare with value from outer query     | Correlated |
| Filter rows based on existence in table | EXISTS     |
| Filter rows based on absence in table   | NOT EXISTS |
| Check top performers per group          | Correlated |
