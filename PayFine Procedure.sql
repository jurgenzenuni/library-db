DELIMITER //

CREATE PROCEDURE PayFine(
    IN input_memberid INT,
    IN input_bookid INT
)
BEGIN
    DECLARE fine_exists INT;

    -- Check if there's an unpaid fine for the member and book
    SELECT COUNT(*) INTO fine_exists
    FROM fine
    WHERE memberid = input_memberid
      AND reason LIKE CONCAT('%', input_bookid, '%')  -- reason stores the bookid
      AND PaidStatus = 0;  -- Unpaid fine

    -- If a fine exists, mark it as paid
    IF fine_exists > 0 THEN
        UPDATE fine
        SET PaidStatus = 1
        WHERE memberid = input_memberid
          AND reason LIKE CONCAT('%', input_bookid, '%')
          AND PaidStatus = 0;

        -- Optionally, you can also update the transaction or perform other actions if needed
        -- Example: Log the payment, etc.
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No unpaid fine found for the member and book.';
    END IF;
END;
//

DELIMITER ;


CALL PayFine(9, 11);  -- Member 9 paying the fine for the book with ID 11
