## 🔹 1. **String Functions**

| Function                                 | Description                         | Example                                               |
| ---------------------------------------- | ----------------------------------- | ----------------------------------------------------- |
| `UPPER(str)`                             | Converts string to uppercase        | `SELECT UPPER('hello');` → `'HELLO'`                  |
| `LOWER(str)`                             | Converts string to lowercase        | `SELECT LOWER('HELLO');` → `'hello'`                  |
| `LENGTH(str)`                            | Returns length of string            | `SELECT LENGTH('SQL');` → `3`                         |
| `CHAR_LENGTH(str)`                       | Same as `LENGTH` (depends on DB)    | `SELECT CHAR_LENGTH('SQL');`                          |
| `SUBSTRING(str, start, len)` or `SUBSTR` | Extracts substring                  | `SELECT SUBSTRING('Database', 1, 4);` → `'Data'`      |
| `CONCAT(str1, str2, ...)`                | Joins strings                       | `SELECT CONCAT('SQL', 'Tutorial');` → `'SQLTutorial'` |
| `TRIM(str)`                              | Removes leading and trailing spaces | `SELECT TRIM(' hello ');` → `'hello'`                 |
| `REPLACE(str, old, new)`                 | Replaces part of string             | `SELECT REPLACE('abcabc', 'a', 'x');` → `'xbcxbc'`    |
| `INSTR(str, substr)`                     | Returns position of substr          | `SELECT INSTR('Database', 'base');` → `5`             |
| `LEFT(str, len)`                         | Gets left part                      | `SELECT LEFT('SQLFunction', 3);` → `'SQL'`            |
| `RIGHT(str, len)`                        | Gets right part                     | `SELECT RIGHT('SQLFunction', 8);` → `'Function'`      |


## 🔸 EXPLAINING ADDITIONAL STRING FUNCTIONS

### 1. `LOCATE(substr, str [, start])`

Returns the position (1-based index) of the first occurrence of a substring.

```sql
SELECT LOCATE('is', 'This is SQL');      -- Result: 6
SELECT LOCATE('is', 'This is SQL', 4);   -- Result: 6
```

---

### 2. `REVERSE(str)`

Reverses the string.

```sql
SELECT REVERSE('hello');   -- Output: 'olleh'
```

---

### 3. `ASCII(char)`

Returns the ASCII value of the first character.

```sql
SELECT ASCII('A');     -- Output: 65
SELECT ASCII('₹');     -- Output: Depends on character encoding
```

---

### 4. `FIELD(str, val1, val2, ...)`

Returns the **index (1-based)** of the matching value in the list.

```sql
SELECT FIELD('orange', 'apple', 'orange', 'banana');   -- Output: 2
SELECT FIELD('grape', 'apple', 'orange', 'banana');    -- Output: 0 (no match)
```

---

### 5. `LENGTH(str)` vs `CHAR_LENGTH(str)`

* `LENGTH()` returns **bytes**.
* `CHAR_LENGTH()` returns **number of characters**.

```sql
-- English
SELECT LENGTH('abc');         -- 3 bytes
SELECT CHAR_LENGTH('abc');    -- 3 characters

-- Unicode (e.g. Hindi: "अ")
SELECT LENGTH('अ');           -- 3 bytes (UTF-8)
SELECT CHAR_LENGTH('अ');      -- 1 character
```

---

### 6. `SOUNDEX(str)`

Returns a phonetic representation of the string (used for fuzzy matching of similar-sounding words).

```sql
SELECT SOUNDEX('Smith');    -- S530
SELECT SOUNDEX('Smyth');    -- S530 (sounds the same)
```

---

## 🔸 SQL TABLE + INSERT + QUERY FOR ALL STRING FUNCTIONS

### Step 1: ✅ Create a table

```sql
CREATE TABLE string_examples (
    id INT AUTO_INCREMENT PRIMARY KEY,
    word1 VARCHAR(100),
    word2 VARCHAR(100),
    mixed_text VARCHAR(255)
);
```

