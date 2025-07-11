## 🔷 Type and Networking

### **1. Server Configuration Type**

**`Config Type: Development Computer`**

This setting determines how much system resources (RAM, CPU) will be allocated to MySQL.

* **Development Computer** (selected):
  ✔ Light resource usage.
  ✔ Best for developers who want to test applications locally.

* **Server Computer**:
  ⚙️ Medium usage. Suitable if you're running MySQL on a machine that needs better performance.

* **Dedicated Computer**:
  🖥 High resource allocation. Used when the whole computer is dedicated to running MySQL (like in production environments).

---

### **2. Connectivity**

**How will clients connect to this MySQL server?**

#### ✅ `TCP/IP` (Port: 3306)

* **Purpose:** Enables access over the network (localhost or LAN).
* **Port 3306**: This is the **default port for MySQL**.
* ✔ **Keep this enabled** if you're running MySQL on localhost (your own PC) or want to connect remotely.

#### 🔲 `Open Windows Firewall ports for network access`

* ✅ If this is **checked**, Windows Firewall will automatically allow access to port 3306.
* ✔ Necessary if you want to connect to MySQL from **other computers** or apps.

---

### 🔲 `Named Pipe`

* **Used for inter-process communication on Windows**.
* Useful in some local development setups, but rarely used nowadays.
* 🔸 You can ignore this unless you have a specific reason.

---

### 🔲 `Shared Memory`

* Another method for **local-only** connections.
* Mostly used when running MySQL and your client software on the same Windows machine.
* 🔸 Also usually not needed unless you’re doing something advanced.

---

## 🔽 Advanced Configuration

**`Show Advanced and Logging Options`**

* If you check this, the next installation steps will let you:

  * Set custom paths for logs
  * Configure error logging, general logging
  * Enable binary logs (used for replication)
* 🛠 Only check this if you **know you need more control**.

---

## 📌 Why You Have to Do This

This step is **critical for setting up how MySQL behaves and communicates**:

* ✅ Without this configuration, the server might not allow your applications (e.g., PHP, Python, Node.js apps) to connect.
* ✅ Ensures that MySQL can accept local or remote connections properly.
* ✅ Helps secure and optimize the server depending on your usage.

---

## ✅ What You Should Do (Recommended for You)

Since you’re likely using MySQL for development:

* Keep `Development Computer` selected.
* Keep `TCP/IP` enabled with port `3306`.
* Keep “Open Windows Firewall ports…” **enabled** if you may connect from another device (or another app running outside MySQL Workbench).
* Skip Named Pipe and Shared Memory.
* You can skip the Advanced Configuration for now unless you're experienced.



---
---
---

### 🔷 What is **X Protocol Port** in MySQL?

The **X Protocol Port** (in your image it's set to `33060`) is used for **MySQL X Protocol**, which is a **newer protocol introduced by MySQL 5.7+**. It enables more advanced, flexible access to the database.

---

### 🔹 Purpose of X Protocol:

It allows you to interact with MySQL using **MySQL Document Store** and **MySQL Shell**, including:

* **CRUD operations on JSON documents**
* **Async non-blocking access**
* **Using X DevAPI** (modern API for MySQL)
* **Using MySQL as a NoSQL database** (document-style)

---

### 🔹 When do you need it?

You need the **X Protocol** (and this port) **only if**:

* You're using **MySQL Shell** with `X DevAPI`
* You're working with **MySQL as a NoSQL Document Store**
* You're using programming languages like **Node.js, Python, Java** with **X DevAPI libraries**

If you’re **just using regular SQL** with MySQL Workbench, `phpMyAdmin`, or using `mysql` CLI tool, then:

> 🟢 **You don’t need the X Protocol or port 33060.**

---

### 🔸 Summary

| Feature          | Port    | Protocol       | Use case                         |
| ---------------- | ------- | -------------- | -------------------------------- |
| Standard MySQL   | `3306`  | MySQL Protocol | Traditional SQL (SELECT, INSERT) |
| MySQL X Protocol | `33060` | X Protocol     | Document Store, X DevAPI         |
