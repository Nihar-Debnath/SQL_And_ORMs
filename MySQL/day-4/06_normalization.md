Database **Normalization** is a process used to structure a relational database in a way that:

* Reduces data redundancy
* Ensures data integrity
* Makes data maintenance easier

It is done through a series of **normal forms (NF)**:
Each normal form builds upon the previous one.

---

## 🔹 **1NF (First Normal Form):**

### ✅ Rules:

* Each table cell must contain **atomic (indivisible)** values.
* Each record must be **unique**.
* Values in each column must be of the **same type**.

---

### ❌ Problem Example (Unnormalized):

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    subjects VARCHAR(100) -- e.g., 'Math, Physics, Chemistry'
);
```

| student\_id | student\_name | subjects           |
| ----------- | ------------- | ------------------ |
| 1           | Alice         | Math, Physics      |
| 2           | Bob           | Chemistry, Biology |

---

### ✅ Convert to 1NF:

```sql
CREATE TABLE student_subjects (
    student_id INT,
    student_name VARCHAR(100),
    subject VARCHAR(50),
    PRIMARY KEY (student_id, subject)
);
```

| student\_id | student\_name | subject   |
| ----------- | ------------- | --------- |
| 1           | Alice         | Math      |
| 1           | Alice         | Physics   |
| 2           | Bob           | Chemistry |
| 2           | Bob           | Biology   |

🔍 Now each cell contains **atomic** values (1 subject per row).

---

## 🔹 **2NF (Second Normal Form):**

### ✅ Rules:

* Must be in **1NF**
* **No partial dependency** on the primary key
  → All non-key attributes must depend on the **entire** primary key (not just part of it)

---

### ❌ Problem Example:

```sql
CREATE TABLE student_subjects (
    student_id INT,
    subject VARCHAR(50),
    student_name VARCHAR(100),
    subject_teacher VARCHAR(100),
    PRIMARY KEY (student_id, subject)
);
```

🧠 Problem: `student_name` depends **only on student\_id**, not subject
So it violates **2NF** → **Partial dependency**

---

### ✅ Convert to 2NF:

Split into two tables:

```sql
-- Students
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

-- Subjects taken by each student
CREATE TABLE student_subjects (
    student_id INT,
    subject VARCHAR(50),
    subject_teacher VARCHAR(100),
    PRIMARY KEY (student_id, subject)
);
```

🧠 Now:

* `student_name` is fully dependent on `student_id`
* `subject_teacher` is specific to both `student_id` and `subject`

---

## 🔸 What is a **Partial Dependency**?

> A **partial dependency** occurs **when a non-prime (non-key) attribute depends only on part of a composite primary key**, not the **entire** key.

---

### 📌 Key Concepts First:

* **Primary Key**: Uniquely identifies a row.
* **Composite Key**: A primary key made of **two or more columns**.
* **Non-prime attribute**: A column that is **not** part of any candidate key.

---

## ✅ Example to Understand Clearly

### ❌ Let’s say we have this table:

```sql
CREATE TABLE student_subject (
    student_id INT,
    subject_code VARCHAR(10),
    student_name VARCHAR(100),
    subject_name VARCHAR(100),
    PRIMARY KEY (student_id, subject_code)
);
```

| student\_id | subject\_code | student\_name | subject\_name |
| ----------- | ------------- | ------------- | ------------- |
| 1           | MATH101       | Alice         | Mathematics   |
| 1           | PHY101        | Alice         | Physics       |
| 2           | CHEM101       | Bob           | Chemistry     |

Here the **composite primary key** is: `(student_id, subject_code)`

---

## ❗ Where is the Partial Dependency?

### Let’s examine:

* `student_name` **depends only on `student_id`** (NOT subject\_code)
* `subject_name` **depends only on `subject_code`** (NOT student\_id)

So:

* `student_name` → partial dependency on `student_id`
* `subject_name` → partial dependency on `subject_code`

➡️ **Both are partial dependencies** because they depend on a **part of the composite key**, not the **whole** key.

---

## 🎯 Why is it Bad?

It **violates 2NF** — because the non-key attributes should depend on the **entire** composite key.

---

## ✅ Fixing It (2NF conversion):

Break it into 3 tables:

### 1. Students table:

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);
```

### 2. Subjects table:

```sql
CREATE TABLE subjects (
    subject_code VARCHAR(10) PRIMARY KEY,
    subject_name VARCHAR(100)
);
```

### 3. Relationship table:

```sql
CREATE TABLE student_subjects (
    student_id INT,
    subject_code VARCHAR(10),
    PRIMARY KEY (student_id, subject_code),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_code) REFERENCES subjects(subject_code)
);
```

---

## 🔄 Summary:

| Term               | Meaning                                                                 |
| ------------------ | ----------------------------------------------------------------------- |
| Composite Key      | Primary key with more than one column                                   |
| Partial Dependency | A non-key column depends on only part of the composite key              |
| Why bad?           | Leads to redundancy and update anomalies                                |
| Fix                | Split into smaller tables, where each non-key fully depends on full key |

---
---
---

## 🔹 **3NF (Third Normal Form):**

### ✅ Rules:

* Must be in **2NF**
* **No transitive dependencies**
  → A non-key attribute should **not depend on another non-key attribute**

---

### ❌ Problem Example:

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    dept_name VARCHAR(100)
);
```

🧠 Problem:

* `dept_name` depends on `dept_id` (a non-key attribute)
* This is a **transitive dependency**

---

### ✅ Convert to 3NF:

```sql
-- Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT
);

-- Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);
```

🧠 Now:

* `emp_name` depends only on `emp_id`
* `dept_name` depends only on `dept_id`
* Clean, no transitive dependency

---

## Summary Table:

| Normal Form | Rule                            |
| ----------- | ------------------------------- |
| **1NF**     | Atomic values only, unique rows |
| **2NF**     | 1NF + no partial dependency     |
| **3NF**     | 2NF + no transitive dependency  |
