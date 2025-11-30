# **Chapter Backend API Reference**

## **Base URLs**

- **Local:** `http://localhost:5001`
- **Production:** `https://chapter-djfj.onrender.com`

## **Authentication**

- Uses **JWT tokens**, stored as `jwtToken` on the frontend.
- Protected routes require:
  `Authorization: Bearer <token>`
- Roles:

  - `student`
  - `librarian` (required for creating books, borrow ops, etc.)

### **Common Headers**

| Header          | Value                            |
| --------------- | -------------------------------- |
| `Content-Type`  | `application/json`               |
| `Authorization` | `Bearer <token>` (when required) |

---

# **Auth Endpoints (`/auth`)**

## **POST /auth/login**

Authenticate user.

**Body**

- `identifier` (string: email or username)
- `password` (string)

**Response 200**

```json
{
  "token": "...",
  "role": "student",
  "user": { ... }
}
```

---

## **POST /auth/register**

Register new user.

**Body**

- `firstName`
- `lastName`
- `email`
- `password`
- `role` (student or librarian)
- `student_id` (number, required if role = student)

**Response 200/201**

- Token and/or user info.

---

## **POST /auth/logout**

Clear session.

**Response:** `200`

---

## **GET /auth/me**

Fetch logged-in user's profile.

**Headers:** `Authorization` required.

**Response example**

```json
{
  "first_name": "Alice",
  "last_name": "Smith",
  "email": "alice@example.com",
  "student_id": 12345,
  "role": "student"
}
```

---

# **User Endpoints (`/users`)**

## **GET /users/:id**

Get user by ID.

## **PATCH /users/:id**

or

## **PUT /users/:id**

Update profile fields.

**Body**

- `first_name`
- `last_name`
- `student_id` (integer)
- others as needed

**Auth:** Required.

---

# **Book Endpoints (`/books`)**

## **GET /books**

List all books.

## **GET /books/isbn/:isbn**

Get book by ISBN.

## **GET /books/:id**

Get book by DB ID.

## **POST /books**

Create a new book (**librarian only**).

**Body**

```json
{
  "isbn": "...",
  "title": "...",
  "author": "...",
  "description": "...",
  "publication_date": "YYYY-MM-DD",
  "language": "...",
  "category": "...",
  "cover_image_url": "...",
  "total_copies": 5
}
```

**Response:** Created book object.

---

# **Borrow Endpoint (`/borrow`)**

## **POST /borrow**

Borrow a book (calls Supabase RPC `make_borrow`).

**Body**

```json
{
  "book_isbn": "string",
  "student_id": 12345
}
```

**Responses**

- `200` success
- `400` invalid input
- `500` server/DB error

---

# **Borrowings (`/api/borrowings`)**

## **GET /api/borrowings/:studentId**

Fetch loans for a student.

**Response**
Array of loans:

```json
{
  "loan_id": 1,
  "book": { ... },
  "student_id": 230029,
  "borrowed_at": "ISO",
  "due_at": "ISO",
  "returned_at": null,
  "status": "active",
  "notes": null
}
```

---

# **Favorites (`/api/favorites`)**

- **GET /api/favorites/:studentId** — list favorites
- **POST /api/favorites** — add favorite

  - Body: `student_id`, `book_id` or `isbn`

- **DELETE /api/favorites/:id** — remove favorite

---

# **Reservations (`/api/reservations`)**

- **GET /api/reservations/:studentId** — list reservations
- **POST /api/reservations** — create reservation

  - Body: `student_id`, `book_isbn`, etc.

- **DELETE /api/reservations/:id** — cancel reservation
