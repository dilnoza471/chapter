import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
// CRITICAL FIX: Add .js extension for ESM resolution
import { AuthRequest, AuthenticatedUser } from '../controllers/user.controller.js'; 

const JWT_SECRET = process.env.JWT_SECRET; 

/**
 * Middleware 1: Verifies the custom JWT token and authenticates the user.
 * It attaches the decoded user payload (id, email, role, student_id) to req.user.
 */
export function authenticateToken(req: AuthRequest, res: Response, next: NextFunction) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Authentication token missing.' });
    }
    
    if (!JWT_SECRET) {
        console.error("JWT_SECRET is not configured.");
        return res.status(500).json({ message: 'Server configuration error.' });
    }

    // jwt.verify takes the token, secret, and a callback
    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            // Token is invalid, expired, or malformed
            return res.status(403).json({ message: 'Invalid or expired token.' });
        }
        
        // The decoded `user` payload here contains the required fields (id, email, role, etc.)
        // We cast it to the AuthenticatedUser type for safety.
        req.user = user as AuthenticatedUser; 
        next();
    });
}

/**
 * Middleware 2: Higher-order function to check if the authenticated user has the required role.
 * @param requiredRole The role string ('student' or 'librarian').
 */
export function checkRole(requiredRole: 'student' | 'librarian') {
    return (req: AuthRequest, res: Response, next: NextFunction) => {
        // Check if the user is authenticated and has the necessary role
        if (req.user && req.user.role === requiredRole) {
            next();
        } else {
            res.status(403).json({ message: 'Forbidden. Insufficient permissions to access this resource.' });
        }
    };
}