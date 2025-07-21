### ✅ **Understanding LEFT JOIN Recap**

A `LEFT JOIN` returns:

* All rows from the **left table** (`FROM` table).
* Matched rows from the **right table** (`JOIN` table).
* If there's **no match**, the result will contain `NULL` for right table columns.

---

## 🔍 QUERY 1: Apartments and Their Residents (if any)

```sql
SELECT a.apartment_number, a.floor_number, a.wing_name, 
       r.first_name, r.last_name
FROM apartments a
LEFT JOIN residents r
ON r.apartment_id = a.apartment_id;
```

### ✅ What It Does:

* Shows **all apartments**, even if **no one lives there**.
* For each apartment, if residents are found, shows their names.
* If no resident found → shows `NULL` for `first_name` and `last_name`.

### 🧾 Sample Output:

| apartment\_number | floor\_number | wing\_name | first\_name | last\_name |
| ----------------- | ------------- | ---------- | ----------- | ---------- |
| 101               | 1             | A          | Jethalal    | Gada       |
| 101               | 1             | A          | Daya        | Gada       |
| 102               | 1             | A          | Taarak      | Mehta      |
| 102               | 1             | A          | Anjali      | Mehta      |
| 201               | 2             | A          | Popatlal    | Pandey     |
| 202               | 2             | A          | Bhide       | Aatmaram   |
| 202               | 2             | A          | Madhavi     | Bhide      |
| 301               | 3             | A          | Dr          | Hathi      |
| 301               | 3             | A          | Komal       | Hathi      |
| 302               | 3             | A          | NULL        | NULL       |
| 401               | 4             | A          | NULL        | NULL       |
| 402               | 4             | A          | NULL        | NULL       |
| 501               | 5             | B          | NULL        | NULL       |
| 502               | 5             | B          | NULL        | NULL       |

🧠 Apartment 302, 401, 402, 501, 502 have **no residents**, so NULLs appear.

---

## 🔍 QUERY 2: Right Join (Same Output, Order Changes)

```sql
SELECT a.apartment_number, a.floor_number, a.wing_name, 
       r.first_name, r.last_name
FROM residents r 
RIGHT JOIN apartments a
ON r.apartment_id = a.apartment_id;
```

### ✅ What It Does:

* Same logic as above but uses `RIGHT JOIN` (so apartments is still the main table).
* In MySQL, this is **functionally identical to LEFT JOIN** in this case.

🔄 Just changes the table order in the query — output will be the same as QUERY 1.

---

## 🔍 EXERCISE 1: Unoccupied Apartments

```sql
SELECT a.apartment_id, a.apartment_number, a.floor_number, a.wing_name
FROM apartments a
LEFT JOIN residents r ON a.apartment_id = r.apartment_id
WHERE r.resident_id IS NULL;
```

### ✅ What It Does:

* Finds all apartments where **no resident is assigned**.
* `LEFT JOIN` makes sure we include apartments with no matching `resident_id`.
* Then filters those rows (`r.resident_id IS NULL`).

### 🧾 Sample Output:

| apartment\_id | apartment\_number | floor\_number | wing\_name |
| ------------- | ----------------- | ------------- | ---------- |
| 6             | 302               | 3             | A          |
| 7             | 401               | 4             | A          |
| 8             | 402               | 4             | A          |
| 9             | 501               | 5             | B          |
| 10            | 502               | 5             | B          |

---

## 🔍 EXERCISE 2: Count of Residents per Apartment

```sql
SELECT a.apartment_id, a.apartment_number, COUNT(r.resident_id) AS resident_count
FROM apartments a
LEFT JOIN residents r ON a.apartment_id = r.apartment_id
GROUP BY a.apartment_id;
```

### ✅ What It Does:

* Groups by apartment.
* Counts how many residents are in each apartment (even if 0).

### 🧾 Sample Output:

| apartment\_id | apartment\_number | resident\_count |
| ------------- | ----------------- | --------------- |
| 1             | 101               | 2               |
| 2             | 102               | 2               |
| 3             | 201               | 1               |
| 4             | 202               | 2               |
| 5             | 301               | 2               |
| 6             | 302               | 0               |
| 7             | 401               | 0               |
| 8             | 402               | 0               |
| 9             | 501               | 0               |
| 10            | 502               | 0               |

