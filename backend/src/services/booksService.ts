import { supabase } from "../config/supabaseClient.js";
import { Book } from "../models/bookModel.js";
import axios from 'axios';


export async function getAllBooks(): Promise<Book[]> {
  const { data, error } = await supabase.from("books").select("*");

  if (error) {
    console.error("Supabase error:", error);
    throw new Error(error.message);
  }

  console.log("Retrieved data:", data);
  return data as Book[];
}

export async function getBookById(id: number): Promise<Book> {
  const { data, error } = await supabase
    .from("books")
    .select("*")
    .eq("id", id)
    .single();
  if (error) {
    console.error("Supabase error:", error);
    throw new Error(error.message);
  }
  return data as Book;
}

export async function getBookByIsbn(isbn: string): Promise<Book | null> {
  try {
    // First, check if book exists in your database
    const { data: existingBook, error } = await supabase
      .from("books")
      .select("*")
      .eq("isbn", isbn)
      .single();
    
    if (existingBook && !error) {
      return existingBook as Book;
    }
    
    // Fetch from Open Library API
    const response = await axios.get(
      `https://openlibrary.org/api/books?bibkeys=ISBN:${isbn}&format=json&jscmd=data`
    );
    
    const bookKey = `ISBN:${isbn}`;
    if (!response.data[bookKey]) {
      return null;
    }
    
    const bookData = response.data[bookKey];
    
    // Transform API data to your Book model
    const book: Book = {
      id: '',
      isbn: isbn,
      title: bookData.title || 'Unknown',
      author: bookData.authors?.map((a: any) => a.name).join(', ') || 'Unknown',
      description: bookData.notes || bookData.subtitle || '',
      publicationDate: bookData.publish_date || '',
      language: 'en', // Open Library doesn't always provide this
      category: bookData.subjects?.slice(0, 3).map((s: any) => s.name).join(', ') || 'Uncategorized',
      coverImageUrl: bookData.cover?.medium || bookData.cover?.small || '',
      totalCopies: 0,
      availableCopies: 0
    };
    
    return book;
    
  } catch (error: any) {
    console.error("Error fetching book by ISBN:", error);
    return null;
  }
}