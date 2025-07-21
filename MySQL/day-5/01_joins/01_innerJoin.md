## 🔸 What is `INNER JOIN`?

**INNER JOIN** returns **only the matching rows** from both tables based on a condition (usually equality of keys).
If a row in **either table** doesn’t have a match, it will **not** appear in the result.

---

## 🔸 INNER JOIN Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;
```

You can also use `JOIN` instead of `INNER JOIN`, they are the same:

```sql
SELECT columns
FROM table1
JOIN table2
ON table1.column = table2.column;
```

---

## 🔸 Example Scenario: Students and Courses

### 🔹 Table 1: `students`

| student\_id | name    |
| ----------- | ------- |
| 1           | Alice   |
| 2           | Bob     |
| 3           | Charlie |

### 🔹 Table 2: `enrollments`

| enrollment\_id | student\_id | course\_name |
| -------------- | ----------- | ------------ |
| 101            | 1           | Math         |
| 102            | 2           | Science      |
| 103            | 4           | History      |

> Note: student\_id = 4 in `enrollments` has no match in `students` table.

---

## 🔸 INNER JOIN Query

```sql
SELECT students.name, enrollments.course_name
FROM students
INNER JOIN enrollments
ON students.student_id = enrollments.student_id;
```

### 🔹 Result:

| name  | course\_name |
| ----- | ------------ |
| Alice | Math         |
| Bob   | Science      |

🟡 `Charlie` is excluded (no course enrolled)
🟡 `enrollment_id 103` is excluded (student ID 4 doesn't exist in students table)

---

## 🔸 Visual Representation

```
students          enrollments
-----------       ----------------
1 | Alice         101 | 1 | Math
2 | Bob    ---->  102 | 2 | Science
3 | Charlie       103 | 4 | History

Only matching student_id from both are returned
```

---

## 🔸 Using Aliases (for cleaner SQL)

```sql
SELECT s.name, e.course_name
FROM students AS s
INNER JOIN enrollments AS e
ON s.student_id = e.student_id;
```

---

## 🔸 INNER JOIN with WHERE clause

```sql
SELECT s.name, e.course_name
FROM students AS s
INNER JOIN enrollments AS e
ON s.student_id = e.student_id
WHERE e.course_name = 'Math';
```

### 🔹 Result:

| name  | course\_name |
| ----- | ------------ |
| Alice | Math         |

---

## 🔸 INNER JOIN on multiple conditions

If you need more complex joins:

```sql
SELECT *
FROM A
INNER JOIN B
ON A.id = B.a_id AND A.status = B.status;
```

---

## 🔸 INNER JOIN with 3+ tables

```sql
SELECT s.name, e.course_name, c.teacher
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_name = c.course_name;
```

This joins **three** tables: students → enrollments → courses.

---

## 🔸 Things to Remember

| Key Point      | Description                                            |
| -------------- | ------------------------------------------------------ |
| Matching Rows  | Only rows with matches in **both** tables are returned |
| No Match       | Rows with no match in either table are **excluded**    |
| Join Condition | Usually `ON` keyword with key columns                  |
| Aliases        | Make SQL readable, especially with multiple tables     |
| Can Chain      | You can INNER JOIN multiple tables in one query        |

---

## 🔸 Real-Life Examples

1. **Users & Orders**

```sql
SELECT u.name, o.amount
FROM users u
JOIN orders o
ON u.user_id = o.user_id;
```

2. **Employees & Departments**

```sql
SELECT e.name, d.dept_name
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id;
```

3. **Products & Sales**

```sql
SELECT p.name, s.sale_date
FROM products p
JOIN sales s
ON p.product_id = s.product_id;
```

---

## 🔸 Summary Table

| Join Type  | Description                                      |
| ---------- | ------------------------------------------------ |
| INNER JOIN | Returns only matching rows from both tables      |
| LEFT JOIN  | All rows from left + matched rows from right     |
| RIGHT JOIN | All rows from right + matched rows from left     |
| FULL JOIN  | All rows from both sides (not in MySQL natively) |