---

## 🔍 EXERCISE 3: Apartments with Residents and Maintenance Status

```sql
SELECT 
    a.apartment_id, 
    a.apartment_number, 
    a.floor_number, 
    a.wing_name,
    CONCAT(r.first_name, ' ', r.last_name) AS resident_name,
    mr.status AS maintenance_status
FROM 
    apartments a
LEFT JOIN 
    residents r ON a.apartment_id = r.apartment_id
LEFT JOIN 
    maintenance_requests mr ON a.apartment_id = mr.apartment_id;
```

### ✅ What It Does:

* Lists all apartments.
* Shows residents (if any).
* Shows maintenance request statuses (if any).
* If either **resident** or **maintenance** is missing, shows `NULL`.

### 🧾 Sample Output (Partial):

| apartment\_id | apartment\_number | floor | wing | resident\_name | maintenance\_status |
| ------------- | ----------------- | ----- | ---- | -------------- | ------------------- |
| 1             | 101               | 1     | A    | Jethalal Gada  | Completed           |
| 1             | 101               | 1     | A    | Jethalal Gada  | Completed           |
| 1             | 101               | 1     | A    | Daya Gada      | Completed           |
| 2             | 102               | 1     | A    | Taarak Mehta   | In Progress         |
| 2             | 102               | 1     | A    | Anjali Mehta   | In Progress         |
| 6             | 302               | 3     | A    | NULL           | NULL                |

🔍 **Duplicates happen** when apartments have multiple residents and multiple requests (joins create Cartesian product).

---

## 🔍 EXERCISE 4: Floor with Most Unoccupied Apartments

```sql
SELECT 
    floor_number,
    wing_name,
    COUNT(*) AS unoccupied_count
FROM 
    apartments a
LEFT JOIN 
    residents r ON a.apartment_id = r.apartment_id
WHERE 
    r.resident_id IS NULL
GROUP BY 
    floor_number, wing_name
ORDER BY 
    unoccupied_count DESC
LIMIT 1;
```

### ✅ What It Does:

* Checks unoccupied apartments (where `resident_id IS NULL`).
* Groups by floor and wing.
* Counts how many unoccupied apartments per floor.
* Shows the one with **most unoccupied units**.

### 🧾 Sample Output:

| floor\_number | wing\_name | unoccupied\_count |
| ------------- | ---------- | ----------------- |
| 4             | A          | 2                 |

---

## 🔍 EXERCISE 5: Total Maintenance Requests per Apartment

```sql
SELECT 
    a.apartment_id, 
    a.apartment_number, 
    a.floor_number, 
    a.wing_name,
    COUNT(mr.request_id) AS maintenance_request_count
FROM 
    apartments a
LEFT JOIN 
    maintenance_requests mr ON a.apartment_id = mr.apartment_id
GROUP BY 
    a.apartment_id;
```

### ✅ What It Does:

* Counts maintenance requests **per apartment**, even if there are none.

### 🧾 Sample Output:

| apartment\_id | apartment\_number | floor\_number | wing\_name | maintenance\_request\_count |
| ------------- | ----------------- | ------------- | ---------- | --------------------------- |
| 1             | 101               | 1             | A          | 2                           |
| 2             | 102               | 1             | A          | 1                           |
| 4             | 202               | 2             | A          | 1                           |
| 5             | 301               | 3             | A          | 1                           |
| 6             | 302               | 3             | A          | 0                           |

---

### ✅ Summary of When to Use LEFT JOIN

| Use Case                           | Use LEFT JOIN? | Why?                                      |
| ---------------------------------- | -------------- | ----------------------------------------- |
| Include all items from left table  | ✅ Yes          | Even if no match found on right table     |
| Count missing or unlinked data     | ✅ Yes          | `IS NULL` condition after LEFT JOIN helps |
| Aggregate data with optional links | ✅ Yes          | COUNT, AVG, etc. can work on NULLs        |

---
---
---
---



## ✅ WHAT IS `RIGHT JOIN`?

### 📌 **Definition**:

A `RIGHT JOIN` returns **all records from the right table**, and the **matched records from the left table**. If there is **no match**, `NULL` values are returned for columns from the left table.

### 📊 Syntax:

