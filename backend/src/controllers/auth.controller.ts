import { Request, Response } from 'express';
import { supabase } from '../config/supabaseClient.js'; 
import jwt from 'jsonwebtoken'; 
import { User } from '@supabase/supabase-js';

interface RegistrationBody {
    email: string;
    password: string;
    firstname: string; 
    lastname: string;
    role?: 'student' | 'librarian';
    student_id?: string;
}

interface LoginBody {
    identifier: string;
    password: string;
}

interface SessionUserPayload {
    id: string;
    email: string;
    role: string;
    student_id: string | null;
}

function generateSessionToken(payload: SessionUserPayload): string {
    const tokenPayload = {
        id: payload.id,
        email: payload.email,
        role: payload.role,
        student_id: payload.student_id,
    };
    
    if (!process.env.JWT_SECRET) {
        throw new Error("JWT_SECRET is not defined in the environment variables.");
    }

    return jwt.sign(tokenPayload, process.env.JWT_SECRET, { expiresIn: '1h' });
}

export async function register(req: Request<{}, {}, RegistrationBody>, res: Response) {
    const { email, password, firstname, lastname, role = 'student', student_id = null } = req.body;

    console.log('=== REGISTRATION ATTEMPT ===');
    console.log('Email:', email);
    console.log('Role:', role);
    console.log('Student ID:', student_id);

    if (!email || !password || !firstname || !lastname) {
        return res.status(400).json({ message: 'Email, password, firstname, and lastname are required.' });
    }

    try {
        console.log('Creating user in Supabase Auth...');
        const { data: authData, error: authError } = await supabase.auth.signUp({
            email,
            password,
        });

        if (authError) {
            console.error('❌ Supabase Auth registration error:', authError.message);
            return res.status(400).json({ message: authError.message });
        }

        if (!authData.user) {
            console.log('⚠️ Email confirmation required');
            return res.status(202).json({ 
                message: 'Registration initiated. Please check your email for a confirmation link to activate your account.' 
            });
        }
        
        const userId = authData.user.id;
        console.log('✅ Auth user created with ID:', userId);

        console.log('Inserting profile into users table...');
        const { error: profileError } = await supabase
            .from('users')
            .insert({
                id: userId,
                firstname: firstname,
                lastname: lastname,
                email: email,
                role: role,
                student_id: student_id
            });

        if (profileError) {
            console.error('❌ Profile insertion error:', profileError.message);
            return res.status(500).json({ message: 'User registered but profile failed to save.' });
        }

        console.log('✅ Profile created successfully');

        const sessionPayload: SessionUserPayload = {
            id: userId,
            email: email,
            role: role,
            student_id: student_id,
        };
        const token = generateSessionToken(sessionPayload);

        console.log('✅ REGISTRATION SUCCESSFUL');
        return res.status(201).json({
            token,
            role,
            message: 'Registration successful'
        });

    } catch (error) {
        console.error('❌ Registration server error:', error);
        return res.status(500).json({ message: 'Server error during registration.' });
    }
}

export async function login(req: Request<{}, {}, LoginBody>, res: Response) {
    const { identifier, password } = req.body;

    console.log('=== LOGIN ATTEMPT ===');
    console.log('Identifier:', identifier);
    console.log('Password length:', password.length);

    if (!identifier || !password) {
        return res.status(400).json({ message: 'Identifier and password are required.' });
    }

    try {
        let emailToLogin: string = identifier;
        let profileRole: string = 'student'; 
        let profileStudentId: string | null = null;
        
        if (!identifier.includes('@')) {
            console.log('🔍 Looking up by student_id:', identifier);
            const { data, error } = await supabase
                .from('users')
                .select('email, role, student_id')
                .eq('student_id', identifier)
                .maybeSingle();

            console.log('Student lookup - Data:', data);
            console.log('Student lookup - Error:', error?.message || 'No error');

            if (error || !data) {
                console.error('❌ Student ID not found');
                return res.status(401).json({ message: 'Invalid credentials.' }); 
            }
            
            emailToLogin = data.email;
            profileRole = data.role;
            profileStudentId = data.student_id;
            console.log('✅ Found email for student_id:', emailToLogin);
        } else {
            console.log('📧 Login with email');
        }
        
        console.log('🔐 Attempting Supabase Auth login with:', emailToLogin);
        const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
            email: emailToLogin,
            password: password,
        });

        console.log('Auth Data:', authData?.user ? `User: ${authData.user.email}` : 'No user');
        console.log('Auth Error:', authError?.message || 'No error');

        if (authError) {
            console.error('❌ AUTH FAILED:', authError.message);
            return res.status(401).json({ message: 'Invalid credentials.' });
        }
        
        if (!authData.user) {
            console.error('❌ No user data returned');
            return res.status(500).json({ message: 'Auth successful but user data is missing.' });
        }
        
        console.log('✅ Auth successful for:', authData.user.email);
        
        if (identifier.includes('@')) {
            console.log('🔍 Fetching profile for user ID:', authData.user.id);
            const { data: profile, error: profileError } = await supabase
                .from('users')
                .select('role, student_id')
                .eq('id', authData.user.id)
                .maybeSingle();
                
            console.log('Profile Data:', profile);
            console.log('Profile Error:', profileError?.message || 'No error');
                
            if (profileError) {
                console.error('❌ Profile fetch error:', profileError.message);
                return res.status(500).json({ message: 'Failed to fetch user profile.' });
            }

            if (!profile) {
                console.error('❌ No profile found for user');
                return res.status(500).json({ message: 'User profile not found in database.' });
            }
            
            profileRole = profile.role;
            profileStudentId = profile.student_id;
            console.log('✅ Profile fetched - Role:', profileRole);
        }

        const sessionPayload: SessionUserPayload = {
            id: authData.user.id,
            email: emailToLogin,
            role: profileRole, 
            student_id: profileStudentId,
        };
        const token = generateSessionToken(sessionPayload);

        console.log('✅ LOGIN SUCCESSFUL - Role:', profileRole);
        
        res.status(200).json({
            token,
            role: profileRole,
            message: 'Login successful'
        });

    } catch (error) {
        console.error('❌ UNEXPECTED LOGIN ERROR:', error);
        res.status(500).json({ message: 'Server error during login.' });
    }
}

export async function logout(req: Request, res: Response) {
    const { error } = await supabase.auth.signOut();
    if (error) {
        console.warn("Supabase sign out warning:", error.message);
    }
    
    res.status(200).json({ message: 'Logout successful (client-side token removal).' });
}

