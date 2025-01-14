
-- (memberid, 'book title/s')
CALL AddTransactions(1, 'The Shining, 1984, Harry Potter and the Philosophers Stone');

-- (memberid, bookid)
CALL UpdateActualReturnDate(8, 11);

-- Member 9 paying the fine for the book with ID 11
CALL PayFine(9, 11); 

-- (Use cases: book either lost or damaged beyond repair)
-- memberid, bookid, transactionid
CALL LostBookFine(10, 19, 65);

-- add new lib member, (name, address, email)
CALL addmember('Cliff Robertson', '334 Main St, Staten Island NY', 'cliff.rob@gmail.com');