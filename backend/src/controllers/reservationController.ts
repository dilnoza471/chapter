import { Request, Response } from "express";
import { getReservationsByUser, cancelReservation } from "../services/reservationService.js";

export async function getUserReservations(req: Request, res: Response) {
  try {
    const userId = Number(req.params.userId);
    if (!userId) return res.status(400).json({ error: "Invalid user ID" });

    const reservations = await getReservationsByUser(userId);
    return res.json(reservations);

  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function cancelUserReservation(req: Request, res: Response) {
  try {
    const reservationId = Number(req.params.reservationId);
    if (!reservationId) return res.status(400).json({ error: "Invalid ID" });

    await cancelReservation(reservationId);
    return res.json({ message: "Reservation cancelled" });

  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
