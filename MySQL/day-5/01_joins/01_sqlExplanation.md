## 🔸 Query:

```sql
SELECT a.first_name, a.last_name, COUNT(*) AS book_count
FROM authors AS a 
JOIN books AS b 
ON a.author_id = b.author_id 
GROUP BY a.author_id;
```

---

## 🔸 Tables Used:

### Table 1: `authors`

| author\_id | first\_name | last\_name |
| ---------- | ----------- | ---------- |
| 1          | John        | Smith      |
| 2          | Jane        | Doe        |

---

### Table 2: `books`

| book\_id | title  | author\_id |
| -------- | ------ | ---------- |
| 101      | Book A | 1          |
| 102      | Book B | 1          |
| 103      | Book C | 2          |
| 104      | Book D | 1          |

---

## 🔸 Step-by-step Explanation

### 🔹 1. JOIN:

This part:

```sql
FROM authors AS a 
JOIN books AS b 
ON a.author_id = b.author_id
```

Matches each **author** with their books using `author_id`.

👉 Result after `JOIN`:

| first\_name | last\_name | book\_id | title  |
| ----------- | ---------- | -------- | ------ |
| John        | Smith      | 101      | Book A |
| John        | Smith      | 102      | Book B |
| John        | Smith      | 104      | Book D |
| Jane        | Doe        | 103      | Book C |

---

### 🔹 2. GROUP BY:

```sql
GROUP BY a.author_id;
```

Groups all the above rows **by author**, so each group contains the rows (books) written by that author.

---

### 🔹 3. COUNT(\*):

```sql
COUNT(*) AS book_count
```

Counts the number of **rows in each group**.

* For **John Smith (author\_id = 1)** → 3 books
* For **Jane Doe (author\_id = 2)** → 1 book

---

## 🔸 Final Output:

| first\_name | last\_name | book\_count |
| ----------- | ---------- | ----------- |
| John        | Smith      | 3           |
| Jane        | Doe        | 1           |

✅ So the `COUNT(*)` counts how many times that author's `author_id` appears in the `books` table, after the join.

---

## 🔸 Summary:

* The `JOIN` links each book with its author.
* The `GROUP BY` forms a group for each author.
* The `COUNT(*)` counts how many rows (books) are in each group.


---
---
---










## 🔹 Query 1:

```sql
SELECT b.title, a.first_name, a.last_name, 
GROUP_CONCAT(c.category_name SEPARATOR ', ') AS categories
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN book_categories bc ON b.book_id = bc.book_id
JOIN categories c ON bc.category_id = c.category_id
GROUP BY b.book_id;
```

### ✅ What it does:

* Shows each **book title**, its **author**, and a **comma-separated list of all its categories**.

### 🔍 How:

1. Joins 4 tables:

   * `books` (alias `b`)
   * `authors` (alias `a`)
   * `book_categories` (alias `bc`)
   * `categories` (alias `c`)
2. Matches:

   * Book ↔ Author (via `author_id`)
   * Book ↔ Categories (via `book_id`)
   * Category ↔ Name (via `category_id`)
3. Uses `GROUP_CONCAT` to collect all category names of a book as a single string.
4. `GROUP BY` ensures **one row per book**.

### 🧠 Example Output (simplified):

| title               | first\_name | last\_name | categories                  |
| ------------------- | ----------- | ---------- | --------------------------- |
| Pride and Prejudice | Jane        | Austen     | Fiction, Classic, Romance   |
| Animal Farm         | George      | Orwell     | Fiction, Classic, Political |

---

## 🔹 Query 2:

```sql
SELECT b.title, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
                      AND b.publication_year < 1950
                      AND a.birth_year < 1900;
```

### ✅ What it does:

* Returns the **title and author last name** for books that:

  * Were **published before 1950**, and
  * Were written by authors **born before 1900**

### 🔍 Key Detail:

* **Filter conditions** (`< 1950` and `< 1900`) are applied **inside the `ON` clause** of the `INNER JOIN`.

💡 This means the filtering is applied **before** the rows are considered to be part of the join.

> ✅ Equivalent to filtering during the join itself, but **less readable** than using `WHERE`.

---

## 🔹 Query 3:

```sql
SELECT b.title, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE b.publication_year < 1950 
  AND a.birth_year < 1900;
```

### ✅ What it does:

* Same as the previous query — selects titles and author last names for:

  * Books published before 1950
  * Authors born before 1900

### 🔍 Difference:

* This time, the **filter conditions are in the `WHERE` clause**, not inside `JOIN`.

🔄 **Functionally identical** to the previous query in this case — but:

* This version is **more readable and recommended** for clarity.
* Also easier to debug and extend with `LEFT JOIN` or `OUTER JOIN` logic.

