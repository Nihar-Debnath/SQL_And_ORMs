**Advanced SQL filtering techniques** using **`GROUP BY`** and **`HAVING`**

## 🧠 Key Concepts Recap

| Clause   | Filters on              | Runs at         |
| -------- | ----------------------- | --------------- |
| `WHERE`  | **Individual rows**     | Before GROUP BY |
| `HAVING` | **Groups (aggregated)** | After GROUP BY  |

---

## 🧪 Example Table: `sales`

```sql
CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50),
    product VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO sales (customer_name, product, quantity, price, sale_date) VALUES
('Alice', 'Laptop', 1, 80000, '2025-07-01'),
('Alice', 'Mouse', 2, 500, '2025-07-01'),
('Bob', 'Laptop', 1, 80000, '2025-07-02'),
('Bob', 'Mouse', 1, 500, '2025-07-02'),
('Charlie', 'Laptop', 1, 80000, '2025-07-03'),
('Charlie', 'Keyboard', 1, 1500, '2025-07-03'),
('Alice', 'Keyboard', 1, 1500, '2025-07-04'),
('Bob', 'Laptop', 1, 80000, '2025-07-05');
```

---

## ✅ 1. Basic `GROUP BY` — Total purchase per customer

```sql
SELECT customer_name, SUM(price * quantity) AS total_spent
FROM sales
GROUP BY customer_name;
```

### 🔍 Output:

| customer\_name | total\_spent |
| -------------- | ------------ |
| Alice          | 83000        |
| Bob            | 161000       |
| Charlie        | 81500        |

---

## ✅ 2. Using `HAVING` to Filter Aggregates — Only customers who spent > 85,000

```sql
SELECT customer_name, SUM(price * quantity) AS total_spent
FROM sales
GROUP BY customer_name
HAVING total_spent > 85000;
```

### 🔍 Output:

| customer\_name | total\_spent |
| -------------- | ------------ |
| Bob            | 161000       |

---

## ✅ 3. Group by `customer_name`, `product` — Find total quantity bought per product

```sql
SELECT customer_name, product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY customer_name, product;
```

---

## ✅ 4. HAVING with Multiple Conditions

```sql
SELECT customer_name, SUM(price * quantity) AS total_spent
FROM sales
GROUP BY customer_name
HAVING total_spent > 80000 AND total_spent < 90000;
```

### 🔍 Output:

| customer\_name | total\_spent |
| -------------- | ------------ |
| Alice          | 83000        |

---

## ✅ 5. Filter Before Grouping with `WHERE`, After with `HAVING`

### 🎯 Get Laptop sales only, and filter groups with total spent > 80000

```sql
SELECT customer_name, SUM(price * quantity) AS laptop_spent
FROM sales
WHERE product = 'Laptop'
GROUP BY customer_name
HAVING laptop_spent > 80000;
```

---

## ✅ 6. Count Purchases Per Day & Filter for Busy Days

```sql
SELECT sale_date, COUNT(*) AS total_sales
FROM sales
GROUP BY sale_date
HAVING total_sales >= 2;
```

---

## ✅ 7. Use Aliases in `HAVING` (MySQL allows this)

```sql
SELECT customer_name, SUM(price * quantity) AS total
FROM sales
GROUP BY customer_name
HAVING total > 90000;
```

---

## ✅ 8. Filtering Based on Aggregated COUNT

### 🎯 Get customers who bought more than 2 different products

```sql
SELECT customer_name, COUNT(DISTINCT product) AS distinct_products
FROM sales
GROUP BY customer_name
HAVING distinct_products > 2;
```

---

## ✅ 9. Combine `GROUP BY`, `HAVING`, and `ORDER BY`

```sql
SELECT customer_name, SUM(price * quantity) AS total_spent
FROM sales
GROUP BY customer_name
HAVING total_spent > 80000
ORDER BY total_spent DESC;
```

---

