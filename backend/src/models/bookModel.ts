export interface Book {
  id: string;
  isbn: string;
  title: string;
  author: string;
  description?: string;
  publicationDate: string;
  language: string;
  category: string;
  coverImageUrl?: string;
  totalCopies: number;
  availableCopies: number;
}
