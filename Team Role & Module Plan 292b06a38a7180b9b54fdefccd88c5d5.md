# Team Role & Module Plan

# **Team Overview**

| Name | Role | Modules | Notes |
| --- | --- | --- | --- |
| **Dilnoza** | Project Manager + Fullstack Dev | Book Catalog + Book Details (Student side) | Oversees repo, coordinates backend consistency, manages tasks & documentation. |
| **Asilbek** | Fullstack Dev | Auth + Profile (Student + Librarian) | Handles user auth for both roles and session management. |
| **Saidmurod** | Fullstack Dev | Home Page + Search & Filter (Student side) | Connects book data APIs and builds discovery experience. |
| **Malika** | Fullstack Dev | My Borrowings + Notifications (Student side) | Manages transactions and notification integration (Firebase). |
| **Mirpolat** | Fullstack Dev | Favorites + Announcements + Global UI | Unifies design, themes, and builds librarian announcements system. |

---

## **Detailed Breakdown by Module**

### **1. Authentication & Profile – Asilbek**

**Frontend:**

- Login/signup screen with student ID/email + password.
- Input validation (empty fields, wrong format).
- Profile screen showing user info (name, email, borrowed books count).
- Edit profile (change name, email, password).
- Logout button clears token/session.

**Backend:**

- `/auth/register` – create new user (student or librarian role).
- `/auth/login` – authenticate and return JWT.
- `/auth/logout` – invalidate session.
- `/users/:id` – get or update user profile.
- Database tables: `users`, `sessions`.
- Middleware for role-based access (`student`, `librarian`).

**Shared responsibility:**

- Works with Dilnoza to link book actions to logged-in users.
- Test both student and librarian login flows.

---

### **2. Home, Search, and Filter – Saidmurod**

**Frontend:**

- Home screen showing:
    - *Featured*, *Popular*, *New arrivals* sections (horizontal scroll).
    - Dynamic search bar (title/author/category).
    - Filters: available, borrowed, category.
- Book card clickable → opens details (from Dilnoza’s module).

**Backend:**

- `/books` – get all books.
- `/books/popular` – top borrowed books.
- `/books/new` – recently added books.
- `/books/search?query=xyz` – search by title, author, or category.
- Integrate **Google Books API / OpenLibrary API** via ISBN for extra book details.
- Cache results to prevent API spam.

**Shared responsibility:**

- Coordinate with Dilnoza on book schema (ensure same data fields).
- Provide API endpoints that feed home and catalog pages.

---

### **3. Book Catalog & Details – Dilnoza**

**Frontend:**

- Catalog page (grid or list view) showing books with availability status.
- Book details page with full info (title, author, desc, cover, category).
- Action buttons:
    - **Borrow / Reserve** (student)
    - **Add to Favorites**
    - **Subscribe for Availability**
- Confirmation dialogs for actions.

**Backend:**

- `/books/:id` – get single book info.
- `/borrow` – create borrow record.
- `/reserve` – subscribe to notification when available.
- `/favorites` – add/remove favorites.
- Updates book status (`available_count`, `borrowed_count`).

**PM Tasks:**

- Manage weekly sync meetings.
- Update progress tracker.
- Review code merges before pushing to main branch.
- Maintain documentation.

**Shared responsibility:**

- Works with Malika on borrow/return logic, and Mirpolat on favorites integration.

---

### **4. My Borrowings + Notifications – Malika**

**Frontend:**

- “My Borrowings” page: list of currently borrowed books with due dates.
- Buttons:
    - **Renew** (sends extension request).
    - **Return** (marks book returned).
    - Show borrowing history (past returns).
- Notifications UI (bell icon + list).

**Backend:**

- `/borrowings` – get current + past borrowings for user.
- `/borrowings/renew/:id` – request extension.
- `/borrowings/return/:id` – mark as returned.
- `/notifications` – CRUD for app notifications.
- Integrate Firebase Cloud Messaging for push notifications.

**Shared responsibility:**

- Works with Dilnoza to update book availability on return.
- Syncs with Asilbek’s auth system for user-specific borrowing data.

---

### **5. Favorites, Announcements & Global Styling – Mirpolat**

**Frontend:**

- Favorites page: saved books in grid view, clickable to open details.
- Dark/light mode toggle (persistent with local storage).
- Global theming: colors, typography, reusable buttons, icons.
- Announcement page (library updates).

**Backend:**

- `/favorites` – add/remove/get favorites.
- `/announcements` – librarian posts announcements.
- `/themes` – (optional) endpoint to store theme preference.

**Shared responsibility:**

- Works with Dilnoza for favorites logic.
- Collaborates with Saidmurod to match home + catalog styling.
- Ensures global styling consistency across all screens.

---

### **6. Librarian Platform (Shared Responsibility)**

All members contribute a small librarian-side feature tied to their module to balance workload:

| Member | Librarian Function |
| --- | --- |
| **Asilbek** | Librarian login + profile management. |
| **Saidmurod** | Librarian dashboard: display total books, borrowed count, recent activity. |
| **Dilnoza** | Manage catalog: add/update/delete books, change availability. |
| **Malika** | Handle extension requests, approve/decline, send notifications. |
| **Mirpolat** | Create announcements, manage posts shown on student feed. |

---

### **Coordination Rules**

- Each person handles both **frontend and backend** for their assigned module.
- Backend routes must follow a consistent naming convention (`/api/v1/...`).
- Shared models (e.g., `Book`, `User`, `BorrowRecord`) are defined **once** in a central folder.
- Weekly sync meeting (Dilnoza leads) every Friday to merge branches and resolve conflicts.
- Common testing dataset used by everyone.
- Each feature tested independently through Postman before UI integration.

---

### **Workload Balance**

| Member | Frontend Workload | Backend Workload | Combined Level |
| --- | --- | --- | --- |
| Asilbek | Medium | Medium | Balanced |
| Saidmurod | High (UI-heavy) | Medium | Slightly higher UI load |
| Dilnoza | Medium | High (catalog + borrow system) | Balanced |
| Malika | Medium | Medium | Balanced |
| Mirpolat | Medium (styling + theme) | Medium | Balanced |

---