## 🔍 What is `EXPLAIN` in SQL?

```sql
EXPLAIN SELECT * FROM products;
```

### ✅ `EXPLAIN` is **used to analyze how SQL will execute your query.**

It shows the **query plan** — meaning **how the database will retrieve the data**:
Will it use an index? Will it scan the whole table? How efficient is it?

---

## 📌 When is `EXPLAIN` used?

* To **optimize** performance.
* To **debug slow queries**.
* To see if indexes are being used.
* To understand what MySQL or PostgreSQL is *doing behind the scenes*.

---

## 🧠 Output Example (MySQL):

```sql
EXPLAIN SELECT * FROM products WHERE price > 1000;
```

You might see something like this:

| id | select\_type | table    | type  | possible\_keys | key          | rows | Extra       |
| -- | ------------ | -------- | ----- | -------------- | ------------ | ---- | ----------- |
| 1  | SIMPLE       | products | range | price\_index   | price\_index | 10   | Using where |

### 🔑 Explanation of Columns:

* `id`: Query step
* `select_type`: Type of SELECT (SIMPLE, SUBQUERY, etc.)
* `table`: The table used
* `type`: Join/search type (very important: `ALL`, `index`, `range`, `ref`, etc.)
* `possible_keys`: What indexes *could* be used
* `key`: What index *is actually used*
* `rows`: Approx. how many rows will be scanned
* `Extra`: Extra info like `Using where`, `Using temporary`, `Using filesort`

---

## 🚀 Example Use Case

### Your query:

```sql
SELECT * FROM products WHERE stock_quantity <= 50 ORDER BY price;
```

### With EXPLAIN:

```sql
EXPLAIN SELECT * FROM products WHERE stock_quantity <= 50 ORDER BY price;
```

This tells you:

* Is it doing a **full table scan**? (bad for performance)
* Is it using **indexes**?
* Will it **sort in memory** or use index for `ORDER BY`?

---

## ⚠️ Summary:

| Keyword   | Meaning                                                                                    |
| --------- | ------------------------------------------------------------------------------------------ |
| `EXPLAIN` | Shows how MySQL/PostgreSQL will **execute** your query — helps you understand and optimize |

---

Would you like me to show how to **read `EXPLAIN` results** for a real query or when to **add indexes** based on it?


Perfect! Let’s now **deep dive into reading `EXPLAIN` output** and understanding how to use it to **optimize your SQL queries.**

---

## 🧪 Let’s Start With This Query:

```sql
EXPLAIN SELECT * FROM products WHERE stock_quantity <= 50 ORDER BY price;
```

Let’s say your table `products` looks like this:

| id | name      | price | stock\_quantity |
| -- | --------- | ----- | --------------- |
| 1  | Laptop    | 1000  | 200             |
| 2  | Mouse     | 50    | 20              |
| 3  | Keyboard  | 80    | 25              |
| 4  | Monitor   | 150   | 50              |
| 5  | Headphone | 200   | 80              |

---

## 🧾 Typical `EXPLAIN` Output:

| id | select\_type | table    | type | possible\_keys | key  | rows | Extra                       |
| -- | ------------ | -------- | ---- | -------------- | ---- | ---- | --------------------------- |
| 1  | SIMPLE       | products | ALL  | NULL           | NULL | 1000 | Using where; Using filesort |

---

## 🔍 How to Read Each Column:

| Column             | Meaning                                                            |
| ------------------ | ------------------------------------------------------------------ |
| **id**             | Step number in the execution plan (usually `1` for simple queries) |
| **select\_type**   | `SIMPLE`, `SUBQUERY`, `DERIVED`, etc.                              |
| **table**          | Name of the table being accessed                                   |
| **type**           | Access type: tells how rows are fetched                            |
| **possible\_keys** | Which indexes *could* be used                                      |
| **key**            | Which index is *actually* being used                               |
| **rows**           | Estimated number of rows MySQL will scan                           |
| **Extra**          | Additional info like `Using where`, `Using filesort`               |

---

## ⚠️ `type: ALL` means:

> **Full Table Scan** — the worst-case scenario for large tables.

It will read every row one by one and apply the filter `stock_quantity <= 50`.

---

## 💥 Problem:

You’re filtering on `stock_quantity` and sorting on `price`, but there's **no index** on either of those fields.

As a result:

* MySQL reads **all rows** (`type: ALL`)
* Then filters rows in memory (`Using where`)
* Then sorts the result in memory (`Using filesort`)

---

## ✅ How to Optimize This

### 1. Add Index on the Filter Column:

```sql
CREATE INDEX idx_stock_quantity ON products(stock_quantity);
```

Then run:

```sql
EXPLAIN SELECT * FROM products WHERE stock_quantity <= 50 ORDER BY price;
```

Now you might see:

| type  | key                  | rows | Extra                       |
| ----- | -------------------- | ---- | --------------------------- |
| range | idx\_stock\_quantity | 30   | Using where; Using filesort |

✅ **type: range** = good
✅ Now it's only scanning \~30 rows instead of 1000

---

### 2. Add Composite Index for Filter + Sort:

```sql
CREATE INDEX idx_stock_price ON products(stock_quantity, price);
```

Then run `EXPLAIN` again.

Now you might see:

| type  | key               | rows | Extra       |
| ----- | ----------------- | ---- | ----------- |
| range | idx\_stock\_price | 30   | Using where |

✅ **No filesort!**
✅ MySQL uses the index to both **filter and sort**

---

## 🧠 Summary of What You Look for in EXPLAIN:

| What You See     | What It Means                 | What to Do                       |
| ---------------- | ----------------------------- | -------------------------------- |
| `type: ALL`      | Full table scan               | Add indexes                      |
| `key: NULL`      | No index used                 | Add index on filter/sort columns |
| `Using filesort` | Sorting done in memory (slow) | Add index to cover `ORDER BY`    |
| `Using where`    | Filter applied                | That’s fine (if indexed)         |

---

## ✅ TL;DR

Use `EXPLAIN SELECT ...` to:

* See how your query behaves
* Identify slow parts (like `ALL` and `filesort`)
* Add **indexes** to avoid scanning and sorting
