import { Router } from "express";
import { getBooks, getBookByID } from "../controllers/booksController.js";

const router = Router();

router.get("/", getBooks);
router.get("/:id", getBookByID);

export default router;
