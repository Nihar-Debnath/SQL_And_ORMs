In SQL, **pattern matching** is used to **search for specific text patterns** in string columns — especially useful with the `WHERE` clause.

There are **two main types** of pattern matching in SQL:

---

## ✅ 1. **Pattern Matching using `LIKE` and Wildcards**

### 🔸 Syntax:

```sql
SELECT * FROM table_name
WHERE column_name LIKE 'pattern';
```

### 🔸 Common Wildcards:

| Wildcard | Meaning                  | Example                        |
| -------- | ------------------------ | ------------------------------ |
| `%`      | **0 or more characters** | `'a%'` → starts with 'a'       |
| `_`      | **Exactly 1 character**  | `'h_t'` → matches 'hat', 'hot' |

---

### ✅ Examples:

#### Table: `students`

| id | name  |
| -- | ----- |
| 1  | Alice |
| 2  | Bob   |
| 3  | Ayaan |
| 4  | Ankit |
| 5  | Akira |

---

### 1.1. **Starts with**

```sql
SELECT * FROM students WHERE name LIKE 'A%';
```

✅ Matches: Alice, Ayaan, Ankit, Akira

---

### 1.2. **Ends with**

```sql
SELECT * FROM students WHERE name LIKE '%a';
```

✅ Matches: Akira

---

### 1.3. **Contains**

```sql
SELECT * FROM students WHERE name LIKE '%li%';
```

✅ Matches: Alice

---

### 1.4. **Single Character Wildcard**

```sql
SELECT * FROM students WHERE name LIKE '_ob';
```

✅ Matches: Bob (any 1 character before 'ob')

---

### 1.5. **Combination**

```sql
SELECT * FROM students WHERE name LIKE 'A__a';
```

✅ Matches: Akira (only names starting with A, and 4 characters total, with last 'a')

---

## ✅ 2. **Advanced Pattern Matching using `REGEXP` or `RLIKE` (MySQL)**

This allows **regular expressions**, giving much more power than `LIKE`.

### 🔸 Syntax:

```sql
SELECT * FROM students WHERE name REGEXP 'pattern';
```

---

### ✅ REGEXP Examples:

#### 2.1. **Begins with A**

```sql
SELECT * FROM students WHERE name REGEXP '^A';
```

✅ `^` means starts with

---

#### 2.2. **Ends with a**

```sql
SELECT * FROM students WHERE name REGEXP 'a$';
```

✅ `$` means ends with

---

#### 2.3. **Contains 'ai'**

```sql
SELECT * FROM students WHERE name REGEXP 'ai';
```

✅ Matches names with the sequence 'ai'

---

#### 2.4. **Matches ‘Ankit’ or ‘Akira’**

```sql
SELECT * FROM students WHERE name REGEXP 'Ankit|Akira';
```

✅ `|` is OR in regular expressions

---

#### 2.5. **Contains any vowel**

```sql
SELECT * FROM students WHERE name REGEXP '[aeiou]';
```

✅ Matches any name that contains a vowel

---

#### 2.6. **Only names with digits (if column had numbers)**:

```sql
SELECT * FROM students WHERE name REGEXP '[0-9]';
```

---

## ✅ 3. **NOT LIKE** and **NOT REGEXP**

Used to **exclude** matching patterns:

```sql
SELECT * FROM students WHERE name NOT LIKE '%a';
```

```sql
SELECT * FROM students WHERE name NOT REGEXP '^A';
```

---

## ✅ Summary Table

| Operator     | Description                       | Example                  |
| ------------ | --------------------------------- | ------------------------ |
| `LIKE`       | Basic pattern matching            | `LIKE 'A%'`, `LIKE '%a'` |
| `NOT LIKE`   | Opposite of LIKE                  | `NOT LIKE '%z%'`         |
| `%`          | Wildcard for 0+ characters        | `'A%'` matches 'Alice'   |
| `_`          | Wildcard for exactly 1 character  | `'A__a'`                 |
| `REGEXP`     | Pattern using regular expressions | `REGEXP '^A'`            |
| `NOT REGEXP` | Exclude regex pattern             | `NOT REGEXP '[aeiou]'`   |

---

## ✅ Bonus: Escape Special Characters

If you're matching literal `_` or `%`, use `ESCAPE` keyword:

```sql
SELECT * FROM table_name
WHERE column_name LIKE '50\%%' ESCAPE '\';
```

✅ Matches: `50% discount`

---
---
---





```sql
SELECT * FROM students WHERE name LIKE BINARY '%li%';
```

Let's break it down:

---

## 🔍 What does `LIKE BINARY` do?

### ✅ **`BINARY` keyword makes the comparison case-sensitive**.

By default in MySQL, `LIKE` is **case-insensitive**. That means:

```sql
SELECT * FROM students WHERE name LIKE '%li%';
```

Would match **both** `"Alice"` and `"aLIce"` or `"ALICE"` (if they existed).

But:

```sql
SELECT * FROM students WHERE name LIKE BINARY '%li%';
```

### 👉 Now it matches only if `'li'` is lowercase exactly as written (case-sensitive).

---

## 🧪 Example:

Let’s say your table has:

| name  |
| ----- |
| Alice |
| aLIce |
| ALICE |
| Ayaan |

### Without `BINARY`:

```sql
LIKE '%li%'
```

✅ Matches: Alice, aLIce, ALICE

---

### With `BINARY`:

```sql
LIKE BINARY '%li%'
```

✅ Only matches: **Alice** (exact `'li'` with lowercase `l` and `i`)

---

## ✅ When should you use `LIKE BINARY`?

* When you need **case-sensitive filtering**
* Example: Password matching, usernames, tags, case-specific codes

---

## 🧠 Tip:

If your database collation is already case-sensitive (`utf8mb4_bin`, etc.), then even normal `LIKE` behaves case-sensitive.
