import { Router } from "express";
import { getUserReservations, cancelUserReservation } from "../controllers/reservationController.js";

const router = Router();

router.get("/:userId", getUserReservations);
router.delete("/:reservationId", cancelUserReservation);

export default router;
