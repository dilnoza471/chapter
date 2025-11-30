export interface Notification {
  id?: number;
  studentId: number;
  type: string; // 'borrow_due', 'reservation_available', etc.
  title: string;
  body: string;
  relatedId?: string;
  isRead?: boolean;
  createdAt?: Date;
  scheduledFor?: Date;
}