## 🧠 Tips

* Use `WHERE` when filtering **before aggregation**.
* Use `HAVING` when filtering **aggregated values**.
* You can group by multiple columns (e.g., `GROUP BY customer, product`).
* You can even group by derived values like `DATE(sale_date)`.

---

## ✅ Want Next?

I can also show:

* Nested `GROUP BY` with subqueries
* `ROLLUP` and `CUBE` (advanced summary stats)
* Using `CASE` inside aggregates for conditional totals

Would you like that?


Perfect! Let’s now explore all **three advanced SQL filtering and grouping techniques** you asked for:

---

## 🔹 1. **Nested `GROUP BY` with Subqueries**

### 🎯 Goal: Show total amount each customer spent **each day**, and then show each customer’s **average daily spending**

We’ll do this in **two steps** using subqueries.

---

### 🧪 Step 1: Subquery — Total per customer per day

```sql
SELECT 
    customer_name,
    sale_date,
    SUM(price * quantity) AS daily_total
FROM sales
GROUP BY customer_name, sale_date;
```

#### 🔍 Output:

| customer\_name | sale\_date | daily\_total |
| -------------- | ---------- | ------------ |
| Alice          | 2025-07-01 | 81000        |
| Alice          | 2025-07-04 | 1500         |
| Bob            | 2025-07-02 | 80500        |
| Bob            | 2025-07-05 | 80000        |
| Charlie        | 2025-07-03 | 81500        |

---

### 🧪 Step 2: Use above as a subquery

```sql
SELECT 
    customer_name,
    AVG(daily_total) AS avg_daily_spending
FROM (
    SELECT 
        customer_name,
        sale_date,
        SUM(price * quantity) AS daily_total
    FROM sales
    GROUP BY customer_name, sale_date
) AS daily_summary
GROUP BY customer_name;
```

#### 🔍 Output:

| customer\_name | avg\_daily\_spending |
| -------------- | -------------------- |
| Alice          | 41250.00             |
| Bob            | 80250.00             |
| Charlie        | 81500.00             |

---

## 🔹 2. `ROLLUP` – Subtotals and Grand Totals

The `WITH ROLLUP` modifier adds subtotals and grand totals **automatically**.

---

### 🎯 Goal: Show total spent by each customer, and also a grand total of **all customers combined**.

```sql
SELECT 
    customer_name,
    SUM(price * quantity) AS total_spent
FROM sales
GROUP BY customer_name WITH ROLLUP;
```

#### 🔍 Output:

| customer\_name | total\_spent              |
| -------------- | ------------------------- |
| Alice          | 83000                     |
| Bob            | 161000                    |
| Charlie        | 81500                     |
| **NULL**       | **325500**  ← Grand total |

> ✅ `NULL` row = grand total!

---

### 🎯 Grouping by multiple columns with subtotal levels

```sql
SELECT 
    customer_name,
    product,
    SUM(price * quantity) AS total
FROM sales
GROUP BY customer_name, product WITH ROLLUP;
```

> This creates:

* Totals per `customer_name` & `product`
* Subtotals per `customer_name`
* Grand total (NULL, NULL)

---

## 🔹 3. `CUBE` (in other SQLs) & Emulation in MySQL

> MySQL does **not support `CUBE` directly**, but we can simulate it using `UNION`.

🎯 Example: Total spent **by customer**, **by product**, and **overall**

```sql
-- By customer
SELECT customer_name, NULL AS product, SUM(price * quantity) AS total_spent
FROM sales
GROUP BY customer_name

UNION

-- By product
SELECT NULL, product, SUM(price * quantity)
FROM sales
GROUP BY product

UNION

-- Overall total
SELECT NULL, NULL, SUM(price * quantity)
FROM sales;
```

---

## Summary Table

