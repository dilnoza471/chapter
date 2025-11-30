import { supabase } from '../config/supabaseClient';
import { Notification } from '../models/notification';

export class NotificationService {

  // Get notifications for a student
  static async getByStudent(studentId: string): Promise<Notification[]> {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .eq('student_id', studentId)
      .order('created_at', { ascending: false });

    if (error) throw error;

    // Map snake_case to camelCase
    return data.map((row: any) => ({
      id: row.id,
      studentId: row.student_id,
      type: row.type,
      title: row.title,
      body: row.body,
      relatedId: row.related_id,
      isRead: row.is_read,
      createdAt: row.created_at,
      scheduledFor: row.scheduled_for,
    }));
  }

  // Create new notification
  static async create(notification: Notification): Promise<Notification> {
    const { data, error } = await supabase
      .from('notifications')
      .insert([{
        student_id: notification.studentId,
        type: notification.type,
        title: notification.title,
        body: notification.body,
        related_id: notification.relatedId,
        is_read: notification.isRead ?? false,
        scheduled_for: notification.scheduledFor ?? null
      }])
      .select();

    if (error) throw error;
    const row = data[0];
    return {
      id: row.id,
      studentId: row.student_id,
      type: row.type,
      title: row.title,
      body: row.body,
      relatedId: row.related_id,
      isRead: row.is_read,
      createdAt: row.created_at,
      scheduledFor: row.scheduled_for,
    };
  }

  // Mark notification as read
  static async markAsRead(id: number): Promise<Notification> {
    const { data, error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('id', id)
      .select();

    if (error) throw error;
    const row = data[0];
    return {
      id: row.id,
      studentId: row.student_id,
      type: row.type,
      title: row.title,
      body: row.body,
      relatedId: row.related_id,
      isRead: row.is_read,
      createdAt: row.created_at,
      scheduledFor: row.scheduled_for,
    };
  }

  // Delete notification
  static async delete(id: number): Promise<void> {
    const { error } = await supabase
      .from('notifications')
      .delete()
      .eq('id', id);

    if (error) throw error;
  }
}
