> ✅ `CREATE`, `USE`, `DROP`, `SHOW`
> including **databases**, **tables**, **views**, **indexes**, and more — all grouped with short explanations and examples.

---

## 🔵 PART 1: `DATABASE`-Related Queries

### ✅ Create a Database

```sql
CREATE DATABASE my_database;
```

### ✅ Use a Database

```sql
USE my_database;
```

### ✅ Show All Databases

```sql
SHOW DATABASES;
```

### ✅ Show the Current Database

```sql
SELECT DATABASE();
```

### ✅ Drop/Delete a Database

```sql
DROP DATABASE my_database;
```

---

## 🔵 PART 2: `TABLE`-Related Queries

### ✅ Create a Table

```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(150)
);
```

### ✅ Show All Tables in the Current Database

```sql
SHOW TABLES;
```

### ✅ Show Table Structure

```sql
DESCRIBE users;        -- or
EXPLAIN users;
```

### ✅ Show Table Creation Query

```sql
SHOW CREATE TABLE users;
```

### ✅ Rename a Table

```sql
RENAME TABLE users TO customers;
```

### ✅ Drop/Delete a Table

```sql
DROP TABLE users;
```

---

## 🔵 PART 3: `VIEW`-Related Queries

### ✅ Create a View

```sql
CREATE VIEW active_users AS
SELECT id, name FROM users WHERE active = 1;
```

### ✅ Show All Views

```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

### ✅ Show View Definition

```sql
SHOW CREATE VIEW active_users;
```

### ✅ Drop a View

```sql
DROP VIEW active_users;
```

---

## 🔵 PART 4: `INDEX`-Related Queries

### ✅ Create an Index

```sql
CREATE INDEX idx_name ON users(name);
```

### ✅ Show Indexes on a Table

```sql
SHOW INDEX FROM users;
```

### ✅ Drop an Index

```sql
DROP INDEX idx_name ON users;
```

---

## 🔵 PART 5: `TRIGGER`-Related Queries

### ✅ Show All Triggers

```sql
SHOW TRIGGERS;
```

### ✅ Drop a Trigger

```sql
DROP TRIGGER IF EXISTS trigger_name;
```

---

## 🔵 PART 6: Other Useful `SHOW` Commands

| Query               | Purpose                                |
| ------------------- | -------------------------------------- |
| `SHOW STATUS;`      | Server status info                     |
| `SHOW VARIABLES;`   | Server/system config variables         |
| `SHOW PROCESSLIST;` | List of active MySQL threads/processes |
| `SHOW PRIVILEGES;`  | All supported privilege types          |
| `SHOW WARNINGS;`    | Last query's warnings                  |
| `SHOW ERRORS;`      | Errors from the last failed query      |

---

## 📦 Bonus: IF NOT EXISTS / IF EXISTS (Safe Creation/Deletion)

```sql
CREATE DATABASE IF NOT EXISTS my_database;
DROP TABLE IF EXISTS users;
```

---

## 🧠 Summary

| Action           | Keywords                                       | Examples                   |
| ---------------- | ---------------------------------------------- | -------------------------- |
| Work with DBs    | `CREATE`, `USE`, `DROP`, `SHOW DATABASES`      | `CREATE DATABASE test;`    |
| Work with Tables | `CREATE TABLE`, `DESCRIBE`, `DROP`             | `SHOW CREATE TABLE users;` |
| Views            | `CREATE VIEW`, `SHOW CREATE VIEW`, `DROP VIEW` |                            |
| Indexes          | `CREATE INDEX`, `SHOW INDEX`, `DROP INDEX`     |                            |
| Triggers         | `SHOW TRIGGERS`, `DROP TRIGGER`                |                            |
| Server Info      | `SHOW STATUS`, `SHOW VARIABLES`                |                            |



---
---












## 🔍 What Is Case Sensitivity in SQL?

Case sensitivity refers to **whether `TableName` and `tablename` are treated as the same or different**.

* **Case-sensitive** = `Users` ≠ `users`
* **Case-insensitive** = `Users` = `users`

---

## ✅ Case Sensitivity in MySQL Depends On:

1. **Operating System (file system)**
2. **MySQL system variable: `lower_case_table_names`**
3. **Whether you're talking about table names, column names, aliases, etc.**

---

## 🔵 OS-Based Defaults for `lower_case_table_names`

| Operating System      | `lower_case_table_names` default         | Behavior                            |
| --------------------- | ---------------------------------------- | ----------------------------------- |
| **Linux (ext4)**      | `0` (case-sensitive)                     | Table names are case-sensitive      |
| **Windows (NTFS)**    | `1` (case-insensitive)                   | Table names are case-insensitive    |
| **macOS (HFS+/APFS)** | `2` (stored lowercase, case-insensitive) | All table names stored in lowercase |

---

## ⚙️ `lower_case_table_names` — What It Does

| Value | Meaning                                                                                          |
| ----- | ------------------------------------------------------------------------------------------------ |
| `0`   | **Case-sensitive** table and database names (Unix/Linux only)                                    |
| `1`   | All table and database names **stored in lowercase**, comparisons **case-insensitive** (Windows) |
| `2`   | Names stored in lowercase, comparisons case-insensitive (used mostly on macOS)                   |

> 🔒 `lower_case_table_names` **must be set before MySQL starts** — it cannot be changed at runtime.

---

## ✅ Identifier Case-Sensitivity Summary

| Identifier Type             | Case-Sensitive? (Linux) | Case-Sensitive? (Windows) |
| --------------------------- | ----------------------- | ------------------------- |
| **Database names**          | Yes (default)           | No                        |
| **Table names**             | Yes (default)           | No                        |
| **Column names**            | ❌ No                    | ❌ No                      |
| **Aliases** (SELECT a AS B) | ❌ No                    | ❌ No                      |
| **Stored Procedure Names**  | ❌ No                    | ❌ No                      |
| **Triggers, Views**         | Depends on file system  | Depends on file system    |

---

## 🧪 Example (Linux with `lower_case_table_names = 0`):

```sql
CREATE TABLE MyData (id INT);
SELECT * FROM mydata;   -- ❌ ERROR: table doesn't exist
SELECT * FROM MyData;   -- ✅ Works
```

---

## 🧪 Example (Windows with `lower_case_table_names = 1`):

```sql
CREATE TABLE MyData (id INT);
SELECT * FROM mydata;   -- ✅ Works
SELECT * FROM MYDATA;   -- ✅ Works
```

All treated as the same.

---

## 💡 How to Check Current Setting

```sql
SHOW VARIABLES LIKE 'lower_case_table_names';
```

---

## ✅ Tips

* Always use **lowercase table and database names** in SQL code — most portable across OSes.
* MySQL is **case-insensitive for column names**, but other DBs like PostgreSQL are stricter.
* Changing `lower_case_table_names` on an existing database requires **table renaming and backups** — be cautious!
