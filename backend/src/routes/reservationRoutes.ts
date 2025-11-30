import { Router } from "express";
import {
  getUserReservations,
  cancelUserReservation,
} from "../controllers/reservationController.js";

const router = Router();

router.get("/:studentId", getUserReservations);
router.post("/", getUserReservations);
router.delete("/:reservationId", cancelUserReservation);

export default router;
