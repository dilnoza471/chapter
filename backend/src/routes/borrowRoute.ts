import { Router } from "express";
import { makeBorrow } from "../controllers/borrowController.js";

const router = Router();

router.post("/", makeBorrow);

export default router;
