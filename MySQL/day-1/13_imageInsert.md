### 🔹 `CREATE DATABASE test;`

* **Creates a new database** named `test`.
* A database is like a folder that holds tables and other DB objects.
* You only need to do this once (unless it already exists).

---

### 🔹 `USE test;`

* Tells MySQL to **switch to the `test` database**.
* All subsequent table creations and queries will now happen inside this database.

---

### 🔹 `CREATE TABLE image ( ... );`

```sql
CREATE TABLE image (
  id INT AUTO_INCREMENT PRIMARY KEY,
  file_name VARCHAR(255),
  file_data LONGBLOB
);
```

This creates a table named `image` with 3 columns:

| Column      | Type                             | Purpose                                             |
| ----------- | -------------------------------- | --------------------------------------------------- |
| `id`        | `INT AUTO_INCREMENT PRIMARY KEY` | Unique identifier for each row (auto-generated)     |
| `file_name` | `VARCHAR(255)`                   | Name of the uploaded file (e.g., `"a.jpg"`)         |
| `file_data` | `LONGBLOB`                       | Stores the **binary data** of the file (up to 4 GB) |

---

### 🔹 `SHOW VARIABLES LIKE 'secure_file_priv';`

* **Checks where MySQL is allowed to access files from**, for `LOAD_FILE()` or `LOAD DATA`.
* You will get a path like:

  ```
  C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
  ```
* You **must place your file (`a.jpg`) in this folder** to read it using `LOAD_FILE()`.

---

### 🔹 `SELECT LENGTH(LOAD_FILE(...))`

```sql
SELECT LENGTH(LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/a.jpg'));
```

* Loads the file from disk as **binary data**.
* `LENGTH(...)` returns the **number of bytes** in that file.
* Confirms:

  * The file exists
  * MySQL can read it
  * It’s within allowed size limits

---

### 🔹 `INSERT INTO image (...) VALUES (...)`

```sql
INSERT INTO image (file_name, file_data)
VALUES (
  'a.jpg',
  LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/a.jpg')
);
```

* Inserts a new row into the `image` table:

  * `file_name` = `'a.jpg'`
  * `file_data` = the **raw binary content** of that file (read using `LOAD_FILE()`)
* If successful, the image is now **stored inside the database** (in the `LONGBLOB` column).

---

### 🔹 `SELECT id, file_name, LENGTH(file_data) ...`

```sql
SELECT id, file_name, LENGTH(file_data) AS size_in_bytes
FROM image;
```

* Retrieves:

  * `id`: auto-generated unique ID
  * `file_name`: name of the uploaded file
  * `LENGTH(file_data)`: size (in bytes) of the file stored in the database
* Renames the length column as `size_in_bytes` for readability.

---

### ✅ Summary of What You Achieved:

| Step | Action                                             |
| ---- | -------------------------------------------------- |
| 1️⃣  | Created a test database                            |
| 2️⃣  | Created a table with a `LONGBLOB` for binary files |
| 3️⃣  | Checked `secure_file_priv` to ensure file access   |
| 4️⃣  | Used `LOAD_FILE()` to read the image from disk     |
| 5️⃣  | Inserted the file into MySQL as binary data        |
| 6️⃣  | Verified it was stored correctly with `LENGTH()`   |
