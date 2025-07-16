## 🔹 What is the `BINARY` Data Type?

The `BINARY` type is similar to the `CHAR(n)` type, but instead of storing **character strings**, it stores **binary byte sequences** (raw bytes).

### 📦 Basic Properties:

| Feature     | Description                                             |
| ----------- | ------------------------------------------------------- |
| Type        | Fixed-length binary string                              |
| Storage     | Exactly `n` bytes                                       |
| Padded with | `\0` (null bytes) if shorter                            |
| Max Length  | 255 bytes                                               |
| Charset     | **Binary-safe**, no character set or collation involved |
| Usage       | Storing encrypted data, hashes, or raw binary blobs     |

---

## 🔹 `VARBINARY(n)` — Variable-Length Binary

Just like `VARCHAR(n)` is for variable-length text, `VARBINARY(n)` stores **variable-length binary** data.

| Feature    | Description                                  |
| ---------- | -------------------------------------------- |
| Storage    | Length of data + 1 or 2 bytes                |
| Max Length | 65,535 bytes (depending on row size)         |
| Best For   | Storing binary tokens, compressed data, etc. |

---

## ✅ Examples:

### 🧱 Create a table:

```sql
CREATE TABLE binary_example (
  id INT PRIMARY KEY AUTO_INCREMENT,
  fixed_hash BINARY(16),         -- e.g., MD5 hash
  variable_token VARBINARY(255)  -- e.g., binary authentication token
);
```

### 🔐 Insert binary data:

```sql
INSERT INTO binary_example (fixed_hash, variable_token)
VALUES (
  UNHEX('5d41402abc4b2a76b9719d911017c592'),   -- "hello" in MD5 hex, converted to binary
  UNHEX('7a79636f6e65746f6b656e')              -- "zyconetoken" as binary
);
```

> ✅ `UNHEX()` converts a hex string to binary format.

---

## 🧠 Why Use `BINARY` Types?

You should use `BINARY` or `VARBINARY` when:

| Use Case                                 | Reason                                       |
| ---------------------------------------- | -------------------------------------------- |
| Storing hashed passwords (e.g., SHA-256) | Binary hashes are more compact than hex      |
| Encryption keys / tokens                 | Must be stored as raw binary                 |
| Image/file content                       | Use `BLOB` (binary large object)             |
| Sensitive info                           | Binary can avoid string interpretation risks |

---

## 🔁 Related: BLOB Types (for very large binary data)

| Type       | Max Size  | Use Case                       |
| ---------- | --------- | ------------------------------ |
| TINYBLOB   | 255 bytes | Small binary blobs             |
| BLOB       | 64 KB     | Medium-sized blobs             |
| MEDIUMBLOB | 16 MB     | Larger binary data             |
| LONGBLOB   | 4 GB      | Huge files (videos, documents) |

---

## 🔐 Summary Table

| Type           | Fixed/Variable | Max Size  | Padding           | Use Case           |
| -------------- | -------------- | --------- | ----------------- | ------------------ |
| `BINARY(n)`    | Fixed          | 255 bytes | Null bytes (`\0`) | Hashes, IDs        |
| `VARBINARY(n)` | Variable       | \~64KB    | None              | Tokens, keys       |
| `BLOB` types   | Variable       | Up to 4GB | None              | Large files/images |



---
---
---



## ✅ STEP 1: Create a Table for Binary Data

```sql
CREATE TABLE binary_demo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  token VARBINARY(32),         -- Variable-length binary token
  hash_value BINARY(16),       -- Fixed-length MD5 hash
  file_data BLOB               -- For storing raw file content (image, doc, etc.)
);
```

---

## ✅ STEP 2: Insert Binary Data

### 🔹 Example 1: Store Binary Hash (MD5 of 'hello') and Token

```sql
INSERT INTO binary_demo (token, hash_value)
VALUES (
  UNHEX('7a79636f6e65746f6b656e'),                          -- "zyconetoken" (hex)
  UNHEX('5d41402abc4b2a76b9719d911017c592')                -- MD5('hello')
);
```

> `UNHEX()` converts a **hex string** to binary format (raw bytes).
> Without `UNHEX()`, MySQL would store it as regular text, not raw binary.

---

### 🔹 Example 2: Store File Content in BLOB

Let’s say you read a file (`image.jpg`) in binary format in your application and insert it:

