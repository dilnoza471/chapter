import { supabase } from "../config/supabaseClient.js";

<<<<<<< HEAD
export async function make_borrow(book_isbn: Text, student_id: number) {
  const { data, error } = await supabase.rpc("make_borrow", {
    p_book_isbn: book_isbn,
    p_student_id: student_id,
=======
export async function make_borrow(copy_id: number, user_id: number) {
  const { data, error } = await supabase.rpc("make_borrow", {
    p_copy_id: copy_id,
    p_user_id: user_id,
>>>>>>> origin/librarian/assign
  });
  if (error) throw error;
}
