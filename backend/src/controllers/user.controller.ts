import { Request, Response } from 'express';
import { supabase } from '../config/supabaseClient.js'; 


interface UserProfile {
    id: string;
    name: string;
    email: string;
    role: string;
    borrowed_books_count: number;
    created_at: string;
}

export interface AuthenticatedUser {
    id: string;
    role: 'student' | 'librarian';
    email: string;
}

export interface AuthRequest<
    P = {}, 
    ResB = any, 
    ReqB = any
> extends Request<P, ResB, ReqB> {
    user?: AuthenticatedUser;
}

interface UpdateProfileBody {
    name?: string;
    email?: string;
}
interface ChangePasswordBody {
    newPassword: string;
}

export async function getUserProfile(
    req: AuthRequest<{ id: string }>, 
    res: Response
): Promise<Response> {
    const requestedId = req.params.id; 
    const userId = req.user?.id;
    const userRole = req.user?.role;
    
    if (!userId || !userRole) {
        return res.status(401).json({ message: 'Authentication required.' });
    }

    if (userRole === 'student' && userId !== requestedId) {
        return res.status(403).json({ message: 'Forbidden. Students may only view their own profile.' });
    }

    try {
        const { data, error } = await supabase
            .from('users')
            .select('*') 
            .eq('id', requestedId)
            .single();

        if (error || !data) {
            console.error('Error fetching user profile:', error?.message);
            return res.status(404).json({ message: 'User profile not found.' });
        }
        
        return res.status(200).json(data);

    } catch (error) {
        console.error('Server error during profile fetch:', error);
        return res.status(500).json({ message: 'Server error during profile fetch.' });
    }
}

// In src/controllers/user.controller.js

// ... (inside updateProfile function)

// In src/controllers/user.controller.js

// ... (inside updateProfile function)

export async function updateProfile(
    req: AuthRequest<{}, {}, UpdateProfileBody>, 
    res: Response
): Promise<Response> {
    
    const userId = req.user?.id;
    // ✅ ONLY allow name updates
    const { name } = req.body; 

    if (!userId) {
        return res.status(401).json({ message: 'Authentication required.' });
    }
    
    if (!name) {
        return res.status(400).json({ message: 'Full name is required for profile update.' });
    }

    try {
        const updateProfileData: any = {}; 

        // Handle Name only (public.users table update)
        const parts = name.trim().split(/\s+/);
        updateProfileData.firstname = parts[0];
        updateProfileData.lastname = parts.length > 1 ? parts.slice(1).join(' ') : '';
        
        // ❌ REMOVED: Student ID update logic entirely
        // Student ID should never be updated by users
        
        console.log('Update Data:', updateProfileData);

        // Execute Profile Update
        const { data, error: profileError } = await supabase
            .from('users')
            .update(updateProfileData) 
            .eq('id', userId)
            .select()
            .single();

        if (profileError) {
            console.error('❌ Supabase Profile Update Error:', profileError.message);
            console.error('❌ Full error details:', profileError);
            throw new Error('Database update failed.');
        }
        
        console.log('✅ Profile updated successfully:', data);
        
        return res.status(200).json({ message: 'Profile updated successfully.' });

    } catch (error: any) {
        console.error('❌ Server error during profile update:', error);
        const errorMessage = error.message.includes('Database update failed')
            ? error.message
            : 'Server error during profile update.';
            
        return res.status(500).json({ message: errorMessage });
    }
}

export async function changePassword(
    req: AuthRequest<{}, {}, ChangePasswordBody>, 
    res: Response
): Promise<Response> {
    const userId = req.user?.id;
    const { newPassword } = req.body; 

    if (!userId) {
        return res.status(401).json({ message: 'Authentication required.' });
    }
    if (!newPassword) {
        return res.status(400).json({ message: 'New password is required.' });
    }

    try {
        const { error: updateError } = await supabase.auth.updateUser({
            password: newPassword
        });

        if (updateError) {
            console.error('Supabase password update error:', updateError.message);
            return res.status(500).json({ message: 'Failed to change password. This often requires the user to be recently authenticated.' });
        }
        
        return res.status(200).json({ message: 'Password changed successfully.' });

    } catch (error) {
        console.error('Server error during password change:', error);
        return res.status(500).json({ message: 'Server error during password change.' });
    }
}