| Technique         | Use Case                            | Output Type                   |
| ----------------- | ----------------------------------- | ----------------------------- |
| Nested `GROUP BY` | Aggregations inside aggregations    | Advanced summaries            |
| `WITH ROLLUP`     | Subtotals + grand totals            | Automatic subtotal rows       |
| `CUBE` (manual)   | All combination totals (like pivot) | Full multi-dimensional totals |

---

Would you like:

* A visual **pivot table-style layout** for these?
* Or how to use **GROUPING()** function with `ROLLUP` to distinguish real `NULL` from subtotal `NULL`?


Great question! Let's break this down:

---

## 🔍 What is `GROUPING()` in SQL?

When using `ROLLUP` (or `CUBE` in some DBMS), **subtotal and grand total rows** will contain `NULL` in the grouped columns. But sometimes, your **original data** may actually contain real `NULL` values.

So the question is:

> “Is this `NULL` because of ROLLUP, or was it originally NULL in the data?”

👉 That's where the **`GROUPING()`** function helps.

---

## 🧠 Syntax:

```sql
GROUPING(column_name)
```

* Returns `**1**` if the column is NULL **because of ROLLUP**
* Returns `**0**` if the column was a **real value** (including real `NULL` in data)

---

## ✅ Example Table

| customer\_name | product | price | quantity | sale\_date |
| -------------- | ------- | ----- | -------- | ---------- |
| Alice          | iPhone  | 80000 | 1        | 2025-07-01 |
| Bob            | iPhone  | 80000 | 1        | 2025-07-02 |
| Alice          | Charger | 1500  | 1        | 2025-07-04 |
| Bob            | iPhone  | 500   | 1        | 2025-07-05 |
| Charlie        | iPhone  | 81000 | 1        | 2025-07-03 |

---

## 🧪 SQL Example with `ROLLUP` and `GROUPING()`:

```sql
SELECT 
    customer_name,
    product,
    SUM(price * quantity) AS total_spent,
    GROUPING(customer_name) AS is_customer_rollup,
    GROUPING(product) AS is_product_rollup
FROM sales
GROUP BY customer_name, product WITH ROLLUP;
```

---

### 🔍 Output:

| customer\_name | product | total\_spent | is\_customer\_rollup | is\_product\_rollup        |
| -------------- | ------- | ------------ | -------------------- | -------------------------- |
| Alice          | Charger | 1500         | 0                    | 0                          |
| Alice          | iPhone  | 80000        | 0                    | 0                          |
| Alice          | NULL    | 81500        | 0                    | **1** ← subtotal for Alice |
| Bob            | Charger | 500          | 0                    | 0                          |
| Bob            | iPhone  | 80000        | 0                    | 0                          |
| Bob            | NULL    | 80500        | 0                    | **1**                      |
| Charlie        | iPhone  | 81000        | 0                    | 0                          |
| Charlie        | NULL    | 81000        | 0                    | **1**                      |
| NULL           | NULL    | 243000       | **1**                | **1** ← Grand Total        |

---

## 🟨 What can you do with `GROUPING()`?

You can use it to **label subtotal and grand total rows**:

```sql
SELECT 
    CASE 
        WHEN GROUPING(customer_name) = 1 AND GROUPING(product) = 1 THEN 'Grand Total'
        WHEN GROUPING(product) = 1 THEN CONCAT(customer_name, ' Subtotal')
        ELSE CONCAT(customer_name, ' - ', product)
    END AS label,
    SUM(price * quantity) AS total
FROM sales
GROUP BY customer_name, product WITH ROLLUP;
```

### 📌 Output (formatted):

| label            | total  |
| ---------------- | ------ |
| Alice - Charger  | 1500   |
| Alice - iPhone   | 80000  |
| Alice Subtotal   | 81500  |
| Bob - Charger    | 500    |
| Bob - iPhone     | 80000  |
| Bob Subtotal     | 80500  |
| Charlie - iPhone | 81000  |
| Charlie Subtotal | 81000  |
| Grand Total      | 243000 |
