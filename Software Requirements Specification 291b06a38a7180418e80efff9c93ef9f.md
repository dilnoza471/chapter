# Software Requirements Specification

**Project Name:** Library Management System (LMS)

**Version:** 1.0

**Prepared by:** Project Team (PM: Dilnoza)

---

## **1. Introduction**

### **1.1 Purpose**

This document defines the functional and non-functional requirements of the Library Management System. It will guide the design, development, and validation of both the librarian and student applications.

### **1.2 Scope**

The LMS will consist of:

- **Librarian Platform (Web/Desktop):** For managing the catalog, recording book transactions, and publishing updates.
- **Student Mobile App (Android/iOS):** For browsing books, viewing history, managing borrowed items, and receiving notifications.

Initial version (MVP) focuses on manual operations and core features. Automation with RFID/barcodes may be implemented later.

### **1.3 Definitions**

- **Librarian:** Authorized user who manages the library database.
- **Student:** Registered user who accesses library info through the app.
- **Book Record:** Entry containing book metadata, availability, and borrower details.

---

## **2. Overall Description**

### **2.1 Product Perspective**

The LMS is an independent client-server system.

Frontend apps (web and mobile) interact with a shared backend API connected to a relational database.

### **2.2 Product Functions**

- Manage book inventory
- Track borrowed and returned books
- Notify users of updates and status changes
- Allow students to request loan extensions
- Provide insights on popular and new books

### **2.3 User Characteristics**

| User | Description | Access |
| --- | --- | --- |
| Librarian | Basic computer literacy | Full CRUD operations on books, manage requests |
| Student | Basic smartphone literacy | Read-only access to catalog, limited account actions |

### **2.4 Constraints**

- Manual data entry by librarian.
- Requires stable internet connection.
- Mobile notifications depend on Firebase availability.
- Single admin account for MVP.

### **2.5 Assumptions & Dependencies**

- Librarian will maintain accurate data.
- System depends on backend server uptime.
- Students must be registered users to use the app.

---

## **3. System Features**

### **3.1 Librarian Platform**

| Feature | Description | Priority |
| --- | --- | --- |
| Add/Update/Delete Book | Manage catalog entries with title, author, category, availability | High |
| Record Borrow/Return | Update book status manually | High |
| Approve/Reject Extension Requests | Manage student requests to extend due date | High |
| Post News/Updates | Publish notices or announcements visible in app | Medium |
| View Statistics | See most borrowed books, total transactions | Medium |

---

### **3.2 Student Mobile App**

| Feature | Description | Priority |
| --- | --- | --- |
| Browse Catalog | View all books and availability status | High |
| Search Books | Search by title, author, or category | High |
| View Loan History | See borrowed and returned books | High |
| Request Extension | Ask librarian for due date extension | High |
| Subscribe to Book | Get notified when unavailable book becomes available | Medium |
| Favorites | Save preferred books | Medium |
| Feed Page | View popular and new arrivals, and librarian updates | Medium |
| Notifications | Receive alerts about book updates or requests | High |

---

## **4. Non-Functional Requirements**

| Category | Requirement |
| --- | --- |
| **Performance** | App should respond within 2 seconds for standard queries. |
| **Scalability** | Backend should support up to 500 student users initially. |
| **Security** | Login required for both users. Passwords stored securely (hashed). |
| **Usability** | Simple UI suitable for non-technical users. |
| **Compatibility** | Android 8+ / iOS 14+ / modern browsers for web. |
| **Maintainability** | Modular code structure; proper documentation. |
| **Reliability** | 99% uptime on hosted backend. |
| **Data Integrity** | Prevent inconsistent updates between client and server. |

---

## **5. Database Requirements**

Basic tables:

- **Users (id, name, role, email, password)**
- **Books (id, title, author, category, available_count, total_count)**
- **BorrowRecords (id, user_id, book_id, issue_date, due_date, return_date, status)**
- **Notifications (id, user_id, type, message, created_at)**
- **News (id, title, content, date)**

---

## **6. Future Enhancements**

- Barcode/RFID integration for book scanning.
- Multi-role librarian accounts.
- Recommendation system for students.
- Detailed analytics and reporting dashboard.