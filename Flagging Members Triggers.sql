CREATE TABLE member_flags (
    memberid INT PRIMARY KEY,
    flag_status BOOLEAN DEFAULT FALSE,
    flag_reason VARCHAR(255),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (memberid) REFERENCES members(memberid)
);

-- trigger to flag a Member for overdue books
DELIMITER //

CREATE TRIGGER flag_overdue_members AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    -- Check if the borrow is overdue (30 days without return)
    IF NEW.actual_return_date IS NULL AND DATEDIFF(CURDATE(), NEW.borrow_date) > 30 THEN
        -- Insert a separate entry for each overdue book
        INSERT INTO member_flags (memberid, flag_status, flag_reason)
        VALUES (NEW.memberid, TRUE, CONCAT('Overdue book: ', NEW.bookid))
        ON DUPLICATE KEY UPDATE flag_status = TRUE, flag_reason = CONCAT('Overdue book: ', NEW.bookid);
    END IF;
END;
//

DELIMITER ;


-- trigger to remove flag when member returns a book (even if late)
DELIMITER //

CREATE TRIGGER remove_overdue_flag_on_return AFTER UPDATE ON transactions
FOR EACH ROW
BEGIN
    -- Check if the actual_return_date is not null (i.e., the book is returned)
    IF NEW.actual_return_date IS NOT NULL THEN
        -- Remove the flag for the specific book that was returned
        DELETE FROM member_flags
        WHERE memberid = NEW.memberid
          AND flag_reason = CONCAT('Overdue book: ', NEW.bookid);
    END IF;
END;
//

DELIMITER ;



-- trigger to flag a member for an unpaid fine

DELIMITER //

CREATE TRIGGER flag_unpaid_fines AFTER INSERT ON fine
FOR EACH ROW
BEGIN
    -- Declare a variable to store the bookid
    DECLARE related_bookid INT;

    -- Check if the fine is unpaid (PaidStatus = 0)
    IF NEW.PaidStatus = 0 THEN
        -- Retrieve the bookid from the transactions table based on the fine's transactionid
        SELECT bookid INTO related_bookid
        FROM transactions
        WHERE transactionid = NEW.transactionid;
        
        -- Insert a flag for the member with the bookid in flag_reason
        INSERT INTO member_flags (memberid, flag_status, flag_reason)
        VALUES (NEW.memberid, TRUE, CONCAT('Unpaid fine for book: ', related_bookid))
        ON DUPLICATE KEY UPDATE flag_status = TRUE, flag_reason = CONCAT('Unpaid fine for book: ', related_bookid);
    END IF;
END;
//

DELIMITER ;




-- remove flag for paid fine

DELIMITER //

CREATE TRIGGER remove_unpaid_fine_flag AFTER UPDATE ON fine
FOR EACH ROW
BEGIN
    -- Declare a variable to store the bookid
    DECLARE related_bookid INT;

    -- Check if the PaidStatus is changed from 0 to 1 (paid)
    IF OLD.PaidStatus = 0 AND NEW.PaidStatus = 1 THEN
        -- Retrieve the bookid from the transactions table based on the fine's transactionid
        SELECT bookid INTO related_bookid
        FROM transactions
        WHERE transactionid = NEW.transactionid;
        
        -- Remove the "Unpaid fine" flag from the member_flags table
        DELETE FROM member_flags
        WHERE memberid = NEW.memberid
          AND flag_reason = CONCAT('Unpaid fine for book: ', related_bookid);
    END IF;
END;
//

DELIMITER ;


