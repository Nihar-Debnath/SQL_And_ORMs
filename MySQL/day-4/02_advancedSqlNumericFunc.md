Would you like me to add **edge case tests** too (like negative power, zero divisor, non-numeric strings)? 

Perfect. Let's now demonstrate **edge cases** and **real-world scenarios** for:

* 🔹 Logarithmic & exponential functions
* 🔹 Trigonometry
* 🔹 Bitwise operations
* 🔹 Angle functions
* 🔹 Edge behavior like **divide by zero**, **invalid inputs**, and **negative powers**

---

## ✅ Step 1: Create Enhanced Table

```sql
CREATE TABLE edge_math_cases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    base_val DOUBLE,
    exp_val DOUBLE,
    int_val1 INT,
    int_val2 INT
);
```

---

## ✅ Step 2: Insert Edge and Real-World Test Data

```sql
INSERT INTO edge_math_cases (base_val, exp_val, int_val1, int_val2) VALUES
(10, 2, 5, 3),          -- Normal case
(-2, 3, 5, 0),          -- Negative base
(0, 2, 0, 0),           -- Zero base
(2, -3, 4, 2),          -- Negative exponent
(NULL, NULL, NULL, NULL), -- NULL values
(100, 0.5, 9, 2),       -- Square root using power
(10, 0, 15, 7),         -- Anything to power 0
(0, -1, 1, 0);          -- Division by zero / log(0)
```

---

## ✅ Step 3: SQL Function Queries with Edge Case Outputs

---

### 🔹 A. Log, Log10, and EXP

```sql
SELECT 
  id, base_val,
  LOG(base_val) AS natural_log,
  LOG10(base_val) AS log10_val,
  EXP(base_val) AS exp_val
FROM edge_math_cases;
```

🧾 **Expected behaviors:**

* `LOG(0)` → **NULL or Error**
* `LOG(-2)` → **NULL**
* `LOG(NULL)` → **NULL**
* `LOG(10)` → Valid (\~2.30)

---

### 🔹 B. POWER with Negative and Zero Exponents

```sql
SELECT 
  base_val, exp_val,
  POWER(base_val, exp_val) AS result
FROM edge_math_cases;
```

🧾 **Expected behaviors:**

* `POWER(2, -3)` → `0.125`
* `POWER(10, 0)` → `1`
* `POWER(0, -1)` → **NULL or Error** (divide by zero)
* `POWER(NULL, 2)` → **NULL**

---

### 🔹 C. Bitwise Operations (with Ints Only)

```sql
SELECT 
  int_val1, int_val2,
  int_val1 & int_val2 AS bit_and,
  int_val1 | int_val2 AS bit_or,
  int_val1 ^ int_val2 AS bit_xor,
  ~int_val1 AS bit_not1,
  int_val1 << 1 AS left_shift,
  int_val1 >> 1 AS right_shift
FROM edge_math_cases
WHERE int_val1 IS NOT NULL AND int_val2 IS NOT NULL;
```

🧾 **Expected Result Sample:**

| int\_val1 | int\_val2 | & | \| | ^ | \~ | << | >> |
| --------- | --------- | - | -- | - | -- | -- | -- |
| 5         | 3         | 1 | 7  | 6 | -6 | 10 | 2  |

---

### 🔹 D. Trigonometry and Angle Conversion

```sql
SELECT 
  base_val,
  RADIANS(base_val) AS to_radians,
  DEGREES(base_val) AS to_degrees,
  SIN(base_val) AS sin_val,
  COS(base_val) AS cos_val,
  TAN(base_val) AS tan_val
FROM edge_math_cases
WHERE base_val IS NOT NULL;
```

🧾 **Highlights:**

* `SIN(PI()/2)` ≈ `1`
* `COS(PI())` ≈ `-1`
* `TAN(PI()/4)` ≈ `1`
* `TAN(PI()/2)` → **infinite or large value**

---

### 🔹 E. Real-World Example 1: Distance Calculation (Pythagorean)

Assume `val1` is `a` and `val2` is `b`, calculate √(a² + b²)

```sql
SELECT 
  base_val, exp_val,
  SQRT(POWER(base_val, 2) + POWER(exp_val, 2)) AS hypotenuse
FROM edge_math_cases
WHERE base_val IS NOT NULL AND exp_val IS NOT NULL;
```

---

### 🔹 F. Real-World Example 2: Sound Level using Log (dB = 10 \* log10(P/P₀))

```sql
SELECT 
  base_val AS power,
  10 * LOG10(base_val / 1) AS decibels
FROM edge_math_cases
WHERE base_val > 0;
```

---

## ✅ Summary of Edge Behavior

| Function       | Input           | Output        | Notes                          |
| -------------- | --------------- | ------------- | ------------------------------ |
| `LOG(0)`       | 0               | NULL or error | log(0) is undefined            |
| `LOG(-2)`      | Negative        | NULL          | No real log of negative number |
| `EXP(NULL)`    | NULL            | NULL          | Safe null handling             |
| `POWER(0, -1)` | 0 base, neg exp | NULL          | Division by zero               |
| `SIN(PI())`    | PI              | \~0           | Edge case                      |
| `TAN(PI()/2)`  | π/2             | Very large    | Near-infinite tangent          |

