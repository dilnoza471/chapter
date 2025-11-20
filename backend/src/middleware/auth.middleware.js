// src/middleware/auth.middleware.js

import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET; 

/**
 * Middleware 1: Verifies the JWT token and authenticates the user.
 */
export function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token == null) {
        return res.status(401).json({ message: 'Access denied. No token provided.' });
    }
    
    if (!JWT_SECRET) {
        console.error("JWT_SECRET is not configured.");
        return res.status(500).json({ message: 'Server configuration error.' });
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ message: 'Invalid or expired token.' });
        }
        
        req.user = user; 
        next();
    });
}

/**
 * Middleware 2: Checks if the authenticated user has the required role.
 */
export function checkRole(requiredRole) {
    return (req, res, next) => {
        if (req.user && req.user.role === requiredRole) {
            next();
        } else {
            res.status(403).json({ message: 'Forbidden. Insufficient permissions to access this resource.' });
        }
    };
}