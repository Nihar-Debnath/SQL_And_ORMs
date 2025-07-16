## 🔷 1. What Are Constraints in SQL?

**Constraints** are **rules** you apply to table columns to **control the data** that can go into a table.
They help maintain the **accuracy**, **reliability**, and **integrity** of the data.

---

## 🔷 2. Advantages of Using Constraints

| ✅ Benefit                   | 📌 Description                                      |
| --------------------------- | --------------------------------------------------- |
| 💡 **Data Integrity**       | Prevents invalid or inconsistent data               |
| ⚠️ **Error Prevention**     | Stops users from entering wrong values              |
| 🎯 **Automatic Validation** | Built-in checks, no extra logic needed              |
| 🔒 **Safer Relationships**  | Maintains links between tables (e.g., foreign keys) |

---

## 🔷 3. Types of Constraints (with Examples)

| Constraint    | Purpose                                   | Example Usage                                    |
| ------------- | ----------------------------------------- | ------------------------------------------------ |
| `NOT NULL`    | Disallow `NULL` values                    | `name VARCHAR(50) NOT NULL`                      |
| `UNIQUE`      | All values must be different              | `email VARCHAR(100) UNIQUE`                      |
| `PRIMARY KEY` | Unique and NOT NULL + ID for row          | `id INT PRIMARY KEY`                             |
| `FOREIGN KEY` | Links to another table’s column           | `user_id INT REFERENCES users(id)`               |
| `CHECK`       | Only allows values that match a condition | `age INT CHECK(age >= 18)`                       |
| `DEFAULT`     | Sets a default value if none given        | `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP` |

---

### 🧪 Example: Create Table with Constraints

```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  age INT CHECK (age >= 18)
);
```

This means:

* `name` must be provided
* `email` must be unique
* `age` must be at least 18

---

## 🔷 4. ALTER TABLE to Add NOT NULL (Real-life Scenario)

### 🧪 Start With This Table:

```sql
CREATE TABLE employees (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100)
);
```

### 🧪 Insert Some Rows:

```sql
INSERT INTO employees (name) VALUES ('Alice'), ('Bob'), (NULL);
```

At this point, **one row has a `NULL` name**.

---

### 🔁 Now Add a `NOT NULL` Constraint:

```sql
ALTER TABLE employees
MODIFY COLUMN name VARCHAR(100) NOT NULL;
```

### ❌ What Happens?

* **MySQL will throw an error**:

  ```
  ERROR 1138 (22004): Invalid use of NULL value
  ```

* Because **you already have rows with `NULL`**, you **cannot apply `NOT NULL`** unless you:

  * First update or delete those invalid rows

---

### ✅ Fix Before Adding Constraint:

```sql
UPDATE employees SET name = 'Unknown' WHERE name IS NULL;

ALTER TABLE employees
MODIFY COLUMN name VARCHAR(100) NOT NULL;
```

Now the alteration will succeed.

---

## 🔷 5. Summary of `ALTER` with Constraints

| Action                              | Behavior                 |
| ----------------------------------- | ------------------------ |
| Add `NOT NULL` on column with NULLs | ❌ Error                  |
| Add `UNIQUE` with duplicates        | ❌ Error                  |
| Add `CHECK` that violates data      | ❌ Error                  |
| Add `DEFAULT` value                 | ✅ Allowed                |
| Drop constraint                     | ✅ Allowed (with caution) |

---

## 🧠 Best Practices

* Always design constraints **before inserting lots of data**
* Validate or clean up data before adding stricter constraints like `NOT NULL`, `UNIQUE`, etc.
* Use `CHECK` constraints in modern MySQL (v8+) for custom rules
* Use constraints with `FOREIGN KEY` to ensure **referential integrity**
