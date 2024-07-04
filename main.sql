-- Database creation
CREATE DATABASE Library;

-- Table creation
CREATE TABLE members (
	memberid INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(100),
	address VARCHAR(255),
	email VARCHAR(100) UNIQUE
);

CREATE TABLE authors (
	authorid INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(100)
);

CREATE TABLE book (
	bookid int PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(255),
	ISBN VARCHAR(20),
	genre VARCHAR(50),
	status ENUM('available', 'not available') DEFAULT 'available',
	authorid INT, FOREIGN KEY (authorid) REFERENCES authors(authorid)
);

CREATE TABLE transactions (
    transactionid INT PRIMARY KEY AUTO_INCREMENT,
    bookid INT,
    memberid INT,
    borrow_date DATE,
    return_date DATE,
    actual_return_date DATE,
    fine_status BIT DEFAULT 0, -- 0 for no fine, 1 for fine applicable
    FOREIGN KEY (bookid) REFERENCES book(bookid),
    FOREIGN KEY (memberid) REFERENCES members(memberid)
);


CREATE TABLE Inventory (
    BookID INT PRIMARY KEY,
    Total_Quantity INT,
    Available_Quantity INT,
    FOREIGN KEY (BookID) REFERENCES book(bookid)
);

CREATE TABLE Fine (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    TransactionID INT,
    Amount DECIMAL(10, 2),
    Reason VARCHAR(255),
    PaidStatus BIT,
    FOREIGN KEY (TransactionID) REFERENCES transactions(transactionid)
);

-- Inserting Data for testing
INSERT INTO members (name, address, email) VALUES
('John Doe', '123 Main St, Anytown, USA', 'john.doe@example.com'),
('Jane Smith', '456 Elm St, Another Town, USA', 'jane.smith@example.com'),
('Michael Johnson', '789 Oak St, Smallville, USA', 'michael.johnson@example.com'),
('Emily Brown', '321 Pine St, Villageville, USA', 'emily.brown@example.com'),
('David Lee', '555 Cedar St, Citytown, USA', 'david.lee@example.com');

INSERT INTO members (name, address, email) VALUES
('Alice Walker', '101 Birch Rd, Townsville, USA', 'alice.walker@example.com'),
('Bob Martin', '202 Cedar Ave, Citytown, USA', 'bob.martin@example.com'),
('Clara Wilson', '303 Spruce Blvd, Metropolis, USA', 'clara.wilson@example.com'),
('Derek White', '404 Willow Ln, Hamlet, USA', 'derek.white@example.com'),
('Eva Green', '505 Maple Dr, Countryside, USA', 'eva.green@example.com');

INSERT INTO authors (name) VALUES
('Stephen King'),
('J.K. Rowling'),
('George Orwell'),
('Harper Lee'),
('J.R.R. Tolkien');

INSERT INTO authors (name) VALUES
('Agatha Christie'),
('Isaac Asimov'),
('Mark Twain'),
('F. Scott Fitzgerald'),
('Ernest Hemingway');


INSERT INTO book (title, ISBN, genre, authorid) VALUES
('The Shining', '9780385121680', 'Horror', 1),
('Harry Potter and the Philosopher''s Stone', '9780747532699', 'Fantasy', 2),
('1984', '9780451524935', 'Dystopian', 3),
('To Kill a Mockingbird', '9780061120084', 'Classic', 4),
('The Hobbit', '9780547928227', 'Fantasy', 5),
('Pet Sematary', '9780743412278', 'Horror', 1),
('Animal Farm', '9780451526342', 'Satire', 3),
('The Catcher in the Rye', '9780316769488', 'Fiction', 4),
('The Lord of the Rings', '9780544003415', 'Fantasy', 5),
('It', '9781501142970', 'Horror', 1),
('Brave New World', '9780060850524', 'Science Fiction', 3),
('The Great Gatsby', '9780743273565', 'Classic', 4);

INSERT INTO book (title, ISBN, genre, authorid) VALUES
('Murder on the Orient Express', '9780007119318', 'Mystery', 6),
('Foundation', '9780553293357', 'Science Fiction', 7),
('The Adventures of Tom Sawyer', '9780486400778', 'Fiction', 8),
('The Great Gatsby', '9780743273565', 'Classic', 9), -- Note: Duplicate title with a different author to simulate real-world scenarios
('The Old Man and the Sea', '9780684801223', 'Fiction', 10),
('The Murder of Roger Ackroyd', '9780007527491', 'Mystery', 6),
('I, Robot', '9780553382563', 'Science Fiction', 7),
('Adventures of Huckleberry Finn', '9780486280615', 'Fiction', 8),
('Tender Is the Night', '9780684801544', 'Classic', 9),
('For Whom the Bell Tolls', '9780684803357', 'Fiction', 10);


INSERT INTO transactions (bookid, memberid, borrow_date, return_date)
VALUES
(1, 1, '2024-06-01', '2024-07-01'),
(2, 2, '2024-06-05', '2024-07-05'),
(3, 3, '2024-06-10', '2024-07-10'),
(4, 4, '2024-06-15', '2024-07-15'),
(5, 5, '2024-06-20', '2024-07-20'),
(6, 1, '2024-06-25', '2024-07-25'),
(7, 2, '2024-06-02', '2024-07-02'),
(8, 3, '2024-06-07', '2024-07-07'),
(9, 4, '2024-06-12', '2024-07-12'),
(10, 5, '2024-06-17', '2024-07-17');

