DELIMITER //

CREATE PROCEDURE UpdateActualReturnDate(
    IN input_memberid INT,
    IN input_bookid INT
)
BEGIN
    -- Update the actual_return_date for the given memberid and bookid
    UPDATE transactions
    SET actual_return_date = CURDATE()
    WHERE memberid = input_memberid
      AND bookid = input_bookid
      AND actual_return_date IS NULL;  -- Ensure it only updates if actual_return_date is currently NULL

    -- Optionally, check if a row was updated
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No matching transaction found for this member and book.';
    END IF;
END;
//

DELIMITER ;

-- (memberid, bookid)
CALL UpdateActualReturnDate(8, 11);
