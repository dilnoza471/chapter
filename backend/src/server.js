// src/server.js

import dotenv from 'dotenv';
dotenv.config();
console.log("JWT_SECRET:", process.env.JWT_SECRET);
import express from 'express';
import { connectDB } from './config/database.js'; 
import authRoutes from './routes/auth.routes.js'; 
import userRoutes from './routes/user.routes.js'; 

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5001;

// Middleware Setup
app.use(express.json());
app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*'); 
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    if (req.method === 'OPTIONS') {
        return res.sendStatus(200);
    }
    next();
});

// Route Handling
app.use('/auth', authRoutes);
app.use('/users', userRoutes);

// Global Error Handler
app.use((error, req, res, next) => {
    console.error(error.stack); 
    const status = error.statusCode || 500;
    const message = error.message || 'An unknown server error occurred!';
    res.status(status).json({ message: message });
});

// Server Start
connectDB()
    .then(() => {
        app.listen(PORT, () => {
            console.log(`✅ Server running on http://localhost:${PORT}`);
        });
    })
    .catch(err => {
        console.error("❌ Failed to start server due to database error:", err);
        process.exit(1); 
    });