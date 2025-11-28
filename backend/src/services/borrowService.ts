import { supabase } from "../config/supabaseClient.js";
import { Loan } from "../models/borrowModel.js";


/*
export async function getBookById(id: number): Promise<Book> {
  const { data, error } = await supabase
    .from("books")
    .select("*")
    .eq("id", id)
    .single();
  if (error) {
    console.error("Supabase error:", error);
    throw new Error(error.message);
  }
  return data as Book;
}*/

export async function make_borrow(copy_id:number, user_id: number) {
    const {data, error} = await supabase
    .rpc("make_borrow", {p_copy_id: copy_id, p_user_id: user_id});
    if(error) throw error;
    
}
