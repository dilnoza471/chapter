import { Router } from 'express';
import { NotificationController } from '../controllers/notificationController';

const router = Router();

router.get('/:studentId', NotificationController.getByStudent);
router.post('/', NotificationController.create);
router.post('/:id/read', NotificationController.markAsRead);
router.delete('/:id', NotificationController.delete);

export default router;

