import { supabase } from "../config/supabaseClient.js";

export async function make_borrow(book_isbn: string, student_id: number) {
  const { data, error } = await supabase.rpc("make_borrow", {
    p_book_isbn: book_isbn,
    p_student_id: student_id,
  });
  if (error) throw error;
  return data;
}
