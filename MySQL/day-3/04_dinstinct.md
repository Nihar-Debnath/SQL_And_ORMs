## ✅ What is `DISTINCT` in SQL?

The `DISTINCT` keyword is used in `SELECT` to **remove duplicate rows** from the result set.

---

## 🔹 Basic Syntax:

```sql
SELECT DISTINCT column1, column2, ...
FROM table_name;
```

* It **compares entire rows** based on the columns listed.
* If two rows are **identical** in those selected columns, only **one copy** will be returned.

---

## 🧱 1. **Single Column Example:**

```sql
SELECT DISTINCT category FROM products;
```

🔸 This returns **each unique category** from the `products` table.

If your table has:

| id | name   | category   |
| -- | ------ | ---------- |
| 1  | Pen    | Stationery |
| 2  | Pencil | Stationery |
| 3  | Banana | Grocery    |

🔹 Output will be:

| category   |
| ---------- |
| Stationery |
| Grocery    |

---

## 🧱 2. **Multiple Columns Example:**

```sql
SELECT DISTINCT category, brand FROM products;
```

This returns **unique combinations** of category and brand.

---

## 🧠 Important Note:

`DISTINCT` compares **all the selected columns together** — not each one separately.

So:

```sql
SELECT DISTINCT brand, price FROM products;
```

This will only remove rows where **both brand and price are the same** — not just duplicate brands.

---

## 🔍 With Expressions:

You can use expressions too:

```sql
SELECT DISTINCT price * quantity AS total_cost FROM products;
```

Returns unique `total_cost` values.

---

## 💡 Tip: Use with `COUNT()` to count unique values

```sql
SELECT COUNT(DISTINCT category) FROM products;
```

Gives you the **number of different categories**.

---

## ⚠️ Common Confusions:

### ❌ Misconception:

```sql
SELECT DISTINCT brand, price
```

This does **not** mean:

> Get distinct `brand` and distinct `price`

Instead, it means:

> Get distinct combinations of (brand, price)

---

## 🚀 Advanced Usage

### 🔸 With ORDER BY:

```sql
SELECT DISTINCT category FROM products ORDER BY category;
```

### 🔸 With WHERE:

```sql
SELECT DISTINCT category FROM products WHERE stock_quantity > 10;
```

### 🔸 With JOIN:

```sql
SELECT DISTINCT p.category, c.name
FROM products p
JOIN categories c ON p.category_id = c.id;
```

---

## 🧪 Example Table:

| id | name   | brand    | price |
| -- | ------ | -------- | ----- |
| 1  | Pen    | Reynolds | 10    |
| 2  | Pen    | Reynolds | 10    |
| 3  | Pencil | Natraj   | 5     |
| 4  | Pencil | Natraj   | 5     |
| 5  | Eraser | Apsara   | 3     |

---

### `SELECT DISTINCT brand, price`:

| brand    | price |
| -------- | ----- |
| Reynolds | 10    |
| Natraj   | 5     |
| Apsara   | 3     |

---

## 🔄 Summary Table:

| Use Case                             | Query Example                                   | Purpose                            |
| ------------------------------------ | ----------------------------------------------- | ---------------------------------- |
| Remove duplicate column values       | `SELECT DISTINCT brand FROM products`           | Unique brands only                 |
| Unique combinations of multiple cols | `SELECT DISTINCT brand, price FROM products`    | Unique brand-price pairs           |
| Count unique values                  | `SELECT COUNT(DISTINCT category) FROM products` | Total different categories         |
| Use with expressions                 | `SELECT DISTINCT price * quantity`              | Unique calculated values           |
| Works with WHERE, JOIN, ORDER BY     | Yes ✅                                           | Filtered and ordered distinct rows |

---
---
---

## 🧨 Why `DISTINCT` Can Be a Performance Problem

### ❗ Problem:

`DISTINCT` forces MySQL to:

1. Fetch all rows that match your query.
2. Compare all selected columns.
3. Remove duplicates — using sorting or hashing.

---

### 🔍 Example:

```sql
SELECT DISTINCT name FROM products;
```

If the `products` table has **1 million rows**, and there's **no index on `name`**, MySQL has to:

* Read 1M rows
* Sort them to find unique `name`s
* Remove duplicates

---

## 🛑 Performance Bottlenecks

| Problem                                    | Reason                                             |
| ------------------------------------------ | -------------------------------------------------- |
| Full table scans                           | If no useful index exists                          |
| Large data sets                            | Sorting/deduplication is memory- and CPU-intensive |
| Using `DISTINCT` on expressions            | Prevents index usage                               |
| Using multiple large columns in `DISTINCT` | MySQL must compare entire row chunks               |

---

## ✅ How to Improve or Solve Performance Issues

### 1. 📌 **Use Indexes**

If you're doing:

```sql
SELECT DISTINCT name FROM products;
```

Then make sure `name` is indexed:

```sql
CREATE INDEX idx_name ON products(name);
```

✅ MySQL can use the index to retrieve unique values directly — **no full scan**.

---

### 2. 🧠 **Use `GROUP BY` Instead (Sometimes)**

```sql
SELECT DISTINCT name FROM products;
```

is functionally same as:

```sql
SELECT name FROM products GROUP BY name;
```

✅ `GROUP BY` sometimes uses more optimized query plans.

You can even add aggregates if needed:

```sql
SELECT name, COUNT(*) FROM products GROUP BY name;
```

---

### 3. ✂️ **Limit Selected Columns**

Avoid this:

```sql
SELECT DISTINCT * FROM big_table;
```

Do this:

```sql
SELECT DISTINCT column1 FROM big_table;
```

✅ Less data = faster deduplication

---

### 4. 🔄 **Use EXISTS Instead of DISTINCT in Subqueries**

Instead of:

```sql
SELECT DISTINCT customer_id
FROM orders
WHERE order_total > 500;
```

Use:

```sql
SELECT customer_id
FROM customers c
WHERE EXISTS (
   SELECT 1 FROM orders o WHERE o.customer_id = c.id AND o.order_total > 500
);
```

✅ This can be faster if there's an index on `orders.customer_id`.

---

### 5. 🧮 **Use `UNIQUE` Index When Possible**

If you *know* your column should be unique, enforce it:

```sql
ALTER TABLE users ADD UNIQUE(email);
```

Then just use:

```sql
SELECT email FROM users;
```

✅ No need for `DISTINCT` at all.

---

## 💣 Performance Killers with `DISTINCT`

| Query Pattern                        | Why it's bad                          |
| ------------------------------------ | ------------------------------------- |
| `SELECT DISTINCT * FROM large_table` | Deduplicates all columns = very slow  |
| `SELECT DISTINCT col1, col2*col3`    | Can't use index due to expression     |
| `SELECT DISTINCT` + `ORDER BY`       | Sorting + deduping = memory-intensive |
| `DISTINCT` with joins                | Duplicate rows due to join explosion  |

---

## 📌 Summary: Best Practices

| Tip                                           | Benefit                          |
| --------------------------------------------- | -------------------------------- |
| Index the columns used in `DISTINCT`          | Fast retrieval of unique values  |
| Use `GROUP BY` when applicable                | Can be optimized better          |
| Select only needed columns                    | Reduces processing               |
| Avoid complex expressions                     | Keeps query index-friendly       |
| Use `EXISTS` instead of subquery + `DISTINCT` | Avoids unnecessary deduplication |
| Use `LIMIT` when possible                     | Avoids fetching too many rows    |
