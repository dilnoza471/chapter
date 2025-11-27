import { supabase } from "../config/supabaseClient.js";

export async function make_borrow(copy_id: number, user_id: number) {
  const { data, error } = await supabase.rpc("make_borrow", {
    p_copy_id: copy_id,
    p_user_id: user_id,
  });
  if (error) throw error;
}