INSERT INTO transactions (bookid, memberid, borrow_date, return_date, actual_return_date, fine_status)
VALUES
(11, 6, '2024-07-01', '2024-08-01', '2024-08-02', 1), -- Fine applicable
(12, 7, '2024-07-05', '2024-08-05', NULL, 0),          -- Not yet returned
(13, 8, '2024-07-10', '2024-08-10', '2024-08-09', 0),  -- Returned on time
(14, 9, '2024-07-15', '2024-08-15', '2024-08-20', 1),  -- Late return
(15, 10, '2024-07-20', '2024-08-20', NULL, 0),         -- Not yet returned
(16, 6, '2024-07-25', '2024-08-25', '2024-08-24', 0),  -- Returned on time
(17, 7, '2024-07-30', '2024-08-30', NULL, 0),          -- Not yet returned
(18, 8, '2024-08-01', '2024-09-01', NULL, 0),          -- Not yet returned
(19, 9, '2024-08-05', '2024-09-05', NULL, 0),          -- Not yet returned
(20, 10, '2024-08-10', '2024-09-10', NULL, 0);         -- Not yet returned

INSERT INTO Inventory (BookID, Total_Quantity, Available_Quantity) VALUES
(1, 5, 5),
(2, 3, 3),
(3, 2, 2),
(4, 4, 4),
(5, 6, 6),
(6, 2, 2),
(7, 5, 5),
(8, 7, 7),
(9, 3, 3),
(10, 1, 1),
(11, 4, 4),
(12, 5, 5),
(13, 6, 6),
(14, 2, 2),
(15, 1, 1),
(16, 3, 3),
(17, 4, 4),
(18, 6, 6),
(19, 7, 7),
(20, 2, 2);

INSERT INTO Fine (TransactionID, Amount, Reason, PaidStatus, memberid) VALUES
(11, 2.50, 'Late return of book ID 11', 0, 6), -- Fine for late return
(14, 5.00, 'Late return of book ID 14', 0, 9); -- Fine for late return

-- Indexes for members table
CREATE INDEX idx_members_email ON members(email);

-- Indexes for book table
CREATE INDEX idx_book_title ON book(title);
CREATE INDEX idx_book_authorid ON book(authorid);

-- Indexes for transactions table
CREATE INDEX idx_transactions_memberid ON transactions(memberid);
CREATE INDEX idx_transactions_return_date ON transactions(return_date);

-- Update Inventory on Book Borrow:
DELIMITER //

CREATE TRIGGER after_borrow_trigger AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE Inventory
    SET Available_Quantity = Available_Quantity - 1
    WHERE BookID = NEW.bookid;
END //

DELIMITER ;

-- QUERY person borrowing book
INSERT INTO transactions (bookid, memberid, borrow_date, return_date)
VALUES
(15, 7, '2024-06-01', '2024-07-01');

-- Update inventory on book return
DELIMITER //

CREATE TRIGGER after_return_trigger AFTER UPDATE ON transactions
FOR EACH ROW
BEGIN
    IF NEW.actual_return_date IS NOT NULL THEN
        UPDATE Inventory
        SET Available_Quantity = Available_Quantity + 1
        WHERE BookID = NEW.bookid;
    END IF;
END //

DELIMITER ;

-- QUERY person returning book
UPDATE transactions
SET actual_return_date = CURRENT_DATE  -- Set the actual return date here
WHERE transactionid = 25;
-- WHERE bookid = <bookid> 
-- AND memberid = <memberid>
-- AND actual_return_date IS NULL;

-- update book status in book table based on inventory count
DELIMITER //

CREATE TRIGGER update_book_status_trigger AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    DECLARE available_count INT;

    -- Get the available quantity for the book after update
    SELECT Available_Quantity INTO available_count
    FROM Inventory
    WHERE BookID = NEW.BookID;

    -- Update the status in the book table based on available quantity
    IF available_count > 0 THEN
        UPDATE book
        SET status = 'available'
        WHERE bookid = NEW.BookID;
    ELSE
        UPDATE book
        SET status = 'not available'
        WHERE bookid = NEW.BookID;
    END IF;
END //

DELIMITER ;

-- update fine status and actual fine in fine table
DELIMITER //

CREATE TRIGGER calculate_fine_trigger BEFORE UPDATE ON transactions
FOR EACH ROW
BEGIN
    DECLARE fine_amount DECIMAL(10, 2) DEFAULT 5.00;
    
    IF NEW.actual_return_date > NEW.return_date THEN
        -- Update fine_status to 1
        SET NEW.fine_status = 1;

        -- Insert into Fine table
        INSERT INTO Fine (TransactionID, Amount, Reason, PaidStatus, memberid)
        VALUES (NEW.transactionid, fine_amount, CONCAT('Late return of book ID ', NEW.bookid), 0, NEW.memberid);
    END IF;
END //

DELIMITER ;

-- Create the event to check for overdue books
CREATE EVENT check_overdue_books
ON SCHEDULE EVERY 1 DAY  -- Run daily to check overdue books
DO
BEGIN

		-- Update transactions where fine_status should be set to 1
    UPDATE transactions t
    JOIN Inventory i ON t.bookid = i.BookID
    SET t.fine_status = 1
    WHERE t.actual_return_date IS NULL
      AND t.return_date < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
			
    -- Update transactions where fine_status should be set to 1 and insert into Fine table
    INSERT INTO Fine (TransactionID, Amount, Reason, PaidStatus)
    SELECT t.transactionid, 20.00, 'Late Return Deadline Surpassed (exceeded 30 days)', 0
    FROM transactions t
    WHERE t.actual_return_date IS NULL
      AND t.return_date < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
      AND t.transactionid NOT IN (SELECT TransactionID FROM Fine);
END;





