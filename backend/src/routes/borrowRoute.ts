import { Router } from "express";
import { makeBorrow } from "../controllers/borrowController.js";

const router = Router();

router.post("/borrow", makeBorrow);

export default router;
