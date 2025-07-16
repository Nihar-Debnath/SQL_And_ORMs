## ✅ Comparison Operators in MySQL

| Operator     | Meaning                        | Example                          |
| ------------ | ------------------------------ | -------------------------------- |
| `=`          | Equal to                       | `salary = 50000`                 |
| `!=` or `<>` | Not equal to                   | `salary != 50000`                |
| `>`          | Greater than                   | `salary > 50000`                 |
| `<`          | Less than                      | `age < 30`                       |
| `>=`         | Greater than or equal to       | `salary >= 60000`                |
| `<=`         | Less than or equal to          | `age <= 25`                      |
| `<=>`        | **NULL-safe equal to**         | `value <=> NULL`                 |
| `IS`         | Compare with NULL or boolean   | `salary IS NULL`                 |
| `IS NOT`     | Opposite of `IS`               | `salary IS NOT NULL`             |
| `BETWEEN`    | Between two values (inclusive) | `salary BETWEEN 40000 AND 60000` |
| `IN`         | Match any value in list        | `dept_id IN (1, 2, 3)`           |
| `NOT IN`     | Not in the list                | `dept_id NOT IN (4, 5)`          |
| `LIKE`       | Pattern match (with `%`, `_`)  | `name LIKE 'A%'`                 |
| `NOT LIKE`   | Opposite of LIKE               | `name NOT LIKE '%z%'`            |
| `REGEXP`     | Regex pattern match            | `name REGEXP '^A'`               |
| `NOT REGEXP` | Opposite of REGEXP             | `name NOT REGEXP '[aeiou]'`      |
| `EXISTS`     | True if subquery returns rows  | `WHERE EXISTS (...)`             |
| `NOT EXISTS` | Opposite of EXISTS             | `WHERE NOT EXISTS (...)`         |

---

## ✅ Examples using a sample table `employees`

| emp\_id | name    | salary | age |
| ------- | ------- | ------ | --- |
| 1       | Alice   | 60000  | 30  |
| 2       | Bob     | NULL   | 28  |
| 3       | Charlie | 70000  | 40  |
| 4       | David   | 45000  | 25  |

---

### 🔸 `=` (Equal To)

```sql
SELECT * FROM employees WHERE salary = 60000;
```

---

### 🔸 `!=` or `<>` (Not Equal To)

```sql
SELECT * FROM employees WHERE age != 30;
```

---

### 🔸 `>` and `<`

```sql
SELECT * FROM employees WHERE salary > 50000;
SELECT * FROM employees WHERE age < 30;
```

---

### 🔸 `>=` and `<=`

```sql
SELECT * FROM employees WHERE age >= 25;
```

---

### 🔸 `<=>` (NULL-safe Equal To)

💡 This is the **only operator** that correctly handles `NULL`.

```sql
SELECT * FROM employees WHERE salary <=> NULL;
```

✅ Returns rows where `salary IS NULL`.

---

### 🔸 `IS NULL` and `IS NOT NULL`

```sql
SELECT * FROM employees WHERE salary IS NULL;
SELECT * FROM employees WHERE salary IS NOT NULL;
```

---

### 🔸 `BETWEEN`

```sql
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 65000;
```

✅ Includes 50000 and 65000.

---

### 🔸 `IN` and `NOT IN`

```sql
SELECT * FROM employees WHERE age IN (25, 28);
SELECT * FROM employees WHERE emp_id NOT IN (2, 4);
```

---

### 🔸 `LIKE` and `NOT LIKE`

```sql
SELECT * FROM employees WHERE name LIKE 'A%';     -- Starts with A
SELECT * FROM employees WHERE name NOT LIKE '%e'; -- Not ending with e
```

---

### 🔸 `REGEXP` and `NOT REGEXP`

```sql
SELECT * FROM employees WHERE name REGEXP '^A';  -- Starts with A
SELECT * FROM employees WHERE name NOT REGEXP '[aeiou]$'; -- Doesn't end with vowel
```

---

### 🔸 `EXISTS` and `NOT EXISTS`

Used with subqueries:

