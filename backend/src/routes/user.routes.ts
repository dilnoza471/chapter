import express, { Response } from 'express';
import { getUserProfile, updateProfile, changePassword, AuthRequest } from '../controllers/user.controller.js';
import { authenticateToken } from '../middleware/auth.middleware.js';
import { supabase } from '../config/supabaseClient.js';

const router = express.Router();

// Get current user's own profile (matches Flutter app's /users/me endpoint)
router.get('/me', authenticateToken, async (req: AuthRequest, res: Response) => {
    const userId = req.user?.id;
    
    console.log('=== PROFILE FETCH ===');
    console.log('User ID from token:', userId);
    console.log('Full user object:', req.user);
    
    if (!userId) {
        console.error('❌ No user ID in token');
        return res.status(401).json({ message: 'Authentication required.' });
    }

    try {
        console.log('🔍 Fetching profile from database...');
        const { data, error } = await supabase
            .from('users')
            .select('id, firstname, lastname, email, role, student_id, created_at')
            .eq('id', userId)
            .single();

        if (error) {
            console.error('❌ Database error:', error.message);
            return res.status(500).json({ message: 'Database error fetching profile.' });
        }

        if (!data) {
            console.error('❌ No profile found for user ID:', userId);
            return res.status(404).json({ message: 'User profile not found.' });
        }
        
        console.log('✅ Profile found:', data.email);
        return res.status(200).json(data);

    } catch (error) {
        console.error('❌ Server error during profile fetch:', error);
        return res.status(500).json({ message: 'Server error during profile fetch.' });
    }
});

// Get specific user profile by ID (for librarians or admin use)
router.get('/:id', authenticateToken, getUserProfile);

// Update current user's profile
router.put('/me', authenticateToken, updateProfile);

// Change password
router.put('/password', authenticateToken, changePassword);

export default router;