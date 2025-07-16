## 🧩 What Is `ALTER TABLE`?

The `ALTER TABLE` command is used to **change the structure of an existing table** — like:

* Add/remove columns
* Modify column type or constraints
* Rename columns or tables
* Add/remove constraints
* Add/remove indexes or keys

---

## 🔷 1. Add a New Column

```sql
ALTER TABLE employees
ADD COLUMN salary DECIMAL(10,2);
```

* ✅ Adds a new column named `salary` to the `employees` table.

---

## 🔷 2. Add Multiple Columns

```sql
ALTER TABLE employees
ADD COLUMN email VARCHAR(100),
ADD COLUMN hire_date DATE;
```

* ✅ Adds both `email` and `hire_date` at once.

---

## 🔷 3. Drop (Remove) a Column

```sql
ALTER TABLE employees
DROP COLUMN salary;
```

* ❌ Removes the column permanently and its data.

---

## 🔷 4. Rename a Column (MySQL 8+)

```sql
ALTER TABLE employees
RENAME COLUMN email TO company_email;
```

* ✅ Changes the column name from `email` to `company_email`.

---

## 🔷 5. Modify a Column’s Data Type or Constraint

```sql
ALTER TABLE employees
MODIFY COLUMN name VARCHAR(150) NOT NULL;
```

* ✅ Changes the data type and adds a `NOT NULL` constraint.

---

## 🔷 6. Change Column Name & Data Type Together

```sql
ALTER TABLE employees
CHANGE COLUMN name full_name VARCHAR(200) NOT NULL;
```

* ✅ Changes:

  * column name: `name → full_name`
  * data type: `VARCHAR(100) → VARCHAR(200)`
  * adds `NOT NULL`

---

## 🔷 7. Rename the Table

```sql
RENAME TABLE employees TO staff;
-- OR
ALTER TABLE employees RENAME TO staff;
```

* ✅ Changes table name from `employees` to `staff`.

---

## 🔷 8. Add a NOT NULL Constraint

```sql
ALTER TABLE employees
MODIFY COLUMN full_name VARCHAR(200) NOT NULL;
```

* ✅ Makes sure the column **cannot be NULL**.

🧠 Be careful! If there are already `NULL` values in this column, this will throw an error.

---

## 🔷 9. Add a DEFAULT Value

```sql
ALTER TABLE employees
ALTER COLUMN hire_date SET DEFAULT CURRENT_DATE;
```

📝 In MySQL:

```sql
ALTER TABLE employees
MODIFY COLUMN hire_date DATE DEFAULT CURRENT_DATE;
```

---

## 🔷 10. Remove a DEFAULT Value

```sql
ALTER TABLE employees
ALTER COLUMN hire_date DROP DEFAULT;
```

📝 In MySQL:

```sql
ALTER TABLE employees
MODIFY COLUMN hire_date DATE;
```

---

## 🔷 11. Add a PRIMARY KEY

```sql
ALTER TABLE employees
ADD PRIMARY KEY (id);
```

🧠 You can only have **one primary key per table**, and it must be **NOT NULL + UNIQUE**.

---

## 🔷 12. Drop a PRIMARY KEY

```sql
ALTER TABLE employees
DROP PRIMARY KEY;
```

---

## 🔷 13. Add a UNIQUE Constraint

```sql
ALTER TABLE employees
ADD UNIQUE (email);
```

* ✅ Ensures `email` values are all unique.

---

## 🔷 14. Add a CHECK Constraint

```sql
ALTER TABLE employees
ADD CONSTRAINT chk_age CHECK (age >= 18);
```

✅ Only allows values where `age >= 18`.

---

## 🔷 15. Drop a CHECK Constraint

```sql
ALTER TABLE employees
DROP CHECK chk_age;
```

---

## 🔷 16. Add a FOREIGN KEY

```sql
ALTER TABLE employees
ADD CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(id);
```

✅ Ensures that `dept_id` in employees exists in `departments.id`

---

## 🔷 17. Drop a FOREIGN KEY

```sql
ALTER TABLE employees
DROP FOREIGN KEY fk_dept;
```

🧠 First, run:

```sql
SHOW CREATE TABLE employees;
```

To get the foreign key name if you forgot it.

---

## 🔷 18. Add an Index

```sql
ALTER TABLE employees
ADD INDEX idx_name (full_name);
```

---

## 🔷 19. Drop an Index

```sql
ALTER TABLE employees
DROP INDEX idx_name;
```

---

## ✅ Summary Cheat Sheet

| Action                        | Query                                              |
| ----------------------------- | -------------------------------------------------- |
| Add column                    | `ADD COLUMN col_name type`                         |
| Remove column                 | `DROP COLUMN col_name`                             |
| Modify column type/constraint | `MODIFY COLUMN col_name new_type`                  |
| Rename column                 | `RENAME COLUMN old TO new`                         |
| Rename table                  | `RENAME TO new_table`                              |
| Add constraint                | `ADD PRIMARY KEY / UNIQUE / CHECK / FOREIGN KEY`   |
| Drop constraint               | `DROP PRIMARY KEY / CHECK name / FOREIGN KEY name` |
| Add/Drop index                | `ADD INDEX`, `DROP INDEX`                          |
