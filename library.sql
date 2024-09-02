/*
 Navicat Premium Dump SQL

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80036 (8.0.36)
 Source Host           : localhost:3306
 Source Schema         : library

 Target Server Type    : MySQL
 Target Server Version : 80036 (8.0.36)
 File Encoding         : 65001

 Date: 29/08/2024 23:24:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for authors
-- ----------------------------
DROP TABLE IF EXISTS `authors`;
CREATE TABLE `authors`  (
  `authorid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`authorid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of authors
-- ----------------------------
INSERT INTO `authors` VALUES (1, 'Stephen King');
INSERT INTO `authors` VALUES (2, 'J.K. Rowling');
INSERT INTO `authors` VALUES (3, 'George Orwell');
INSERT INTO `authors` VALUES (4, 'Harper Lee');
INSERT INTO `authors` VALUES (5, 'J.R.R. Tolkien');
INSERT INTO `authors` VALUES (6, 'Agatha Christie');
INSERT INTO `authors` VALUES (7, 'Isaac Asimov');
INSERT INTO `authors` VALUES (8, 'Mark Twain');
INSERT INTO `authors` VALUES (9, 'F. Scott Fitzgerald');
INSERT INTO `authors` VALUES (10, 'Ernest Hemingway');

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `bookid` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ISBN` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `genre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` enum('available','not available') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'available',
  `authorid` int NULL DEFAULT NULL,
  PRIMARY KEY (`bookid`) USING BTREE,
  INDEX `authorid`(`authorid` ASC) USING BTREE,
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`authorid`) REFERENCES `authors` (`authorid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (1, 'The Shining', '9780385121680', 'Horror', 'available', 1);
INSERT INTO `book` VALUES (2, 'Harry Potter and the Philosopher\'s Stone', '9780747532699', 'Fantasy', 'available', 2);
INSERT INTO `book` VALUES (3, '1984', '9780451524935', 'Dystopian', 'available', 3);
INSERT INTO `book` VALUES (4, 'To Kill a Mockingbird', '9780061120084', 'Classic', 'available', 4);
INSERT INTO `book` VALUES (5, 'The Hobbit', '9780547928227', 'Fantasy', 'available', 5);
INSERT INTO `book` VALUES (6, 'Pet Sematary', '9780743412278', 'Horror', 'available', 1);
INSERT INTO `book` VALUES (7, 'Animal Farm', '9780451526342', 'Satire', 'available', 3);
INSERT INTO `book` VALUES (8, 'The Catcher in the Rye', '9780316769488', 'Fiction', 'available', 4);
INSERT INTO `book` VALUES (9, 'The Lord of the Rings', '9780544003415', 'Fantasy', 'available', 5);
INSERT INTO `book` VALUES (10, 'It', '9781501142970', 'Horror', 'not available', 1);
INSERT INTO `book` VALUES (11, 'Brave New World', '9780060850524', 'Science Fiction', 'available', 3);
INSERT INTO `book` VALUES (12, 'The Great Gatsby', '9780743273565', 'Classic', 'available', 4);
INSERT INTO `book` VALUES (13, 'Murder on the Orient Express', '9780007119318', 'Mystery', 'available', 6);
INSERT INTO `book` VALUES (14, 'Foundation', '9780553293357', 'Science Fiction', 'available', 7);
INSERT INTO `book` VALUES (15, 'The Adventures of Tom Sawyer', '9780486400778', 'Fiction', 'available', 8);
INSERT INTO `book` VALUES (16, 'The Great Gatsby', '9780743273565', 'Classic', 'available', 9);
INSERT INTO `book` VALUES (17, 'The Old Man and the Sea', '9780684801223', 'Fiction', 'available', 10);
INSERT INTO `book` VALUES (18, 'The Murder of Roger Ackroyd', '9780007527491', 'Mystery', 'available', 6);
INSERT INTO `book` VALUES (19, 'I, Robot', '9780553382563', 'Science Fiction', 'available', 7);
INSERT INTO `book` VALUES (20, 'Adventures of Huckleberry Finn', '9780486280615', 'Fiction', 'available', 8);
INSERT INTO `book` VALUES (21, 'Tender Is the Night', '9780684801544', 'Classic', 'available', 9);
INSERT INTO `book` VALUES (22, 'For Whom the Bell Tolls', '9780684803357', 'Fiction', 'available', 10);

-- ----------------------------
-- Table structure for fine
-- ----------------------------
DROP TABLE IF EXISTS `fine`;
CREATE TABLE `fine`  (
  `FineID` int NOT NULL AUTO_INCREMENT,
  `TransactionID` int NULL DEFAULT NULL,
  `Amount` decimal(10, 2) NULL DEFAULT NULL,
  `Reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `PaidStatus` bit(1) NULL DEFAULT NULL,
  `memberid` int NULL DEFAULT NULL,
  PRIMARY KEY (`FineID`) USING BTREE,
  INDEX `TransactionID`(`TransactionID` ASC) USING BTREE,
  INDEX `fk_fine_transactions`(`memberid` ASC) USING BTREE,
  CONSTRAINT `fine_ibfk_1` FOREIGN KEY (`TransactionID`) REFERENCES `transactions` (`transactionid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_fine_transactions` FOREIGN KEY (`memberid`) REFERENCES `transactions` (`memberid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fine
-- ----------------------------
INSERT INTO `fine` VALUES (1, 11, 2.50, 'Late return of book', b'0', 6);
INSERT INTO `fine` VALUES (2, 14, 5.00, 'Late return of book', b'1', 9);
INSERT INTO `fine` VALUES (6, 25, 5.00, 'Late return of book ID 15', b'0', 7);
INSERT INTO `fine` VALUES (7, 27, 5.00, 'Late return of book ID 9', b'1', 3);
INSERT INTO `fine` VALUES (8, 26, 20.00, 'Late Return Deadline Surpassed (exceeded 30 days)', b'0', 5);
INSERT INTO `fine` VALUES (9, 28, 20.00, 'Late Return Deadline Surpassed (exceeded 30 days)', b'0', 6);
INSERT INTO `fine` VALUES (10, 29, 5.00, 'Late return of book ID 5', b'0', 10);

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `BookID` int NOT NULL,
  `Total_Quantity` int NULL DEFAULT NULL,
  `Available_Quantity` int NULL DEFAULT NULL,
  PRIMARY KEY (`BookID`) USING BTREE,
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`bookid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory
-- ----------------------------
INSERT INTO `inventory` VALUES (1, 5, 5);
INSERT INTO `inventory` VALUES (2, 3, 3);
INSERT INTO `inventory` VALUES (3, 2, 2);
INSERT INTO `inventory` VALUES (4, 4, 3);
INSERT INTO `inventory` VALUES (5, 6, 7);
INSERT INTO `inventory` VALUES (6, 2, 2);
INSERT INTO `inventory` VALUES (7, 5, 5);
INSERT INTO `inventory` VALUES (8, 7, 7);
INSERT INTO `inventory` VALUES (9, 3, 3);
INSERT INTO `inventory` VALUES (10, 1, 0);
INSERT INTO `inventory` VALUES (11, 4, 4);
INSERT INTO `inventory` VALUES (12, 5, 5);
INSERT INTO `inventory` VALUES (13, 6, 6);
INSERT INTO `inventory` VALUES (14, 2, 2);
INSERT INTO `inventory` VALUES (15, 1, 1);
INSERT INTO `inventory` VALUES (16, 3, 3);
INSERT INTO `inventory` VALUES (17, 4, 4);
INSERT INTO `inventory` VALUES (18, 6, 6);
INSERT INTO `inventory` VALUES (19, 7, 7);
INSERT INTO `inventory` VALUES (20, 2, 1);
INSERT INTO `inventory` VALUES (21, 5, 5);
INSERT INTO `inventory` VALUES (22, 10, 8);

-- ----------------------------
-- Table structure for members
-- ----------------------------
DROP TABLE IF EXISTS `members`;
CREATE TABLE `members`  (
  `memberid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`memberid`) USING BTREE,
  UNIQUE INDEX `unique_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of members
-- ----------------------------
INSERT INTO `members` VALUES (1, 'John Doe', '123 Main St, Anytown, USA', 'john.doe@example.com');
INSERT INTO `members` VALUES (2, 'Jane Smith', '456 Elm St, Another Town, USA', 'jane.smith@example.com');
INSERT INTO `members` VALUES (3, 'Michael Johnson', '789 Oak St, Smallville, USA', 'michael.johnson@example.com');
INSERT INTO `members` VALUES (4, 'Emily Brown', '321 Pine St, Villageville, USA', 'emily.brown@example.com');
INSERT INTO `members` VALUES (5, 'David Lee', '555 Cedar St, Citytown, USA', 'david.lee@example.com');
INSERT INTO `members` VALUES (6, 'Alice Walker', '101 Birch Rd, Townsville, USA', 'alice.walker@example.com');
INSERT INTO `members` VALUES (7, 'Bob Martin', '202 Cedar Ave, Citytown, USA', 'bob.martin@example.com');
INSERT INTO `members` VALUES (8, 'Clara Wilson', '303 Spruce Blvd, Metropolis, USA', 'clara.wilson@example.com');
INSERT INTO `members` VALUES (9, 'Derek White', '404 Willow Ln, Hamlet, USA', 'derek.white@example.com');
INSERT INTO `members` VALUES (10, 'Eva Green', '505 Maple Dr, Countryside, USA', 'eva.green@example.com');

-- ----------------------------
-- Table structure for transactions
-- ----------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions`  (
  `transactionid` int NOT NULL AUTO_INCREMENT,
  `bookid` int NULL DEFAULT NULL,
  `memberid` int NULL DEFAULT NULL,
  `borrow_date` date NULL DEFAULT NULL,
  `return_date` date NULL DEFAULT NULL,
  `actual_return_date` date NULL DEFAULT NULL,
  `fine_status` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`transactionid`) USING BTREE,
  INDEX `bookid`(`bookid` ASC) USING BTREE,
  INDEX `memberid`(`memberid` ASC) USING BTREE,
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`bookid`) REFERENCES `book` (`bookid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`memberid`) REFERENCES `members` (`memberid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of transactions
-- ----------------------------
INSERT INTO `transactions` VALUES (1, 1, 1, '2024-06-01', '2024-07-01', '2024-07-01', b'0');
INSERT INTO `transactions` VALUES (2, 2, 2, '2024-06-05', '2024-07-05', '2024-07-01', b'0');
INSERT INTO `transactions` VALUES (3, 3, 3, '2024-06-10', '2024-07-10', '2024-07-09', b'0');
INSERT INTO `transactions` VALUES (4, 4, 4, '2024-06-15', '2024-07-15', '2024-07-10', b'0');
INSERT INTO `transactions` VALUES (5, 5, 5, '2024-06-20', '2024-07-20', '2024-07-14', b'0');
INSERT INTO `transactions` VALUES (6, 6, 1, '2024-06-25', '2024-07-25', '2024-07-16', b'0');
INSERT INTO `transactions` VALUES (7, 7, 2, '2024-06-02', '2024-07-02', '2024-07-01', b'0');
INSERT INTO `transactions` VALUES (8, 8, 3, '2024-06-07', '2024-07-07', '2024-07-04', b'0');
INSERT INTO `transactions` VALUES (9, 9, 4, '2024-06-12', '2024-07-12', '2024-07-10', b'0');
INSERT INTO `transactions` VALUES (10, 10, 5, '2024-06-17', '2024-07-17', '2024-07-15', b'0');
INSERT INTO `transactions` VALUES (11, 11, 6, '2024-07-01', '2024-08-01', '2024-08-02', b'1');
INSERT INTO `transactions` VALUES (12, 12, 7, '2024-07-05', '2024-08-05', '2024-07-31', b'0');
INSERT INTO `transactions` VALUES (13, 13, 8, '2024-07-10', '2024-08-10', '2024-08-09', b'0');
INSERT INTO `transactions` VALUES (14, 14, 9, '2024-07-15', '2024-08-15', '2024-08-20', b'1');
INSERT INTO `transactions` VALUES (15, 15, 10, '2024-07-20', '2024-08-20', '2024-07-31', b'0');
INSERT INTO `transactions` VALUES (16, 16, 6, '2024-07-25', '2024-08-25', '2024-08-24', b'0');
INSERT INTO `transactions` VALUES (17, 17, 7, '2024-07-30', '2024-08-30', '2024-08-20', b'0');
INSERT INTO `transactions` VALUES (22, 10, 1, '2024-07-01', '2024-08-01', '2024-07-30', b'0');
INSERT INTO `transactions` VALUES (23, 1, 7, '2024-07-01', '2024-08-01', '2024-07-03', b'0');
INSERT INTO `transactions` VALUES (24, 15, 7, '2024-07-01', '2024-08-01', '2024-07-04', b'0');
INSERT INTO `transactions` VALUES (25, 15, 7, '2024-06-01', '2024-07-01', '2024-07-04', b'1');
INSERT INTO `transactions` VALUES (26, 10, 5, '2024-05-01', '2024-06-01', NULL, b'1');
INSERT INTO `transactions` VALUES (27, 9, 3, '2024-06-01', '2024-07-01', '2024-07-04', b'1');
INSERT INTO `transactions` VALUES (28, 4, 6, '2024-04-03', '2024-05-03', NULL, b'1');
INSERT INTO `transactions` VALUES (29, 5, 10, '2024-06-01', '2024-07-01', '2024-07-04', b'1');
INSERT INTO `transactions` VALUES (30, 22, 6, '2024-08-29', '2024-09-29', NULL, b'0');
INSERT INTO `transactions` VALUES (31, 20, 1, '2024-08-29', '2024-09-29', NULL, b'0');
INSERT INTO `transactions` VALUES (32, 22, 4, '2024-08-29', '2024-09-29', NULL, b'0');

-- ----------------------------
-- View structure for bookinventorysummary
-- ----------------------------
DROP VIEW IF EXISTS `bookinventorysummary`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `bookinventorysummary` AS select `b`.`bookid` AS `bookid`,`b`.`title` AS `title`,`i`.`Total_Quantity` AS `Total_Quantity`,`i`.`Available_Quantity` AS `Available_Quantity` from (`book` `b` join `inventory` `i` on((`b`.`bookid` = `i`.`BookID`)));

-- ----------------------------
-- View structure for booksavailable
-- ----------------------------
DROP VIEW IF EXISTS `booksavailable`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `booksavailable` AS select `b`.`title` AS `title`,`b`.`ISBN` AS `ISBN`,`a`.`name` AS `author_name` from (`book` `b` join `authors` `a` on((`b`.`authorid` = `a`.`authorid`))) where (`b`.`status` = 'available');

-- ----------------------------
-- View structure for membertransactions
-- ----------------------------
DROP VIEW IF EXISTS `membertransactions`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `membertransactions` AS select `m`.`name` AS `member_name`,`b`.`title` AS `book_title`,`t`.`borrow_date` AS `borrow_date`,`t`.`return_date` AS `return_date`,`t`.`actual_return_date` AS `actual_return_date`,`f`.`Amount` AS `fine_amount`,(case when (coalesce(`f`.`PaidStatus`,0) = 1) then 'paid' else 'unpaid' end) AS `PaidStatus` from (((`transactions` `t` join `members` `m` on((`t`.`memberid` = `m`.`memberid`))) join `book` `b` on((`t`.`bookid` = `b`.`bookid`))) left join `fine` `f` on((`t`.`transactionid` = `f`.`TransactionID`)));

-- ----------------------------
-- View structure for overduebooks
-- ----------------------------
DROP VIEW IF EXISTS `overduebooks`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `overduebooks` AS select `b`.`title` AS `title`,`b`.`ISBN` AS `ISBN`,`m`.`name` AS `member_name`,`t`.`return_date` AS `return_date`,`t`.`actual_return_date` AS `actual_return_date` from ((`transactions` `t` join `book` `b` on((`t`.`bookid` = `b`.`bookid`))) join `members` `m` on((`t`.`memberid` = `m`.`memberid`))) where ((`t`.`actual_return_date` is null) and (`t`.`return_date` < curdate()));

-- ----------------------------
-- View structure for popularbooks
-- ----------------------------
DROP VIEW IF EXISTS `popularbooks`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `popularbooks` AS select `b`.`bookid` AS `bookid`,`b`.`title` AS `title`,count(`t`.`transactionid`) AS `transaction_count` from (`book` `b` left join `transactions` `t` on((`b`.`bookid` = `t`.`bookid`))) group by `b`.`bookid`,`b`.`title` order by `transaction_count` desc;

-- ----------------------------
-- Event structure for check_overdue_books
-- ----------------------------
DROP EVENT IF EXISTS `check_overdue_books`;
delimiter ;;
CREATE EVENT `check_overdue_books`
ON SCHEDULE
EVERY '1' DAY STARTS '2024-07-04 13:22:14'
DO BEGIN

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
END
;;
delimiter ;

-- ----------------------------
-- Event structure for update_transactions_event
-- ----------------------------
DROP EVENT IF EXISTS `update_transactions_event`;
delimiter ;;
CREATE EVENT `update_transactions_event`
ON SCHEDULE
EVERY '1' HOUR STARTS '2024-07-04 15:12:50'
DO BEGIN
    -- Update transactions where PaidStatus is 1 in Fine table
    UPDATE transactions t
    JOIN fine f ON t.transactionid = f.TransactionID
    SET t.fine_status = 0
    WHERE f.PaidStatus = 1
      AND t.fine_status = 1;  -- Only update where fine_status needs to be reset
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table inventory
-- ----------------------------
DROP TRIGGER IF EXISTS `update_book_status_trigger`;
delimiter ;;
CREATE TRIGGER `update_book_status_trigger` AFTER UPDATE ON `inventory` FOR EACH ROW BEGIN
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `after_borrow_trigger`;
delimiter ;;
CREATE TRIGGER `after_borrow_trigger` AFTER INSERT ON `transactions` FOR EACH ROW BEGIN
    UPDATE Inventory
    SET Available_Quantity = Available_Quantity - 1
    WHERE BookID = NEW.bookid;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `calculate_fine_trigger`;
delimiter ;;
CREATE TRIGGER `calculate_fine_trigger` BEFORE UPDATE ON `transactions` FOR EACH ROW BEGIN
    DECLARE fine_amount DECIMAL(10, 2) DEFAULT 5.00;
    
    IF NEW.actual_return_date > NEW.return_date THEN
        -- Update fine_status to 1
        SET NEW.fine_status = 1;

        -- Insert into Fine table
        INSERT INTO Fine (TransactionID, Amount, Reason, PaidStatus, memberid)
        VALUES (NEW.transactionid, fine_amount, CONCAT('Late return of book ID ', NEW.bookid), 0, NEW.memberid);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table transactions
-- ----------------------------
DROP TRIGGER IF EXISTS `after_return_trigger`;
delimiter ;;
CREATE TRIGGER `after_return_trigger` AFTER UPDATE ON `transactions` FOR EACH ROW BEGIN
    IF NEW.actual_return_date IS NOT NULL THEN
        UPDATE Inventory
        SET Available_Quantity = Available_Quantity + 1
        WHERE BookID = NEW.bookid;
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
