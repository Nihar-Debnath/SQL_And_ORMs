## 🔑 What is a Foreign Key?

A **foreign key** is a field (or collection of fields) in one table that **references the primary key** in another table.

It creates a **relationship** between two tables.

---

## 🧠 Real-World Analogy

Imagine two registers in a college:

1. **Students** table:

   * `student_id` is the **primary key** (each student is unique).
2. **Enrollments** table:

   * Tracks which **student is enrolled in which course**.
   * Has `student_id` as a **foreign key** pointing to `Students`.

So you can't insert an enrollment with a student who doesn't exist.

---

## 🔗 One-to-Many Relationship Example

### 🎯 Goal: One student can enroll in **many courses**.

### ✅ Step 1: Create Main Table (`students`)

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100)
);
```

### ✅ Step 2: Create Related Table (`enrollments`) with FOREIGN KEY

```sql
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_name VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

---

## ⚠️ FOREIGN KEY Rules:

* ✅ You **can only insert** a `student_id` in `enrollments` **if it exists in `students`**.
* ❌ If a student is deleted, their enrollments are deleted automatically (`ON DELETE CASCADE`).

---

## 🧪 Sample Data Insert

```sql
-- Add students
INSERT INTO students VALUES (1, 'Alice', 'alice@example.com');
INSERT INTO students VALUES (2, 'Bob', 'bob@example.com');

-- Enroll them in courses
INSERT INTO enrollments VALUES (101, 1, 'Math');
INSERT INTO enrollments VALUES (102, 1, 'Science');
INSERT INTO enrollments VALUES (103, 2, 'History');
```

---

## 🔍 Querying the Relationship (JOIN)

```sql
SELECT s.name, e.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id;
```

### 🟩 Output:

| name  | course\_name |
| ----- | ------------ |
| Alice | Math         |
| Alice | Science      |
| Bob   | History      |

---

## 🔁 Many-to-Many Relationship with Foreign Keys

Let’s say each course can have many students, and each student can take many courses.

You’ll need 3 tables:

1. `students`
2. `courses`
3. `enrollments` – a **bridge table** with 2 foreign keys.

---

### 🎯 Step-by-step:

```sql
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    title VARCHAR(100)
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

This allows you to track multiple students in multiple courses.

---

## ✅ Benefits of Foreign Keys:

| Benefit                  | Description                                     |
| ------------------------ | ----------------------------------------------- |
| 🔐 Data integrity        | Prevents invalid data from being inserted       |
| 🔄 Cascading changes     | Automatically updates/deletes related records   |
| 🔍 Easier joins          | Enables meaningful joins between related tables |
| 📚 Normalization support | Reduces redundancy in databases                 |

---

## 🧨 What happens if you violate a foreign key?

```sql
-- Error: Student ID 5 does not exist in students table
INSERT INTO enrollments VALUES (999, 5, 'Biology');
```

**Result:** Error like:

```
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails
```
