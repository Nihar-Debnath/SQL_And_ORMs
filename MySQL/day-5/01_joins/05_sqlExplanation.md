## ✅ 🔹 FULL JOIN - Concept Recap

* A `FULL JOIN` returns:

  * All matching rows from both tables.
  * All non-matching rows from the left table.
  * All non-matching rows from the right table.
* **MySQL does not support FULL JOIN natively**, so we simulate it with:

  ```sql
  LEFT JOIN ... 
  UNION 
  RIGHT JOIN ...
  ```

---

## ✅ FULL JOIN Example (Friends Database)

### 🔸 Simulated FULL JOIN using UNION

```sql
SELECT c.character_id, c.first_name, c.last_name, c.occupation,
       a.apartment_id, a.building_address, a.apartment_number, a.monthly_rent
FROM characters c
LEFT JOIN apartments a ON c.character_id = a.current_tenant_id

UNION

SELECT c.character_id, c.first_name, c.last_name, c.occupation,
       a.apartment_id, a.building_address, a.apartment_number, a.monthly_rent
FROM characters c
RIGHT JOIN apartments a ON c.character_id = a.current_tenant_id;
```

### ✅ What This Does:

* Combines:

  * Rows where a character **is matched** to an apartment
  * Characters **without apartments** (from `LEFT JOIN`)
  * Apartments **without tenants** (from `RIGHT JOIN`)
* `UNION` merges both results and **removes duplicates**
* You get the **complete picture**: every character and every apartment

---

## ✅ Filtering from FULL JOIN

---

### 🔸 Characters **without apartments**

```sql
SELECT c.character_id, c.first_name, c.last_name
FROM characters c
LEFT JOIN apartments a ON c.character_id = a.current_tenant_id
WHERE a.apartment_id IS NULL;
```

* Uses `LEFT JOIN` to keep all characters.
* `WHERE a.apartment_id IS NULL` filters out only those **without a match**.
* 🔍 Shows **Gunther** and **Janice** (not renting any apartment).

---

### 🔸 Apartments **without tenants**

```sql
SELECT a.apartment_id, a.building_address, a.apartment_number
FROM apartments a
LEFT JOIN characters c ON a.current_tenant_id = c.character_id
WHERE c.character_id IS NULL;
```

* Uses `LEFT JOIN` on apartments side to keep all apartments.
* `WHERE c.character_id IS NULL` filters out only **vacant apartments**.

---

### 🔸 Combining both unmatched (FULL OUTER JOIN filtering)

```sql
SELECT c.character_id, c.first_name, c.last_name, 
       a.apartment_id, a.building_address, a.apartment_number
FROM characters c
LEFT JOIN apartments a ON c.character_id = a.current_tenant_id
WHERE a.apartment_id IS NULL

UNION

SELECT c.character_id, c.first_name, c.last_name, 
       a.apartment_id, a.building_address, a.apartment_number
FROM characters c
RIGHT JOIN apartments a ON c.character_id = a.current_tenant_id
WHERE c.character_id IS NULL;
```

### ✅ Purpose:

* The **first SELECT** fetches all characters with **no apartments**.
* The **second SELECT** fetches all apartments with **no tenants**.
* The `UNION` merges both → Gives all **unmatched rows** from both tables.

---

## ✅ PostgreSQL FULL JOIN (Reference Only)

```sql
-- Native syntax (not for MySQL)
SELECT ...
FROM characters c
FULL JOIN apartments a ON c.character_id = a.current_tenant_id;
```

✔ PostgreSQL supports this natively.

---

## ✅ Extended Use Case – Employee & Department (Commented Section)

### 🔸 FULL JOIN with employee/department structure:

```sql
SELECT e.employee_id, e.first_name, e.last_name,
       d.department_id, d.department_name, d.location
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id

UNION

SELECT e.employee_id, e.first_name, e.last_name,
       d.department_id, d.department_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;
```

### ✅ What this does:

* Finds:

  * All employees and their departments
  * Employees **without departments**
  * Departments **without employees**

This approach ensures **no data is left behind** from either table.

---

## 🔍 Summary: FULL JOIN in MySQL

| Feature          | Details                                                               |
| ---------------- | --------------------------------------------------------------------- |
| Native Support   | ❌ Not available in MySQL                                              |
| Workaround       | `LEFT JOIN ... UNION ... RIGHT JOIN`                                  |
| Returns          | All matches + all unmatched from both sides                           |
| NULLs            | Present where no match                                                |
| Usage            | Combine full data, find unmatched, consolidate both sets              |
| Performance Note | UNION does deduplication; UNION ALL is faster if you allow duplicates |
