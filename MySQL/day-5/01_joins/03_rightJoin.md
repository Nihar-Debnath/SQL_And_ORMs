## 🔶 What is RIGHT JOIN?

> A **RIGHT JOIN** returns **all records from the right table**, and the **matched records from the left table**. If there's no match, **NULLs** will be shown for columns from the left table.

### ✅ Syntax:

```sql
SELECT columns
FROM left_table
RIGHT JOIN right_table
ON left_table.column = right_table.column;
```

---

## 🧱 Let's Use the Same Sample Tables

We’ll reuse:

* **`customers`** table with `customer_id`, `customer_name`, `email`, and `city`
* **`orders`** table with `order_id`, `customer_id`, `order_date`, and `total_amount`

Assume data:

**customers**

| customer\_id | customer\_name | email        | city        |
| ------------ | -------------- | ------------ | ----------- |
| 1            | John Smith     | john\@...    | New York    |
| 2            | Jane Doe       | jane\@...    | Los Angeles |
| 3            | Robert Johnson | robert\@...  | Chicago     |
| 4            | Emily Davis    | emily\@...   | Houston     |
| 5            | Michael Brown  | michael\@... | Phoenix     |

**orders**

| order\_id | customer\_id | order\_date | total\_amount |                         |
| --------- | ------------ | ----------- | ------------- | ----------------------- |
| 101       | 1            | 2023-01-15  | 150.75        |                         |
| 102       | 3            | 2023-01-16  | 89.50         |                         |
| 103       | 1            | 2023-01-20  | 45.25         |                         |
| 104       | 2            | 2023-01-25  | 210.30        |                         |
| 105       | 3            | 2023-02-01  | 75.00         |                         |
| 106       | NULL         | 2023-02-10  | 55.00         | ⬅️ No customer (orphan) |

---

## 🔸 Example 1: Basic RIGHT JOIN

```sql
SELECT 
    c.customer_id, 
    c.customer_name, 
    o.order_id, 
    o.total_amount
FROM 
    customers c
RIGHT JOIN 
    orders o ON c.customer_id = o.customer_id;
```

### 🔍 What happens here:

* For each row in `orders`, it tries to **match** the `customer_id` with `customers`.
* If there's **no matching customer**, NULL is shown for customer details.
* This includes **order 106** which has `NULL` customer.

### 📤 Output:

| customer\_id | customer\_name | order\_id | total\_amount |                |
| ------------ | -------------- | --------- | ------------- | -------------- |
| 1            | John Smith     | 101       | 150.75        |                |
| 3            | Robert Johnson | 102       | 89.50         |                |
| 1            | John Smith     | 103       | 45.25         |                |
| 2            | Jane Doe       | 104       | 210.30        |                |
| 3            | Robert Johnson | 105       | 75.00         |                |
| NULL         | NULL           | 106       | 55.00         | ✅ orphan order |

---

## 🔸 Example 2: Find orders **without customers**

```sql
SELECT 
    o.order_id, 
    o.total_amount
FROM 
    customers c
RIGHT JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    c.customer_id IS NULL;
```

### 🔍 Explanation:

* The `RIGHT JOIN` ensures all orders are included.
* The `WHERE` condition filters only those orders **where customer didn't exist** (i.e., `c.customer_id IS NULL`).

### 📤 Output:

| order\_id | total\_amount |
| --------- | ------------- |
| 106       | 55.00         |

---

## 🔸 Example 3: Aggregation using RIGHT JOIN (less common but valid)

```sql
SELECT 
    o.order_id,
    COUNT(c.customer_id) AS matched_customers
FROM 
    customers c
RIGHT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    o.order_id;
```

### 🔍 What this does:

* For each order, count how many matching customers exist (either 1 or 0).
* Usually 1 for matching, 0 for unmatched.

### 📤 Output:

| order\_id | matched\_customers |               |
| --------- | ------------------ | ------------- |
| 101       | 1                  |               |
| 102       | 1                  |               |
| 103       | 1                  |               |
| 104       | 1                  |               |
| 105       | 1                  |               |
| 106       | 0                  | ✅ no customer |

---

## 🔸 Example 4: RIGHT JOIN with multiple columns

```sql
SELECT 
    o.order_id,
    o.total_amount,
    c.customer_name,
    c.city
FROM 
    customers c
RIGHT JOIN 
    orders o 
    ON c.customer_id = o.customer_id;
```

### 🔍 Output:

| order\_id | total\_amount | customer\_name | city        |
| --------- | ------------- | -------------- | ----------- |
| 101       | 150.75        | John Smith     | New York    |
| 102       | 89.50         | Robert Johnson | Chicago     |
| 103       | 45.25         | John Smith     | New York    |
| 104       | 210.30        | Jane Doe       | Los Angeles |
| 105       | 75.00         | Robert Johnson | Chicago     |
| 106       | 55.00         | NULL           | NULL        |

---

## 🔸 LEFT JOIN vs RIGHT JOIN

| Operation            | LEFT JOIN                     | RIGHT JOIN                     |
| -------------------- | ----------------------------- | ------------------------------ |
| Keeps all rows from  | Left table                    | Right table                    |
| NULLs for missing in | Right table                   | Left table                     |
| Used when            | You want everything from left | You want everything from right |

You can **switch LEFT and RIGHT** by flipping table positions.

---

## ✅ Summary of RIGHT JOIN:

| Feature             | Description                                                                                      |
| ------------------- | ------------------------------------------------------------------------------------------------ |
| Keeps all rows from | **Right table**                                                                                  |
| Missing match?      | Shows **NULLs** for left table                                                                   |
| Common use cases    | - Finding unmatched data on left<br>- Displaying all records from right table even without match |
| Can be rewritten as | LEFT JOIN by switching tables                                                                    |