---

## 🔹 Query 4:

```sql
SELECT b.title, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE YEAR(CURDATE()) - b.publication_year > 70;
```

### ✅ What it does:

* Finds all **books published more than 70 years ago** from the **current year**.

### 🔍 Explanation:

* `CURDATE()` gets today’s date (e.g., `2025-07-21`)
* `YEAR(CURDATE())` extracts the year (e.g., 2025)
* `YEAR(CURDATE()) - b.publication_year` computes how many years old the book is.
* Filters those where that difference is **more than 70**

So you're retrieving **books that are 71+ years old** and who wrote them.

---

## 🔹 Query 5:

```sql
SELECT a.first_name, 
       a.last_name, 
       COUNT(b.book_id) AS book_count
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id, a.first_name, a.last_name
HAVING COUNT(b.book_id) > 1;
```

### ✅ What it does:

* Lists **authors who have written more than one book**
* Also shows how many books they wrote.

### 🔍 How:

1. `INNER JOIN` connects authors to books.
2. `GROUP BY` groups all rows by author.
3. `COUNT(b.book_id)` counts the number of books per author.
4. `HAVING` filters those **with book count > 1**

> 🧠 Note: `HAVING` is used **after** `GROUP BY`, unlike `WHERE`.

### 🧾 Sample Output:

| first\_name | last\_name | book\_count |
| ----------- | ---------- | ----------- |
| Jane        | Austen     | 2           |
| George      | Orwell     | 2           |
| Ernest      | Hemingway  | 2           |
| Agatha      | Christie   | 2           |

---

## ✅ Summary Table

| Query # | Purpose                                                                      |
| ------- | ---------------------------------------------------------------------------- |
| 1       | Show books with authors and their categories (using `GROUP_CONCAT`)          |
| 2       | Filter books by year and author's birth year (inside JOIN)                   |
| 3       | Same as #2, but filters moved to WHERE clause (preferred)                    |
| 4       | Find books published more than 70 years ago                                  |
| 5       | Find authors who have written more than one book (using `GROUP BY + HAVING`) |














---
---
---





## ✅ Initial Data Snapshot:

### `authors`

| author\_id | first\_name | last\_name | birth\_year |
| ---------- | ----------- | ---------- | ----------- |
| 1          | Jane        | Austen     | 1775        |
| 2          | George      | Orwell     | 1903        |
| 3          | Ernest      | Hemingway  | 1899        |
| 4          | Agatha      | Christie   | 1890        |
| 5          | J.K.        | Rowling    | 1965        |

---

### `books`

| book\_id | title                        | author\_id | publication\_year | price |
| -------- | ---------------------------- | ---------- | ----------------- | ----- |
| 101      | Pride and Prejudice          | 1          | 1813              | 12.99 |
| 102      | 1984                         | 2          | 1949              | 14.50 |
| 103      | Animal Farm                  | 2          | 1945              | 11.75 |
| 104      | The Old Man and the Sea      | 3          | 1952              | 10.99 |
| 105      | Murder on the Orient Express | 4          | 1934              | 13.25 |
| 106      | Death on the Nile            | 4          | 1937              | 12.50 |
| 107      | Emma                         | 1          | 1815              | 11.99 |
| 108      | For Whom the Bell Tolls      | 3          | 1940              | 15.75 |

---

### `categories`

| category\_id | category\_name |
| ------------ | -------------- |
| 1            | Fiction        |
| 2            | Classic        |
| 3            | Romance        |
| 4            | Political      |
| 5            | Mystery        |
| 6            | Adventure      |

---

### `book_categories`

| book\_id | category\_id |
| -------- | ------------ |
| 101      | 1            |
| 101      | 2            |
| 101      | 3            |
| 102      | 1            |
| 102      | 2            |
| 102      | 4            |
| 103      | 1            |
| 103      | 2            |
| 103      | 4            |
| 104      | 1            |
| 104      | 2            |
| 104      | 6            |
| 105      | 1            |
| 105      | 5            |
| 106      | 1            |
| 106      | 5            |
| 107      | 1            |
| 107      | 2            |
| 107      | 3            |
| 108      | 1            |
| 108      | 2            |
| 108      | 6            |

---

## 🔶 QUERY 1:

```sql
SELECT b.title, a.first_name, a.last_name, 
GROUP_CONCAT(c.category_name SEPARATOR ', ') AS categories
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN book_categories bc ON b.book_id = bc.book_id
JOIN categories c ON bc.category_id = c.category_id
GROUP BY b.book_id;
```

### 🧠 What SQL is doing internally:

1. **Step 1: `FROM books b`**

   * Start with all rows from the `books` table.