```sql
-- Assuming you're using a programming language like Python/PHP
INSERT INTO binary_demo (file_data) VALUES (?);
```

You'd bind the binary file content using the appropriate method from your language.

---

## ✅ STEP 3: Retrieve and Compare Binary Data

### 🔍 Query to retrieve all rows with raw hex representation:

```sql
SELECT 
  id,
  HEX(token) AS hex_token,
  HEX(hash_value) AS md5_hash
FROM binary_demo;
```

> `HEX()` is used to convert binary data back to readable hex strings.

---

### 🔍 Compare binary hash:

Find all entries where `hash_value` matches MD5 of `'hello'`:

```sql
SELECT * FROM binary_demo
WHERE hash_value = UNHEX('5d41402abc4b2a76b9719d911017c592');
```

---

## ✅ Notes on Comparing Binary Data:

| Comparison Type | Method                                | Notes                                 |
| --------------- | ------------------------------------- | ------------------------------------- |
| Exact match     | `= UNHEX('hexvalue')`                 | Must use same length and content      |
| Partial match   | Use `LEFT()`, `SUBSTRING()` on binary | Still works on binary fields          |
| Case-sensitive  | Always (binary is case-sensitive)     | No collation involved like text types |

---

## 🧠 Summary:

* Use `UNHEX()` to insert hex values as binary.
* Use `HEX()` to **read** binary as printable hex.
* Comparisons are **byte-by-byte** and **case-sensitive**.
* `BINARY/VARBINARY` is for **small binary values** (hashes, tokens).
* Use `BLOB` when storing **files or large binary blobs**.



---
---
---



## ✅ 1. CREATE TABLE for All Binary Data Types

```sql
CREATE TABLE binary_data_types (
  id INT AUTO_INCREMENT PRIMARY KEY,

  fixed_binary BINARY(8),           -- Fixed-length binary string (always 8 bytes)
  var_binary VARBINARY(16),         -- Variable-length binary string
  tiny_blob TINYBLOB,               -- Very small binary blob (max 255 bytes)
  normal_blob BLOB,                 -- Medium binary data (max 64KB)
  medium_blob MEDIUMBLOB,           -- Large binary data (max 16MB)
  long_blob LONGBLOB                -- Very large binary data (max 4GB)
);
```

---

## ✅ 2. INSERT Query for All Binary Data Types

We’ll insert **hex-encoded strings** using `UNHEX()` to simulate real binary data:

```sql
INSERT INTO binary_data_types (
  fixed_binary, var_binary, tiny_blob, normal_blob, medium_blob, long_blob
) VALUES (
  UNHEX('4142434445464748'),               -- 8-byte fixed binary: 'ABCDEFGH'
  UNHEX('313233343536'),                   -- 6-byte variable binary: '123456'
  UNHEX('546869732069732061207465737421'), -- TinyBlob: 'This is a test!'
  UNHEX('4461746120666F7220424C4F42'),     -- Blob: 'Data for BLOB'
  REPEAT(UNHEX('61'), 1024 * 1024),        -- MediumBlob: 1MB of 'a'
  REPEAT(UNHEX('62'), 1024 * 1024 * 2)     -- LongBlob: 2MB of 'b'
);
```

> 🔁 `REPEAT(UNHEX('61'), 1024 * 1024)` generates 1MB of the byte `'a'` (`0x61`)
> You can only use `REPEAT()` like this for testing purposes. In apps, you would send binary data via your programming language.

---

## ✅ 3. How Each Binary Type Stores Data Internally

| Column         | Type     | Max Size          | Storage Mechanism                                                                    | Notes                              |
| -------------- | -------- | ----------------- | ------------------------------------------------------------------------------------ | ---------------------------------- |
| `BINARY(n)`    | Fixed    | 0 to 255 bytes    | Always stores **exactly n bytes**, padded with `\0` (null bytes) if input is shorter | `'AB'` in `BINARY(4)` → `'AB\0\0'` |
| `VARBINARY(n)` | Variable | 0 to 65,535 bytes | Stores length + data (1 or 2 bytes for length + actual binary)                       | More compact for short data        |
| `TINYBLOB`     | Variable | 255 bytes         | 1 byte for length + binary data                                                      | For small blobs                    |
| `BLOB`         | Variable | 64 KB             | 2 bytes for length + binary data                                                     | Common for images, files           |
| `MEDIUMBLOB`   | Variable | 16 MB             | 3 bytes for length + binary data                                                     | Large files                        |
| `LONGBLOB`     | Variable | 4 GB              | 4 bytes for length + binary data                                                     | Videos, documents, backups         |

