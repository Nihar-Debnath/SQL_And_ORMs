### 🔸**1. What is a Foreign Key?**

> A **foreign key** is a field (or collection of fields) in a **child table** that refers to the **primary key** in the **parent table**. It enforces **referential integrity**, meaning it ensures relationships between records are valid.

---

## 💠 SECTION-WISE BREAKDOWN

---

### ✅ **1. One-to-One Relationship**

```sql
CREATE TABLE employee_details (
    employee_id INT NOT NULL,
    passport_number VARCHAR(20),
    marital_status VARCHAR(20),
    emergency_contact VARCHAR(100),
    PRIMARY KEY (employee_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
```

* **Purpose:** Each employee has **exactly one** corresponding detailed record.
* **Foreign Key:** `employee_id` in `employee_details` must match one in `employees`.
* **Relationship:** 1:1 between `employees` and `employee_details`.

---

### ✅ **2. One-to-Many Relationship**

```sql
CREATE TABLE employees (
    employee_id INT NOT NULL,
    ...
    department_id INT,
    ...
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

* **Purpose:** Many employees can belong to the same department.
* **Foreign Key:** `department_id` in `employees` must match one in `departments`.
* **Relationship:** 1 department ↔ many employees (**1\:N**).

---

### ✅ **3. Many-to-Many Relationship (via Junction Table)**

```sql
CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    ...
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
```

* **Purpose:** Students can enroll in multiple courses, and each course can have multiple students.
* **Junction Table:** `Enrollments` holds relationships.
* **Foreign Keys:** Connect to both `Students` and `Courses`.
* **Relationship:** Many ↔ Many (**N\:M**).

---

## 🔧 PRACTICAL IMPLEMENTATION SECTION

---

### ✅ **Create Database & Tables**

```sql
CREATE DATABASE company_db;
USE company_db;
```

* **Creates a database** named `company_db`.
* **Switches to it** to run all the next commands.

---

### ✅ **Create departments (parent) and employees (child)**

```sql
CREATE TABLE departments (...)
CREATE TABLE employees (...)
```

* **`departments`**: Holds unique `department_id` as primary key.
* **`employees`**: Has a `department_id` field referencing `departments`.

🔗 Now each employee **must belong to a valid department**, or the `department_id` should be `NULL`.

---

### ✅ **Insert Sample Data**

```sql
-- Insert departments
-- Insert employees
```

* You insert actual rows into both tables.
* The foreign key in `employees` will **validate** that the `department_id` exists in `departments`.

---

### ✅ **Attempting to Violate FK Constraint**

```sql
-- Insert into employees with department_id = 69 (which does not exist)
```

* ⚠️ **Fails!**
* Because **69 is not a valid department\_id** in the parent table.
* This proves **foreign keys enforce integrity**.

---

### ✅ **NULL Foreign Key**

```sql
-- Insert employee with NULL department_id
```

* ✔️ **Works**.
* Because NULL values are **allowed** if not restricted.
* NULL means the employee is **not yet assigned to a department**.

---

## 🔄 ADDING & REMOVING FOREIGN KEYS AFTER TABLE CREATION

---

### ✅ **Add Foreign Key to Existing Table**

```sql
ALTER TABLE projects
ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);
```

* Adds a foreign key to an existing column.
* Now, `manager_id` must be a valid `employee_id`.

---

### ✅ **View Table Structure**

```sql
SHOW CREATE TABLE projects;
```

* Displays full schema, including foreign key constraints.

---

### ✅ **Drop Foreign Key**

```sql
ALTER TABLE projects DROP FOREIGN KEY projects_ibfk_1;
```

* Deletes the foreign key constraint.
* You must know the **constraint name** (`projects_ibfk_1` is auto-generated).

---

## 🧠 DEEPER EXERCISE: EMPLOYEE SKILLS TABLE

---

### ✅ **Create Employee Skills Table with FK**

```sql
CREATE TABLE employee_skills (
    ...
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
```

* Each skill entry **must reference a valid employee**.
* Demonstrates how you can extend relationships to even **non-core tables**.

---

### ✅ **Insert into employee\_skills**

```sql
INSERT INTO employee_skills (...)
```

* Assigns skills to specific employees.
* You can now **query across these relationships** to get skills by employee, etc.

---

## 🧩 SUMMARY OF WHAT'S HAPPENING

| Concept               | Explanation                                                                             |
| --------------------- | --------------------------------------------------------------------------------------- |
| **Primary Key**       | Uniquely identifies each row in a table.                                                |
| **Foreign Key**       | Enforces relationship between tables. Only allows values from the parent table or NULL. |
| **1:1 Relationship**  | One-to-one, using same PK in both tables.                                               |
| **1\:N Relationship** | One parent, many children — e.g., departments to employees.                             |
| **N\:M Relationship** | Many-to-many via a junction table — e.g., students and courses.                         |
| **Integrity Check**   | Ensures child table cannot have invalid references.                                     |
| **ALTER Commands**    | Used to add or remove foreign keys later.                                               |
| **Junction Tables**   | Allow complex relationships between two tables.                                         |
