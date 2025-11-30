import { Router } from 'express';
import { favoritesController } from '../controllers/favoritesController.js';
import { authenticateToken } from '../middleware/auth.middleware.js'; // Adjust path if needed

const router = Router();

// All routes require authentication
router.use(authenticateToken);

// Add book to favorites
router.post('/add', favoritesController.addFavorite);

// Remove book from favorites
router.post('/remove', favoritesController.removeFavorite);

// Get all user favorites
router.get('/my-favorites', favoritesController.getFavorites);

// Check if a specific book is favorited
router.get('/check/:bookIsbn', favoritesController.checkFavorite);

export default router;