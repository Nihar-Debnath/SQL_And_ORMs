## ✅ 1. `AND` – All conditions must be **true**

### 🔸Syntax:

```sql
SELECT * FROM table_name
WHERE condition1 AND condition2;
```

### 📌 Example:

Get employees who are in **department 1** **and** have a salary **greater than 60000**.

```sql
SELECT * 
FROM employees
WHERE dept_id = 1 AND salary > 60000;
```

✅ **Only employees matching BOTH conditions** will be selected.

---

## ✅ 2. `OR` – **At least one** condition must be **true**

### 🔸Syntax:

```sql
SELECT * FROM table_name
WHERE condition1 OR condition2;
```

### 📌 Example:

Get employees who are either in **department 2** **or** have salary less than **50000**.

```sql
SELECT * 
FROM employees
WHERE dept_id = 2 OR salary < 50000;
```

✅ **If any one condition is true**, the row will be selected.

---

## ✅ 3. `NOT` – Reverses a condition

### 🔸Syntax:

```sql
SELECT * FROM table_name
WHERE NOT condition;
```

### 📌 Example:

Get employees **not in department 1**.

```sql
SELECT * 
FROM employees
WHERE NOT dept_id = 1;
```

✅ This returns employees **except** those in department 1.

---

## ✅ ✅ Combine `AND`, `OR`, `NOT`

### 📌 Example: Complex condition

Get employees **not in department 3** and whose salary is **less than 60000** **or** age is **less than 30**.

```sql
SELECT * 
FROM employees
WHERE NOT dept_id = 3 
AND (salary < 60000 OR age < 30);
```

🧠 **Important Tip:** Use parentheses `()` to group `OR` and `AND` properly when combining them.

---
---
---



## ❓ Why use `IS NULL` instead of `= NULL`?

### ❌ This **does NOT work**:

```sql
SELECT * FROM employees WHERE salary = NULL;
```

⛔ This **will never return any rows** — even if `salary` is actually NULL.

---

## ✅ Correct way:

```sql
SELECT * FROM employees WHERE salary IS NULL;
```

✅ This works and **correctly finds NULL values**.

---

### 🧠 Why?

In SQL, **`NULL` is not a value** — it means “**unknown**” or “**missing**”.

So:

* You **can’t compare anything to NULL** using `=` or `!=`
* Because **`NULL = NULL` is not true**, it’s unknown
* **You must use `IS NULL`** or `IS NOT NULL` to check for NULLs

---

### ✅ Examples:

#### Table: `employees`

| emp\_id | name    | salary |
| ------- | ------- | ------ |
| 1       | Alice   | 60000  |
| 2       | Bob     | NULL   |
| 3       | Charlie | 70000  |

#### ✅ Find people with missing salaries:

```sql
SELECT * FROM employees WHERE salary IS NULL;
```

✅ Returns Bob.

---

## ❓ What happens with math like `salary + NULL`?

```sql
SELECT name, salary + NULL AS total
FROM employees;
```

📌 If `salary` is **not NULL**, result = `NULL`
📌 If `salary` is **NULL**, result = `NULL`

🔴 Because any math with NULL becomes NULL.

---

## ✅ Summary

| Operation         | Result            |
| ----------------- | ----------------- |
| `NULL = NULL`     | ❌ False (Unknown) |
| `IS NULL`         | ✅ Correct         |
| `= NULL`          | ❌ Wrong           |
| `NULL + anything` | NULL              |