* Add more real-world examples like **compound interest**, **unit conversions**, **currency rounding**?



Awesome! Let’s now move into **real-world math use cases** implemented with **SQL functions** — especially:

1. ✅ **Compound Interest**
2. ✅ **Unit Conversions**
3. ✅ **Currency Rounding**

I'll provide:

* A new table schema
* Insert realistic data
* Queries using **math functions**
* Output examples

---

## 🔸 1. **Compound Interest Calculator**

📘 **Formula:**

$$
A = P \times (1 + \frac{r}{n})^{n \times t}
$$

Where:

* `P` = principal amount
* `r` = annual interest rate (in decimal)
* `n` = number of compounding periods per year
* `t` = time in years
* `A` = final amount

---

### Step 1: Create the Table

```sql
CREATE TABLE investment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    principal DECIMAL(10,2),
    rate DECIMAL(5,4),   -- e.g. 0.07 = 7%
    time_years INT,
    compounds_per_year INT
);
```

---

### Step 2: Insert Sample Data

```sql
INSERT INTO investment (principal, rate, time_years, compounds_per_year) VALUES
(10000, 0.07, 5, 4),     -- Quarterly compounding
(5000, 0.05, 10, 1),     -- Annual
(20000, 0.08, 3, 12),    -- Monthly
(15000, 0.065, 7, 2);    -- Semi-annually
```

---

### Step 3: Query to Compute Compound Interest

```sql
SELECT 
  id,
  principal,
  rate,
  time_years,
  compounds_per_year,
  ROUND(
    principal * POWER(1 + rate / compounds_per_year, compounds_per_year * time_years),
    2
  ) AS maturity_amount
FROM investment;
```

---

### ✅ Sample Output

| principal | rate  | years | comp | maturity\_amount |
| --------- | ----- | ----- | ---- | ---------------- |
| 10000     | 0.07  | 5     | 4    | 14147.75         |
| 5000      | 0.05  | 10    | 1    | 8144.47          |
| 20000     | 0.08  | 3     | 12   | 25316.55         |
| 15000     | 0.065 | 7     | 2    | 23652.44         |

---

## 🔸 2. **Unit Conversion Table (Weight, Length)**

📘 Example conversions:

* Pounds to Kilograms: `kg = lb × 0.453592`
* Inches to Centimeters: `cm = in × 2.54`
* Fahrenheit to Celsius: `C = (F - 32) × 5/9`

---

### Create Table

```sql
CREATE TABLE unit_conversion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pounds DECIMAL(10,2),
    inches DECIMAL(10,2),
    fahrenheit DECIMAL(10,2)
);
```

---

### Insert Sample Data

```sql
INSERT INTO unit_conversion (pounds, inches, fahrenheit) VALUES
(150, 70, 98.6),
(180, 72, 104),
(120, 65, 32),
(200, 74, 0);
```

---

### Query for Conversions

```sql
SELECT 
  id,
  pounds,
  ROUND(pounds * 0.453592, 2) AS kg,
  inches,
  ROUND(inches * 2.54, 2) AS cm,
  fahrenheit,
  ROUND((fahrenheit - 32) * 5 / 9, 2) AS celsius
FROM unit_conversion;
```

---

### ✅ Output Sample

| pounds | kg    | inches | cm    | °F   | °C    |
| ------ | ----- | ------ | ----- | ---- | ----- |
| 150    | 68.04 | 70     | 177.8 | 98.6 | 37.00 |
| 180    | 81.65 | 72     | 182.9 | 104  | 40.00 |

---

## 🔸 3. **Currency Rounding with SQL**

📘 Simulate a shopping cart with tax + discount:

---

### Create Table

```sql
CREATE TABLE shopping_cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(50),
    price DECIMAL(10,2),
    tax_percent DECIMAL(5,2),
    discount_percent DECIMAL(5,2)
);
```

---

### Insert Sample Items

```sql
INSERT INTO shopping_cart (item_name, price, tax_percent, discount_percent) VALUES
('Laptop', 59999.99, 18, 10),
('Headphones', 2499.50, 18, 5),
('Mouse', 599.99, 12, 0),
('Keyboard', 999.99, 18, 20);
```

---

### Query to Calculate Final Price with ROUND()

```sql
SELECT 
  item_name,
  price,
  ROUND(price * (tax_percent / 100), 2) AS tax_amt,
  ROUND(price * (discount_percent / 100), 2) AS discount_amt,
  ROUND(
    price + (price * (tax_percent / 100)) - (price * (discount_percent / 100)),
    2
  ) AS final_price
FROM shopping_cart;
```

---

### ✅ Output Sample

| item\_name | price    | tax\_amt | discount\_amt | final\_price |
| ---------- | -------- | -------- | ------------- | ------------ |
| Laptop     | 59999.99 | 10799.99 | 5999.99       | 64800.00     |
| Headphones | 2499.50  | 449.91   | 124.98        | 2824.43      |

---

## ✅ Summary Table of Use Cases

| Use Case           | Functions Used               |
| ------------------ | ---------------------------- |
| Compound Interest  | `POWER()`, `ROUND()`         |
| Unit Conversion    | `ROUND()`, math expressions  |
| Currency Bill Calc | `ROUND()`, math + percentage |
