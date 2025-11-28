// src/routes/user.routes.js

import express from 'express';
// ✅ CORRECT: Import profile functions from user.controller.js
import { getUserProfile, updateProfile, changePassword } from '../controllers/user.controller.js'; 
import { authenticateToken } from '../middleware/auth.middleware.js'; 

const router = express.Router();

// ALL routes below REQUIRE a valid JWT token
router.get('/:id', authenticateToken, getUserProfile);
router.patch('/profile', authenticateToken, updateProfile);
router.post('/change-password', authenticateToken, changePassword);

export default router;