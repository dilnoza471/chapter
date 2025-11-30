import { Request, Response } from "express";
import { getBorrowingsByUser } from "../services/borrowingService.js";

export async function getUserBorrowings(req: Request, res: Response) {
  try {
    const userId = Number(req.params.userId);

    if (!userId) {
      return res.status(400).json({ error: "Invalid user ID" });
    }

    const borrowings = await getBorrowingsByUser(userId);
    return res.status(200).json(borrowings);

  } catch (error: any) {
    return res.status(500).json({
      error: "Failed to fetch borrowings",
      message: error.message,
    });
  }
}
