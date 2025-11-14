// src/controllers/auth.controller.js

import * as authService from '../services/auth.service.js';
import User from '../models/user.model.js'; 
import { UniqueConstraintError } from 'sequelize';


export async function register(req, res) {
    const { email, password, name } = req.body;

    // 1. Basic validation
    if (!email || !password || !name) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    try {
        // 2. Hash password securely
        const password_hash = await authService.hashPassword(password);

        // 3. Create user record in the database
        const newUser = await User.create({
            email,
            password_hash,
            name,
            role: 'student',
        });

        // 4. Send success response
        res.status(201).json({ 
            message: 'User registered successfully!',
            userId: newUser.id 
        });

    } catch (error) {
        console.error(error);
        
        // Handle specific Sequelize error for duplicate emails
        if (error instanceof UniqueConstraintError) {
            return res.status(409).json({ message: 'User with this email already exists.' });
        }

        res.status(500).json({ message: 'Server error during registration.' });
    }
}

export async function login(req, res) {
    const { email, password } = req.body;

    // 1. Basic validation
    if (!email || !password) {
        return res.status(400).json({ message: 'Email and password are required.' });
    }

    try {
        // 2. Find user by email in the database
        const user = await User.findOne({ where: { email } });

        if (!user) {
            // Use a generic message for security
            return res.status(401).json({ message: 'Invalid credentials.' });
        }

        // 3. Compare password (using the hash from the DB)
        const isMatch = await authService.comparePassword(password, user.password_hash);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid credentials.' });
        }

        // 4. Generate JWT. We pass the Sequelize model instance to get id and role.
        const token = authService.generateToken(user);

        // 5. Send response to Flutter client
        res.status(200).json({
            token, // The JWT that the frontend must save
            role: user.role,
            message: 'Login successful'
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error during login.' });
    }
}

// Export functions for use in routes.
// We use named exports since we are using ESM.
// You will import them in auth.routes.js like: import { register, login } from '...'
// export { register, login }; // Shorthand export