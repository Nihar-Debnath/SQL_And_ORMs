## 🔷 1. What is `UPDATE` in SQL?

The `UPDATE` statement is used to **modify existing data** in a table. It can:

* Change a **single row**
* Change **multiple rows**
* Use conditions to target **specific data**
* Even use **subqueries or joins**

---

## 🔹 2. Basic Syntax

```sql
UPDATE table_name
SET column1 = value1,
    column2 = value2,
    ...
WHERE condition;
```

> ⚠️ **Always use a `WHERE` clause** unless you mean to update *every row*.

---

## 🔸 3. Simple Example

Imagine this table:

```sql
CREATE TABLE employees (
    id INT,
    name VARCHAR(50),
    salary DECIMAL(10,2),
    department VARCHAR(50)
);
```

And it has these rows:

| id | name    | salary  | department |
| -- | ------- | ------- | ---------- |
| 1  | Alice   | 50000.0 | Sales      |
| 2  | Bob     | 60000.0 | HR         |
| 3  | Charlie | 55000.0 | IT         |

---

### ✅ Update one row

```sql
UPDATE employees
SET salary = 65000
WHERE id = 2;
```

✔️ Updates Bob’s salary to ₹65,000.

---

### ✅ Update multiple columns

```sql
UPDATE employees
SET salary = 70000, department = 'Operations'
WHERE name = 'Charlie';
```

✔️ Updates Charlie’s salary and department.

---

### ✅ Update multiple rows

```sql
UPDATE employees
SET salary = salary + 5000
WHERE department = 'Sales';
```

✔️ Increases salary of all employees in Sales by ₹5000.

---

## 🔸 4. Update Without WHERE — 🔥 **Danger!**

```sql
UPDATE employees
SET department = 'Fired';
```

⚠️ This will update **every single row** in the table. Be very careful.

---

## 🔸 5. Using Subqueries in `UPDATE`

You can update using a value from a subquery.

```sql
UPDATE employees
SET salary = (SELECT MAX(salary) FROM employees)
WHERE name = 'Alice';
```

✔️ Alice gets the highest salary in the table.

---

## 🔸 6. Update with JOIN (MySQL Syntax)

Let’s say we have a second table:

```sql
CREATE TABLE bonuses (
    emp_id INT,
    bonus_amount DECIMAL(10,2)
);
```

To update salaries using bonuses:

```sql
UPDATE employees e
JOIN bonuses b ON e.id = b.emp_id
SET e.salary = e.salary + b.bonus_amount;
```

✔️ This adds bonus to each employee’s salary.

---

## 🔸 7. Conditional Update with CASE

```sql
UPDATE employees
SET salary = 
  CASE 
    WHEN department = 'Sales' THEN salary + 2000
    WHEN department = 'IT' THEN salary + 3000
    ELSE salary
  END;
```

✔️ Updates differently for each department.

---

## 🔸 8. Update with LIMIT (MySQL only)

```sql
UPDATE employees
SET salary = salary + 1000
LIMIT 2;
```

⚠️ Only updates the **first 2 rows** (based on storage order, not predictable unless ordered).

---

## 🔸 9. Check What Will Change Before Updating

Always test using a `SELECT` before updating:

```sql
SELECT * FROM employees WHERE department = 'Sales';
```

---

## 🔸 10. Rollback Option (in transactions)

If you're using a database that supports transactions (e.g., MySQL with InnoDB, PostgreSQL):

```sql
START TRANSACTION;

UPDATE employees
SET salary = 999999
WHERE name = 'Bob';

-- If needed:
ROLLBACK;

-- Or to save:
COMMIT;
```

---

## 🔸 11. Best Practices

| Practice                         | Why?                        |
| -------------------------------- | --------------------------- |
| Use `WHERE`                      | Prevents accidental updates |
| Use `LIMIT`                      | Test partial updates        |
| Use `SELECT` first               | Preview affected rows       |
| Wrap in transaction              | Makes updates safer         |
| Use `CASE` for conditional logic | Flexible updates            |

---

## ✅ Summary

| Syntax Type        | Example                            |
| ------------------ | ---------------------------------- |
| Simple Update      | `SET col = val WHERE id = 1`       |
| Multi-column       | `SET col1 = val1, col2 = val2`     |
| Subquery Update    | `SET col = (SELECT val ...)`       |
| Join Update        | `UPDATE t1 JOIN t2 ON ...`         |
| Conditional Update | `SET col = CASE WHEN ... THEN ...` |
| All rows (risky)   | `UPDATE table SET col = val`       |
| Transactional      | `START TRANSACTION ... ROLLBACK`   |

---
---
---





## 🔷 What is **Safe Update Mode** in MySQL?

**Safe Update Mode** is a safety feature in MySQL (especially when using tools like MySQL Workbench or command line with `--safe-updates`) that **prevents you from accidentally updating or deleting lots of data** without a condition.

---

## 🔸 What Triggers Safe Update Errors?

In **Safe Update Mode**, the following statements will raise an error:

```sql
UPDATE employees SET salary = 50000;
DELETE FROM employees;
```

> ❌ Because there's **no `WHERE` clause** or **no `LIMIT`** — it's considered dangerous.

---

## 🔶 Example Error Message

You might see:

```
Error Code: 1175
You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.
```

---

## ✅ Allowed in Safe Mode:

These **will work**:

```sql
UPDATE employees SET salary = 50000 WHERE id = 1;

DELETE FROM employees WHERE id = 5;

UPDATE employees SET salary = 60000 LIMIT 1;

UPDATE employees SET salary = 60000 WHERE department = 'Sales' LIMIT 5;
```

✔️ These use `WHERE` and/or `LIMIT`, which are **safe** filters.

---

## 🛠️ How to Disable Safe Update Mode

### ✅ Option 1: Temporary (Session-wise)

```sql
SET SQL_SAFE_UPDATES = 0;
```

Now you can run:

```sql
UPDATE employees SET salary = 50000;
```

To turn it back on:

```sql
SET SQL_SAFE_UPDATES = 1;
```

---

### ✅ Option 2: Permanently Disable in MySQL Workbench

1. Go to **Edit > Preferences**
2. Select **SQL Editor**
3. Uncheck **"Safe Updates"**
4. Restart Workbench

---

## 💡 When Should You Keep It On?

**Keep it ON** when:

* You’re a beginner
* You're running destructive commands (`DELETE`, `UPDATE`) without clear filters
* You want to avoid accidental full-table updates

---

## 🧠 Tip: Preview Before You Update

Before running any risky `UPDATE`:

```sql
SELECT * FROM employees WHERE department = 'Sales';
```

Make sure the filter catches the right rows.

---

## ✅ Summary

| Feature                  | Description                                           |
| ------------------------ | ----------------------------------------------------- |
| **Safe Update Mode**     | Prevents `UPDATE`/`DELETE` without `WHERE` or `LIMIT` |
| **Default in Workbench** | Usually ON to protect users                           |
| **Can Disable with**     | `SET SQL_SAFE_UPDATES = 0;`                           |
| **Best Practice**        | Always use `WHERE`, possibly with `LIMIT`             |