---

### Step 2: ✅ Insert some test values

```sql
INSERT INTO string_examples (word1, word2, mixed_text) VALUES
('hello', 'WORLD', '  This is a MySQL string test  '),
('अ', 'abc', '   Unicode test अ आ इ   '),
('Smith', 'Smyth', 'Sound Match'),
('banana', 'orange', 'fruit salad'),
('abcdef', 'cd', 'substring locate test');
```

---

### Step 3: ✅ Run string function queries

```sql
-- UPPER & LOWER
SELECT word1, UPPER(word1), LOWER(word2) FROM string_examples;

-- LENGTH (bytes) vs CHAR_LENGTH (characters)
SELECT mixed_text, LENGTH(mixed_text) AS byte_length, CHAR_LENGTH(mixed_text) AS char_length FROM string_examples;

-- TRIM
SELECT TRIM(mixed_text) AS trimmed_text FROM string_examples;

-- SUBSTRING
SELECT SUBSTRING(word1, 2, 3) AS sub FROM string_examples;

-- CONCAT
SELECT CONCAT(word1, '-', word2) AS joined FROM string_examples;

-- REPLACE
SELECT REPLACE(word1, 'l', 'X') AS replaced FROM string_examples;

-- INSTR
SELECT INSTR(word1, 'l') AS position FROM string_examples;

-- LEFT / RIGHT
SELECT LEFT(word1, 2) AS left_part, RIGHT(word2, 3) AS right_part FROM string_examples;

-- LOCATE
SELECT LOCATE('cd', word1) AS locate_pos FROM string_examples;

-- REVERSE
SELECT REVERSE(word1) AS reversed FROM string_examples;

-- ASCII
SELECT word1, ASCII(word1) AS ascii_first_char FROM string_examples;

-- FIELD
SELECT FIELD(word1, 'apple', 'banana', 'hello', 'Smith') AS field_position FROM string_examples;

-- SOUNDEX
SELECT word1, word2, SOUNDEX(word1) AS sound1, SOUNDEX(word2) AS sound2 FROM string_examples;
```


## 🔹 OUTPUT SAMPLE EXPLAINED

| word1  | word2  | LENGTH | CHAR\_LENGTH | SOUNDEX |
| ------ | ------ | ------ | ------------ | ------- |
| hello  | WORLD  | 31     | 31           | H400    |
| अ      | abc    | 37     | 21           | A000    |
| Smith  | Smyth  | 20     | 20           | S530    |
| banana | orange | 26     | 26           | B550    |

> Results will vary depending on the string used.


## ✅ Bonus: See if two words **sound alike**

```sql
SELECT word1, word2,
       SOUNDEX(word1) = SOUNDEX(word2) AS sound_match
FROM string_examples;
```

---
---
---
---

## 🔹 2. **Numeric Functions**

| Function                 | Description          | Example                            |
| ------------------------ | -------------------- | ---------------------------------- |
| `ABS(num)`               | Absolute value       | `SELECT ABS(-20);` → `20`          |
| `CEIL(num)` or `CEILING` | Round up             | `SELECT CEIL(4.2);` → `5`          |
| `FLOOR(num)`             | Round down           | `SELECT FLOOR(4.8);` → `4`         |
| `ROUND(num, d)`          | Rounds to d decimals | `SELECT ROUND(3.456, 2);` → `3.46` |
| `TRUNCATE(num, d)`       | No Rounding only cut the value upto that decimal | `SELECT TRUNCATE(25.678, 2);` → e.g. `25.67`   |
| `MOD(a, b)` or `%`       | Remainder            | `SELECT MOD(10, 3);` → `1`         |
| `POWER(a, b)`            | a^b                  | `SELECT POWER(2, 3);` → `8`        |
| `SQRT(num)`              | Square root          | `SELECT SQRT(16);` → `4`           |
| `RAND()`                 | Random number        | `SELECT RAND();` → e.g. `0.4867`   |