2. **Step 2: `JOIN authors a ON b.author_id = a.author_id`**

   * For each book, look up the **matching author** from the `authors` table using `author_id`.
   * Adds author’s first and last name to each row.

3. **Step 3: `JOIN book_categories bc ON b.book_id = bc.book_id`**

   * Each book may belong to **multiple categories**.
   * This join creates **duplicate rows** for each category a book is in.

   📌 Example:
   `"Pride and Prejudice"` is linked to 3 categories → this row becomes 3 rows (one per category).

4. **Step 4: `JOIN categories c ON bc.category_id = c.category_id`**

   * Now attach the **actual category name** (like "Fiction", "Romance") to each row.

5. **Step 5: `GROUP BY b.book_id`**

   * Collapse all rows **back into one per book**.

6. **Step 6: `GROUP_CONCAT(...)`**

   * Combine all category names for the book into a single string (e.g., "Fiction, Classic, Romance").

---

### 🎯 Purpose:

**Aggregate category names per book** while still showing author info.
That’s why you use `GROUP BY` and `GROUP_CONCAT`.


### 🔍 Internal Joins:

This joins books + authors + categories. Example for Book 101 ("Pride and Prejudice"):

| title               | author      | category |
| ------------------- | ----------- | -------- |
| Pride and Prejudice | Jane Austen | Fiction  |
| Pride and Prejudice | Jane Austen | Classic  |
| Pride and Prejudice | Jane Austen | Romance  |

Same duplication happens for every book with multiple categories.

### ✅ Final Output:

| title                        | first\_name | last\_name | categories                  |
| ---------------------------- | ----------- | ---------- | --------------------------- |
| Pride and Prejudice          | Jane        | Austen     | Fiction, Classic, Romance   |
| 1984                         | George      | Orwell     | Fiction, Classic, Political |
| Animal Farm                  | George      | Orwell     | Fiction, Classic, Political |
| The Old Man and the Sea      | Ernest      | Hemingway  | Fiction, Classic, Adventure |
| Murder on the Orient Express | Agatha      | Christie   | Fiction, Mystery            |
| Death on the Nile            | Agatha      | Christie   | Fiction, Mystery            |
| Emma                         | Jane        | Austen     | Fiction, Classic, Romance   |
| For Whom the Bell Tolls      | Ernest      | Hemingway  | Fiction, Classic, Adventure |

---

## 🔶 QUERY 2:

```sql
SELECT b.title, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
                      AND b.publication_year < 1950
                      AND a.birth_year < 1900;
```

### 🧠 Internal working:

1. **Step 1: `FROM books b`**

   * Load all rows from the `books` table.

2. **Step 2: `INNER JOIN authors a`**

   * For each book, look for the **matching author** using `author_id`.

3. **Step 3: ON Clause includes filters:**

   ```sql
   b.publication_year < 1950 AND a.birth_year < 1900
   ```

   * **Important**: These filters are **applied before** the join is finalized.
   * SQL will:

     * Only consider books **published before 1950**, and
     * Only match with authors **born before 1900**

4. **Result:**

   * You'll only get book-author pairs **where both filters are true**.

---

### ❗️Important Insight:

Filtering inside the `ON` clause behaves similarly to filtering before the join completes.
That means rows **not satisfying the filter are excluded from the join entirely**.


### 🔍 Filtering during join:

Only matches rows **where:**

* `b.publication_year < 1950`
* `a.birth_year < 1900`

### ✅ Matched Data:

| title                        | last\_name |
| ---------------------------- | ---------- |
| Pride and Prejudice          | Austen     |
| Emma                         | Austen     |
| Animal Farm                  | Orwell     |
| Murder on the Orient Express | Christie   |
| Death on the Nile            | Christie   |
| For Whom the Bell Tolls      | Hemingway  |

---

## 🔶 QUERY 3:

```sql
SELECT b.title, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE b.publication_year < 1950 
  AND a.birth_year < 1900;
```

### 🧠 Internally:

1. **JOIN Phase** (same as query 2):

   * Match books to authors using `author_id`.

2. **WHERE Phase** (after join):

   * Now filter out any rows **after** the join:

     * Keep only those where book is **published before 1950** and author is **born before 1900**.

---

### 🔄 Key Difference from Query 2:

| Query | Filtering Done In | Effect                             |
| ----- | ----------------- | ---------------------------------- |
| #2    | `ON` clause       | Filters happen **during** the join |
| #3    | `WHERE` clause    | Filters happen **after** the join  |

✅ But with `INNER JOIN`, both give the **same output**.
However, using `WHERE` is **clearer** and preferred for readability.


### 🔍 Filtering after join:

Still applies the same conditions but **after the join**. Output is **same as Query 2**.

### ✅ Output:

| title                        | last\_name |
| ---------------------------- | ---------- |
| Pride and Prejudice          | Austen     |
| Emma                         | Austen     |
| Animal Farm                  | Orwell     |
| Murder on the Orient Express | Christie   |
| Death on the Nile            | Christie   |
| For Whom the Bell Tolls      | Hemingway  |

---

## 🔶 QUERY 4:

```sql
SELECT b.title, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE YEAR(CURDATE()) - b.publication_year > 70;
```

### 🧠 Internally:

1. **JOIN books to authors**:

   * Normal inner join using `author_id`.

2. **Filter with `WHERE`:**

   ```sql
   YEAR(CURDATE()) - b.publication_year > 70
   ```

   * Get today’s date using `CURDATE()`, e.g., `2025-07-21`.
   * Extract year → `YEAR(CURDATE()) = 2025`.
   * Subtract `publication_year` of the book.
   * If the result > 70 → this book is more than 70 years old.

3. **Final Result:**

   * Book title and author last name, for **very old books**.

---

### 🔍 Example:

* Book published in 1945: `2025 - 1945 = 80 → ✅`
* Book in 1960: `2025 - 1960 = 65 → ❌`



### 🧮 CURDATE = 2025 → 2025 - pub\_year > 70 → pub\_year < 1955

### ✅ Matching books:

| title                        | last\_name |
| ---------------------------- | ---------- |
| Pride and Prejudice          | Austen     |
| Emma                         | Austen     |
| 1984                         | Orwell     |
| Animal Farm                  | Orwell     |
| Murder on the Orient Express | Christie   |
| Death on the Nile            | Christie   |
| For Whom the Bell Tolls      | Hemingway  |

📌 *Notice*: **"The Old Man and the Sea" (1952)** is included now (because it's older than 70 years in 2025), even though Hemingway was born in 1899.


---

## 🔶 QUERY 5:

```sql
SELECT a.first_name, 
       a.last_name, 
       COUNT(b.book_id) AS book_count
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id, a.first_name, a.last_name
HAVING COUNT(b.book_id) > 1;
```

### 🧠 Internally:

1. **Join authors with their books** using `author_id`.

2. Now you get **1 row per book** with all author info.

3. **GROUP BY**:

   * Group all rows by `author_id`, so all books by the same author are collected together.
   * Each group = 1 author.

4. **COUNT(b.book\_id)**:

   * Counts how many books each author wrote.

5. **HAVING COUNT > 1**:

   * Only keeps those authors who wrote **more than 1 book**.
   * `HAVING` is applied **after** the aggregation (not `WHERE`).



## 🔶 QUERY 5:

```sql
SELECT a.first_name, 
       a.last_name, 
       COUNT(b.book_id) AS book_count
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id, a.first_name, a.last_name
HAVING COUNT(b.book_id) > 1;
```

### 🔍 How it's counted:

| author\_id | first\_name | last\_name | books\_written                |
| ---------- | ----------- | ---------- | ----------------------------- |
| 1          | Jane        | Austen     | 2 → Pride and Prejudice, Emma |
| 2          | George      | Orwell     | 2 → 1984, Animal Farm         |
| 3          | Ernest      | Hemingway  | 2 → Old Man, Bell Tolls       |
| 4          | Agatha      | Christie   | 2 → Orient Express, Nile      |
| 5          | J.K.        | Rowling    | 0 → No books listed           |

### ✅ Output:

| first\_name | last\_name | book\_count |
| ----------- | ---------- | ----------- |
| Jane        | Austen     | 2           |
| George      | Orwell     | 2           |
| Ernest      | Hemingway  | 2           |
| Agatha      | Christie   | 2           |


---

### 🧠 Why `HAVING`, not `WHERE`?

| Clause | When it's applied            | Can access aggregates? |
| ------ | ---------------------------- | ---------------------- |
| WHERE  | Before `GROUP BY`            | ❌ No                   |
| HAVING | After `GROUP BY` + `COUNT()` | ✅ Yes                  |

---

## ✅ FINAL ANALOGY SUMMARY

| Query # | Real-world analogy                                                                               |
| ------- | ------------------------------------------------------------------------------------------------ |
| 1       | "For each book, show me the author and a **list of categories** it belongs to"                   |
| 2       | "Show me books from authors who were **old**, written a **long time ago** (filter during match)" |
| 3       | Same as above, but filtering **after** matching (easier to read)                                 |
| 4       | "Give me books that are **more than 70 years old** from today"                                   |
| 5       | "List authors who have **written more than 1 book**"                                             |

---
---
---


