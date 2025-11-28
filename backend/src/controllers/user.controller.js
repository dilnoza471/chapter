// src/controllers/user.controller.js

import User from '../models/user.model.js'; 
import * as authService from '../services/auth.service.js'; 
import { Op } from 'sequelize'; 

export async function getUserProfile(req, res) { 
    const requestedId = parseInt(req.params.id); 
    const { id: currentUserId, role: currentUserRole } = req.user; 

    if (currentUserRole === 'student' && currentUserId !== requestedId) {
        return res.status(403).json({ message: 'Access denied. You can only view your own profile.' });
    }

    try {
        const user = await User.findByPk(requestedId, {
            attributes: ['id', 'name', 'email', 'role', 'borrowed_books_count', 'createdAt'] 
        });

        if (!user) {
            return res.status(404).json({ message: 'User not found.' });
        }

        res.status(200).json(user);

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error retrieving profile.' });
    }
}

export async function updateProfile(req, res) {
    const userId = req.user.id; 
    const { name, email } = req.body;

    if (!name && !email) {
        return res.status(400).json({ message: 'No fields provided for update.' });
    }

    try {
        const updateFields = {};
        if (name) updateFields.name = name;
        if (email) updateFields.email = email;

        const [updatedRowsCount] = await User.update(updateFields, {
            where: { id: userId },
            individualHooks: true
        });
        
        // ... (rest of logic) ...
        const updatedUser = await User.findByPk(userId, { attributes: ['id', 'name', 'email', 'role'] });
        
        res.status(200).json({
            message: 'Profile updated successfully',
            profile: updatedUser
        });

    } catch (error) {
        console.error(error);
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(409).json({ message: 'This email is already taken by another user.' });
        }
        res.status(500).json({ message: 'Server error during profile update.' });
    }
}

export async function changePassword(req, res) {
    // ... (Your changePassword logic goes here) ...
    const userId = req.user.id; 
    const { oldPassword, newPassword } = req.body;

    if (!oldPassword || !newPassword) {
        return res.status(400).json({ message: 'Both old and new passwords are required.' });
    }
    
    try {
        const user = await User.findByPk(userId);
        const isMatch = await authService.comparePassword(oldPassword, user.password_hash);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid old password.' });
        }

        const newPasswordHash = await authService.hashPassword(newPassword);
        await User.update({ password_hash: newPasswordHash }, { where: { id: userId } });

        res.status(200).json({ message: 'Password updated successfully. Please log in again.' });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error during password change.' });
    }
}