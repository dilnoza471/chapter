import '../models/book.dart';
import '../models/borrowing.dart';
import '../models/reservation.dart';
class MockData{
  static final List<Borrowing> borrowings=[
    Borrowing(
      id: '1',
      book: Book(
        id: 'b1',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 3,
        availableCopies: 0,
      ),
      borrowDate: DateTime.now().subtract(Duration(days: 10)),
      dueDate: DateTime.now().add(Duration(days:4)),
      status: 'active',
    ),
    Borrowing(
      id: '2',
      book: Book(
        id: 'b2',
        title: '1984',
        author: 'George Orwell',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 2,
        availableCopies: 0,
      ),
      borrowDate: DateTime.now().subtract(Duration(days: 20)),
      dueDate: DateTime.now().add(Duration(days: 1)),
      status: 'active',
    ),
    Borrowing(
      id: '3',
      book: Book(
        id: 'b3',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 4,
        availableCopies: 0,
      ),
      borrowDate: DateTime.now().subtract(Duration(days: 15)),
      dueDate: DateTime.now().add(Duration(days: 13)),
      status: 'active',
    ),
  ];
  static final List<Reservation> reservations=[
    Reservation(
      id: 'r1',
      book: Book(
        id: 'b4',
        title: 'Harry Potter and the Philosopher\'s Stone',
        author: 'J.K. Rowling',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 5,
        availableCopies: 0,
      ),
      reservationDate: DateTime.now().subtract(Duration(days: 5)),
      status: 'waiting',
      queuePosition: 1,
    ),
    Reservation(
      id: 'r2',
      book: Book(
        id: 'b4',
        title: 'Harry Potter and the Philosopher\'s Stone',
        author: 'J.K. Rowling',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 5,
        availableCopies: 0,
      ),
      reservationDate: DateTime.now().subtract(Duration(days: 3)),
      status: 'waiting',
      queuePosition: 2,
    ),
    Reservation(
      id: 'r3',
      book: Book(
        id: 'b4',
        title: 'Harry Potter and the Philosopher\'s Stone',
        author: 'J.K. Rowling',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 5,
        availableCopies: 0,
      ),
      reservationDate: DateTime.now().subtract(Duration(days: 2)),
      status: 'waiting',
      queuePosition: 3,
    ),
    Reservation(
      id: 'r4',
      book: Book(
        id: 'b4',
        title: 'Harry Potter and the Philosopher\'s Stone',
        author: 'J.K. Rowling',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 5,
        availableCopies: 0,
      ),
      reservationDate: DateTime.now().subtract(Duration(days: 1)),
      status: 'waiting',
      queuePosition: 4,
    ),
    Reservation(
      id: 'r5',
      book: Book(
        id: 'b4',
        title: 'Harry Potter and the Philosopher\'s Stone',
        author: 'J.K. Rowling',
        coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
        isAvailable: false,
        totalCopies: 5,
        availableCopies: 0,
      ),
      reservationDate: DateTime.now().subtract(Duration(days: 1)),
      status: 'waiting',
      queuePosition: 5,
    ),
  ];
}