## 📋 Sample Data Recap

### `customers` table:

| customer\_id | customer\_name | email                                             | city        |
| ------------ | -------------- | ------------------------------------------------- | ----------- |
| 1            | John Smith     | [john@example.com](mailto:john@example.com)       | New York    |
| 2            | Jane Doe       | [jane@example.com](mailto:jane@example.com)       | Los Angeles |
| 3            | Robert Johnson | [robert@example.com](mailto:robert@example.com)   | Chicago     |
| 4            | Emily Davis    | [emily@example.com](mailto:emily@example.com)     | Houston     |
| 5            | Michael Brown  | [michael@example.com](mailto:michael@example.com) | Phoenix     |

### `orders` table:

| order\_id | customer\_id | order\_date | total\_amount |
| --------- | ------------ | ----------- | ------------- |
| 101       | 1            | 2023-01-15  | 150.75        |
| 102       | 3            | 2023-01-16  | 89.50         |
| 103       | 1            | 2023-01-20  | 45.25         |
| 104       | 2            | 2023-01-25  | 210.30        |
| 105       | 3            | 2023-02-01  | 75.00         |

### `shipping` table:

| shipping\_id | order\_id | shipping\_date | carrier | tracking\_number |
| ------------ | --------- | -------------- | ------- | ---------------- |
| 1001         | 101       | 2023-01-16     | FedEx   | FDX123456789     |
| 1002         | 104       | 2023-01-26     | UPS     | UPS987654321     |
| 1003         | 105       | 2023-02-02     | USPS    | USPS456789123    |

---

## ✅ LEFT JOIN Queries with Output and Explanation

---

### **Example 1: Basic LEFT JOIN**

```sql
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
```

🎯 **What it does**:

* Fetches **all customers**.
* If a customer has made **orders**, those are shown.
* If **no order**, `NULL` appears for order details.

📤 **Output**:

| customer\_id | customer\_name | order\_id | order\_date | total\_amount |
| ------------ | -------------- | --------- | ----------- | ------------- |
| 1            | John Smith     | 101       | 2023-01-15  | 150.75        |
| 1            | John Smith     | 103       | 2023-01-20  | 45.25         |
| 2            | Jane Doe       | 104       | 2023-01-25  | 210.30        |
| 3            | Robert Johnson | 102       | 2023-01-16  | 89.50         |
| 3            | Robert Johnson | 105       | 2023-02-01  | 75.00         |
| 4            | Emily Davis    | NULL      | NULL        | NULL          |
| 5            | Michael Brown  | NULL      | NULL        | NULL          |

---

### **Example 2: Customers with No Orders**

```sql
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

🎯 **What it does**:

* Uses LEFT JOIN to get all customers.
* Filters those who had **no match** in `orders` (i.e., `order_id IS NULL`).

📤 **Output**:

| customer\_id | customer\_name |
| ------------ | -------------- |
| 4            | Emily Davis    |
| 5            | Michael Brown  |

---

### **Example 3: Aggregate with LEFT JOIN**

```sql
SELECT 
    c.customer_id, 
    c.customer_name, 
    COUNT(o.order_id) AS order_count, 
    IFNULL(SUM(o.total_amount), 0) AS total_spent 
FROM 
    customers c 
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id 
GROUP BY 
    c.customer_id;
```

🎯 **What it does**:

* Shows **all customers**.
* Counts how many orders they’ve placed.
* Shows their **total spending**.
* Uses `IFNULL(..., 0)` for customers with no orders.

📤 **Output**:

| customer\_id | customer\_name | order\_count | total\_spent |
| ------------ | -------------- | ------------ | ------------ |
| 1            | John Smith     | 2            | 196.00       |
| 2            | Jane Doe       | 1            | 210.30       |
| 3            | Robert Johnson | 2            | 164.50       |
| 4            | Emily Davis    | 0            | 0.00         |
| 5            | Michael Brown  | 0            | 0.00         |

---

### **Example 4: Multiple LEFT JOINs**

```sql
SELECT 
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    s.carrier,
    s.tracking_number
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
LEFT JOIN 
    shipping s ON o.order_id = s.order_id;
