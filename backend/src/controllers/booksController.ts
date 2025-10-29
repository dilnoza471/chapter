import { Request, Response } from 'express';
import { getAllBooks } from '../services/booksService.js';

export async function getBooks(req: Request, res: Response) {
  try {
    const books = await getAllBooks();
    res.status(200).json(books);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}