## 🔸 Step 1: Create the Table

```sql
CREATE TABLE numeric_examples (
    id INT AUTO_INCREMENT PRIMARY KEY,
    num1 DECIMAL(10, 3),
    num2 DECIMAL(10, 3)
);
```

---

## 🔸 Step 2: Insert Sample Data

```sql
INSERT INTO numeric_examples (num1, num2) VALUES
(-20.75, 3),        -- For ABS, MOD, FLOOR
(4.2, 0),           -- For CEIL, RAND (only use num1)
(4.8, NULL),        -- For FLOOR
(3.456, 2),         -- For ROUND
(10, 3),            -- For MOD
(2, 3),             -- For POWER
(16, NULL),         -- For SQRT
(0, NULL);          -- For edge cases
```

---

## 🔸 Step 3: Queries for Each Function with Output

### 1. `ABS(num)`

```sql
SELECT num1, ABS(num1) AS absolute_value FROM numeric_examples;
```

🧾 **Output Example:**

```
| num1    | absolute_value |
|--------|----------------|
| -20.75 | 20.75          |
| 4.2    | 4.2            |
| ...    | ...            |
```

---

### 2. `CEIL(num)`

```sql
SELECT num1, CEIL(num1) AS ceiling_value FROM numeric_examples;
```

🧾 **Output Example:**

```
| num1 | ceiling_value |
|------|---------------|
| 4.2  | 5             |
| 4.8  | 5             |
```

---

### 3. `FLOOR(num)`

```sql
SELECT num1, FLOOR(num1) AS floor_value FROM numeric_examples;
```

🧾 **Output Example:**

```
| num1 | floor_value |
|------|-------------|
| 4.2  | 4           |
| 4.8  | 4           |
```

---

### 4. `ROUND(num, decimals)`

```sql
SELECT num1, num2, ROUND(num1, num2) AS rounded_value FROM numeric_examples;
```

🧾 **Output Example:**

```
| num1   | num2 | rounded_value |
|--------|------|----------------|
| 3.456  | 2    | 3.46           |
| 4.8    | NULL | NULL           |
```

---

### 5. `MOD(num1, num2)`

```sql
SELECT num1, num2, MOD(num1, num2) AS modulus FROM numeric_examples;
```

🧾 **Output Example:**

```
| num1 | num2 | modulus |
|------|------|---------|
| 10   | 3    | 1       |
```

---

### 6. `POWER(num1, num2)`

```sql
SELECT num1, num2, POWER(num1, num2) AS raised_power FROM numeric_examples;
```

🧾 **Output Example:**

```
| num1 | num2 | raised_power |
|------|------|--------------|
| 2    | 3    | 8            |
```

---

### 7. `SQRT(num1)`

```sql
SELECT num1, SQRT(num1) AS square_root FROM numeric_examples;
```

🧾 **Output Example:**

```
| num1 | square_root |
|------|-------------|
| 16   | 4           |
| 0    | 0           |
```

---

### 8. `RAND()` — Random Number (doesn't need a column)

```sql
SELECT RAND() AS random_number_1, RAND() AS random_number_2;
```

🧾 **Output Example:**

```
| random_number_1 | random_number_2 |
|------------------|-----------------|
| 0.763921         | 0.344588        |
```

Note: Results change every time.

---

## 🔸 Bonus: Full Combined Query

```sql
SELECT
  id,
  num1,
  num2,
  ABS(num1) AS abs_val,
  CEIL(num1) AS ceil_val,
  FLOOR(num1) AS floor_val,
  ROUND(num1, COALESCE(num2, 0)) AS round_val,
  MOD(num1, COALESCE(num2, 1)) AS mod_val,
  POWER(num1, COALESCE(num2, 1)) AS power_val,
  SQRT(num1) AS sqrt_val,
  RAND() AS random_val
FROM numeric_examples;
```


## 🔹 A. **LOG(), EXP() and Exponential Functions**

