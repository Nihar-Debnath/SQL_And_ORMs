The **Relational Model** is the foundation of relational databases (like MySQL, PostgreSQL, etc.). It was introduced by **E. F. Codd in 1970** and provides a clear structure for storing and querying data.

---

### 🔑 **Key Concepts in the Relational Model**

---

### 1. **Relation (Table)**

* A **relation** is a **table** with rows and columns.
* Each relation has a **name** and contains **tuples** (rows) and **attributes** (columns).

📌 Example:

```
STUDENT (StudentID, Name, Age, Major)
```

---

### 2. **Tuple (Row)**

* A **tuple** is a single row in a table.
* It represents one **record** or instance of the relation.

📌 Example:

```
(101, 'Alice', 20, 'Computer Science')
```

---

### 3. **Attribute (Column)**

* An **attribute** is a column in a table.
* Each attribute has a **name** and a **data type**.

📌 Example:

* In `STUDENT`, `Name` is an attribute of type `VARCHAR`.

---

### 4. **Domain**

* A **domain** is the **set of valid values** an attribute can take.
  For example:

  * `Age` domain = integers from 16 to 100
  * `Major` domain = list of valid academic programs

---

### 5. **Schema**

* A **schema** defines the **structure** of the relation:

  * Relation name
  * Attribute names and types

📌 Example:

```
STUDENT(StudentID: INT, Name: VARCHAR, Age: INT, Major: VARCHAR)
```

---

### 6. **Keys**

Keys help ensure **uniqueness** and **relationships** between tables.

#### ✅ Primary Key

* Uniquely identifies each row.
* **Cannot be NULL.**
  📌 Example: `StudentID` in `STUDENT`

#### ✅ Candidate Key

* All possible unique identifiers.
  📌 Example: If both `StudentID` and `Email` are unique, both are candidate keys.

#### ✅ Alternate Key

* Candidate keys that are **not chosen** as the primary key.

#### ✅ Foreign Key

* Refers to the **primary key of another table** to establish a relationship.

📌 Example:

```
ENROLLMENT(StudentID) → STUDENT(StudentID)
```

---

### 7. **Integrity Constraints**

To maintain correct and consistent data:

* **Entity Integrity**:
  Primary key must be **unique** and **not null**.

* **Referential Integrity**:
  A foreign key must reference an **existing** value in another table or be NULL.

---

### 8. **Relationships**

Defines how tables relate to each other:

* **One-to-One**
* **One-to-Many**
* **Many-to-Many** (usually broken into two `One-to-Many` with a join table)

---

### 9. **Operations (Relational Algebra / SQL)**

Used to query and manipulate the data:

* **SELECT** (π)
* **PROJECT** (σ)
* **JOIN**
* **UNION**
* **INTERSECTION**
* **DIFFERENCE**
* **CARTESIAN PRODUCT**

---

### 10. **Views**

* A **view** is a **virtual table** created by a query.
* It does **not store data**, but reflects data from one or more tables.
