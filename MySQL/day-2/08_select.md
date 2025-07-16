```sql
SELECT '100' < '2';
```
## ✅ What it looks like:

You're comparing two strings: `'100'` and `'2'` using the **less-than (`<`)** operator.

So naturally, you might expect:

```
100 < 2 → FALSE
```

But the **result is**:

```
SELECT '100' < '2'; 
-- Returns: TRUE (1)
```

😲 Why??

---

## 🧠 MySQL Rule: String Comparison Is **Lexicographical by Default**

When **both operands are strings**, MySQL compares them as **strings**, not as numbers.

---

### Lexicographical = Dictionary Order (like words)

So:

* `'100'` is compared to `'2'`
* First characters: `'1'` < `'2'` → So `'100'` is considered **less than** `'2'`
* That's why: `SELECT '100' < '2'` returns **1 (TRUE)**

---

### 🔸 Visual Explanation:

```
'100'     → ASCII of '1' = 49
'2'       → ASCII of '2' = 50

So: '1' < '2' → TRUE
```

Even though **numerically** `100 > 2`, the comparison is done **character-by-character** as **strings**, not as numbers.

---

## ✅ How to Compare as Numbers Instead?

You must **convert the strings to numbers** implicitly or explicitly.

---

### 🔹 Method 1: Use number literals

```sql
SELECT 100 < 2;  -- FALSE (0)
```

---

### 🔹 Method 2: Cast to number

```sql
SELECT CAST('100' AS UNSIGNED) < CAST('2' AS UNSIGNED);  -- FALSE
```

or

```sql
SELECT '100' + 0 < '2' + 0;  -- FALSE
```

✅ Adding `+ 0` converts strings to numbers.

---

## ✅ Summary

| Query                     | Behavior               | Result    |
| ------------------------- | ---------------------- | --------- |
| `SELECT '100' < '2';`     | Lexical string compare | TRUE (1)  |
| `SELECT 100 < 2;`         | Numeric compare        | FALSE (0) |
| `SELECT '100' + 0 < '2';` | Forced numeric compare | FALSE (0) |



---
---
---


## 🔥 Core Rule in MySQL

When comparing values like:

```sql
SELECT 'abc' < 'def';
```

MySQL **compares them as strings** using **character-by-character ASCII order**.

When mixing **strings and numbers**, MySQL tries to **auto-convert** the string to a number **only if one side is numeric**.

---

## ✅ PART 1: Pure **String vs String** Comparison (Lexical)

| Query                | Result | Reason                                    |
| -------------------- | ------ | ----------------------------------------- |
| `'apple' < 'banana'` | ✅ 1    | `'a' < 'b'`                               |
| `'Zoo' < 'apple'`    | ✅ 1    | `'Z'` = 90 < `'a'` = 97 (ASCII)           |
| `'apple' < 'Apple'`  | ❌ 0    | `'a'` = 97 > `'A'` = 65 (case-sensitive!) |
| `'abc' < 'abz'`      | ✅ 1    | first different char: `'c' < 'z'`         |
| `'abc' < 'abc '`     | ✅ 1    | space has ASCII 32, greater than nothing  |

📌 Note: String comparison is **case-sensitive by default** (unless collation says otherwise).

---

## ✅ PART 2: **String vs Number** — Implicit Conversion

| Query            | Result | Reason                                    |
| ---------------- | ------ | ----------------------------------------- |
| `'100' < '2'`    | ✅ 1    | Both strings → Lexical → `'1' < '2'`      |
| `'100' < 2`      | ❌ 0    | `'100'` → numeric 100, 100 < 2 → FALSE    |
| `'abc' = 0`      | ✅ 1    | `'abc'` → invalid number → becomes `0`    |
| `'123abc' = 123` | ✅ 1    | `'123abc'` → parsed as `123`              |
| `'   456' = 456` | ✅ 1    | leading spaces allowed in conversion      |
| `'abc123' = 123` | ❌ 0    | `'abc'` can't convert to number → 0 ≠ 123 |
| `'12.3' = 12.3`  | ✅ 1    | string `'12.3'` converts to number        |

---

## ✅ PART 3: Using Math to Force Conversion

| Query                 | Result | Why?                       |
| --------------------- | ------ | -------------------------- |
| `'100' + 0 < '2' + 0` | ❌ 0    | 100 < 2                    |
| `'1abc' + 0 = 1`      | ✅ 1    | converts to `1`            |
| `'abc' + 0 = 0`       | ✅ 1    | invalid numeric string → 0 |
| `'123abc' + 0 = 123`  | ✅ 1    | leading numeric part used  |
| `'0abc' + 0 = 0`      | ✅ 1    | converted to 0             |

---

## ✅ PART 4: NULL-safe Comparison (`<=>`)

| Query                         | Result | Reason                    |
| ----------------------------- | ------ | ------------------------- |
| `NULL = NULL`                 | ❌ 0    | NULL ≠ anything           |
| `NULL <=> NULL`               | ✅ 1    | `<=>` is NULL-safe equal  |
| `'abc' <=> NULL`              | ❌ 0    | Still NULL ≠ anything     |
| `CAST(NULL AS CHAR) <=> NULL` | ✅ 1    | Explicit NULL still equal |

---

## ✅ PART 5: Collation Affects String Comparison

* **MySQL string comparisons are affected by collation**
* Examples:

  * `utf8_general_ci` → **case-insensitive**
  * `utf8_bin` → **case-sensitive**

### Example:

```sql
SELECT 'abc' = 'ABC' COLLATE utf8_general_ci; -- ✅ 1 (equal)
SELECT 'abc' = 'ABC' COLLATE utf8_bin;        -- ❌ 0 (not equal)
```

---

## ✅ PART 6: STRANGE BEHAVIORS TO REMEMBER

| Query          | Result | Why?                          |
| -------------- | ------ | ----------------------------- |
| `'abc' > 0`    | ✅ 1    | `'abc'` → 0, so 0 > 0 = FALSE |
| `'abc' = 0`    | ✅ 1    | same as above                 |
| `'abc123' > 0` | ✅ 1    | `'abc123'` → 0                |
| `'123abc' > 0` | ✅ 1    | `'123abc'` → 123              |
| `'a' < 'A'`    | ❌ 0    | `'a'` = 97, `'A'` = 65        |

---

## ✅ Best Practices

| Do                                                                 | Don’t                                                   |
| ------------------------------------------------------------------ | ------------------------------------------------------- |
| Use `CAST()` or `CONVERT()` when comparing string and number types | Don’t rely on implicit conversion in critical logic     |
| Use `BINARY` or `COLLATE` to force case sensitivity                | Don’t assume `'abc' = 'ABC'` unless collation allows it |
| Use `<=>` when comparing `NULL` values                             | Don’t use `=` with `NULL`                               |
