import { Router } from "express";
import { getBooks, getBookByID , getBookByISBN, createBook} from "../controllers/booksController.js";

const router = Router();

router.get("/", getBooks);
router.get("/isbn/:isbn", getBookByISBN);
router.get("/:id", getBookByID);
router.post("/", createBook);

export default router;