---

## ✅ Example Output Using `HEX()` to Read Binary

```sql
SELECT 
  HEX(fixed_binary) AS fixed_hex,
  HEX(var_binary) AS var_hex,
  HEX(tiny_blob) AS tiny_hex
FROM binary_data_types;
```

### 🔍 Output (HEX format):

| fixed\_hex         | var\_hex       | tiny\_hex                        |
| ------------------ | -------------- | -------------------------------- |
| `4142434445464748` | `313233343536` | `546869732069732061207465737421` |

This is:

* `'ABCDEFGH'` → 8-byte `BINARY`
* `'123456'` → 6-byte `VARBINARY`
* `'This is a test!'` → Tiny BLOB

---

## 🔒 Summary

| Type           | Fixed or Variable | Max Size | Best For                                |
| -------------- | ----------------- | -------- | --------------------------------------- |
| `BINARY(n)`    | Fixed             | 255 B    | Exact-length data (e.g., UUIDs, hashes) |
| `VARBINARY(n)` | Variable          | 65 KB    | Tokens, keys                            |
| `TINYBLOB`     | Variable          | 255 B    | Short binary                            |
| `BLOB`         | Variable          | 64 KB    | Medium binary data (images, audio)      |
| `MEDIUMBLOB`   | Variable          | 16 MB    | Large files                             |
| `LONGBLOB`     | Variable          | 4 GB     | Very large data (videos, PDFs)          |

---
---
---



## ✅ What is `LOAD_FILE()` in MySQL?

* It reads a **file from your server’s file system**.
* Returns the **binary contents** of the file (e.g., image, document).
* Useful for inserting data into `BLOB`, `TEXT`, etc.

---

## 🔧 Step 1: Prepare a Table with BLOB

```sql
CREATE TABLE file_demo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  file_name VARCHAR(255),
  file_data LONGBLOB
);
```

---

## 📁 Step 2: Make Sure MySQL Can Access the File

* File must be in a **directory MySQL can read** (`secure_file_priv`).
* Run this to check where MySQL can access files from:

```sql
SHOW VARIABLES LIKE 'secure_file_priv';
```

You’ll get a path like:

```
+------------------+------------------------+
| Variable_name    | Value                  |
+------------------+------------------------+
| secure_file_priv | C:\ProgramData\MySQL\  |
+------------------+------------------------+
```

✅ Place your file (e.g., `myimage.jpg`) in that folder.

---

## 📥 Step 3: Insert File Using `LOAD_FILE()`

```sql
INSERT INTO file_demo (file_name, file_data)
VALUES (
  'myimage.jpg',
  LOAD_FILE('C:/ProgramData/MySQL/myimage.jpg')
);
```

> 📝 For Linux: path would be like `'/var/lib/mysql-files/myimage.jpg'`

---

## ✅ Step 4: Read Back the File (Optional)

To check what's stored:

```sql
SELECT id, file_name, LENGTH(file_data) AS size_in_bytes
FROM file_demo;
```

---

## ⚠️ Troubleshooting: If `LOAD_FILE()` returns NULL

| Reason                                  | Fix                                                |
| --------------------------------------- | -------------------------------------------------- |
| File path is outside `secure_file_priv` | Move file inside allowed folder                    |
| File not readable by MySQL              | Set proper file permissions (e.g., 644 on Linux)   |
| File doesn't exist at path              | Check exact spelling and path                      |
| MySQL lacks `FILE` privilege            | Run `GRANT FILE ON *.* TO 'youruser'@'localhost';` |
| `secure_file_priv` is `NULL` (disabled) | Edit `my.cnf` or `my.ini` to set a folder          |

---

## 🧠 Summary

| Step       | Action                                  |
| ---------- | --------------------------------------- |
| 1️⃣ Table  | Create a table with a `BLOB` column     |
| 2️⃣ File   | Move file to `secure_file_priv` folder  |
| 3️⃣ Insert | Use `LOAD_FILE('path/to/file')`         |
| 4️⃣ Query  | Use `SELECT LENGTH(file_data)` to check |
