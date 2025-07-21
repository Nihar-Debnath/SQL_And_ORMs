## ✅ BASIC UNION EXAMPLES

---

### 🔹 **Example 1: UNION vs UNION ALL**

```sql
-- Without duplicates
SELECT first_name, last_name, email FROM headquarters_employees
UNION
SELECT first_name, last_name, email FROM branch_employees;
```

* Combines employee records from **both tables**
* If an employee (like Robert Williams) exists in both, only **one record appears** (duplicate removed)
* Uses `UNION` → **removes duplicates**

```sql
-- With duplicates
SELECT first_name, last_name, email FROM headquarters_employees
UNION ALL
SELECT first_name, last_name, email FROM branch_employees;
```

* Same query as above, but using `UNION ALL`
* All records are included, **even duplicates**
* Faster because it doesn’t check for duplicates

---

### 🔹 **Example 2: Combining full tables**

```sql
SELECT * FROM headquarters_employees
UNION ALL
SELECT * FROM branch_employees;
```

* Combines **entire structure** of both tables row-wise
* Assumes both tables have the **same schema**
* Uses `UNION ALL` to include duplicates (e.g., Robert Williams will appear twice)

---

## ✅ ADVANCED UNION EXAMPLES

---

### 🔹 **Example 3: Adding a descriptor column**

```sql
SELECT first_name, last_name, email, 'Employee' AS contact_type
FROM headquarters_employees
UNION
SELECT first_name, last_name, email, 'Customer' AS contact_type
FROM customers;
```

* Merges employees and customers
* Adds a **static label** (alias `contact_type`) to identify source

  * `'Employee'` for employees
  * `'Customer'` for customers
* Useful for creating unified contact lists

📝 All columns must **match in number and type**, so even the `'Employee'` and `'Customer'` strings are treated as a column (`VARCHAR`).

---

### 🔹 **Example 4: Ordering results after UNION**

```sql
SELECT employee_id, first_name, last_name, department
FROM headquarters_employees
UNION
SELECT employee_id, first_name, last_name, department
FROM branch_employees
ORDER BY last_name;
```

* Combines employees from both tables
* Removes duplicates
* Final result is sorted by `last_name`
* **ORDER BY comes at the end**, not inside individual SELECTs

---

### 🔹 **Example 5: Filtering before UNION**

```sql
SELECT employee_id, first_name, last_name, department, salary
FROM headquarters_employees
WHERE salary > 70000
UNION
SELECT employee_id, first_name, last_name, department, salary
FROM branch_employees
WHERE salary > 70000
ORDER BY salary DESC;
```

* Each `SELECT` filters high-salary employees (`>70000`) **before** union
* `UNION` removes duplicates
* Final result is ordered by `salary` descending

✅ Efficient filtering and ordering
✅ Removes duplicate employees if any (e.g., Robert Williams with 82000)

---

## ✅ HANDLING DIFFERENT TABLE STRUCTURES

---

### 🔹 **Example 6: Handling different table structures with NULLs**

```sql
SELECT employee_id, first_name, last_name, department, salary, NULL AS status
FROM headquarters_employees
UNION
SELECT customer_id, first_name, last_name, NULL, NULL, status
FROM customers
ORDER BY first_name, last_name;
```

* Combines **employee and customer** data
* Employee table lacks `status` → fill with `NULL`
* Customer table lacks `department` and `salary` → fill with `NULL`
* **Columns aligned positionally**:

  * ID → ID
  * Name → Name
  * Dept/Salary → NULL for customers
  * Status → NULL for employees
* This is a powerful way to combine differently structured tables

---

## ✅ PRACTICAL USE CASES

---

### 🔹 **Example 7: All unique departments**

```sql
SELECT department
FROM headquarters_employees
UNION
SELECT department
FROM branch_employees;
```

* Gets all unique departments across both locations
* `UNION` ensures no duplicates (e.g., "HR" appears only once)

---

### 🔹 **Example 8: Common departments**

```sql
SELECT department FROM (
    SELECT DISTINCT department
    FROM headquarters_employees
    UNION ALL
    SELECT DISTINCT department
    FROM branch_employees
) AS combined 
GROUP BY department 
HAVING COUNT(*) = 2;
```

* This is a **clever trick to find common values**
* Steps:

  1. Use `UNION ALL` to get **all departments** from both tables
  2. `DISTINCT` removes repeated departments **within** a table
  3. Group by department and keep only those that appear **twice** (i.e., in both locations)

🎯 Result: Departments that exist in **both** tables.

---

## 🧠 Summary of UNION Concepts

| Concept                          | UNION                                              | UNION ALL                                        |
| -------------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| Removes duplicates?              | ✅ Yes                                              | ❌ No                                             |
| Performance                      | Slightly slower                                    | Faster                                           |
| Use case                         | You want unique results                            | You want complete results (including duplicates) |
| Column count/type                | Must be same                                       | Must be same                                     |
| Uses first SELECT's column names | ✅                                                  | ✅                                                |
| Can combine different tables     | ✅ Yes, use `NULL` placeholders for missing columns | ✅                                                |
