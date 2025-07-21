## 🔹 What is a FULL JOIN?

A **FULL JOIN** (also called **FULL OUTER JOIN**) returns:

```
ALL records from BOTH tables:
- Matching rows from both tables (where condition is true)
- Non-matching rows from the LEFT table (with NULLs for the right)
- Non-matching rows from the RIGHT table (with NULLs for the left)
```

---

### 🔹 Visual Diagram (Venn Diagram Style)

```
          Table A            Table B
          +-----+            +-----+
          |  A  |<---------->|  B  |
          +-----+            +-----+

     FULL JOIN = All A + All B
                + Matching AB
```

* Returns entire **outer area** (left-only + right-only + matched)

---

## 🔹 Syntax of FULL JOIN (Standard SQL)

```sql
SELECT *
FROM table1
FULL JOIN table2
ON table1.common_column = table2.common_column;
```

> 🔸 But **MySQL does NOT support FULL JOIN directly**
> (more on workaround later)

---

## 🔹 Example

Let’s say we have two tables:

### 🧾 Table: `students`

| student\_id | name    |
| ----------- | ------- |
| 1           | Alice   |
| 2           | Bob     |
| 3           | Charlie |

### 🧾 Table: `marks`

| student\_id | score |
| ----------- | ----- |
| 2           | 88    |
| 3           | 92    |
| 4           | 85    |

---

### ✅ FULL JOIN Result

```sql
SELECT *
FROM students
FULL JOIN marks
ON students.student_id = marks.student_id;
```

| student\_id | name    | student\_id | score |
| ----------- | ------- | ----------- | ----- |
| 1           | Alice   | NULL        | NULL  |
| 2           | Bob     | 2           | 88    |
| 3           | Charlie | 3           | 92    |
| NULL        | NULL    | 4           | 85    |

* **Alice** has no mark → NULL from `marks`
* **Student ID 4** has no name → NULL from `students`

---

## 🔹 MySQL Workaround for FULL JOIN

Since MySQL doesn't support `FULL JOIN` directly, we simulate it using `LEFT JOIN + RIGHT JOIN + UNION`.

```sql
-- MySQL full join workaround
SELECT *
FROM students
LEFT JOIN marks ON students.student_id = marks.student_id

UNION

SELECT *
FROM students
RIGHT JOIN marks ON students.student_id = marks.student_id;
```

> 🔸 `UNION` removes duplicates; use `UNION ALL` if you want to keep them.

---

## 🔹 Key Points About FULL JOIN

| Feature               | Description                           |
| --------------------- | ------------------------------------- |
| Shows unmatched rows? | ✅ From both tables                    |
| Matching condition    | `ON` clause (like any JOIN)           |
| NULLs?                | Shown where no match exists           |
| Duplicate handling    | Depends on `UNION` or `UNION ALL`     |
| Sorting               | Use `ORDER BY` after the entire join  |
| Filtering             | Use `WHERE`, but carefully with NULLs |

---

## 🔹 Filtering Example

```sql
-- All students without marks (LEFT only)
SELECT *
FROM students
LEFT JOIN marks ON students.student_id = marks.student_id
WHERE marks.student_id IS NULL;
```

```sql
-- All marks with no student (RIGHT only)
SELECT *
FROM students
RIGHT JOIN marks ON students.student_id = marks.student_id
WHERE students.student_id IS NULL;
```

---

## 🔹 Practical Use Cases

| Scenario                 | Use FULL JOIN for...                                             |
| ------------------------ | ---------------------------------------------------------------- |
| Students vs Marks        | Show all students and all test entries                           |
| Employees vs Attendance  | Find employees not logged in, and logins not mapped to employees |
| Products vs Sales        | View full catalog + all sold products                            |
| Subscribers vs Purchases | Combine email list and buyers, see overlaps and gaps             |

---

## 🔹 Summary

| JOIN Type   | Includes...                    |
| ----------- | ------------------------------ |
| INNER JOIN  | Only matching rows             |
| LEFT JOIN   | All left + matches             |
| RIGHT JOIN  | All right + matches            |
| ✅ FULL JOIN | All left + all right + matches |
