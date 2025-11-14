// src/routes/auth.routes.js

import express from 'express';
// ✅ CORRECT: Import register and login from auth.controller.js
import { register, login } from '../controllers/auth.controller.js'; 

const router = express.Router();

router.post('/register', register);
router.post('/login', login);

export default router;