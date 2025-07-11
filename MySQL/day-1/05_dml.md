## 🔷 What is DML in SQL?

### ✅ DML stands for **Data Manipulation Language**

These are the SQL commands used to **manipulate the data inside database tables**.

> 📌 DML commands **do not define** the structure — they only **deal with the actual data (rows)**.

---

## 🧩 Main DML Commands

Here are the most commonly used DML commands with full explanation and examples:

---

### ✅ 1. `INSERT`

**Used to add new rows** (records) to a table.

#### 🧪 Example 1: Insert one row

```sql
INSERT INTO Students (StudentID, Name, Age)
VALUES (1, 'Alice', 20);
```

#### 🧪 Example 2: Insert multiple rows

```sql
INSERT INTO Students (StudentID, Name, Age)
VALUES 
(2, 'Bob', 22),
(3, 'Charlie', 21);
```

#### 🔍 What happens:

* New rows are added to the table `Students`
* If there’s a **primary key**, it must be **unique**

---

### ✅ 2. `SELECT`

**Used to retrieve** (fetch) data from one or more tables.

#### 🧪 Example 1: Get all data

```sql
SELECT * FROM Students;
```

#### 🧪 Example 2: Get specific columns

```sql
SELECT Name, Age FROM Students;
```

#### 🧪 Example 3: With filter (`WHERE`)

```sql
SELECT * FROM Students WHERE Age > 20;
```

#### 🧪 Example 4: With sorting

```sql
SELECT * FROM Students ORDER BY Age DESC;
```

#### 🔍 What happens:

* `SELECT` doesn’t change data; it **reads** it.
* Most used command in DML.

---

### ✅ 3. `UPDATE`

**Used to modify** existing rows.

#### 🧪 Example: Update a student’s age

```sql
UPDATE Students
SET Age = 21
WHERE StudentID = 1;
```

#### 🔍 What happens:

* Finds student with `StudentID = 1`
* Changes their `Age` to 21

> ⚠️ **Always use WHERE** with `UPDATE`, otherwise it updates all rows!

---

### ✅ 4. `DELETE`

**Used to remove rows** from a table.

#### 🧪 Example: Delete one student

```sql
DELETE FROM Students
WHERE StudentID = 3;
```

#### 🧪 Example: Delete all students above 25

```sql
DELETE FROM Students
WHERE Age > 25;
```

#### 🔍 What happens:

* Deletes matching rows.
* Table structure remains.

> ⚠️ **Be careful** — without `WHERE`, all rows will be deleted.

---

## 💾 DML and Transactions (Very Important)

DML commands like `INSERT`, `UPDATE`, `DELETE` are part of a **transaction**.

* You can **commit** to save changes:

```sql
COMMIT;
```

* Or **rollback** to undo changes:

```sql
ROLLBACK;
```

> 🚨 Unlike DDL, **DML commands are not auto-committed** (in many DBMS).
> That means you can undo changes before committing.

---

## 🧠 Summary Table

| Command  | Purpose                  | Example                            |
| -------- | ------------------------ | ---------------------------------- |
| `INSERT` | Add new rows             | `INSERT INTO Students ...`         |
| `SELECT` | Read/retrieve data       | `SELECT * FROM Students;`          |
| `UPDATE` | Modify existing data     | `UPDATE Students SET Age = 21 ...` |
| `DELETE` | Remove rows from a table | `DELETE FROM Students WHERE ...`   |

---

## 🧑‍🏫 Real-Life Analogy

Imagine a **register book** in a school classroom:

* `INSERT`: Add a new student entry.
* `SELECT`: Read/look up students.
* `UPDATE`: Change the name or age of a student.
* `DELETE`: Erase a student’s record from the book.

You are not changing the **book itself** (the table), just its **content** (the data).

---

## 🛡️ Best Practices

1. 🔐 Always use `WHERE` with `UPDATE` and `DELETE`
2. 📝 Use `SELECT` first to preview what rows you will affect
3. 💾 Use transactions (`BEGIN`, `COMMIT`, `ROLLBACK`) when working with critical data
4. ✅ Check constraints (like primary key, foreign key) before inserting data
5. 🛠 Use parameterized queries in real applications to prevent SQL injection