```

🎯 **What it does**:

* Gets all customers.
* Joins orders if any.
* Also gets shipping details for those orders (if shipped).

📤 **Output**:

| customer\_name | order\_id | order\_date | total\_amount | carrier | tracking\_number |
| -------------- | --------- | ----------- | ------------- | ------- | ---------------- |
| John Smith     | 101       | 2023-01-15  | 150.75        | FedEx   | FDX123456789     |
| John Smith     | 103       | 2023-01-20  | 45.25         | NULL    | NULL             |
| Jane Doe       | 104       | 2023-01-25  | 210.30        | UPS     | UPS987654321     |
| Robert Johnson | 102       | 2023-01-16  | 89.50         | NULL    | NULL             |
| Robert Johnson | 105       | 2023-02-01  | 75.00         | USPS    | USPS456789123    |
| Emily Davis    | NULL      | NULL        | NULL          | NULL    | NULL             |
| Michael Brown  | NULL      | NULL        | NULL          | NULL    | NULL             |

---

### **Example 5: WHERE vs ON Filtering**

#### Method 1: Filter in `WHERE` clause

```sql
SELECT ...
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id 
WHERE c.city = 'New York';
```

🧠 **Effect**: Returns **only customers from New York** who also have orders.
But if there are **no orders**, the row might be **filtered out** because of `WHERE`.

📤 **Output**:

| customer\_id | customer\_name | city     | order\_id | order\_date | total\_amount |
| ------------ | -------------- | -------- | --------- | ----------- | ------------- |
| 1            | John Smith     | New York | 101       | 2023-01-15  | 150.75        |
| 1            | John Smith     | New York | 103       | 2023-01-20  | 45.25         |

---

#### Method 2: Filter in `ON` clause

```sql
LEFT JOIN orders o ON c.customer_id = o.customer_id AND c.city = 'New York';
```

🧠 **Effect**: Joins only **New York customers** with orders, but still keeps **all customers** in output.

📤 **Output**:
Same as previous, but in different situations it keeps non-matching customers too.

---

#### Method 3: Filter left table using subquery

```sql
FROM (SELECT * FROM customers WHERE city = 'New York') c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
```

🧠 **Effect**: Filters left table to only customers in New York, **before** the join happens.

📤 **Output**:

Same as Method 1 — clean and controlled.

---

### **Example 6: Customers who haven't ordered in the last 30 days**

```sql
SELECT 
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.customer_name
HAVING 
    MAX(o.order_date) IS NULL 
    OR MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 30 DAY);
```

🎯 **What it does**:

* Shows customers whose **most recent order** is older than 30 days or **who never ordered**.

📤 **Assuming today is `2023-03-05`**, output:

| customer\_id | customer\_name | last\_order\_date |
| ------------ | -------------- | ----------------- |
| 1            | John Smith     | 2023-01-20        |
| 2            | Jane Doe       | 2023-01-25        |
| 3            | Robert Johnson | 2023-02-01        |
| 4            | Emily Davis    | NULL              |
| 5            | Michael Brown  | NULL              |

✅ After filtering:

| customer\_id | customer\_name | last\_order\_date |
| ------------ | -------------- | ----------------- |
| 1            | John Smith     | 2023-01-20        |
| 2            | Jane Doe       | 2023-01-25        |
| 4            | Emily Davis    | NULL              |
| 5            | Michael Brown  | NULL              |

---

## 🧠 Summary of What You Learned

* **LEFT JOIN**: Always keeps **all rows from the left table**.
* If **no match**, right table columns are filled with **NULL**.
* You can:

  * Filter out unmatched rows.
  * Count and sum data with unmatched values safely using `IFNULL`.
  * Chain multiple LEFT JOINs.
  * Control filtering location (`WHERE` vs `ON`) for accurate results.