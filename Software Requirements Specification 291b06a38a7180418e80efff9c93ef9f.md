Software Requirements Specification (SRS)

Project Name: Library Management System (LMS)
Version: 1.0
Prepared by: Project Team (PM: Dilnoza)

1. Introduction
   1.1 Purpose

This document defines the full functional and non-functional requirements of the Library Management System (LMS). It serves as the primary reference for developers, testers, and stakeholders.

1.2 Scope

The LMS consists of:

Librarian Platform (Web/Desktop): Catalog management, borrow/return tracking, and posting updates.

Student Mobile App (Android/iOS): Browsing catalog, tracking borrowed books, receiving notifications, submitting requests.

Initial release (MVP) focuses on manual operations. Automation (barcode/RFID) will be added in future versions.

1.3 Definitions

Librarian: Authorized user who manages library data.

Student: Registered mobile app user.

Book Record: Metadata including title, author, category, availability, and borrower info.

2. Overall Description
   2.1 Product Perspective

Client-server system with shared backend.
Mobile and web apps interact with the backend API connected to a relational database (PostgreSQL).

2.2 Product Functions

Manage book inventory

Track borrow/return operations

Notify users

Allow extension requests

Provide insights on library activity

2.3 User Characteristics
User Description Access
Librarian Basic computer literacy Full CRUD on books; manage borrow/return; manage requests
Student Basic smartphone familiarity Browse catalog; limited account actions; request extensions
2.4 Constraints

Requires internet access

Manual input from librarian

Notifications depend on FCM availability

Only one admin account for MVP

2.5 Assumptions & Dependencies

Librarian must maintain accurate records

System depends on backend server uptime

Students must be registered

3. System Requirements
   3.1 System Requirements (Mobile App)

Minimum Android SDK: API 26 (Android 8.0+)

Minimum iOS version: iOS 14+

Required permissions:

Internet

Push notifications

Storage: ≥50MB

Minimum RAM: 2GB

3.2 System Requirements (Web/Desktop – Librarian Platform)

Supported browsers: Chrome, Firefox, Edge, Safari (latest)

OS support: Windows 10+, macOS 11+, Ubuntu 20.04+

Internet: minimum 5 Mbps

3.3 Hardware Requirements

Smartphone with working internet

Push notification capability

Optional future hardware:

Barcode scanner

RFID reader

4. Requirements Catalogue
   4.1 Functional Requirements (FR)
   FR-1: Add Book

Actor: Librarian

Description: Librarian adds a new book with title, author, category, and quantity.

Preconditions: Librarian is logged in.

Postconditions: Book record is stored; catalog updates.

FR-2: Update Book

Actor: Librarian

Description: Modify book details or stock count.

Postconditions: Updated record replaces old one.

FR-3: Delete Book

Actor: Librarian

Description: Remove book from catalog when no active borrow records exist.

Postconditions: Book is no longer visible to students.

FR-4: Record Borrow Transaction

Actor: Librarian

Inputs: Student ID, book ID, due date

Preconditions: Book availability > 0

Postconditions: Availability decreases; borrow record created.

FR-5: Record Return Transaction

Actor: Librarian

Preconditions: Borrow record exists

Postconditions: Availability increases; record marked "returned."

FR-6: Browse Catalog

Actor: Student

Description: View list of available books with search and filters.

Output: Titles, authors, categories, availability.

FR-7: View Loan History

Actor: Student

Description: Student sees all borrowed, returned, overdue books.

FR-8: Request Due-Date Extension

Actor: Student

Description: Submit a request for more time.

Postconditions: Request stored; librarian notified.

FR-9: Approve/Reject Extension

Actor: Librarian

Postconditions: Borrow record updated; student notified via push notification.

FR-10: Subscribe to Book

Actor: Student

Description: Student gets notified when an unavailable book becomes available.

Postconditions: Subscription stored.

FR-11: Favorites

Actor: Student

Description: Save books to personal favorites list.

FR-12: View Feed

Actors: Students

Description: Shows new arrivals, popular books, and updates/news posted by librarian.

FR-13: Post News/Updates

Actor: Librarian

Description: Publish an announcement visible in student feed.

FR-14: Notifications

Actor: System

Triggers: Extension decisions, book availability, news, overdue reminders.

4.2 Non-Functional Requirements (NFR)
NFR-1: Performance

API responses must return within ≤2 seconds under normal load.

NFR-2: Scalability

System must support up to 500 student users in initial deployment.

NFR-3: Security

JWT-based authentication.

Passwords stored as salted hashes.

NFR-4: Usability

UI must be simple and suitable for non-technical users.

NFR-5: Compatibility

Runs on Android 8+, iOS 14+, and major modern browsers.

NFR-6: Maintainability

Codebase must follow modular architecture and be properly documented.

NFR-7: Reliability

Backend must maintain 99% uptime during academic terms.

NFR-8: Data Integrity

No inconsistent updates allowed (e.g., preventing double borrows).

5. Database Requirements
   Core Tables

Users (id, name, role, email, password_hash)

Books (id, title, author, category, available_count, total_count)

BorrowRecords (id, user_id, book_id, issue_date, due_date, return_date, status)

Notifications (id, user_id, type, message, created_at)

News (id, title, content, date_created)

6. Future Enhancements

Barcode/RFID integration

Multi-librarian roles

Recommendation engine

Full analytics dashboard

Book reservation system

7. Project Overview (Merged Section)
   7.1 Summary

LMS will offer two applications:

Librarian Web/Desktop for management

Student Mobile App for browsing and interacting with library services

7.2 Objectives

Digitize library workflows

Improve communication

Provide easy access to book info

Prepare for future automation

7.3 Tech Stack

Frontend: Flutter (mobile), web for librarian

Backend: Spring Boot or Node.js

Database: PostgreSQL

Notifications: Firebase Cloud Messaging

Version Control: GitHub

7.4 Scope Limitations

Manual operations only

One librarian account

Notifications only via mobile app

No barcode scanning yet

7.5 Team Structure

(You can fill your names/roles here.)