### 1. `LOG(X)` — Natural log (base **e**)

```sql
SELECT LOG(10);       -- ≈ 2.30258 (ln(10))
```

### 2. `LOG10(X)` — Log base 10

```sql
SELECT LOG10(1000);   -- = 3
```

### 3. `LOG(X, Y)` — Logarithm of **Y** with base **X**

```sql
SELECT LOG(2, 8);     -- = 3 because 2^3 = 8
```

### 4. `EXP(X)` — e^X (Exponential function)

```sql
SELECT EXP(1);        -- ≈ 2.71828 (Euler's number)
SELECT EXP(2);        -- ≈ 7.3891
```

---

## 🔹 B. **Trigonometric Functions**

| SQL Function  | What It Does                   | Example                           |
| ------------- | ------------------------------ | --------------------------------- |
| `SIN(x)`      | Sine (x in radians)            | `SELECT SIN(PI()/2);` → 1         |
| `COS(x)`      | Cosine                         | `SELECT COS(0);` → 1              |
| `TAN(x)`      | Tangent                        | `SELECT TAN(PI()/4);` → \~1       |
| `ASIN(x)`     | Arc Sine                       | `SELECT ASIN(1);` → `π/2`         |
| `ACOS(x)`     | Arc Cosine                     | `SELECT ACOS(1);` → 0             |
| `ATAN(x)`     | Arc Tangent                    | `SELECT ATAN(1);` → \~0.785 (π/4) |
| `ATAN2(y, x)` | Arc Tan(y/x) but more accurate | `SELECT ATAN2(2, 2);` → π/4       |

🔹 **NOTE:** Inputs/outputs are in **radians**, not degrees.

---

## 🔹 C. **Angle Conversions**

### 1. Convert **degrees to radians**

```sql
SELECT RADIANS(180);  -- Output: PI ≈ 3.1416
```

### 2. Convert **radians to degrees**

```sql
SELECT DEGREES(PI()); -- Output: 180
```

---

## 🔹 D. **PI() Function**

Returns the value of π

```sql
SELECT PI();          -- Output: 3.1415926535
```

---

## 🔹 E. **Bitwise Functions (for integers only)**

| Function | Description | Example          | Result     |      |   |
| -------- | ----------- | ---------------- | ---------- | ---- | - |
| `&`      | Bitwise AND | `SELECT 5 & 3;`  | 1          |      |   |
| \`       | \`          | Bitwise OR       | \`SELECT 5 | 3;\` | 7 |
| `^`      | Bitwise XOR | `SELECT 5 ^ 3;`  | 6          |      |   |
| `~`      | Bitwise NOT | `SELECT ~5;`     | -6         |      |   |
| `<<`     | Left Shift  | `SELECT 5 << 1;` | 10         |      |   |
| `>>`     | Right Shift | `SELECT 5 >> 1;` | 2          |      |   |

Binary:

* `5 = 0101`
* `3 = 0011`
* `5 & 3 = 0001 = 1`
* `5 | 3 = 0111 = 7`
* `5 ^ 3 = 0110 = 6`

> MySQL allows all these directly in expressions.

---

## 🔸 F. Create Table + Insert + Query All

### Create:

```sql
CREATE TABLE advanced_math (
    id INT AUTO_INCREMENT PRIMARY KEY,
    val1 DOUBLE,
    val2 DOUBLE
);
```

### Insert:

```sql
INSERT INTO advanced_math (val1, val2) VALUES
(10, 2),
(1, 1),
(PI(), 0.5),
(0.7071, NULL),
(5, 3);
```

### SQL Queries:

```sql
-- Exponential & Logarithmic
SELECT val1, LOG(val1) AS ln_val, LOG10(val1) AS log10_val, EXP(val1) AS exp_val FROM advanced_math;

-- Trigonometric
SELECT val1, SIN(val1), COS(val1), TAN(val1) FROM advanced_math;

