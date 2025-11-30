import { supabase } from "../config/supabaseClient.js";
import { Reservation } from "../models/reservationModel.js";

export async function getReservationsByUser(
  student_id: number
): Promise<Reservation[]> {
  const { data, error } = await supabase.rpc("get_reservations_by_user", {
    p_student_id: student_id,
  });

  if (error) throw error;
  return data as Reservation[];
}

export async function addReservation(book_isbn: String, student_id: number) {
  const { error } = await supabase.rpc("add_reservation", {
    p_book_isbn: book_isbn,
    p_student_id: student_id,
  });
  if (error) throw error;
  return;
}

export async function cancelReservation(reservation_id: number) {
  const { data, error } = await supabase.rpc("cancel_reservation", {
    p_reservation_id: reservation_id,
  });

  if (error) throw error;
  return data;
}
