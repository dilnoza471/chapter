import express from 'express';
// FIXED for ESM: Added .js extension to controller import
import { register, login, logout } from '../controllers/auth.controller.js'; 

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/logout', logout);

export default router;