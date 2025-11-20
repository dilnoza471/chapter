// src/services/auth.service.js

import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const SALT_ROUNDS = 10;

export async function hashPassword(password) {
    return bcrypt.hash(password, SALT_ROUNDS);
}

export async function comparePassword(plainPassword, hash) {
    return bcrypt.compare(plainPassword, hash);
}

export function generateToken(user) {
    const JWT_SECRET = process.env.JWT_SECRET; 
    
    if (!process.env.JWT_SECRET) {
        throw new Error("JWT_SECRET is not defined in the environment variables.");
    }
    
    const payload = {
        id: user.id,
        role: user.role,
    };

    return jwt.sign(payload, JWT_SECRET, { expiresIn: '1d' });
}