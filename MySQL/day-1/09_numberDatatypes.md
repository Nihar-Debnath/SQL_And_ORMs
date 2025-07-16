### 🔸 **1. TINYINT**

* **Storage**: 1 byte (8 bits)
* **Signed Range**: -128 to 127
* **Unsigned Range**: 0 to 255
* ✅ Good for: flags, small counters, statuses

---

### 🔸 **2. SMALLINT**

* **Storage**: 2 bytes (16 bits)
* **Signed Range**: -32,768 to 32,767
* **Unsigned Range**: 0 to 65,535
* ✅ Good for: small numbers like age, year, small IDs

---

### 🔸 **3. MEDIUMINT**

* **Storage**: 3 bytes (24 bits)
* **Signed Range**: -8,388,608 to 8,388,607
* **Unsigned Range**: 0 to 16,777,215
* ✅ Used rarely, useful for medium-size numbers

---

### 🔸 **4. INT / INTEGER**

* **Storage**: 4 bytes (32 bits)
* **Signed Range**: -2,147,483,648 to 2,147,483,647
* **Unsigned Range**: 0 to 4,294,967,295
* ✅ Commonly used for IDs, counters, general numbers

---

### 🔸 **5. BIGINT**

* **Storage**: 8 bytes (64 bits)
* **Signed Range**: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
* **Unsigned Range**: 0 to 18,446,744,073,709,551,615
* ✅ Used for very large values like phone numbers, monetary values in paise, etc.

---

## 🔸 Floating Point Types (with Precision)

### 🔸 **6. FLOAT**

* **Storage**: 4 bytes
* **Range**:

  * Min: \~ -3.4 × 10^38
  * Max: \~ 3.4 × 10^38
  * Smallest non-zero: \~ 1.17 × 10^-38
* **Precision**: \~ **7 decimal digits**
* ✅ Use for: approximate values where a small error is acceptable (like temperature, percentages)

---

### 🔸 **7. DOUBLE**

* **Storage**: 8 bytes
* **Range**:

  * Min: \~ -1.79 × 10^308
  * Max: \~ 1.79 × 10^308
  * Smallest non-zero: \~ 2.22 × 10^-308
* **Precision**: \~ **15–17 decimal digits**
* ✅ Use for: more accurate floating point calculations (e.g., scientific data, financial calculations)

---

### 🔸 **8. DECIMAL(p, s)**

* **Storage**: Varies (depends on p and s)
* **p = Precision**: total number of digits
* **s = Scale**: number of digits after the decimal
* ✅ Use when: **exact precision** is needed (money, measurements, etc.)
* Example: `DECIMAL(10,2)` → 10 digits total, 2 after the decimal → 99999999.99

> **Decimal is stored as a string of digits internally**, not as binary floating point — so no rounding issues like with `FLOAT` or `DOUBLE`.


### 👇 `DECIMAL(10, 2)` Breakdown:

* **Total digits (`p`)**: `10`
* **Digits after decimal (`s`)**: `2`
* So,

  * Digits **before** decimal = `10 - 2 = 8`
  * ✅ Max value you can store = `99,999,999.99`


### ✅ Example:

| Value          | Valid? | Why?                                 |
| -------------- | ------ | ------------------------------------ |
| `12345.67`     | ✅      | 7 digits total → OK                  |
| `99999999.99`  | ✅      | Max allowed                          |
| `100000000.00` | ❌      | 9 digits before decimal → Too big    |
| `1.234`        | ❌      | 3 digits after decimal → Too precise |



---

## 📝 Summary Table of Precision

| Data Type       | Approx. Decimal Precision |
| --------------- | ------------------------- |
| `FLOAT`         | \~7 digits                |
| `DOUBLE`        | \~15-17 digits            |
| `DECIMAL(p, s)` | Defined manually          |

---
---
---





## ✅ NUMERIC DATA TYPES

```sql
CREATE TABLE number_examples (
  id INT AUTO_INCREMENT PRIMARY KEY,
  age TINYINT UNSIGNED,                   -- 0 to 255 (1 byte)
  quantity SMALLINT,                      -- -32,768 to 32,767 (2 bytes)
  stock INT,                              -- -2B to +2B (4 bytes)
  big_number BIGINT,                      -- 8 bytes (used for huge integers)
  rating DECIMAL(3,2),                    -- Up to 3 digits total, 2 after decimal (e.g., 4.75)
  price FLOAT(7,2),                       -- Approximate decimal, 7 digits, 2 decimal places
  distance DOUBLE(10,4)                   -- Higher precision
);
```

### ✅ Sample INSERT:

```sql
INSERT INTO number_examples (
  age, quantity, stock, big_number, rating, price, distance
) VALUES (
  25,
  1200,
  50000,
  999999999999,
  4.75,
  1499.99,
  12.5678
);
```

### ⚠️ Notes:

* `DECIMAL(p,s)` is for **exact values** (e.g., money).
* `FLOAT` and `DOUBLE` are **approximate**—small rounding errors possible.
* `TINYINT`, `SMALLINT`, `BIGINT` have **signed** and **unsigned** versions.
