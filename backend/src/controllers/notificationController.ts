import { Request, Response } from 'express';
import { NotificationService } from '../services/notificationService.js';

export class NotificationController {

  static async getByStudent(req: Request, res: Response) {
    try {
      const { studentId } = req.params;
      const notifications = await NotificationService.getByStudent(studentId);
      res.json(notifications);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const notification = await NotificationService.create(req.body);
      res.status(201).json(notification);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  static async markAsRead(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const notification = await NotificationService.markAsRead(Number(id));
      res.json(notification);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  static async delete(req: Request, res: Response) {
    try {
      const { id } = req.params;
      await NotificationService.delete(Number(id));
      res.status(204).send();
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
