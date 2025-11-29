import { Request, Response } from "express";
import { getAllBooks, getBookById, getBookByIsbn } from "../services/booksService.js";
import { supabase } from "../config/supabaseClient.js";

export async function getBooks(req: Request, res: Response) {
  try {
    const books = await getAllBooks();
    res.status(200).json(books);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}

export async function getBookByID(req: Request, res: Response) {
  const bookId = parseInt(req.params.id, 10);
  try {
    const book = await getBookById(bookId);
    res.status(200).json(book);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}

export async function getBookByISBN(req: Request, res: Response) {
  try {
    const { isbn } = req.params;
    
    if (!isbn) {
      res.status(400).json({ error: "ISBN is required" });
      return;
    }
    
    const book = await getBookByIsbn(isbn);
    
    if (!book) {
      res.status(404).json({ error: "Book not found with the provided ISBN" });
      return;
    }
    
    res.status(200).json(book);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}
export async function createBook(req: Request, res: Response) {
  try {
    const bookData = req.body;
    
    // Validate required fields
    if (!bookData.isbn || !bookData.title || !bookData.author) {
      res.status(400).json({ error: "ISBN, title, and author are required" });
      return;
    }
    
    // Insert book into database
    const { data, error } = await supabase
      .from("books")
      .insert(bookData)
      .select()
      .single();
    
    if (error) {
      console.error("Supabase error:", error);
      res.status(500).json({ error: error.message });
      return;
    }
    
    res.status(201).json(data);
  } catch (err: any) {
    console.error("Error creating book:", err);
    res.status(500).json({ error: err.message });
  }
}