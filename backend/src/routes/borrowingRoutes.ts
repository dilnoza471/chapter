import { Router } from "express";
import { getUserBorrowings } from "../controllers/borrowingController.js";

const router = Router();

// GET /api/borrowings/:userId
router.get("/:userId", getUserBorrowings);

export default router;
