import { supabase } from "../config/supabaseClient.js";
import { Reservation } from "../models/reservationModel.js";

export async function getReservationsByUser(user_id: number): Promise<Reservation[]> {
  const { data, error } = await supabase.rpc("get_reservations_by_user", {
    p_user_id: user_id,
  });

  if (error) throw error;
  return data as Reservation[];
}

export async function cancelReservation(reservation_id: number) {
  const { data, error } = await supabase.rpc("cancel_reservation", {
    p_reservation_id: reservation_id,
  });

  if (error) throw error;
  return data;
}
