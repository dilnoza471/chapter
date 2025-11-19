import * as authService from '../services/auth.service.js';
import User from '../models/user.model.js'; 
import { UniqueConstraintError } from 'sequelize';
import { Sequelize } from 'sequelize';


export async function register(req, res) {
    const { email, password, name, role, student_id } = req.body;

    if (!email || !password || !name) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    const assignedRole = (role === 'librarian') ? 'librarian' : 'student';
    if (assignedRole === 'student' && !student_id) {
        return res.status(400).json({ message: 'Student registration requires a student_id.' });
    }

    try {
        const password_hash = await authService.hashPassword(password);

        const newUser = await User.create({
            email,
            password_hash,
            name,
            role: assignedRole,
            student_id: assignedRole === 'student' ? student_id : null,
        });

        res.status(201).json({ 
            message: 'User registered successfully!',
            userId: newUser.id,
            role: assignedRole
        });

    } catch (error) {
        console.error(error);
        
        if (error instanceof UniqueConstraintError) {
            return res.status(409).json({ message: 'User with this email already exists.' });
        }

        res.status(500).json({ message: 'Server error during registration.' });
    }
}


export async function login(req, res) {
    const { identifier, password } = req.body;

    if (!identifier || !password) {
        return res.status(400).json({ message: 'Identifier and password are required.' });
    }

    try {
        const user = await User.findOne({
            where: {
                [Sequelize.Op.or]: [
                    { email: identifier },
                    { student_id: identifier }
                ]
            }
        });

        if (!user) {
            return res.status(401).json({ message: 'Invalid credentials.' });
        }

        const isMatch = await authService.comparePassword(password, user.password_hash);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid credentials.' });
        }

        const token = authService.generateToken(user);

        res.status(200).json({
            token,
            role: user.role,
            message: 'Login successful'
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error during login.' });
    }

    
}

export async function logout(req, res) {
    // For JWT-based auth, logging out is typically client-side 
    // (clearing the token). The server only needs to confirm the request
    // or optionally blacklist a token if using refresh tokens.
    // Here we just send a success response.
    res.status(200).json({ message: 'Logout successful (client-side token removal)' });
}
