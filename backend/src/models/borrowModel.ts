export interface Loan{
    loan_id: number,
    copy_id: number,
    user_id: number,
    borrowed_at:Date,
    due_at: Date,
    returned_at: Date | null,
    status:string,
    notes:string
}