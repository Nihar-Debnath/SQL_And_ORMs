## ✅ What is an **alias** in MySQL?

An **alias** is a **temporary name** you give to a **column** or **table** in a SQL query to make it more readable or meaningful.

---

### 🔹 Syntax:

```sql
SELECT column_name AS alias_name
FROM table_name AS alias_name;
```

* `AS` is optional — you can also write without `AS`.
* Aliases only exist **during query execution**.

---

## 🧱 1. **Column Alias**:

Used to **rename a column** in the output.

### Example:

```sql
SELECT price * quantity AS total_cost
FROM products;
```

🟢 Output column will be named `total_cost`, not the raw expression.

### Without AS (still works):

```sql
SELECT price * quantity total_cost
FROM products;
```

---

## 🧱 2. **Table Alias**:

Used to give a **short name** to a table (especially helpful with joins).

### Example:

```sql
SELECT p.name, c.category_name
FROM products AS p
JOIN categories AS c
ON p.category_id = c.id;
```

* `p` and `c` are **aliases** for `products` and `categories`.
* Makes your query **shorter** and **easier to read**.

---

## 💡 Why use aliases?

| Use Case                      | Why It Helps                         |
| ----------------------------- | ------------------------------------ |
| Complex calculations          | Name them clearly in output          |
| Long table names              | Use short aliases to simplify joins  |
| Subqueries and derived tables | Required to give the subquery a name |
| Renaming for clarity          | Show meaningful names in result      |

---

## 🧪 Example with subquery alias:

```sql
SELECT *
FROM (
    SELECT name, price FROM products
    WHERE stock_quantity < 10
) AS low_stock_products;
```

* Here, `low_stock_products` is the alias for the subquery (a **derived table**).
* Without this alias, MySQL will throw an error.

---

## 🔄 Summary:

| Alias Type     | Example                           | Purpose                     |
| -------------- | --------------------------------- | --------------------------- |
| Column alias   | `SELECT price AS product_price`   | Rename result column        |
| Table alias    | `FROM products AS p`              | Shorten long table names    |
| Subquery alias | `FROM (SELECT ...) AS some_table` | Required for derived tables |
