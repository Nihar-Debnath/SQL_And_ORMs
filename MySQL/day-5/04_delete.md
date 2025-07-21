## 🔷 1. What is `DELETE` in SQL?

The `DELETE` statement is used to **remove one or more rows** from a table.

Syntax:

```sql
DELETE FROM table_name
WHERE condition;
```

> ❗**If you skip the `WHERE` clause, it will delete all rows!**

---

## ✅ 2. How to Delete Specific Rows

### 👉 Delete a row by primary key:

```sql
DELETE FROM employees
WHERE employee_id = 3;
```

### 👉 Delete multiple rows with a condition:

```sql
DELETE FROM employees
WHERE department = 'Sales';
```

### 👉 Delete top N rows (in MySQL):

```sql
DELETE FROM employees
ORDER BY hire_date ASC
LIMIT 5;
```

> ✔️ Useful when Safe Update Mode is on.

---

## ⚠️ 3. Deleting ALL Rows

### ❌ Dangerous if unintentional:

```sql
DELETE FROM employees;
```

This will delete **all** rows but keep the **table structure intact**.

---

## 🔥 4. DELETE vs TRUNCATE vs DROP

| Feature                    | `DELETE`              | `TRUNCATE`        | `DROP`                   |
| -------------------------- | --------------------- | ----------------- | ------------------------ |
| **Purpose**                | Removes specific rows | Removes all rows  | Removes table completely |
| **WHERE clause**           | ✅ Allowed             | ❌ Not allowed     | ❌ Not applicable         |
| **Rollback possible**      | ✅ (with transaction)  | ❌ (in most DBMSs) | ❌                        |
| **Resets AUTO\_INCREMENT** | ❌                     | ✅ Yes             | ✅ Yes                    |
| **Triggers fired?**        | ✅ Yes                 | ❌ No              | ❌                        |
| **Speed**                  | ❌ Slower (row-by-row) | ✅ Faster          | ❌ N/A                    |

---

## 🧪 Examples

### Example Table:

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    department VARCHAR(30),
    hire_date DATE
);
```

### Insert sample data:

```sql
INSERT INTO employees (name, department, hire_date)
VALUES
('Alice', 'Sales', '2020-01-01'),
('Bob', 'HR', '2019-03-15'),
('Charlie', 'Sales', '2021-05-10');
```

---

### ✅ Delete only Sales department employees

```sql
DELETE FROM employees
WHERE department = 'Sales';
```

### ✅ Delete all rows

```sql
DELETE FROM employees;
```

---

### ✅ Truncate the table

```sql
TRUNCATE TABLE employees;
```

> All rows are gone, and `id` will reset to 1 if it's AUTO\_INCREMENT.

---

### ✅ Drop the table (careful!)

```sql
DROP TABLE employees;
```

> Removes the **entire table** including structure — cannot be recovered.

---

## 🛡️ Safe Practices

* Always use a `WHERE` clause unless you really want to remove everything.
* Use `SELECT` first to confirm what will be deleted:

```sql
SELECT * FROM employees WHERE department = 'Sales';
```

Then:

```sql
DELETE FROM employees WHERE department = 'Sales';
```

* Consider using transactions when supported:

```sql
START TRANSACTION;

DELETE FROM employees WHERE department = 'Sales';

ROLLBACK; -- or COMMIT;
```

---

## ✅ Summary

| Operation  | Deletes Rows      | Keeps Table | Can Filter | Fast | Rollback |
| ---------- | ----------------- | ----------- | ---------- | ---- | -------- |
| `DELETE`   | ✅                 | ✅           | ✅          | ❌    | ✅        |
| `TRUNCATE` | ✅ (All rows)      | ✅           | ❌          | ✅    | ❌        |
| `DROP`     | ✅ (and structure) | ❌           | ❌          | ✅    | ❌        |
