# ✅ What is `LEFT JOIN`?

A `LEFT JOIN` returns:

> ✅ **All rows from the LEFT table**
> ➕ The **matching rows** from the RIGHT table
> ❌ If there's **no match** in the right table, it fills with **NULLs**

---

## 🔸 Basic Syntax

```sql
SELECT columns
FROM left_table
LEFT JOIN right_table
ON left_table.column = right_table.column;
```

---

## 🔸 Real Example: `authors` and `books`

Let's use your data again:

### `authors` (left table)

| author\_id | first\_name | last\_name |
| ---------- | ----------- | ---------- |
| 1          | Jane        | Austen     |
| 2          | George      | Orwell     |
| 3          | Ernest      | Hemingway  |
| 4          | Agatha      | Christie   |
| 5          | J.K.        | Rowling    |

### `books` (right table)

| book\_id | title                        | author\_id |
| -------- | ---------------------------- | ---------- |
| 101      | Pride and Prejudice          | 1          |
| 102      | 1984                         | 2          |
| 103      | Animal Farm                  | 2          |
| 104      | The Old Man and the Sea      | 3          |
| 105      | Murder on the Orient Express | 4          |
| 106      | Death on the Nile            | 4          |
| 107      | Emma                         | 1          |
| 108      | For Whom the Bell Tolls      | 3          |

---

## 🔶 LEFT JOIN Example

```sql
SELECT a.first_name, a.last_name, b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id;
```

---

## 🧠 What happens internally:

1. SQL engine starts with all rows in the **authors** table.
2. For each `author_id`, it searches in the `books` table.
3. If a match is found:

   * The author’s data + book title is included.
   * If multiple books → multiple rows per author.
4. If no match:

   * The author’s data is shown with **NULL** for `b.title`.

---

## ✅ Output:

| first\_name | last\_name | title                        |
| ----------- | ---------- | ---------------------------- |
| Jane        | Austen     | Pride and Prejudice          |
| Jane        | Austen     | Emma                         |
| George      | Orwell     | 1984                         |
| George      | Orwell     | Animal Farm                  |
| Ernest      | Hemingway  | The Old Man and the Sea      |
| Ernest      | Hemingway  | For Whom the Bell Tolls      |
| Agatha      | Christie   | Murder on the Orient Express |
| Agatha      | Christie   | Death on the Nile            |
| J.K.        | Rowling    | **NULL**                     |

---

### 🎯 Why is `J.K. Rowling → NULL`?

Because:

* She's in the `authors` table (left side)
* But has **no matching rows** in `books` (right side)

So `LEFT JOIN` shows her with **no book** → NULL in `b.title`.

---

## 🔸 Visual Representation:

```
Authors (Left Table)         Books (Right Table)

1. Jane Austen         ←      Pride and Prejudice
                        ←      Emma

2. George Orwell       ←      1984
                        ←      Animal Farm

3. Ernest Hemingway    ←      The Old Man and the Sea
                        ←      For Whom the Bell Tolls

4. Agatha Christie     ←      Murder on the Orient Express
                        ←      Death on the Nile

5. J.K. Rowling        ←      NULL (no book)
```

---

## 🔸 LEFT JOIN vs INNER JOIN

| Type         | What it returns                                                     |
| ------------ | ------------------------------------------------------------------- |
| `INNER JOIN` | Only rows that match in **both tables**                             |
| `LEFT JOIN`  | All rows from **left table**, with matching rows (or NULL) on right |

---

## 🔶 LEFT JOIN with WHERE condition

```sql
SELECT a.first_name, a.last_name, b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
WHERE b.title IS NULL;
```

### ✅ Output:

| first\_name | last\_name | title |
| ----------- | ---------- | ----- |
| J.K.        | Rowling    | NULL  |

### 🎯 What this does:

* This filters only authors who have **no books**.

---

## 🔸 LEFT JOIN with Aggregation (Count Books per Author)

```sql
SELECT a.first_name, a.last_name, COUNT(b.book_id) AS book_count
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id;
```

### ✅ Output:

| first\_name | last\_name | book\_count |
| ----------- | ---------- | ----------- |
| Jane        | Austen     | 2           |
| George      | Orwell     | 2           |
| Ernest      | Hemingway  | 2           |
| Agatha      | Christie   | 2           |
| J.K.        | Rowling    | 0           |

💡 This works because `COUNT(b.book_id)` ignores `NULL`s, so Rowling gets 0.

---

## 🔶 When to use LEFT JOIN

Use LEFT JOIN when:

✅ You want **all rows from the left table**
➕ You want to show **missing related data** from the right table
🧠 Especially useful for:

* Finding "who has no ...?"
* Optional data (e.g., users with or without posts, students without marks)

---

## 🔄 Summary Table

| Join Type   | Returns                                                |
| ----------- | ------------------------------------------------------ |
| INNER JOIN  | Only matched rows from both tables                     |
| LEFT JOIN   | All rows from left, matched rows (or NULLs) from right |
| RIGHT JOIN  | All rows from right, matched rows from left            |
| FULL JOIN\* | All rows from both (not supported in MySQL directly)   |
