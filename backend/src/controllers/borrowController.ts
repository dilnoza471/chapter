import { Request, Response } from "express";
import { make_borrow } from "../services/borrowService.js";

export async function makeBorrow(req: Request, res: Response) {
  const copy_id = parseInt(req.body.id, 10);
  const user_id = parseInt(req.body.user_id, 10);
  try {
    await make_borrow(copy_id, user_id);
    res.status(200).json({ message: "Borrow successful" });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
}
