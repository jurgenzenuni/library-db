DELIMITER //

CREATE PROCEDURE AddTransactions(
    IN input_memberid INT,
    IN input_book_titles VARCHAR(255)  -- Comma-separated book titles
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE book_id INT;
    DECLARE book_title VARCHAR(255);
    DECLARE book_cursor CURSOR FOR 
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(input_book_titles, ',', n), ',', -1)) 
        FROM (SELECT @rownum := @rownum + 1 AS n 
              FROM information_schema.columns, (SELECT @rownum := 0) r 
              LIMIT 255) numbers
        WHERE n <= (LENGTH(input_book_titles) - LENGTH(REPLACE(input_book_titles, ',', '')) + 1);

    -- Declare a handler for when the cursor finishes
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN book_cursor;

    read_loop: LOOP
        FETCH book_cursor INTO book_title;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Retrieve the book ID based on the title
        SELECT bookid INTO book_id
        FROM book
        WHERE title = book_title
          AND status = 'available'
        LIMIT 1;

        -- Check if the book exists and is available
        IF book_id IS NULL THEN
            -- Return an error if the book is unavailable
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more books are not available or do not exist.';
        ELSE
            -- Insert the transaction for each book
            INSERT INTO transactions (
                bookid,
                memberid,
                borrow_date,
                return_date,
                actual_return_date,
                fine_status
            ) VALUES (
                book_id,
                input_memberid,
                CURDATE(),
                CURDATE() + INTERVAL 30 DAY,
                NULL,
                0
            );
        END IF;
    END LOOP;

    CLOSE book_cursor;
END;
//

DELIMITER ;

-- (memberid, book name/s they are renting)
CALL AddTransactions(1, 'The Shining, 1984, Harry Potter and the Philosophers Stone');

