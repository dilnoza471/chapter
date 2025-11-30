# Project Overview

## **Library Management System (LMS) – Project Overview**

### **1. Project Summary**

A digital library management system consisting of two platforms:

- **Librarian Platform (Desktop/Web):** Used by librarians to manage books, student records, and library operations.
- **Student App (Mobile – Android/iOS):** Used by students to browse books, track borrowed items, get notifications, and interact with library updates.

The system aims to streamline library processes and improve user engagement while keeping the initial version simple and manually managed.

---

### **2. Objectives**

- Digitize book inventory management.
- Enable students to easily check book availability and personal loan history.
- Improve communication between librarian and students through updates, notifications, and requests.
- Prepare scalable structure for later automation (RFID/barcodes).

---

### **3. Core Features**

### **Librarian Platform**

- Manage books: add, update, delete entries.
- Track borrowed and returned books manually.
- Approve or reject loan extension requests.
- Post updates/news visible to students.
- View analytics (popular books, active borrowers).

### **Student Mobile App**

- Browse book catalog and availability.
- View loan history and due dates.
- Receive notifications for updates or loan responses.
- Request loan extensions.
- Subscribe to out-of-stock books (get notified when available).
- View feed: new arrivals, popular books, announcements.
- Favorite books for quick access.

---

### **4. Tech Stack (tentative)**

- **Frontend:** Flutter (cross-platform), web version for librarian.
- **Backend:** Java with Spring Boot (or Node.js if you hate yourself less).
- **Database:** PostgreSQL.
- **Notifications:** Firebase Cloud Messaging.
- **Version Control:** GitHub.

---

### **5. Scope Limitations (for MVP)**

- No barcode/RFID integration in this version.
- No automatic borrowing or return system.
- Only one librarian account for now.
- Notifications only through app (no email/SMS).

---

### **6. Future Enhancements**

- Barcode or NFC integration for faster lending.
- Multiple librarian accounts with roles.
- Analytics dashboard with data visualization.
- Book reservation or hold system.
- AI-based book recommendation engine (because apparently everything needs AI now).

