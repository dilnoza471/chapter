export interface Reservation {
  id: number;
  user_id: number;
  book_isbn: string;
  reserved_at: Date;
  expires_at: Date;
  status: string; // "active", "available", "expired"
}