-- Arc Trig (inverse)
SELECT val1, ASIN(val1), ACOS(val1), ATAN(val1) FROM advanced_math;

-- Angle conversion
SELECT val1, RADIANS(val1) AS rad, DEGREES(val1) AS deg FROM advanced_math;

-- Atan2 (Y, X)
SELECT val1, val2, ATAN2(val1, val2) AS atan2_val FROM advanced_math;

-- Constants
SELECT PI() AS pi_value;

-- Bitwise (only valid for integers)
SELECT val1, val2,
       val1 & val2 AS and_bit,
       val1 | val2 AS or_bit,
       val1 ^ val2 AS xor_bit,
       ~val1 AS not_val,
       val1 << 1 AS left_shift,
       val1 >> 1 AS right_shift
FROM advanced_math
WHERE val1 IS NOT NULL AND val2 IS NOT NULL;
```

---

## ✅ Summary

| Category       | Example                         |            |
| -------------- | ------------------------------- | ---------- |
| Exponentiation | `EXP(1)`, `POWER(2, 3)`         |            |
| Logs           | `LOG(10)`, `LOG10(100)`         |            |
| Trig           | `SIN(PI()/2)`, `COS(0)`         |            |
| Arc Trig       | `ASIN(1)`, `ACOS(0)`            |            |
| Angle Convert  | `RADIANS(180)`, `DEGREES(PI())` |            |
| Constant       | `PI()`                          |            |
| Bitwise Ops    | `5 & 3`, \`5                    | 3`, `\~5\` |

---
---
---
---

## 🔹 3. **Date and Time Functions**

| Function                          | Description        | Example                                                            |
| --------------------------------- | ------------------ | ------------------------------------------------------------------ |
| `NOW()`                           | Current timestamp  | `SELECT NOW();`                                                    |
| `CURDATE()`                       | Current date       | `SELECT CURDATE();` → `2025-07-20`                                 |
| `CURTIME()`                       | Current time       | `SELECT CURTIME();` → `11:02:00`                                   |
| `DATE_ADD(date, INTERVAL n UNIT)` | Add time           | `SELECT DATE_ADD('2024-01-01', INTERVAL 10 DAY);` → `'2024-01-11'` |
| `DATE_SUB(date, INTERVAL n UNIT)` | Subtract time      | `SELECT DATE_SUB('2024-01-11', INTERVAL 10 DAY);` → `'2024-01-01'` |
| `DATEDIFF(date1, date2)`          | Difference in days | `SELECT DATEDIFF('2024-01-11', '2024-01-01');` → `10`              |
| `EXTRACT(unit FROM date)`         | Extract parts      | `SELECT EXTRACT(YEAR FROM '2025-07-20');` → `2025`                 |
| `DAY(date)`                       | Day of month       | `SELECT DAY('2025-07-20');` → `20`                                 |
| `MONTH(date)`                     | Month              | `SELECT MONTH('2025-07-20');` → `7`                                |
| `YEAR(date)`                      | Year               | `SELECT YEAR('2025-07-20');` → `2025`                              |
| `DAYNAME(date)`                   | Name of day        | `SELECT DAYNAME('2025-07-20');` → `'Sunday'`                       |
| `MONTHNAME(date)`                 | Name of month      | `SELECT MONTHNAME('2025-07-20');` → `'July'`                       |


---

## 🔶 1. `DATE_FORMAT()`

### ✅ Purpose:

Formats a `DATETIME` or `DATE` column into a **custom string format** using placeholders.

### 📘 Common Format Specifiers:

| Specifier | Meaning         | Example |
| --------- | --------------- | ------- |
| `%Y`      | Year (4-digit)  | 2025    |
| `%m`      | Month (2-digit) | 07      |
| `%d`      | Day (2-digit)   | 20      |
| `%H`      | Hour (24h)      | 13      |
| `%i`      | Minute          | 45      |
| `%s`      | Second          | 30      |
| `%W`      | Weekday name    | Sunday  |

---

## 🔶 2. `NOW()`

### ✅ Purpose:

Returns the **current date and time** as `YYYY-MM-DD HH:MM:SS`.

---

## 🔶 3. `UNIX_TIMESTAMP()`

### ✅ Purpose:

Returns the number of **seconds since 1970-01-01 00:00:00 UTC** (Unix Epoch). Used for time calculations, comparisons.

---

## 🔶 4. `FROM_UNIXTIME()`

### ✅ Purpose:

Converts a **Unix timestamp (seconds)** back into a `DATETIME` format.

---

## 🔶 5. `DATE_SUB(date, INTERVAL ...)`

### ✅ Purpose:

Subtracts a given **interval** (days, months, hours, etc.) from a date.

---

## 🧪 Sample Table: `events`

```sql
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(50),
    created_at DATETIME DEFAULT NOW()
);
```

### Sample Insert

```sql
INSERT INTO events (event_name, created_at) VALUES
('Signup', '2025-07-20 08:30:00'),
('Login', '2025-07-20 10:45:00'),
('Payment', '2025-07-18 16:20:15'),
('Logout', NOW());  -- dynamic time
```

---

## 🔍 Query 1: Use `DATE_FORMAT()` for readable formatting

```sql
SELECT
  event_name,
  created_at,
  DATE_FORMAT(created_at, '%Y-%m-%d') AS only_date,
  DATE_FORMAT(created_at, '%H:%i:%s') AS only_time,
  DATE_FORMAT(created_at, '%W, %M %e %Y') AS pretty_format
