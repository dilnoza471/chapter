import { supabase } from '../config/supabaseClient.js';

export const favoritesService = {
  async addFavorite(userId: number, bookIsbn: string) {
    const { data, error } = await supabase
      .from('favorites')
      .insert([{ user_id: userId, book_isbn: bookIsbn }])
      .select();

    if (error) throw error;
    return data;
  },

  async removeFavorite(userId: number, bookIsbn: string) {
    const { data, error } = await supabase
      .from('favorites')
      .delete()
      .eq('user_id', userId)
      .eq('book_isbn', bookIsbn);

    if (error) throw error;
    return data;
  },

  async getUserFavorites(userId: number) {
    const { data, error } = await supabase
      .from('favorites')
      .select('book_isbn, books(*)')
      .eq('user_id', userId);

    if (error) throw error;
    return data;
  },

  async isFavorited(userId: number, bookIsbn: string) {
    const { data, error } = await supabase
      .from('favorites')
      .select('id')
      .eq('user_id', userId)
      .eq('book_isbn', bookIsbn)
      .single();

    if (error && error.code !== 'PGRST116') throw error;
    return !!data;
  },
};