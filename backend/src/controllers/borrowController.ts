import { Request, Response } from "express";
import { make_borrow } from "../services/borrowService.js";

export async function makeBorrow(req: Request, res: Response) {
  const book_isbn = req.body.book_isbn;
  const student_id = Number.isFinite(req.body.student_id)
    ? Number(req.body.student_id)
    : parseInt(req.body.student_id, 10);

  if (!book_isbn || isNaN(student_id)) {
    return res.status(400).json({ error: "Invalid book_isbn or student_id" });
  }
  try {
    await make_borrow(book_isbn, student_id);
    res.status(200).json({ message: "Borrow successful" });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}