FROM events;
```

### ✅ Output Example

| event\_name | created\_at         | only\_date | only\_time | pretty\_format       |
| ----------- | ------------------- | ---------- | ---------- | -------------------- |
| Signup      | 2025-07-20 08:30:00 | 2025-07-20 | 08:30:00   | Sunday, July 20 2025 |
| Login       | 2025-07-20 10:45:00 | 2025-07-20 | 10:45:00   | Sunday, July 20 2025 |
| Logout      | 2025-07-20 11:34:22 | 2025-07-20 | 11:34:22   | Sunday, July 20 2025 |

---

## 🔍 Query 2: Get Current Timestamp with `NOW()`, `UNIX_TIMESTAMP()`

```sql
SELECT 
  NOW() AS current_time,
  UNIX_TIMESTAMP() AS unix_now;
```

### ✅ Output Example

| current\_time       | unix\_now  |
| ------------------- | ---------- |
| 2025-07-20 11:36:00 | 1752994560 |

---

## 🔍 Query 3: Convert Back Using `FROM_UNIXTIME()`

```sql
SELECT
  UNIX_TIMESTAMP('2025-07-20 10:45:00') AS to_unix,
  FROM_UNIXTIME(1752994560) AS from_unix;
```

### ✅ Output Example

| to\_unix   | from\_unix          |
| ---------- | ------------------- |
| 1752991500 | 2025-07-20 11:36:00 |

---

## 🔍 Query 4: Use `DATE_SUB()` for Last Week’s Events

```sql
SELECT
  event_name,
  created_at,
  DATE_SUB(created_at, INTERVAL 1 DAY) AS one_day_before,
  DATE_SUB(created_at, INTERVAL 1 WEEK) AS one_week_before
