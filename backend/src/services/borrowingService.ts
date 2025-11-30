import { supabase } from "../config/supabaseClient.js";
import { Loan } from "../models/borrowModel.js";

export async function getBorrowingsByUser(user_id: number): Promise<Loan[]> {
  const { data, error } = await supabase.rpc("get_loans_by_user", {
    p_user_id: user_id,
  });

  if (error) throw error;
  return data as Loan[];
}
