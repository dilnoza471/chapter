import { Router } from "express";
import { getBooks } from "../controllers/booksController.js";

const router = Router();

router.get("/books", getBooks);
router.get("/books/:id", getBooks);

export default router;
