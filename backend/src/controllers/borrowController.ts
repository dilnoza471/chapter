import { Request, Response } from "express";
import { make_borrow } from "../services/borrowService.js";

export async function makeBorrow(req: Request, res: Response) {
  const book_isbn = req.body.book_isbn;
  const student_id = parseInt(req.body.student_id, 10);
  try {
    await make_borrow(book_isbn, student_id);
    res.status(200).json({ message: "Borrow successful" });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}