```sql
SELECT * FROM employees e
WHERE EXISTS (
  SELECT 1 FROM departments d
  WHERE e.dept_id = d.dept_id
);
```

---

## ✅ Summary Table (Cheat Sheet)

| Type           | Operator(s)                  | Description                         |
| -------------- | ---------------------------- | ----------------------------------- |
| Equal          | `=`, `<=>`                   | Standard and NULL-safe equality     |
| Not Equal      | `!=`, `<>`                   | Both mean not equal                 |
| Compare        | `>`, `<`, `>=`, `<=`         | Standard number comparisons         |
| NULL Checks    | `IS`, `IS NOT`               | For `NULL` or `TRUE`/`FALSE` checks |
| Range          | `BETWEEN`                    | Inclusive range                     |
| Multiple Match | `IN`, `NOT IN`               | List of allowed values              |
| Pattern Match  | `LIKE`, `NOT LIKE`, `REGEXP` | Wildcards & regex                   |
| Existence      | `EXISTS`, `NOT EXISTS`       | Subquery row existence              |

---
---
---



## ✅ Common Date/Time Formats in MySQL

| Type        | Format Example          |
| ----------- | ----------------------- |
| `DATE`      | `'2024-07-16'`          |
| `DATETIME`  | `'2024-07-16 14:35:00'` |
| `TIME`      | `'14:35:00'`            |
| `TIMESTAMP` | `'2024-07-16 14:35:00'` |

---

## ✅ Comparison Operators You Can Use

| Operator     | Meaning                    | Example                                      |
| ------------ | -------------------------- | -------------------------------------------- |
| `=`          | Exact match                | `date = '2024-07-16'`                        |
| `!=` or `<>` | Not equal                  | `date <> '2024-07-16'`                       |
| `<`, `>`     | Before / After             | `date < '2024-07-16'`                        |
| `<=`, `>=`   | Before or on / After or on | `datetime >= '2024-07-01 00:00:00'`          |
| `BETWEEN`    | Within range (inclusive)   | `date BETWEEN '2024-07-01' AND '2024-07-31'` |
| `IN`         | Match from list            | `date IN ('2024-07-15', '2024-07-16')`       |

---

## ✅ Example Table: `orders`

| order\_id | order\_date         |
| --------- | ------------------- |
| 1         | 2024-07-15 10:20:00 |
| 2         | 2024-07-16 09:00:00 |
| 3         | 2024-07-17 14:00:00 |

---

## ✅ 1. Compare exact date

```sql
SELECT * FROM orders
WHERE DATE(order_date) = '2024-07-16';
```

🔹 Use `DATE()` to extract just the date part from `DATETIME`.

---

## ✅ 2. Greater or less than

```sql
SELECT * FROM orders
WHERE order_date > '2024-07-15 12:00:00';
```

✅ Gets records after 12 PM on July 15.

---

## ✅ 3. Date range

```sql
SELECT * FROM orders
WHERE order_date BETWEEN '2024-07-15' AND '2024-07-16 23:59:59';
```

✅ Includes all orders on July 15 and 16.

---

## ✅ 4. With time only

If your column is `TIME`, you can do:

```sql
SELECT * FROM timetable
WHERE time_slot >= '14:00:00';
```

---

## ✅ 5. Comparing with CURRENT\_DATE / NOW()

MySQL has built-in date functions:

| Function       | Meaning             |
| -------------- | ------------------- |
| `CURDATE()`    | Current date only   |
| `NOW()`        | Current datetime    |
| `CURRENT_DATE` | Same as `CURDATE()` |
| `CURRENT_TIME` | Current time only   |

---

### 🔹 Example:

```sql
SELECT * FROM orders
WHERE order_date < NOW();
```

✅ Finds all past orders before the current datetime.

---

## ✅ Extra Tip: Extract parts of the date

Use functions like:

```sql
YEAR(order_date)
MONTH(order_date)
DAY(order_date)
HOUR(order_date)
```

### 🔹 Example: Get orders placed in July

```sql
SELECT * FROM orders
WHERE MONTH(order_date) = 7;
```
