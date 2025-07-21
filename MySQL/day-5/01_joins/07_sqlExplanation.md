### ✅ **What Is a Self JOIN?**

A **Self JOIN** is a regular join where a table is joined with itself. It’s useful for:

* Hierarchical relationships (like employees and their managers).
* Comparisons within the same table (like salary comparisons, same department, etc.).

You **must use table aliases** (`emp`, `mgr`, `e1`, `e2`, etc.) to distinguish between the two instances of the table.

---

## 🔍 Query Explanations

---

### 🔹 **EXAMPLE 1: Employees with their Managers**

```sql
SELECT * 
FROM employees emp 
JOIN employees mgr ON emp.manager_id = mgr.employee_id;
```

**Goal:** Show each employee along with their manager’s details.

* `emp`: refers to the employee.
* `mgr`: refers to the same `employees` table, but pointing to their manager.
* Join condition: `emp.manager_id = mgr.employee_id`.

❗ **Note:** The CEO (who has no manager) won't appear here, because it's an **INNER JOIN**.

---

### 🔹 **EXAMPLE 2: Employees + Managers (Even CEO)**

```sql
SELECT * 
FROM employees emp 
LEFT JOIN employees mgr ON emp.manager_id = mgr.employee_id;
```

**Goal:** Include *all* employees, even those who don’t have managers (like CEO).

* Uses `LEFT JOIN`: keeps all rows from `emp` (employees), and fills NULL if no match found in `mgr` (manager).
* Useful for identifying people with no manager (`mgr.*` will be NULL).

---

### 🔹 **EXAMPLE 3: Grouping (Not a Self Join)**

```sql
SELECT 
    department,
    COUNT(*) AS employee_count,
    GROUP_CONCAT(CONCAT(first_name, ' ', last_name) ORDER BY employee_id SEPARATOR ', ') AS employees
FROM employees
GROUP BY department;
```

**Goal:** List departments, number of employees, and names in each.

* `GROUP_CONCAT`: combines multiple employee names into a comma-separated string.
* Just provides context for how employees are structured.

---

### 🔹 **EXAMPLE 4: Employees in Same Department**

```sql
SELECT * 
FROM employees e1 
JOIN employees e2 
ON e1.department = e2.department 
AND e1.employee_id < e2.employee_id;
```

**Goal:** Find *pairs* of employees working in the same department.

* Self join compares rows where departments are equal.
* The condition `e1.employee_id < e2.employee_id`:

  * Avoids duplicate pairs like (A, B) and (B, A).
  * Prevents self-matching (like A, A).

🧠 Use Case: Useful for analyzing collaboration, mentorship, or comparing team members.

---

### 🔹 **EXAMPLE 5: Employees Paid Less Than Managers**

```sql
SELECT * 
FROM employees emp 
JOIN employees mgr ON emp.manager_id = mgr.employee_id 
WHERE emp.salary < mgr.salary;
```

**Goal:** Find employees whose salary is less than their manager’s.

* Uses a self join to bring manager data (`mgr.salary`) into the same row as employee.
* Then filters by comparing salaries.

💡 Good for finding possible underpaid staff or compensation fairness issues.

---

### 🔹 **EXAMPLE 6: Average Salary Difference by Department**

```sql
SELECT 
    emp.department,
    COUNT(emp.employee_id) AS num_employees,
    ROUND(AVG(mgr.salary), 2) AS avg_manager_salary,
    ROUND(AVG(emp.salary), 2) AS avg_employee_salary,
    ROUND(AVG(mgr.salary - emp.salary), 2) AS avg_salary_difference
FROM employees emp
JOIN employees mgr ON emp.manager_id = mgr.employee_id
GROUP BY emp.department
ORDER BY avg_salary_difference DESC;
```

**Goal:** Show average salary difference between employees and managers for each department.

* Compares salaries across self-joined table.
* Uses `GROUP BY emp.department` to calculate per department.
* Shows:

  * Employee count
  * Manager average salary
  * Employee average salary
  * Difference

💡 Helps identify departments with highest salary gap.

---

## 📌 Self JOIN Concepts Summary

| Concept                | Details                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------- |
| **Same Table**         | A self join connects a table with itself.                                                         |
| **Aliases Required**   | Must use aliases (`emp`, `mgr`, etc.) to avoid confusion.                                         |
| **Join Types**         | You can use `INNER`, `LEFT`, `RIGHT` with self join.                                              |
| **Avoid Self-Matches** | Use `e1.id < e2.id` if comparing pairs.                                                           |
| **Use Cases**          | Hierarchies (employees–managers), comparisons (salaries, departments), relationships (same team). |

---

## ✅ When to Use Self JOINs

* When a **hierarchical relationship** exists in a single table (like `manager_id`).
* When **comparing rows** from the same table based on some condition (e.g., same department, lower salary, etc.).
* When you want to find **relationships or pairs** of entries within one table.
