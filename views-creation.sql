CREATE VIEW OverdueBooks AS
SELECT b.title, b.ISBN, m.name AS member_name, t.return_date, t.actual_return_date
FROM transactions t
JOIN book b ON t.bookid = b.bookid
JOIN members m ON t.memberid = m.memberid
WHERE t.actual_return_date IS NULL AND t.return_date < CURRENT_DATE;

CREATE VIEW MemberTransactions AS
SELECT 
    m.name AS member_name, 
    b.title AS book_title, 
    t.borrow_date, 
    t.return_date, 
    t.actual_return_date, 
    f.Amount AS fine_amount,
    CASE WHEN COALESCE(f.PaidStatus, 0) = 1 THEN 'paid' ELSE 'unpaid' END AS PaidStatus
FROM transactions t
JOIN members m ON t.memberid = m.memberid
JOIN book b ON t.bookid = b.bookid
LEFT JOIN Fine f ON t.transactionid = f.TransactionID;

CREATE VIEW BooksAvailable AS
SELECT b.title, b.ISBN, a.name AS author_name
FROM book b
JOIN authors a ON b.authorid = a.authorid
WHERE b.status = 'available';

CREATE VIEW PopularBooks AS
SELECT 
    b.bookid, 
    b.title, 
    COUNT(t.transactionid) AS transaction_count
FROM book b
LEFT JOIN transactions t ON b.bookid = t.bookid
GROUP BY b.bookid, b.title
ORDER BY transaction_count DESC;

CREATE VIEW BookInventorySummary AS
SELECT 
    b.bookid, 
    b.title, 
    i.Total_Quantity, 
    i.Available_Quantity
FROM book b
JOIN Inventory i ON b.bookid = i.BookID;
