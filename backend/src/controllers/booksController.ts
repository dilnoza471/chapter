import { Request, Response } from "express";
import { getAllBooks, getBookById } from "../services/booksService.js";
import { get } from "http";

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