```sql
SELECT columns
FROM left_table
RIGHT JOIN right_table
ON left_table.key = right_table.key;
```

* **right\_table**: ALL rows will appear
* **left\_table**: only the matching ones (or NULLs)

---

### ✅ Let's Use This Query You Wrote:

```sql
SELECT 
    a.apartment_number, 
    a.floor_number, 
    a.wing_name, 
    r.first_name, 
    r.last_name
FROM residents r 
RIGHT JOIN apartments a
ON r.apartment_id = a.apartment_id;
```

---

### 🔍 STEP-BY-STEP WHAT'S HAPPENING:

* You are selecting apartments (`a`) and any matching residents (`r`).
* Since it is a **RIGHT JOIN**, every **apartment** (right table) will show up.
* If any apartment **doesn't have a resident**, then `first_name` and `last_name` will show as `NULL`.

---

### 🧾 Tables for Reference:

#### **apartments**

| apartment\_id | apartment\_number | floor\_number | wing\_name |
| ------------- | ----------------- | ------------- | ---------- |
| 1             | 101               | 1             | A          |
| 2             | 102               | 1             | A          |
| 3             | 201               | 2             | A          |
| 4             | 202               | 2             | A          |
| 5             | 301               | 3             | A          |
| 6             | 302               | 3             | A          |
| 7             | 401               | 4             | A          |
| 8             | 402               | 4             | A          |
| 9             | 501               | 5             | B          |
| 10            | 502               | 5             | B          |

#### **residents**

| resident\_id | first\_name | last\_name | occupation             | apartment\_id |
| ------------ | ----------- | ---------- | ---------------------- | ------------- |
| 1            | Jethalal    | Gada       | Electronics Shop Owner | 1             |
| 2            | Daya        | Gada       | Housewife              | 1             |
| 3            | Taarak      | Mehta      | Writer                 | 2             |
| 4            | Anjali      | Mehta      | Teacher                | 2             |
| 5            | Popatlal    | Pandey     | Reporter               | 3             |
| 6            | Bhide       | Aatmaram   | School Teacher         | 4             |
| 7            | Madhavi     | Bhide      | Housewife              | 4             |
| 8            | Dr          | Hathi      | Doctor                 | 5             |
| 9            | Komal       | Hathi      | Housewife              | 5             |

---

### 🟩 OUTPUT of the RIGHT JOIN query:

| apartment\_number | floor\_number | wing\_name | first\_name | last\_name |
| ----------------- | ------------- | ---------- | ----------- | ---------- |
| 101               | 1             | A          | Jethalal    | Gada       |
| 101               | 1             | A          | Daya        | Gada       |
| 102               | 1             | A          | Taarak      | Mehta      |
| 102               | 1             | A          | Anjali      | Mehta      |
| 201               | 2             | A          | Popatlal    | Pandey     |
| 202               | 2             | A          | Bhide       | Aatmaram   |
| 202               | 2             | A          | Madhavi     | Bhide      |
| 301               | 3             | A          | Dr          | Hathi      |
| 301               | 3             | A          | Komal       | Hathi      |
| 302               | 3             | A          | **NULL**    | **NULL**   |
| 401               | 4             | A          | **NULL**    | **NULL**   |
| 402               | 4             | A          | **NULL**    | **NULL**   |
| 501               | 5             | B          | **NULL**    | **NULL**   |
| 502               | 5             | B          | **NULL**    | **NULL**   |

---

### ✅ WHAT YOU CAN UNDERSTAND FROM THIS:

1. Apartments `302`, `401`, `402`, `501`, `502` **have no residents**, so their resident columns are `NULL`.
2. All apartments from the **right table** are shown, proving this is a `RIGHT JOIN`.
3. If a resident exists for an apartment, you get multiple rows (1 per resident).
   For example:

   * Apartment `101` shows both Jethalal and Daya.

---

### ✅ DIFFERENCE BETWEEN `LEFT JOIN` AND `RIGHT JOIN` QUICKLY:

| Feature              | LEFT JOIN                                                               | RIGHT JOIN                                                               |
| -------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| All rows from...     | Left table                                                              | Right table                                                              |
| Matched rows from... | Right table                                                             | Left table                                                               |
| Use case             | When you want to retain all `residents`, even if they have no apartment | When you want to retain all `apartments`, even if they have no residents |
