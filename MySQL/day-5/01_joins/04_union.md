In SQL, the `UNION` operator is used to **combine the results of two or more `SELECT` statements** into a **single result set**. It removes duplicate rows by default.

---

### 🔹 1. **Basic Syntax of UNION**

```sql
SELECT column1, column2, ...
FROM table1
UNION
SELECT column1, column2, ...
FROM table2;
```

* All `SELECT` statements within the `UNION` must have:

  * The same number of columns
  * The same or compatible data types
  * The columns must be in the same order

---

### 🔹 2. **Example**

#### Table: `students_2024`

| name    | branch |
| ------- | ------ |
| Alice   | CSE    |
| Bob     | ECE    |
| Charlie | ME     |

#### Table: `students_2025`

| name  | branch |
| ----- | ------ |
| David | CSE    |
| Bob   | ECE    |
| Eva   | CE     |

```sql
SELECT name, branch FROM students_2024
UNION
SELECT name, branch FROM students_2025;
```

#### ✅ Result:

| name    | branch |
| ------- | ------ |
| Alice   | CSE    |
| Bob     | ECE    |
| Charlie | ME     |
| David   | CSE    |
| Eva     | CE     |

> 🔸 **Note**: Duplicate row ("Bob", "ECE") appears only once.

---

### 🔹 3. **UNION vs UNION ALL**

#### 🔸 `UNION` removes duplicates

#### 🔸 `UNION ALL` keeps **all** records (including duplicates)

```sql
SELECT name FROM students_2024
UNION ALL
SELECT name FROM students_2025;
```

* Use `UNION ALL` if you **want better performance** and **don’t care about duplicates**, because `UNION` performs **duplicate sorting**, which takes time.

---

### 🔹 4. **Column Names in UNION Result**

* The **column names in the final result set** are taken from the **first SELECT** statement.

Example:

```sql
SELECT name AS student_name FROM students_2024
UNION
SELECT name FROM students_2025;
```

The final result will have the column name `student_name`.

---

### 🔹 5. **Using ORDER BY with UNION**

* Apply `ORDER BY` only **at the end**, not in individual `SELECT`s.

✅ Correct:

```sql
SELECT name FROM students_2024
UNION
SELECT name FROM students_2025
ORDER BY name;
```

❌ Incorrect:

```sql
SELECT name FROM students_2024 ORDER BY name  -- ❌ not allowed
UNION
SELECT name FROM students_2025;
```

---

### 🔹 6. **Using WHERE and LIMIT in Individual Queries**

You **can** use `WHERE`, `LIMIT`, etc., in each `SELECT`.

```sql
SELECT name FROM students_2024 WHERE branch = 'CSE'
UNION
SELECT name FROM students_2025 WHERE branch = 'CSE';
```

---

### 🔹 7. **Data Type Compatibility**

Each column in both SELECTs must be of the **same or compatible** data types. For example:

* INT with FLOAT → ok
* VARCHAR with TEXT → ok
* INT with VARCHAR → sometimes ok (depends on DBMS)

If data types mismatch, you may get an error or unexpected output.

---

### 🔹 8. **UNION of Different Tables with Different Column Names**

Column names don’t need to be the same, but the **position and type should match**.

```sql
SELECT name, branch FROM students_2024
UNION
SELECT student_name, student_branch FROM students_2025;
```

---

### 🔹 9. **UNION on Derived Tables or Subqueries**

```sql
SELECT * FROM (
    SELECT name FROM students_2024 WHERE branch = 'CSE'
    UNION
    SELECT name FROM students_2025 WHERE branch = 'CSE'
) AS all_cse_students;
```

---

### 🔹 10. **Common Errors with UNION**

| Error                                      | Cause                           | Fix                            |
| ------------------------------------------ | ------------------------------- | ------------------------------ |
| `SELECTs have different number of columns` | Mismatch in number of columns   | Match the column count         |
| `Incompatible types`                       | e.g. VARCHAR vs INT             | Use `CAST()` to convert        |
| `ORDER BY not allowed here`                | Used inside SELECT before UNION | Use ORDER BY after all SELECTs |

---

### 🔹 11. **Use Cases of UNION**

* Combine results from different years/tables (like students\_2024 and students\_2025)
* Merge search results from multiple tables
* Pull data from partitioned tables