FROM events;
```

### ✅ Output Example

| event\_name | created\_at         | one\_day\_before    | one\_week\_before   |
| ----------- | ------------------- | ------------------- | ------------------- |
| Signup      | 2025-07-20 08:30:00 | 2025-07-19 08:30:00 | 2025-07-13 08:30:00 |

---

## 🔍 Query 5: Find Events in the Last 2 Days

```sql
SELECT *
FROM events
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 2 DAY);
```

✅ This will return only those events that happened in the **last 48 hours**.

---

## 📦 Summary Table

| Function           | Purpose                             | Sample                            |
| ------------------ | ----------------------------------- | --------------------------------- |
| `NOW()`            | Get current datetime                | `NOW()`                           |
| `DATE_FORMAT()`    | Format datetime in custom ways      | `DATE_FORMAT(..., '%Y-%m-%d')`    |
| `UNIX_TIMESTAMP()` | Convert date to Unix time (seconds) | `UNIX_TIMESTAMP(NOW())`           |
| `FROM_UNIXTIME()`  | Convert Unix time to datetime       | `FROM_UNIXTIME(1752994560)`       |
| `DATE_SUB()`       | Subtract days/months/intervals      | `DATE_SUB(NOW(), INTERVAL 7 DAY)` |




---
---
---
---

## 🔹 4. **Aggregate Functions**

(Operate on multiple rows, return single value)

| Function               | Description          | Example                                    |
| ---------------------- | -------------------- | ------------------------------------------ |
| `COUNT(*)`             | Number of rows       | `SELECT COUNT(*) FROM users;`              |
| `COUNT(column)`        | Non-null values only | `SELECT COUNT(email) FROM users;`          |
| `SUM(column)`          | Total sum            | `SELECT SUM(price) FROM products;`         |
| `AVG(column)`          | Average value        | `SELECT AVG(price) FROM products;`         |
| `MAX(column)`          | Maximum value        | `SELECT MAX(price) FROM products;`         |
| `MIN(column)`          | Minimum value        | `SELECT MIN(price) FROM products;`         |
| `GROUP_CONCAT(column)` | Combines values      | `SELECT GROUP_CONCAT(name) FROM students;` |

> 🔸 Usually used with `GROUP BY`

---

## 🔹 5. **Control Flow Functions**

| Function                                 | Description                 | Example                                             |
| ---------------------------------------- | --------------------------- | --------------------------------------------------- |
| `IF(condition, true_value, false_value)` | If-else logic               | `SELECT IF(score > 40, 'Pass', 'Fail') FROM marks;` |
| `IFNULL(expr, alt)`                      | Returns alt if expr is null | `SELECT IFNULL(name, 'Unknown') FROM users;`        |
| `NULLIF(expr1, expr2)`                   | Returns NULL if equal       | `SELECT NULLIF(100, 100);` → `NULL`                 |
| `CASE`                                   | Conditional logic           |                                                     |

```sql
SELECT 
  CASE 
    WHEN marks >= 90 THEN 'A'
    WHEN marks >= 75 THEN 'B'
    ELSE 'C'
  END AS grade
FROM students;
```

---

## 🔹 6. **System / Metadata Functions**

| Function     | Description     | Example              |
| ------------ | --------------- | -------------------- |
| `DATABASE()` | Current DB name | `SELECT DATABASE();` |
| `USER()`     | Current user    | `SELECT USER();`     |
| `VERSION()`  | DB version      | `SELECT VERSION();`  |

---

## 🔹 7. **JSON Functions** (In MySQL 5.7+)

| Function                   | Description  | Example                                  |
| -------------------------- | ------------ | ---------------------------------------- |
| `JSON_OBJECT(key, value)`  | Create JSON  | `SELECT JSON_OBJECT('name', 'John');`    |
| `JSON_EXTRACT(json, path)` | Get value    | `SELECT JSON_EXTRACT('{"a":1}', '$.a');` |
| `JSON_ARRAY(val1, val2)`   | Create array | `SELECT JSON_ARRAY(1, 2, 'text');`       |

---

## 🔹 8. **Window Functions** (Advanced: need `OVER()`)

| Function       | Description                     | Example |
| -------------- | ------------------------------- | ------- |
| `ROW_NUMBER()` | Unique row number per partition |         |

```sql
SELECT name, salary, ROW_NUMBER() OVER (ORDER BY salary DESC) FROM employees;
```

\| `RANK()` / `DENSE_RANK()` | Rank with/without gaps |
\| `LEAD()` / `LAG()` | Access next/previous row |
\| `NTILE(n)` | Buckets the rows |
