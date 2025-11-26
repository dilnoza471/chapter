import { Request, Response } from 'express';
import { supabase } from '../config/supabaseClient.js'; 

// --- Interfaces ---

// Define the structure of the user data returned from the database query
interface UserProfile {
    id: string;
    name: string;
    email: string;
    role: string;
    borrowed_books_count: number;
    created_at: string;
}

// Define the expected structure of the decoded JWT payload stored in req.user
export interface AuthenticatedUser {
    id: string;
    role: 'student' | 'librarian';
    email: string;
}

/**
 * Extend the Express Request type to include the authenticated user payload.
 * FIX: We make AuthRequest generic by passing through the Express Request generics 
 * (P=Params, ResB=ResponseBody, ReqB=RequestBody) and set default types.
 */
export interface AuthRequest<
    P = {}, 
    ResB = any, 
    ReqB = any
> extends Request<P, ResB, ReqB> {
    user?: AuthenticatedUser;
}

// Define body structure for updating the profile
interface UpdateProfileBody {
    name?: string;
    email?: string; 
}

// Define body structure for changing password
interface ChangePasswordBody {
    newPassword: string;
}

// --- Controller Functions ---

/**
 * Retrieves a user's profile. Access is restricted:
 * - Librarians can view any profile.
 * - Students can only view their own profile.
 */
export async function getUserProfile(
    // FIX: Using AuthRequest<Params> which is now correctly generic
    req: AuthRequest<{ id: string }>, 
    res: Response
): Promise<Response> {
    const requestedId = req.params.id; 
    const userId = req.user?.id; // The ID of the authenticated user
    const userRole = req.user?.role;
    
    if (!userId || !userRole) {
        return res.status(401).json({ message: 'Authentication required.' });
    }

    // Authorization Check: Students can only view their own profile
    if (userRole === 'student' && userId !== requestedId) {
        return res.status(403).json({ message: 'Forbidden. Students may only view their own profile.' });
    }

    try {
        const { data, error } = await supabase
            .from('users')
            .select('*') // Select all columns for the profile
            .eq('id', requestedId)
            .single();

        if (error || !data) {
            console.error('Error fetching user profile:', error?.message);
            return res.status(404).json({ message: 'User profile not found.' });
        }
        
        // FIX: Added return statement
        return res.status(200).json(data);

    } catch (error) {
        console.error('Server error during profile fetch:', error);
        // FIX: Added return statement
        return res.status(500).json({ message: 'Server error during profile fetch.' });
    }
}

/**
 * Allows the authenticated user to update their name and email.
 */
export async function updateProfile(
    // FIX: Using AuthRequest<{}, {}, ReqBody>
    req: AuthRequest<{}, {}, UpdateProfileBody>, 
    res: Response
): Promise<Response> {
    
    const userId = req.user?.id;
    const { name, email } = req.body; 

    if (!userId) {
        return res.status(401).json({ message: 'Authentication required.' });
    }
    
    // Only allow name update for now, email requires a separate Supabase flow
    if (!name) {
        return res.status(400).json({ message: 'Name is required for profile update.' });
    }

    try {
        // Prepare update data
        const updateData: Partial<UpdateProfileBody> = {};
        if (name) updateData.name = name;
        // NOTE: Updating email here requires a special Supabase function (updateUserByEmail)
        // For simplicity, we only allow name updates in the public.users table.

        const { data, error } = await supabase
            .from('users')
            .update(updateData)
            .eq('id', userId)
            .select() // Return the updated row
            .single();

        if (error) {
            console.error('Error updating profile:', error.message);
            return res.status(500).json({ message: 'Failed to update profile.' });
        }
        
        // FIX: Added return statement
        return res.status(200).json({ message: 'Profile updated successfully.', user: data });

    } catch (error) {
        console.error('Server error during profile update:', error);
        // FIX: Added return statement
        return res.status(500).json({ message: 'Server error during profile update.' });
    }
}

/**
 * Allows the authenticated user to change their password.
 */
export async function changePassword(
    // FIX: Using AuthRequest<{}, {}, ReqBody>
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
        // Supabase function to update user password
        const { error: updateError } = await supabase.auth.updateUser({
            password: newPassword
        });

        if (updateError) {
            console.error('Supabase password update error:', updateError.message);
            return res.status(500).json({ message: 'Failed to change password. This often requires the user to be recently authenticated.' });
        }
        
        // FIX: Added return statement
        return res.status(200).json({ message: 'Password changed successfully.' });

    } catch (error) {
        console.error('Server error during password change:', error);
        // FIX: Added return statement
        return res.status(500).json({ message: 'Server error during password change.' });
    }
}