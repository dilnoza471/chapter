import { Response } from 'express';
import { AuthRequest } from './user.controller.js';
import { favoritesService } from '../services/favoritesService.js';
import { supabase } from '../config/supabaseClient.js';

export const favoritesController = {
  // Add book to favorites
  async addFavorite(req: AuthRequest<{}, any, { bookIsbn: string }>, res: Response) {
    try {
      const { bookIsbn } = req.body;
      const authId = req.user?.id; // This is UUID

      if (!authId) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      // Get integer user_id from users table
      const { data: userData, error: userError } = await supabase
        .from('users')
        .select('user_id')
        .eq('id', authId)
        .single();

      if (userError || !userData) {
        return res.status(404).json({ error: 'User not found' });
      }

      const result = await favoritesService.addFavorite(userData.user_id, bookIsbn);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  },

  // Remove book from favorites
  async removeFavorite(req: AuthRequest<{}, any, { bookIsbn: string }>, res: Response) {
    try {
      const { bookIsbn } = req.body;
      const authId = req.user?.id;

      if (!authId) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      const { data: userData, error: userError } = await supabase
        .from('users')
        .select('user_id')
        .eq('id', authId)
        .single();

      if (userError || !userData) {
        return res.status(404).json({ error: 'User not found' });
      }

      await favoritesService.removeFavorite(userData.user_id, bookIsbn);
      res.status(200).json({ message: 'Removed from favorites' });
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  },

  // Get user's favorite books
  async getFavorites(req: AuthRequest, res: Response) {
    try {
      const authId = req.user?.id;

      if (!authId) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      const { data: userData, error: userError } = await supabase
        .from('users')
        .select('user_id')
        .eq('id', authId)
        .single();

      if (userError || !userData) {
        return res.status(404).json({ error: 'User not found' });
      }

      const favorites = await favoritesService.getUserFavorites(userData.user_id);
      res.status(200).json(favorites);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  },

  // Check if book is favorited
  async checkFavorite(req: AuthRequest<{ bookIsbn: string }>, res: Response) {
    try {
      const { bookIsbn } = req.params;
      const authId = req.user?.id;

      if (!authId) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      const { data: userData, error: userError } = await supabase
        .from('users')
        .select('user_id')
        .eq('id', authId)
        .single();

      if (userError || !userData) {
        return res.status(404).json({ error: 'User not found' });
      }

      const isFavorited = await favoritesService.isFavorited(userData.user_id, bookIsbn);
      res.status(200).json({ isFavorited });
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  },
};