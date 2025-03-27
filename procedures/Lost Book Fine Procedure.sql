
DELIMITER $$

CREATE PROCEDURE LostBookFine (
    IN p_member_id INT,
    IN p_bookid INT,
    IN p_transaction_id INT
)
BEGIN
    DECLARE v_price DECIMAL(10, 2);
    DECLARE v_total_quantity INT;

    -- Step 1: Fetch the price of the book from the book table
    SELECT price INTO v_price
    FROM book
    WHERE bookid = p_bookid;

    -- Step 2: Check if the price exists, otherwise raise an error
    IF v_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book price not found for the provided Book ID.';
    END IF;

    -- Step 3: Fetch the Original_Quantity from the inventory table
    SELECT Total_Quantity INTO v_total_quantity
    FROM inventory
    WHERE BookId = p_bookid;

    -- Step 4: Check if the book exists in inventory and has sufficient quantity
    IF v_total_quantity IS NULL OR v_total_quantity < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book not available in inventory.';
    END IF;

    -- Step 5: Insert the fine record into the fines table
    INSERT INTO fine (TransactionID, Amount, Reason, PaidStatus, memberid)
    VALUES (p_transaction_id, v_price, 'Lost Book', 0, p_member_id);

    -- Step 6: Update the inventory table to decrease the Original_Quantity by 1
    UPDATE inventory
    SET Total_Quantity = Total_Quantity - 1
    WHERE BookId = p_bookid;
    
    -- Step 7: Remove the overdue flag from the member_flags table
    DELETE FROM member_flags
    WHERE memberid = p_member_id
      AND flag_reason LIKE CONCAT('Overdue book: ', p_bookid);

END $$

DELIMITER ;

-- (Use cases: book either lost or damaged beyond repair)
-- memberid, bookid, transactionid
CALL LostBookFine(10, 19, 65);
