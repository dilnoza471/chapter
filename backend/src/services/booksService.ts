import { supabase } from "../config/supabaseClient.js";
import { Book } from "../models/bookModel.js";

export async function getAllBooks(): Promise<Book[]> {
  const { data, error } = await supabase.from("books").select("*");

  if (error) {
    console.error("Supabase error:", error);
    throw new Error(error.message);
  }

  console.log("Retrieved data:", data);
  return data as Book[];
}

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
}
